function [ breast_density, breast_volume, dense_volume_reg ] = estimate_BD(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Input parameters:
%Acquistion table:         Force	image_size	Technique_id	thickness	kvp	mAs
%Commomanalysis table:     breast_area
%StructuralAnalysis table: CALDWELL	CD_Slope	FD_TH_15	FD_TH_25	FD_TH_35	FD_TH_65	FD_TH_70	FD_TH_75	FD_TH_85	
%                          FT_FD	FT_RMS	FT_SMP	GLCM_Correlation	GLCM_Dissimilarity	GLCM_Mean	GLCM_Variance	HZ_PROJ	Kurtosis	
%                          Mean_Gradient	NGTDM_Coarseness	NGTDM_Complexity	NGTDM_Contrast	NGTDM_Strength	Skewness	STD
%DICOMInfo table:          Force	image_size	Technique_id	thickness	kvp	mAs
    
% Variable reassignment: 
mas = num(:,2);
kvp = num(:,3);
technique_id = num(:,4);
force = num(:,5);
image_size = num(:,6);
detecortemp = num(:,10);
breast_area = num(:,9);
exposuretime = num(:,11);
fd_th_15 = num(:,12);
fd_th_25 = num(:,13);
fd_th_35 = num(:,14);
fd_th_65 = num(:,15);
fd_th_70 = num(:,16);
fd_th_75 = num(:,17);
fd_th_85 = num(:,18);
cd_slope = num(:,19);
hz_proj = num(:,20);
caldwell = num(:,21);
std_image = num(:,22);
skewness = num(:,23);
kurtosis = num(:,24);
glcm_dissim = num(:,25);
glcm_corr = num(:,26);
gcm_mean = num(:,27);
glcm_mean = num(:,27);
glcm_var = num(:,28);
ngtdm_coarse = num(:,29);
ngtdm_contrast = num(:,30);
ngtdm_complex = num(:,31);
ngtdm_strengh = num(:,32);
mean_gradient = num(:,33);
ft_rms = num(:,34);
ft_smp = num(:,35);
ft_fd = num(:,36);
thickness_rec = num(:,37);
kvp2 = num(:,38);
thickness = num(:,40);

% creation of 29 variable for breast density regression
var0 = ones(size(ft_fd));
var1 = mas.*fd_th_70;
var2 = ft_fd.*caldwell;
var3 = image_size.*mean_gradient;
var4 =	glcm_mean.*mean_gradient;
var5 =	mean_gradient.*mean_gradient;
var6 = glcm_corr./thickness;
var7 =	kvp.*kvp./thickness;
var8 =	skewness./thickness;
var9 =	force./thickness;
var10 =	1./(thickness.*thickness);
var11 =	glcm_var.*force;
var12 =	cd_slope.*ft_rms;
var13 =	hz_proj.*skewness;
var14 =	exposuretime.*kvp;
var15 =	std_image.*ngtdm_strengh;
var16 =	kurtosis.*glcm_dissim;
var17 =	ft_smp.*ngtdm_contrast;
var18 =	std_image.*ngtdm_contrast;
var19 =	fd_th_85.*ngtdm_complex;
var20 =	ngtdm_complex.*ngtdm_complex;
var21 =	ft_fd.*fd_th_15;
var22 =	ft_fd.*fd_th_25;
var23 =	technique_id.*hz_proj;
var24 =	fd_th_65.*fd_th_75;
var25 =	exposuretime.*image_size;
var26 =	ngtdm_coarse.*breast_area;
var27 =	std_image.*fd_th_35;
var28 =	detectortemp.*fd_th_85;
% weight regression coefficints from model
estimates = [-173.730092	0.103893	-13.577028	5.75E-09	0.001074	-0.00000121	4499.245802	2.787068	-441.914126	-5.274841	-46350	-0.00146	3.70E-08	-1.06112	0.000855	-4.98E-09	-19.671185	1.181368	0.507698	2.07E-12	-6.10E-26	6.73243	5.477904	-0.544286	-8.524736	-1.01E-08	4.508959	0.001578	-0.233608]';
% creation of vector or matrix(batch processing)
vars = [var0, var1, var2, var3, var4, var5, var6, var7, var8, var9, var10, var11, var12, var13, var14, var15, var16, var17, var18, var19, var20, var21, var22, var23, var24, var25, var26, var27, var28];
estimates_matr = repmat(estimates',length(var0), 1);

%breast density calculation
breastdensity = (sum((estimates_matr.*vars)'))';

%breast volume estimation to be done
breast_volume = [];

%desne volume estimation to be done
dense_volume = [];
end

