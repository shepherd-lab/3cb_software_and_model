import sys, os, math, time, warnings
import numpy as np
from scipy import ndimage
from scipy.stats import kurtosis, skew
import pandas as pd
import h5py
from PIL import Image, ImageDraw

import matplotlib.pyplot as plt
from multiprocessing import Pool
import multiprocessing
from math import sin, cos, radians
import random

import matplotlib.patches as mpatches
from mpl_toolkits.axes_grid1 import make_axes_locatable

import matplotlib.gridspec as gridspec
import matplotlib as mpl

import ROI
HEADER=['name', 'case_id', 'run', 'view', 'finding', 'finding_prob','finding_id', 'neg_val_in_map',        'lesion_type', 'area','agree_area', 'disagree_area', 'agree_percentage','disagree_percentage', 'dice',        'overlap','lipid_lesion_mean_thick', 'lipid_lesion_sd_thick','lipid_lesion_median_thick',        'lipid_lesion_kurt','lipid_lesion_skew', 'lipid_lesion_min_thick','lipid_lesion_max_thick',        'lipid_lesion_total','lipid_lesion_percent', 'water_lesion_mean_thick', 'water_lesion_sd_thick',        'water_lesion_median_thick', 'water_lesion_kurt', 'water_lesion_skew', 'water_lesion_min_thick',        'water_lesion_max_thick', 'water_lesion_total', 'water_lesion_percent',        'protein_lesion_mean_thick', 'protein_lesion_sd_thick', 'protein_lesion_median_thick',        'protein_lesion_kurt', 'protein_lesion_skew', 'protein_lesion_min_thick', 'protein_lesion_max_thick',         'protein_lesion_total','protein_lesion_percent','lipid_outer_1_mean_thick', 'lipid_outer_1_sd_thick',        'lipid_outer_1_median_thick', 'lipid_outer_1_kurt', 'lipid_outer_1_skew', 'lipid_outer_1_min_thick',        'lipid_outer_1_max_thick', 'lipid_outer_1_total','lipid_outer_1_percent', 'water_outer_1_mean_thick',        'water_outer_1_sd_thick',       'water_outer_1_median_thick', 'water_outer_1_kurt',       'water_outer_1_skew', 'water_outer_1_min_thick',       'water_outer_1_max_thick', 'water_outer_1_total',       'water_outer_1_percent',       'protein_outer_1_mean_thick', 'protein_outer_1_sd_thick',       'protein_outer_1_median_thick', 'protein_outer_1_kurt',       'protein_outer_1_skew', 'protein_outer_1_min_thick',       'protein_outer_1_max_thick', 'protein_outer_1_total',       'protein_outer_1_percent',       'lipid_outer_2_mean_thick', 'lipid_outer_2_sd_thick',       'lipid_outer_2_median_thick', 'lipid_outer_2_kurt',       'lipid_outer_2_skew', 'lipid_outer_2_min_thick',       'lipid_outer_2_max_thick', 'lipid_outer_2_total',       'lipid_outer_2_percent',        'water_outer_2_mean_thick', 'water_outer_2_sd_thick',       'water_outer_2_median_thick', 'water_outer_2_kurt',       'water_outer_2_skew', 'water_outer_2_min_thick',       'water_outer_2_max_thick', 'water_outer_2_total',       'water_outer_2_percent',        'protein_outer_2_mean_thick', 'protein_outer_2_sd_thick',       'protein_outer_2_median_thick', 'protein_outer_2_kurt',       'protein_outer_2_skew', 'protein_outer_2_min_thick',       'protein_outer_2_max_thick', 'protein_outer_2_total',       'protein_outer_2_percent',      'lipid_outer_3_mean_thick', 'lipid_outer_3_sd_thick',       'lipid_outer_3_median_thick', 'lipid_outer_3_kurt',       'lipid_outer_3_skew', 'lipid_outer_3_min_thick',       'lipid_outer_3_max_thick', 'lipid_outer_3_total',       'lipid_outer_3_percent',        'water_outer_3_mean_thick', 'water_outer_3_sd_thick',       'water_outer_3_median_thick', 'water_outer_3_kurt',       'water_outer_3_skew', 'water_outer_3_min_thick',       'water_outer_3_max_thick', 'water_outer_3_total',       'water_outer_3_percent',       'protein_outer_3_mean_thick', 'protein_outer_3_sd_thick',       'protein_outer_3_median_thick', 'protein_outer_3_kurt',       'protein_outer_3_skew', 'protein_outer_3_min_thick',       'protein_outer_3_max_thick', 'protein_outer_3_total',       'protein_outer_3_percent']

class patient_data(object):
	
	def __init__(self, path_to_mat_file):

		self.__data_object = h5py.File(path_to_mat_file)
		# load id fields
		self.mat_file_name=self.int_arr_to_string(self.__data_object['/output/cb_result_file'][:].flatten())
	   
		# load flip variable
		self.flip=self.__data_object['/output']['original_data']['result3cb']['flip_info'][0,0]

		#TODO: make private data types and use getter and setter methods
		# load presentation image
		self.presImg=np.array(self.__data_object['/output/presImg']).T
		self.lipidImg=np.array(self.__data_object['/output/lipidImg']).T
		self.waterImg=np.array(self.__data_object['/output/waterImg']).T
		self.proteinImg=np.array(self.__data_object['/output/proteinImg']).T

		# load breast mask
		self.no_breast_mask=False
		try:
			self.breast_mask=self.load_breast_mask(np.array(self.__data_object['/output']['original_data']['result3cb']['breast_mask']).T)
		except: #hacky
			self.breast_mask=np.ones(self.presImg.shape)
			self.no_breast_mask=True
		#self.__breast_mask=np.array(self.__data_object['/output']['original_data']['result3cb']['breast_mask']).T			

		# load pathology
		self.pathology=self.int_arr_to_string(self.__data_object['/output/pathology/'][:].flatten())

		# load offsets for plotting rois
		self.x_offset = self.__data_object['/output']['x_offset'][0,0]
		self.y_offset = self.__data_object['/output']['y_offset'][0,0]

		# load ROIS
		self.ann_rois=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/annotation_data/'])
		self.mass_rois=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/icad_masses/'])
		self.calc_rois=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/icad_calcs_clusters_mid/'])
		self.calc_rois_vex=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/icad_calcs_clusters_convex/'])
		self.calc_rois_cave=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/icad_calcs_clusters_concave/'])
		self.ind_calc_rois=self.get_roi_pts_list(self.__data_object,self.__data_object['/output/icad_calcs/'])

		# load findings
		self.mid_calc_findings=self.get_cad_finding(self.__data_object,
											   self.__data_object['/output/icad_calcs_clusters_mid/'],1)
		self.masses_findings=self.get_cad_finding(self.__data_object,
											 self.__data_object['/output/icad_masses/'],0)
		self.cave_calc_findings=self.get_cad_finding(self.__data_object,
									   self.__data_object['/output/icad_calcs_clusters_concave/'],1)
		self.vex_calc_findings=self.get_cad_finding(self.__data_object,
								   self.__data_object['/output/icad_calcs_clusters_convex/'],1)
		# define lesion metrics
		self.rad_lesions = self.make_roi_object_list(self.ann_rois,[-1]*len(self.ann_rois),'annotation')
		self.mass_lesions = self.make_roi_object_list(self.mass_rois,self.masses_findings,'cad_mass')
		self.calc_lesions = self.make_roi_object_list(self.calc_rois,self.mid_calc_findings,'cad_clus_mid_no_calc')
		self.cave_lesions = self.make_roi_object_list(self.calc_rois_cave,self.cave_calc_findings,'cad_clus_cave_no_calc')
		self.vex_lesions = self.make_roi_object_list(self.calc_rois_vex,self.vex_calc_findings,'cad_clus_vex_no_calc')
		self.upsampled_lesions = []
		
		#
		self.neg_val=self.check_for_neg_val()
		self.upsampled_params=[]
		
	def load_breast_mask(self, breast_mask):
		nan_loc = np.isnan(breast_mask)
		breast_mask[nan_loc] = 0
		if self.flip:
			breast_mask=np.rot90(np.rot90(breast_mask))
		return breast_mask

	def int_arr_to_string(self,arr):
		return_str=''
		for i in arr:
			return_str+=chr(i)
		return return_str

	def get_roi_pts_list(self, obj,obj_ref):
		if isinstance(obj_ref, h5py.Dataset):
			return []
		obj_len=obj_ref['x'].shape[0]
		rois=[]
		if obj_len>1:
			for i in range(obj_len):
				x_pts=obj[obj_ref['x'][i][0]][0,:]
				y_pts=obj[obj_ref['y'][i][0]][0,:]
				roi_pts=np.array([x_pts,y_pts]).T+1
				rois+=[roi_pts]
		else:
			roi_x=obj_ref['x'][0,:]
			roi_y=obj_ref['y'][0,:]
			rois+=[np.array([roi_x,roi_y]).T+1]
		return rois

	def get_cad_finding(self, obj, obj_ref, calc):
		if isinstance(obj_ref, h5py.Dataset):
			return []
		finding_prob=[]
		if calc:
			obj_len=obj_ref['clus_prob'].shape[0]
			if obj_len>1:
				for i in range(obj_len):
					finding_prob+=[obj[obj_ref['clus_prob'][i][0]][0][0]]
			else:
				finding_prob+=[obj_ref['clus_prob'][0][0]]
		else:
			obj_len=obj_ref['mass_prob'].shape[0]
			if obj_len>1:
				for i in range(obj_len):
					finding_prob+=[obj[obj_ref['mass_prob'][i][0]][0][0]]
			else:
				finding_prob+=[obj_ref['mass_prob'][0][0]]
		return finding_prob
	
	def make_roi_object_list(self, roi_coord_list, finding_probs_list,finding_type):
		if len(roi_coord_list)==0: # if None
			return []
		roi_list=[]
		for i,v in enumerate(roi_coord_list):
			roi_obj=ROI.ROI(v,self.breast_mask,i, finding_type,finding_probs_list[i],self.breast_mask.shape[0],self.breast_mask.shape[1]) #TODO passing breast mask so height and width can be removed later
			roi_list+=[roi_obj]
		return roi_list
	
	def show_all_rois(self):
		if self.flip:
			print('flipped')
		fig = plt.figure(figsize=(15, 7))
		for subplot, img in enumerate([self.presImg,self.lipidImg,self.waterImg,self.proteinImg]):
			ax = fig.add_subplot(1,4,subplot+1)
			for i,delin in enumerate([self.ann_rois, self.mass_rois, self.calc_rois]):
				if i == 0:
					color='yellow'
				elif i == 1:
					color='green'
				elif i == 2:
					color='red'
				for pts in delin:
					ax.plot(pts[:,0],pts[:,1],c=color)
				im = ax.imshow((img),cmap='gray')
		#, extent=extent, origin='lower', interpolation='None', cmap='viridis')
		#fig.tight_layout()
		fig.suptitle(self.mat_file_name+' , '+self.pathology, fontsize=15)
		self.plot=fig
		
	def show_all_rois_flip(self): #for debugging
		pres=np.rot90(np.rot90(self.presImg))
		fig = plt.figure(figsize=(15, 7))
		for subplot, img in enumerate([self.presImg,self.lipidImg,self.waterImg,self.proteinImg]):
			ax = fig.add_subplot(1,4,subplot+1)
			for i,delin in enumerate([self.ann_rois, self.mass_rois, self.calc_rois]):
				if i == 0:
					color='yellow'
				elif i == 1:
					color='green'
				elif i == 2:
					color='red'
				for pts in delin:
					ax.plot(pts[:,0],pts[:,1],c=color)
				im = ax.imshow((img),cmap='gray')
		#, extent=extent, origin='lower', interpolation='None', cmap='viridis')
		#fig.tight_layout()
		fig.suptitle(self.mat_file_name+' , '+self.pathology, fontsize=15)
		self.plot=fig
		
	def compute_roi_mets(self,roi_list):
		if len(roi_list)!=0: # check if None
			for roi in roi_list:
				roi.lesion_comp=roi.get_lwp_comp(roi.lesion_mask, self.lipidImg, self.waterImg, self.proteinImg)
				roi.outer_1_comp=roi.get_lwp_comp(roi.outer_1_mask, self.lipidImg, self.waterImg, self.proteinImg)
				roi.outer_2_comp=roi.get_lwp_comp(roi.outer_2_mask, self.lipidImg, self.waterImg, self.proteinImg)
				roi.outer_3_comp=roi.get_lwp_comp(roi.outer_3_mask, self.lipidImg, self.waterImg, self.proteinImg)
				overlap_mets=[]
				for i, ann in enumerate(self.rad_lesions):
					overlap_mets+=[roi.compute_overlap(ann.lesion_mask, roi.lesion_mask, i, upsample=0)]
				most_overlap, found=-1,-1
				#print(overlap_mets)
				for i,v in enumerate(overlap_mets):
					if v[3]>most_overlap:
						found=i
						most_overlap=v[3]
				#print(found)
				if found!=-1:
					#print(overlap_mets[found])
					self.rad_lesions[found].finding_prob=roi.finding_prob
					roi.total_area, roi.agree_area, roi.disagree_area, roi.agree_percentage, roi.disagree_percentage, roi.dice, roi.overlap = overlap_mets[found]
					self.rad_lesions[found].overlap=-2

	def check_for_neg_val(self):
		minval=np.amin([self.lipidImg,self.proteinImg,self.waterImg])
		return_val=0
		if minval<0:
			return_val=1
		return return_val

	def upsample(self,num_samples,rot_angle=40,trans_per=80, min_agreeance=0.5):
		sampling_parameters=[]
		trials=0
		while len(sampling_parameters)<num_samples and trials<500:
			trials+=1
			trial_params=random.randint(0, len(self.rad_lesions)-1), random.randint(-(rot_angle), rot_angle),random.randint(-(trans_per), trans_per)/100,random.randint(-(trans_per), trans_per)/100
			same_param=0
			for i in sampling_parameters:
				samp_x, samp_y = i[2],i[3]
				x_diff,y_diff=abs(abs(samp_x)-abs(trial_params[2])), abs(abs(samp_y)-abs(trial_params[3]))
				if x_diff<0.02 and y_diff<0.02:
					same_param=1
					break
			if same_param:
				#print('similar')
				continue
			#print(trial_params)
			original_ann_coord=self.rad_lesions[trial_params[0]].xy
			finding_prob=self.rad_lesions[trial_params[0]].finding_prob
			rot_roi, xcent, ycent=patient_data.rotate_polygon_around_center(original_ann_coord,trial_params[1])
			new_roi=patient_data.translate_roi(rot_roi,trial_params[2], trial_params[3])
			new_roi_obj=ROI.ROI(new_roi,self.breast_mask,-2, 'upsample',finding_prob,self.breast_mask.shape[0],self.breast_mask.shape[1]) #TODO passing breast mask so height and width can be removed later
			self.compute_roi_mets([new_roi_obj])
			if new_roi_obj.agree_percentage>min_agreeance and new_roi_obj.agree_percentage<.975:
				sampling_parameters+=[trial_params]
				self.upsampled_lesions+=[new_roi_obj]
		self.upsampled_params+=sampling_parameters
	
	@staticmethod		
	def get_center_coord(xy_coord):
		return np.mean(xy_coord[:,1]).astype(int),np.mean(xy_coord[:,0]).astype(int)
	
	@staticmethod
	def rotate_point(point, angle, center_point=(0, 0)):
		"""Rotates a point around center_point(origin by default)
		Angle is in degrees.
		Rotation is counter-clockwise
		"""
		angle_rad = radians(angle % 360)
		# Shift the point so that center_point becomes the origin
		new_point = (point[0] - center_point[0], point[1] - center_point[1])
		new_point = (new_point[0] * cos(angle_rad) - new_point[1] * sin(angle_rad),
					 new_point[0] * sin(angle_rad) + new_point[1] * cos(angle_rad))
		# Reverse the shifting we have done
		new_point = (new_point[0] + center_point[0], new_point[1] + center_point[1])
		return new_point
	
	@staticmethod
	def rotate_polygon_around_center(xy_coord,angle):
		new_xy_coord=[]
		xcent,ycent=patient_data.get_center_coord(xy_coord)
		for pt in xy_coord:
			new_xy=patient_data.rotate_point(pt,angle,(ycent,xcent))
			new_xy_coord+=[new_xy]
		return np.array(new_xy_coord), xcent,ycent
	
	@staticmethod
	def translate_roi(xy_coord,per_xshift,per_yshift):
		ymin,ymax=int(np.amin(xy_coord[:,0])),int(np.amax(xy_coord[:,0]))
		xmin,xmax=int(np.amin(xy_coord[:,1])),int(np.amax(xy_coord[:,1]))
		xshift,yshift = (xmax-xmin)*per_xshift, (ymax-ymin)*per_yshift
		new_x=xy_coord[:,0]+xshift
		new_y=xy_coord[:,1]+yshift
		return np.vstack((new_x,new_y)).T
	
	def package_roi(self,roi_obj):
		begining=[]
		roi_dict=roi_obj.__dict__
		key_set=['finding_type', 'finding_prob','finding_id']
		key_set2=['total_area','agree_area', 'disagree_area', 'agree_percentage','disagree_percentage', 'dice','overlap']
		for key in key_set:
			begining+=[roi_dict[key]]
		begining+=[self.neg_val,self.pathology]
		overlaps=[]
		for key2 in key_set2:
			overlaps+=[roi_dict[key2]]
		out=begining+overlaps+roi_dict['lesion_comp']+roi_dict['outer_1_comp']+roi_dict['outer_2_comp']+roi_dict['outer_3_comp']
		return out
	
	def to_dataframe(self):
		name=self.mat_file_name
		names=name.split('.')[0].split('_') 
		case_id=names[1]
		view=names[2]
		run=0
		if len(names)>4:
			run=names[-1][-1]
		#lesion_type=self.pathology
		outdata=[]
		front=[name,case_id,run,view]
		for an in self.rad_lesions:
			outdata+=[front+self.package_roi(an)]
		'''
		### only demoing rad annotations ###
		for ma in self.mass_lesions:
			outdata+=[front+self.package_roi(ma)]
		for ca in self.calc_lesions:
			outdata+=[front+self.package_roi(ca)]
		for up in self.upsampled_lesions:
			outdata+=[front+self.package_roi(up)]
		for ve in self.vex_lesions:
			outdata+=[front+self.package_roi(ve)]
		for va in self.cave_lesions:
			outdata+=[front+self.package_roi(va)]
		'''
		df=pd.DataFrame(data=outdata,columns=HEADER)
		return df
