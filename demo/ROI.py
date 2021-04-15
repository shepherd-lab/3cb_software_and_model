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

class ROI(object):
	
	def __init__(self,xy_coord,breast_mask,finding_id,finding_type,finding_prob,img_height, img_width):
		#print('init ROIs')
		self.xy=xy_coord
		self.breast_mask=breast_mask
		self.finding_id=finding_id
		self.finding_type=finding_type
		self.finding_prob=finding_prob
		self.__height=img_height
		self.__width=img_width
		self.lesion_mask=self.poly2mask(self.xy, self.__height, self.__width)
		self.outer_1_mask=None
		self.outer_2_mask=None
		self.outer_3_mask=None
		self.total_area=-1
		self.agree_area=-1
		self.disagree_area=-1
		self.agree_percentage=-1
		self.disagree_percentage=-1
		self.dice=-1
		self.overlap=-1
		self.lesion_comp=None
		self.outer_1_comp=None
		self.outer_2_comp=None
		self.outer_3_comp=None
		self.get_outer_region_mask(self.lesion_mask)
		
	def poly2mask(self,xy_mat,height,width):
		min_val=np.amin(xy_mat)
		if min_val<=0:
			correction=int(min_val+1)
			warnings.warn('Minimum coordinate value <=0. Correcting by adding'+str(correction)+' to all elements')
			xy_mat=xy_mat+correction
		img = Image.new('L', (width, height), 0)
		ImageDraw.Draw(img).polygon((xy_mat).flatten().tolist(), outline=1, fill=1)
		lesion_mask=(self.breast_mask+np.array(img))
		lesion_mask[lesion_mask<2]=0
		lesion_mask[lesion_mask==2]=1
		#print(np.amin(lesion_mask),np.amax(lesion_mask))
		return lesion_mask
	
	def get_outer_region_mask(self,lesion_mask,region_thickness=6,resolution=.35): #TODO thickness was 2
		d = region_thickness #2 mm perpendicular distance
		d_pix = math.ceil(d/resolution)
		lesion_mask2=1-lesion_mask #inversion
		dist_mat=ndimage.distance_transform_edt(lesion_mask2)
		outer_1_mask = (dist_mat > 0) & (dist_mat <= d_pix)
		outer_2_mask = (dist_mat > d_pix) & (dist_mat <= d_pix*2)
		outer_3_mask = (dist_mat > d_pix*2) & (dist_mat <= d_pix*3)
		
		outer_1_mask = (self.breast_mask+outer_1_mask)
		outer_1_mask[outer_1_mask<2]=0
		outer_1_mask[outer_1_mask==2]=1
		self.outer_1_mask=outer_1_mask
		
		outer_2_mask = (self.breast_mask+outer_2_mask)
		outer_2_mask[outer_2_mask<2]=0
		outer_2_mask[outer_2_mask==2]=1
		self.outer_2_mask=outer_2_mask
		
		outer_3_mask = (self.breast_mask+outer_3_mask)
		outer_3_mask[outer_3_mask<2]=0
		outer_3_mask[outer_3_mask==2]=1
		self.outer_3_mask=outer_3_mask
	
	def get_mask_comp(self,img,mask):
		#print(mask.shape, np.amin(mask),np.amax(mask))
		if np.amax(mask)==0:
			return [-1]*8
		masked_img=img*mask
		masked_img=np.ma.masked_equal(masked_img,0)
		masked_img=masked_img.compressed()
		if masked_img.shape[0]==0:
			return [-1]*8
		mets=[np.mean(masked_img), np.std(masked_img), np.median(masked_img), kurtosis(masked_img.flatten()), 
			  skew(masked_img.flatten()), np.amin(masked_img), np.amax(masked_img), np.sum(masked_img)]
		return mets
	
	def get_lwp_comp(self,mask, lipidImg, waterImg, proteinImg):
		lipid_comp=self.get_mask_comp(lipidImg,mask)
		water_comp=self.get_mask_comp(waterImg,mask)
		protein_comp=self.get_mask_comp(proteinImg,mask)
		total_thick=lipid_comp[-1]+water_comp[-1]+protein_comp[-1]
		return lipid_comp+[lipid_comp[-1]/total_thick]+water_comp+[water_comp[-1]/total_thick]+protein_comp+[protein_comp[-1]/total_thick]
		
	def compute_overlap(self,mask1,mask2, annotation_id, upsample=0):
		'''
		args:
			mask1 - typically annotation mask
		'''
		mask_1,mask_2=mask1.copy(), mask2.copy()
		total_area = np.sum(mask_1)
		total_area2 = np.sum(mask_2)
		mask_2[mask_2==1]=2
		merge_mask=mask_1+mask_2
		'''
		fig = plt.figure(figsize=(10, 20))
		ax = fig.add_subplot(121)
		im = ax.imshow(merge_mask)
		#sys.exit(0)
		'''
		agree_area=np.sum(merge_mask[merge_mask==3])/3
		disagree_area=np.sum(merge_mask[merge_mask==2])/2
		agree_percentage=agree_area/total_area
		disagree_percentage=disagree_area/total_area 
		dice=(2*agree_area)/(total_area+total_area2)
		#dice = np.sum(seg[gt==k])*2.0 / (np.sum(seg) + np.sum(gt))
		#dice = 2*nnz(segIm==grndTruth)/(nnz(segIm) + nnz(grndTruth));
		if upsample:
			overlap = -2
		elif agree_percentage>0:
			overlap=1
		else:
			overlap=0
		
		return total_area2, agree_area, disagree_area, agree_percentage, disagree_percentage, dice, overlap
