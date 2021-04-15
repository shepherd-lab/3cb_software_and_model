import sys, os
import pandas as pd
import numpy as np
import argparse
from argparse import RawTextHelpFormatter
from sklearn.externals.joblib import dump, load
from keras.models import Sequential, load_model

import patient_data, ROI

def parse_arguments():

		#print"here"
	parser = argparse.ArgumentParser(epilog="""""",formatter_class=RawTextHelpFormatter)
	parser.add_argument('-i', '--in_dir',  action='store', type=str, dest='path_to_data', metavar='<path to data>', required=True, help='')
	parser.add_argument('-n', '--nn_dir',  action='store', type=str, dest='nn_dir', metavar='<path to models>', required=True, help='')
	parser.add_argument('-o', '--out_dir',  action='store', type=str, dest='out_dir', metavar='<output path>', required=True, help='')
	return parser.parse_args()

def get_labels(df):
	mal_label=[]
	cancer_label=[]
	for i, row in df.iterrows():
		lesion=row['lesion_type']
		can_label=-1
		if 'Benign' in lesion:
			can_label=0
		elif 'FA' in lesion:
			can_label=1
		elif 'DCIS' in lesion:
			can_label=2
		elif 'vasive' in lesion:
			can_label=3
		if can_label<2:
			mal_label+=[0]
		else:
			mal_label+=[1]
		cancer_label+=[can_label]
	return mal_label, cancer_label

if __name__ == '__main__':
	argv = parse_arguments()
	path_to_data = argv.path_to_data
	nn_dir = argv.nn_dir
	out_dir = argv.out_dir

	print('\nLoading Data & Extracting 3CB Freatures\n')
	results_df=pd.DataFrame()
	for i in os.listdir(path_to_data):
		pat=patient_data.patient_data(path_to_data+i)
		pat.compute_roi_mets(pat.rad_lesions)
		pat.compute_roi_mets(pat.mass_lesions)
		pat.compute_roi_mets(pat.calc_lesions)
		pat.compute_roi_mets(pat.cave_lesions)
		pat.compute_roi_mets(pat.vex_lesions)
		df=pat.to_dataframe()
		results_df = results_df.append(df)
	print('\nOutputing 3CB Feature Data\n')
	results_df.to_csv(out_dir+'raw_3cb_feats.csv',index=False)
	print('\nNormalizing/Scaling Data\n')
	scaler=load(nn_dir+'minmax_scaler.bin')
	scaled_feats=scaler.transform(results_df.iloc[:,16:])
	results_df2=results_df.copy(deep=True)
	for i,feats in enumerate(scaled_feats):
		results_df2.iloc[i,16:]=feats
	results_df2.to_csv(out_dir+'scaled_3cb_feats.csv',index=False)
	print('\nPerforming Neural Network Predictions\n')
	os.environ["CUDA_VISIBLE_DEVICES"]="0" #TODO: changes this according to your machine
	model=load_model(nn_dir+'3cbnn_1.h5')
	pred = model.predict([results_df2.iloc[:,16:].values,results_df2.iloc[:,5].values], batch_size=512, verbose=1, steps=None)
	print('\nOutputing Predictions\n')
	nn_out=pd.DataFrame(data=np.array([results_df2.name.values,results_df2.lesion_type.values,pred[:,1]]).T,columns=['filename','pathology','malignancy_probability'])
	nn_out.to_csv(out_dir+'nn_predictions.csv',index=False)
	print('\nExiting\n')
	sys.exit(0)
