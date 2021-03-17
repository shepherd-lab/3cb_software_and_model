function [ breast_density, breast_volume, dense_volume ] = estimate_BD_BV(  )

% Written by Serghei Malkov
% Version:
%   1.0;     11/29/2013 (Original)
%
% Copyright BBDG.


%Input parameters:
%Acquistion table:         Force	image_size	Technique_id	thickness	kvp	mAs
%Commomanalysis table:     breast_area
%StructuralAnalysis table: CALDWELL	CD_Slope	FD_TH_15	FD_TH_25	FD_TH_35	FD_TH_65	FD_TH_70	FD_TH_75	FD_TH_85	
%                          FT_FD	FT_RMS	FT_SMP	GLCM_Correlation	GLCM_Dissimilarity	GLCM_Mean	GLCM_Variance	HZ_PROJ	Kurtosis	
%                          Mean_Gradient	NGTDM_Coarseness	NGTDM_Complexity	NGTDM_Contrast	NGTDM_Strength	Skewness	STD
%DICOMInfo table:          	kvp	mAs

% Variable reassignment

global Info Phantomless   PhantomlessSXA Analysis


mas = Info.Phantomless.mAs;
kvp = Info.Phantomless.kvp ;
technique_id = Info.Phantomless.Technique_id;
force =Info.Phantomless.Force;
image_size =str2num(Info.Phantomless.image_size);
detectortemp = Info.Phantomless.DetectorTemperature;
breast_area =Info.Phantomless.breast_area;
exposuretime = Info.Phantomless.exposuretime;
fd_th_15 = Info.Phantomless.FD_TH_15;
fd_th_25 = Info.Phantomless.FD_TH_25;
fd_th_35 = Info.Phantomless.FD_TH_35 ;
fd_th_65 =Info.Phantomless.FD_TH_65;
fd_th_70 = Info.Phantomless.FD_TH_70;
fd_th_75 =Info.Phantomless.FD_TH_75;
fd_th_85 = Info.Phantomless.FD_TH_85;
cd_slope = Info.Phantomless.CD_Slope;
hz_proj = Info.Phantomless.HZ_PROJ;
caldwell = Info.Phantomless.CALDWELL;
std_image =Info.Phantomless.STD;
skewness = Info.Phantomless.Skewness;
kurtosis = Info.Phantomless.Kurtosis;
glcm_dissim = Info.Phantomless.GLCM_Dissimilarity;
glcm_corr =Info.Phantomless.GLCM_Correlation;
glcm_mean =Info.Phantomless.GLCM_Mean;
glcm_var = Info.Phantomless.GLCM_Variance;
ngtdm_coarse =Info.Phantomless.NGTDM_Coarseness;
ngtdm_contrast = Info.Phantomless.NGTDM_Contrast;
ngtdm_complex =Info.Phantomless.NGTDM_Complexity;
ngtdm_strengh = Info.Phantomless.NGTDM_Strength;
mean_gradient =Info.Phantomless.Mean_Gradient;
ft_rms =Info.Phantomless.FT_RMS;
ft_smp = Info.Phantomless.FT_SMP;
ft_fd = Info.Phantomless.FT_FD;
thickness =Info.Phantomless.thickness;
ft_fmp = Info.Phantomless.FT_FMP;
fd_th_20 = Info.Phantomless.FD_TH_20;

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
Analysis.Phantomless.breast_density = (sum((estimates_matr.*vars)'))';

%breast volume estimation 
var_vol = thickness.*breast_area;
estimates_vol = [-36.146228	0.000012128	-62.691895	-3.69E-12	0.000227	3.612015	0.000229	0.601562]';
vars_vol = [var0,var_vol,fd_th_20, ngtdm_complex, ngtdm_strengh, ft_fmp, breast_area, force];
estimates_matrvol = repmat(estimates_vol',length(var0), 1);
Analysis.Phantomless.breast_volume = (sum((estimates_matrvol.*vars_vol)'))';

% Temporary Commented 
% % % xx=strfind(Info.Manufacturer, 'HOLOGIC');  
% % % % Added by AM 12022013
% % % if (~isempty(strfind(Info.Manufacturer, 'HOLOGIC'))) | (~isempty(strfind(Info.ManufacturerModelName, 'Selenia'))) | (~isempty(strfind(Info.Manufacturer, 'LORAD')))
% % %     
% % %     if Analysis.Phantomless.breast_density <=1;
% % %         Analysis.Phantomless.breast_density=0;
% % %     end
% % %     
% % %     if Analysis.Phantomless.breast_density >100;
% % %         Analysis.Phantomless.breast_density=99.9;
% % %     end
% % % end;

%desne volume estimation 
Analysis.Phantomless.dense_volume = (Analysis.Phantomless.breast_density.*Analysis.Phantomless.breast_volume)/100;



ReturnResults=[Analysis.Phantomless.breast_density,Analysis.Phantomless.breast_volume,Analysis.Phantomless.dense_volume];
PhantomlessSXA.Results=ReturnResults;
str=PhantomlessSXA.Results;
  
  
end

