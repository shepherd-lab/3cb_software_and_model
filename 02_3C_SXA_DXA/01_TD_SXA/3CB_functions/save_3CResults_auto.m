%saveMat3C - Quick, dirty function that saves calculated 3C data.  The
%function with request a presentation image in png format in addition to
%the data stored in the global.  No checking is done to ensure that there
%is actually data in the global variable from which data is retrieved.
%Frankly, my next programming project involves documenting and programming
%an interface that is less overgrown.
%Syntax:  
%
% Inputs:
%   src - not used
%   event - not used
% Outputs:
%
% Example: 
%    
%
% Other m-files required: none
% Subfunctions:
% MAT-files required:
%
% Author: Fred Duewer
% UCSF
% email: fwduewer@radiology.ucsf.edu 
% Website: http://www.ucsf.edu/bbdg
% March 2010; Last revision: 23-March-2010

%------------- BEGIN CODE --------------
function save_3CResults_auto(density_filename, center)
global ROI Image patient_ID flip_info FreeForm file MaskROI_breast maps flag

 %pname = file.startpath;
%  analysis_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run2\';
 [pathstr,name,ext] = fileparts(file.fname)
 maps = [];
 maps.results.Analysis_date	= date;
 maps.results.Analysis_run = 2;
 
 maps.LEPres= Image.LEPresFlipped(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  
 fname = ['\3CBResults_',patient_ID,'_SM_run',num2str(maps.results.Analysis_run),'.mat'];
 fname_results = [pathstr,fname];
 if flag.spot_paddle == true
 breastspot_mask  = circle_spotpaddle();
 MaskROI_breast =  breastspot_mask(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns);
 end
 maps.water = Image.material.*MaskROI_breast;
 maps.lipid = Image.thickness.*MaskROI_breast;
 maps.protein = Image.thirdcomponent.*MaskROI_breast;
 maps.thickness = Image.CTmask3C;
 %maps.LEPres = Image.LEPres_flipped;
 maps.LEatten  = Image.CLE;
 maps.ROI = ROI;
 
%  breastspot_mask  = spot_circle();
%  breastspot_maskROI =  breastspot_mask(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns);
 
% %   mn = mean(mean(Image.CTmask3C));
% %   MaskROI_breast = Image.CTmask3C>(mn*0.8);
% %  maps.breast_mask = ~maps.ROI.BackGround;
 maps.breast_mask = double(MaskROI_breast);
%  se = strel('disk',25);        
%  maps.breast_mask = double(imerode(maps.breast_mask,se));
% %  figure;imagesc(maps.breast_mask);colormap(gray);
 
% % %  FreeForm.FreeFormCluster.face(:,1) = FreeForm.FreeFormCluster.face(:,1)- ROI.xmin;
% % %  FreeForm.FreeFormCluster.face(:,2) = FreeForm.FreeFormCluster.face(:,2)- ROI.ymin;
for i = 1:length(FreeForm.FreeFormCluster(1,:))
 maps.lesion(1,i).xy(:,1) = FreeForm.FreeFormCluster(1,i).face(:,1)- ROI.xmin;
 maps.lesion(1,i).xy(:,2) = FreeForm.FreeFormCluster(1,i).face(:,2)- ROI.ymin;
 lesion_ROI2(:,:,i) = double(roipoly(maps.LEPres,maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2))).*MaskROI_breast;
end
 
 FreeForm_flipped = FreeForm;
 maps.patient_ID = patient_ID;
 maps.flip_info = flip_info;
 maps.ROI = ROI;
  
%  lesion_ROI = double(roipoly(maps.LEPres,maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2))).*MaskROI_breast;
 for i=1:length(FreeForm.FreeFormCluster(1,:))
lesion_ROI = lesion_ROI2(:,:,i);
maps.results.lesionID = i;
%    figure;imagesc(maps.LEPres);colormap(gray);hold on; plot(maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2),'g-');
%    figure;imagesc(Image.LEPresFlipped);colormap(gray);hold on; plot(FreeForm.FreeFormCluster(1,1).face(:,1),FreeForm.FreeFormCluster(1,1).face(:,2),'g-');
 
 
% [lesion_mask, outer_1_mask, outer_2_mask, outer_3_mask] = get_lesion_masks(xp, yp, xRes, yRes, m_ROI, n_ROI)

 
 distbw =  bwdist(lesion_ROI);
 distbw = distbw*0.014;
 distbw_thresh1 = distbw<0.2;
 lesion_periph1 = double(~(~lesion_ROI - distbw_thresh1)).*MaskROI_breast;
  distbw_thresh2 = distbw<0.4;
 lesion_periph2 = double(~(~(lesion_ROI + lesion_periph1) - distbw_thresh2)).*MaskROI_breast;
  distbw_thresh3 = distbw<0.6;
 lesion_periph3 = double(~(~(lesion_ROI + lesion_periph1 + lesion_periph2) - distbw_thresh3)).*MaskROI_breast;
  

 %% lesion ROI
 lesion_ROI(lesion_ROI==0) = NaN;
 filter_ROIW = maps.water.*lesion_ROI;
%  totind = find(filter_ROIW~=NaN);
%  zindex = find(filter_ROIW==0); 
%  maps.results.negROIW = length(zindex)/length(totind)*100;
 filter_ROIWvect = filter_ROIW(~isnan(filter_ROIW));
 maps.results.ROIWmean = mean(filter_ROIWvect);
 maps.results.ROIWmed = median(filter_ROIWvect);
 maps.results.ROIWskew = skewness(filter_ROIWvect);
 maps.results.ROIWkurt = kurtosis(filter_ROIWvect);
 maps.results.ROIWent = entropy(filter_ROIW);
 maps.results.ROIWstd = std(filter_ROIWvect);
 maps.results.negROIW = neg_percent(filter_ROIW);
  
 filter_ROIL = maps.lipid.*lesion_ROI;
 filter_ROILvect = filter_ROIL(~isnan(filter_ROIL));
 maps.results.ROILmean = mean(filter_ROILvect);
 maps.results.ROILmed = median(filter_ROILvect);
 maps.results.ROILskew = skewness(filter_ROILvect);
 maps.results.ROILkurt = kurtosis(filter_ROILvect);
 maps.results.ROILent = entropy(filter_ROIL);
 maps.results.ROILstd = std(filter_ROILvect);
 maps.results.negROIL = neg_percent(filter_ROIL );
  
 filter_ROIP = maps.protein.*lesion_ROI;
 filter_ROIPvect = filter_ROIP(~isnan(filter_ROIP));
 maps.results.ROIPmean = mean(filter_ROIPvect);
 maps.results.ROIPmed = median(filter_ROIPvect);
 maps.results.ROIPskew = skewness(filter_ROIPvect);
 maps.results.ROIPkurt = kurtosis(filter_ROIPvect);
 maps.results.ROIPent = entropy(filter_ROIP);
 maps.results.ROIPstd = std(filter_ROIPvect);
 maps.results.negROIP = neg_percent(filter_ROIP );
  
 s = regionprops(lesion_ROI,'Area');
 maps.results.lesion_area = s.Area*0.014*0.014;
%   figure; imagesc(lesion_ROI); colormap(gray); hold on; plot(maps.lesion(1,1).xy(:,1),maps.lesion(1,i).xy(:,2),'g-'); hold off;
%   figure; imagesc(maps.LEPres); colormap(gray); hold on; plot(maps.lesion(1,1).xy(:,1),maps.lesion(1,i).xy(:,2),'g-'); hold off;
%   
  
  % %  figure; imagesc(filter_ROIW); colormap(gray);
%  figure; imagesc(filter_ROIL); colormap(gray);
% %  figure; imagesc(filter_ROIP); colormap(gray);

 %% lesion periphery, first ring
 lesion_periph1(lesion_periph1==0) = NaN;
 filter_bkgrW1 = maps.water.*lesion_periph1;
 filter_bkgrW1vect = filter_bkgrW1(~isnan(filter_bkgrW1));
 maps.results.bkgrW1mean = mean(filter_bkgrW1vect);
 maps.results.bkgrW1med = median(filter_bkgrW1vect);
 maps.results.bkgrW1skew = skewness(filter_bkgrW1vect);
 maps.results.bkgrW1kurt = kurtosis(filter_bkgrW1vect);
 maps.results.bkgrW1ent = entropy(filter_bkgrW1);
 maps.results.bkgrW1std = std(filter_bkgrW1vect);
 maps.results.negbkgrW1 = neg_percent(filter_bkgrW1);
 
 filter_bkgrL1 = maps.lipid.*lesion_periph1;
 filter_bkgrL1vect = filter_bkgrL1(~isnan(filter_bkgrL1));
 maps.results.bkgrL1mean = mean(filter_bkgrL1vect);
 maps.results.bkgrL1med = median(filter_bkgrL1vect);
 maps.results.bkgrL1skew = skewness(filter_bkgrL1vect);
 maps.results.bkgrL1kurt = kurtosis(filter_bkgrL1vect);
 maps.results.bkgrL1ent = entropy(filter_bkgrL1);
 maps.results.bkgrL1std = std(filter_bkgrL1vect);
 maps.results.negbkgrL1 = neg_percent(filter_bkgrL1);
 
 filter_bkgrP1 = maps.protein.*lesion_periph1;
 filter_bkgrP1vect = filter_bkgrP1(~isnan(filter_bkgrP1));
 maps.results.bkgrP1mean = mean(filter_bkgrP1vect);
 maps.results.bkgrP1med = median(filter_bkgrP1vect);
 maps.results.bkgrP1skew = skewness(filter_bkgrP1vect);
 maps.results.bkgrP1kurt = kurtosis(filter_bkgrP1vect);
 maps.results.bkgrP1ent = entropy(filter_bkgrP1);
 maps.results.bkgrP1std = std(filter_bkgrP1vect);
 maps.results.negbkgrP1 = neg_percent(filter_bkgrP1);
 %  figure; imagesc(lesion_periph1); colormap(gray);
% %  figure; imagesc(filter_bkgrW1); colormap(gray);
% %  figure; imagesc(filter_bkgrL1); colormap(gray);
% %  figure; imagesc(filter_bkgrP1); colormap(gray);

 %% lesion periphery, second ring
 lesion_periph2(lesion_periph2==0) = NaN;
 filter_bkgrW2 = maps.water.*lesion_periph2;
 filter_bkgrW2vect = filter_bkgrW2(~isnan(filter_bkgrW2));
 maps.results.bkgrW2mean = mean(filter_bkgrW2vect);
 maps.results.bkgrW2med = median(filter_bkgrW2vect);
 maps.results.bkgrW2skew = skewness(filter_bkgrW2vect);
 maps.results.bkgrW2kurt = kurtosis(filter_bkgrW2vect);
 maps.results.bkgrW2ent = entropy(filter_bkgrW2);
 maps.results.bkgrW2std = std(filter_bkgrW2vect);
 maps.results.negbkgrW2 = neg_percent(filter_bkgrW2);
 
 filter_bkgrL2 = maps.lipid.*lesion_periph2;
 filter_bkgrL2vect = filter_bkgrL2(~isnan(filter_bkgrL2));
 maps.results.bkgrL2mean = mean(filter_bkgrL2vect);
 maps.results.bkgrL2med = median(filter_bkgrL2vect);
 maps.results.bkgrL2skew = skewness(filter_bkgrL2vect);
 maps.results.bkgrL2kurt = kurtosis(filter_bkgrL2vect);
 maps.results.bkgrL2ent = entropy(filter_bkgrL2);
 maps.results.bkgrL2std = std(filter_bkgrL2vect);
 maps.results.negbkgrL2 = neg_percent(filter_bkgrL2);
 
 filter_bkgrP2 = maps.protein.*lesion_periph2;
 filter_bkgrP2vect = filter_bkgrP2(~isnan(filter_bkgrP2));
 maps.results.bkgrP2mean = mean(filter_bkgrP2vect);
 maps.results.bkgrP2med = median(filter_bkgrP2vect);
 maps.results.bkgrP2skew = skewness(filter_bkgrP2vect);
 maps.results.bkgrP2kurt = kurtosis(filter_bkgrP2vect);
 maps.results.bkgrP2ent = entropy(filter_bkgrP2);
 maps.results.bkgrP2std = std(filter_bkgrP2vect);
 maps.results.negbkgrP2 = neg_percent(filter_bkgrP2);
 %  figure; imagesc(lesion_periph2); colormap(gray);
% %  figure; imagesc(filter_bkgrW2); colormap(gray);
% %  figure; imagesc(filter_bkgrL2); colormap(gray);
% %  figure; imagesc(filter_bkgrP2); colormap(gray);

 %% lesion periphery, third ring
 lesion_periph3(lesion_periph3==0) = NaN;
 filter_bkgrW3 = maps.water.*lesion_periph3;
 filter_bkgrW3vect = filter_bkgrW3(~isnan(filter_bkgrW3));
 maps.results.bkgrW3mean = mean(filter_bkgrW3vect);
 maps.results.bkgrW3med = median(filter_bkgrW3vect);
 maps.results.bkgrW3skew = skewness(filter_bkgrW3vect);
 maps.results.bkgrW3kurt = kurtosis(filter_bkgrW3vect);
 maps.results.bkgrW3ent = entropy(filter_bkgrW3);
 maps.results.bkgrW3std = std(filter_bkgrW3vect);
 maps.results.negbkgrW3 = neg_percent(filter_bkgrW3);
 
 filter_bkgrL3 = maps.lipid.*lesion_periph3;
 filter_bkgrL3vect = filter_bkgrL3(~isnan(filter_bkgrL3));
 maps.results.bkgrL3mean = mean(filter_bkgrL3vect);
 maps.results.bkgrL3med = median(filter_bkgrL3vect);
 maps.results.bkgrL3skew = skewness(filter_bkgrL3vect);
 maps.results.bkgrL3kurt = kurtosis(filter_bkgrL3vect);
 maps.results.bkgrL3ent = entropy(filter_bkgrL3);
 maps.results.bkgrL3std = std(filter_bkgrL3vect);
 maps.results.negbkgrL3 = neg_percent(filter_bkgrL3);
 
 filter_bkgrP3 = maps.protein.*lesion_periph3;
 filter_bkgrP3vect = filter_bkgrP3(~isnan(filter_bkgrP3));
 maps.results.bkgrP3mean = mean(filter_bkgrP3vect);
 maps.results.bkgrP3med = median(filter_bkgrP3vect);
 maps.results.bkgrP3skew = skewness(filter_bkgrP3vect);
 maps.results.bkgrP3kurt = kurtosis(filter_bkgrP3vect);
 maps.results.bkgrP3ent = entropy(filter_bkgrP3);
 maps.results.bkgrP3std = std(filter_bkgrP3vect);
 maps.results.negbkgrP3 = neg_percent(filter_bkgrP3);
 %  figure; imagesc(lesion_periph3); colormap(gray);
% %  figure; imagesc(filter_bkgrW3); colormap(gray);
% %  figure; imagesc(filter_bkgrL3); colormap(gray);
% %  figure; imagesc(filter_bkgrP3); colormap(gray);

 %% breast
 maps.breast_mask(maps.breast_mask==0) = NaN;
 filter_breastW = maps.water.*maps.breast_mask;
 filter_breastWvect = filter_breastW(~isnan(filter_breastW));
 maps.results.breastWmean = mean(filter_breastWvect);
 maps.results.breastWmed = median(filter_breastWvect);
 maps.results.breastWskew = skewness(filter_breastWvect);
 maps.results.breastWkurt = kurtosis(filter_breastWvect);
 maps.results.breastWent = entropy(filter_breastW);
 maps.results.breastWstd = std(filter_breastWvect);
 maps.results.negbreastW = neg_percent(filter_breastW);
 
 filter_breastL = maps.lipid.*maps.breast_mask;
 filter_breastLvect = filter_breastL(~isnan(filter_ROIL));
 maps.results.breastLmean = mean(filter_breastLvect);
 maps.results.breastLmed = median(filter_breastLvect);
 maps.results.breastLskew = skewness(filter_breastLvect);
 maps.results.breastLkurt = kurtosis(filter_breastLvect);
 maps.results.breastLent = entropy(filter_breastL);
 maps.results.breastLstd = std(filter_breastLvect);
 maps.results.negbreastL = neg_percent( filter_breastL);
 
 filter_breastP = maps.protein.*maps.breast_mask;
 filter_breastPvect = filter_breastP(~isnan(filter_breastP));
 maps.results.breastPmean = mean(filter_breastPvect);
 maps.results.breastPmed = median(filter_breastPvect);
 maps.results.breastPskew = skewness(filter_breastPvect);
 maps.results.breastPkurt = kurtosis(filter_breastPvect);
 maps.results.breastPent = entropy(filter_breastP);
 maps.results.breastPstd = std(filter_breastPvect);
 maps.results.negbreastP = neg_percent( filter_breastP);
  
 s = regionprops(MaskROI_breast,'Area');
 maps.results.breast_area = s.Area*0.014*0.014;
%  figure; imagesc(maps.breast_mask); colormap(gray);
% %  figure; imagesc(filter_breastW); colormap(gray);
%  figure; imagesc(filter_breastL); colormap(gray);
% %  figure; imagesc(filter_breastP); colormap(gray);

%% slopes
 
  xdata = [0.2 0.4 0.6];
  ydataWmean = [maps.results.bkgrW1mean, maps.results.bkgrW2mean, maps.results.bkgrW3mean];
  fresult = polyfit(xdata,ydataWmean,1)
  maps.results.slopeWmean = fresult(1);
  maps.results.offsetWmean = fresult(2);clear fresult;
  ydataWmed = [maps.results.bkgrW1med, maps.results.bkgrW2med, maps.results.bkgrW3med];
  fresult = polyfit(xdata,ydataWmed,1)
  maps.results.slopeWmed = fresult(1);
  maps.results.offsetWmed = fresult(2);clear fresult;
  ydataWstd = [maps.results.bkgrW1std, maps.results.bkgrW2std, maps.results.bkgrW3std];
  fresult = polyfit(xdata,ydataWstd,1)
  maps.results.slopeWstd = fresult(1);
  maps.results.offsetWstd = fresult(2);clear fresult;
   ydataWskew = [maps.results.bkgrW1skew, maps.results.bkgrW2skew, maps.results.bkgrW3skew];
  fresult = polyfit(xdata,ydataWskew,1)
  maps.results.slopeWskew = fresult(1);
  maps.results.offsetWskew = fresult(2);clear fresult;
   ydataWkurt = [maps.results.bkgrW1kurt, maps.results.bkgrW2kurt, maps.results.bkgrW3kurt];
  fresult = polyfit(xdata,ydataWkurt,1)
  maps.results.slopeWkurt = fresult(1);
  maps.results.offsetWkurt = fresult(2);clear fresult;
   ydataWent = [maps.results.bkgrW1ent, maps.results.bkgrW2ent, maps.results.bkgrW3ent];
  fresult = polyfit(xdata,ydataWent,1)
  maps.results.slopeWent = fresult(1);
  maps.results.offsetWent = fresult(2);clear fresult;
  
  ydataPmean = [maps.results.bkgrP1mean, maps.results.bkgrP2mean, maps.results.bkgrP3mean];
  fresult = polyfit(xdata,ydataPmean,1)
  maps.results.slopePmean = fresult(1);
  maps.results.offsetPmean = fresult(2);clear fresult;
  ydataPmed = [maps.results.bkgrP1med, maps.results.bkgrP2med, maps.results.bkgrP3med];
  fresult = polyfit(xdata,ydataPmed,1)
  maps.results.slopePmed = fresult(1);
  maps.results.offsetPmed = fresult(2);clear fresult;
  ydataPstd = [maps.results.bkgrP1std, maps.results.bkgrP2std, maps.results.bkgrP3std];
  fresult = polyfit(xdata,ydataPstd,1)
  maps.results.slopePstd = fresult(1);
  maps.results.offsetPstd = fresult(2);clear fresult;
   ydataPskew = [maps.results.bkgrP1skew, maps.results.bkgrP2skew, maps.results.bkgrP3skew];
  fresult = polyfit(xdata,ydataPskew,1)
  maps.results.slopePskew = fresult(1);
  maps.results.offsetPskew = fresult(2);clear fresult;
   ydataPkurt = [maps.results.bkgrP1kurt, maps.results.bkgrP2kurt, maps.results.bkgrP3kurt];
  fresult = polyfit(xdata,ydataPkurt,1)
  maps.results.slopePkurt = fresult(1);
  maps.results.offsetPkurt = fresult(2);clear fresult;
   ydataPent = [maps.results.bkgrP1ent, maps.results.bkgrP2ent, maps.results.bkgrP3ent];
  fresult = polyfit(xdata,ydataPent,1)
  maps.results.slopePent = fresult(1);
  maps.results.offsetPent = fresult(2);clear fresult;
  
  ydataLmean = [maps.results.bkgrL1mean, maps.results.bkgrL2mean, maps.results.bkgrL3mean];
  fresult = polyfit(xdata,ydataLmean,1)
  maps.results.slopeLmean = fresult(1);
  maps.offsetLmean = fresult(2);clear fresult;
  ydataLmed = [maps.results.bkgrL1med, maps.results.bkgrL2med, maps.results.bkgrL3med];
  fresult = polyfit(xdata,ydataLmed,1)
  maps.results.slopeLmed = fresult(1);
  maps.results.offsetLmed = fresult(2);clear fresult;
  ydataLstd = [maps.results.bkgrL1std, maps.results.bkgrL2std, maps.results.bkgrL3std];
  fresult = polyfit(xdata,ydataLstd,1)
  maps.results.slopeLstd = fresult(1);
  maps.results.offsetLstd = fresult(2);clear fresult;
   ydataLskew = [maps.results.bkgrL1skew, maps.results.bkgrL2skew, maps.results.bkgrL3skew];
  fresult = polyfit(xdata,ydataLskew,1)
  maps.results.slopeLskew = fresult(1);
  maps.results.offsetLskew = fresult(2);clear fresult;
   ydataLkurt = [maps.results.bkgrL1kurt, maps.results.bkgrL2kurt, maps.results.bkgrL3kurt];
  fresult = polyfit(xdata,ydataLkurt,1)
  maps.results.slopeLkurt = fresult(1);
  maps.results.offsetLkurt = fresult(2);clear fresult;
   ydataLent = [maps.results.bkgrL1ent, maps.results.bkgrL2ent, maps.results.bkgrL3ent];
  fresult = polyfit(xdata,ydataLent,1)
  maps.results.slopeLent = fresult(1);
  maps.results.offsetLent = fresult(2);clear fresult;
  
  %%
  % %%%%%%%%%%%%%%%SXA computation
  if ~isempty(density_filename)
      density_map = double(imread(density_filename))/100;
      %% lesion ROI SXA density
      lesion_ROI(lesion_ROI==0) = NaN;
      filter_ROISXA = density_map.*lesion_ROI;
      filter_ROISXAvect = filter_ROISXA(~isnan(filter_ROISXA));
      maps.results.ROISXAmean = mean(filter_ROISXAvect);
     maps.results.ROISXAmed = median(filter_ROISXAvect);
     maps.results.ROISXAskew = skewness(filter_ROISXAvect);
     maps.results.ROISXAkurt = kurtosis(filter_ROISXAvect);
     maps.results.ROISXAent = entropy(filter_ROISXA);
     maps.results.ROISXAstd = std(filter_ROISXAvect);
     maps.results.negROISXA = neg_percent(filter_ROISXA);

      %   figure; imagesc(lesion_ROI); colormap(gray); hold on; plot(maps.lesion(1,1).xy(:,1),maps.lesion(1,i).xy(:,2),'g-'); hold off;
      %   figure; imagesc(maps.LEPres); colormap(gray); hold on; plot(maps.lesion(1,1).xy(:,1),maps.lesion(1,i).xy(:,2),'g-'); hold off;
      
      %% lesion periphery, first ring
      lesion_periph1(lesion_periph1==0) = NaN;
      filter_bkgrSXA1 = density_map.*lesion_periph1;
      filter_bkgrSXA1vect = filter_bkgrSXA1(~isnan(filter_bkgrSXA1));
      maps.results.bkgrSXA1mean = mean(filter_bkgrSXA1vect);
     maps.results.bkgrSXA1med = median(filter_bkgrSXA1vect);
     maps.results.bkgrSXA1skew = skewness(filter_bkgrSXA1vect);
     maps.results.bkgrSXA1kurt = kurtosis(filter_bkgrSXA1vect);
     maps.results.bkgrSXA1ent = entropy(filter_bkgrSXA1);
     maps.results.bkgrSXA1std = std(filter_bkgrSXA1vect);
     maps.results.negbkgrSXA1 = neg_percent(filter_bkgrSXA1);
     %   figure; imagesc(SXAresults.bkgrSXA1); colormap(gray);
      
      %% lesion periphery, second ring
      lesion_periph2(lesion_periph2==0) = NaN;
      filter_bkgrSXA2 = density_map.*lesion_periph2;
      filter_bkgrSXA2vect = filter_bkgrSXA2(~isnan(filter_bkgrSXA2));
      maps.results.bkgrSXA2mean = mean(filter_bkgrSXA2vect);
     maps.results.bkgrSXA2med = median(filter_bkgrSXA2vect);
     maps.results.bkgrSXA2skew = skewness(filter_bkgrSXA2vect);
     maps.results.bkgrSXA2kurt = kurtosis(filter_bkgrSXA2vect);
     maps.results.bkgrSXA2ent = entropy(filter_bkgrSXA2);
     maps.results.bkgrSXA2std = std(filter_bkgrSXA2vect);
     maps.results.negbkgrSXA2 = neg_percent(filter_bkgrSXA2);
      
      %   figure; imagesc(SXAresults.bkgrSXA2); colormap(gray);
      
      %% lesion periphery, third ring
      lesion_periph3(lesion_periph3==0) = NaN;
      filter_bkgrSXA3 = density_map.*lesion_periph3;
      filter_bkgrSXA3vect = filter_bkgrSXA3(~isnan(filter_bkgrSXA3));
      maps.results.bkgrSXA3mean = mean(filter_bkgrSXA3vect);
     maps.results.bkgrSXA3med = median(filter_bkgrSXA3vect);
     maps.results.bkgrSXA3skew = skewness(filter_bkgrSXA3vect);
     maps.results.bkgrSXA3kurt = kurtosis(filter_bkgrSXA3vect);
     maps.results.bkgrSXA3ent = entropy(filter_bkgrSXA3);
     maps.results.bkgrSXA3std = std(filter_bkgrSXA3vect);
     maps.results.negbkgrSXA3 = neg_percent(filter_bkgrSXA3);
      %   figure; imagesc(SXAresults.bkgrSXA3); colormap(gray);
      
      %% breast
      maps.breast_mask(maps.breast_mask==0) = NaN;
      filter_breastSXA = density_map.*maps.breast_mask;
     filter_breastSXAvect = filter_breastSXA(~isnan(filter_breastSXA));
     maps.results.breastSXAmean = mean(filter_breastSXAvect);
     maps.results.breastSXAmed = median(filter_breastSXAvect);
     maps.results.breastSXAskew = skewness(filter_breastSXAvect);
     maps.results.breastSXAkurt = kurtosis(filter_breastSXAvect);
     maps.results.breastSXAent = entropy(filter_breastSXA);
     maps.results.breastSXAstd = std(filter_breastSXAvect);
     maps.results.negbreastSXA = neg_percent(filter_breastSXA);
           %   figure; imagesc(SXAresults.breastSXA); colormap(gray);
      %% slope   
   xdata = [0.2 0.4 0.6];
  ydataSXAmean = [maps.results.bkgrSXA1mean, maps.results.bkgrSXA2mean, maps.results.bkgrSXA3mean];
  fresult = polyfit(xdata,ydataSXAmean,1)
  maps.results.slopeSXAmean = fresult(1);
  maps.results.offsetSXAmean = fresult(2);clear fresult;
  ydataSXAmed = [maps.results.bkgrSXA1med, maps.results.bkgrSXA2med, maps.results.bkgrSXA3med];
  fresult = polyfit(xdata,ydataSXAmed,1)
  maps.results.slopeSXAmed = fresult(1);
  maps.results.offsetSXAmed = fresult(2);clear fresult;
  ydataSXAstd = [maps.results.bkgrSXA1std, maps.results.bkgrSXA2std, maps.results.bkgrSXA3std];
  fresult = polyfit(xdata,ydataSXAstd,1)
  maps.results.slopeSXAstd = fresult(1);
  maps.results.offsetSXAstd = fresult(2);clear fresult;
   ydataSXAskew = [maps.results.bkgrSXA1skew, maps.results.bkgrSXA2skew, maps.results.bkgrSXA3skew];
  fresult = polyfit(xdata,ydataSXAskew,1)
  maps.results.slopeSXAskew = fresult(1);
  maps.results.offsetSXAskew = fresult(2);clear fresult;
   ydataSXAkurt = [maps.results.bkgrSXA1kurt, maps.results.bkgrSXA2kurt, maps.results.bkgrSXA3kurt];
  fresult = polyfit(xdata,ydataSXAkurt,1)
  maps.results.slopeSXAkurt = fresult(1);
  maps.results.offsetSXAkurt = fresult(2);clear fresult;
   ydataSXAent = [maps.results.bkgrSXA1ent, maps.results.bkgrSXA2ent, maps.results.bkgrSXA3ent];
  fresult = polyfit(xdata,ydataSXAent,1)
  maps.results.slopeSXAent = fresult(1);
  maps.results.offsetSXAent = fresult(2);clear fresult;
      
      %% percentage of negative values
  else
      maps.results.ROISXAmean 	= [];
    maps.results.ROISXAmed	= [];
    maps.results.ROISXAskew	= [];
    maps.results.ROISXAkurt	= [];
    maps.results.ROISXAent	= [];
    maps.results.ROISXAstd	= [];
    maps.results.bkgrSXA1mean	= [];
    maps.results.bkgrSXA1med	= [];
    maps.results.bkgrSXA1skew	= [];
    maps.results.bkgrSXA1kurt	= [];
    maps.results.bkgrSXA1ent	= [];
    maps.results.bkgrSXA1std	= [];
    maps.results.bkgrSXA2mean	= [];
    maps.results.bkgrSXA2med	= [];
    maps.results.bkgrSXA2skew	= [];
    maps.results.bkgrSXA2kurt	= [];
    maps.results.bkgrSXA2ent	= [];
    maps.results.bkgrSXA2std	= [];
    maps.results.bkgrSXA3mean	= [];
    maps.results.bkgrSXA3med	= [];
    maps.results.bkgrSXA3skew	= [];
    maps.results.bkgrSXA3kurt	= [];
    maps.results.bkgrSXA3ent	= [];
    maps.results.bkgrSXA3std	= [];
    maps.results.breastSXAmean	= [];
    maps.results.breastSXAmed	= [];
    maps.results.breastSXAskew	= [];
    maps.results.breastSXAkurt	= [];
    maps.results.breastSXAent	= [];
    maps.results.breastSXAstd	= [];
    maps.results.slopeSXAmean	= [];
    maps.results.offsetSXAmean	= [];
    maps.results.slopeSXAmed	= [];
    maps.results.offsetSXAmed	= [];
    maps.results.slopeSXAstd	= [];
    maps.results.offsetSXAstd	= [];
    maps.results.slopeSXAskew	= [];
    maps.results.offsetSXAskew	= [];
    maps.results.slopeSXAkurt	= [];
    maps.results.offsetSXAkurt	= [];
    maps.results.slopeSXAent	= [];
    maps.results.offsetSXAent	= [];

  end
  
 %%
 if ~isempty(findstr(center,'ucsf'))
 results_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run2\';
 elseif ~isempty(findstr(center,'ucsf_pipot'))
    results_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\Results\Auto_3C_analysis_runs\Run2\';
 else
 results_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\MOffitt\Results\Auto_3C_analysis_runs\Run2\';    
 
 end    

%  results3C =  cell(1,44);
%  results3C{1,1} = maps.patient_ID;
%  results3C{1,2} = maps.results.ROIW;
%  results3C{1,3} = maps.results.ROIL;
%  results3C{1,4} = maps.results.ROIP;
%  results3C{1,5} = maps.results.bkgrW1;
%  results3C{1,6} = maps.results.bkgrL1;
%  results3C{1,7} = maps.results.bkgrP1;
%  results3C{1,8} = maps.results.bkgrW2;
%  results3C{1,9} = maps.results.bkgrL2;
%  results3C{1,10} = maps.results.bkgrP2;
%  results3C{1,11} = maps.results.bkgrW3;
%  results3C{1,12} = maps.results.bkgrL3;
%  results3C{1,13} = maps.results.bkgrP3;
%  results3C{1,14} = maps.results.breastW;
%  results3C{1,15} = maps.results.breastL;
%  results3C{1,16} = maps.results.breastP;
%  results3C{1,17} = maps.results.lesion_area;
%  results3C{1,18} = maps.results.breast_area;
%  results3C{1,19} = slopeW;
%  results3C{1,20} = offsetW;
%  results3C{1,21} = slopeL;
%  results3C{1,22} = offsetL;
%  results3C{1,23} = slopeP;
%  results3C{1,24} = offsetP;
%  results3C{1,25} = SXAresults.ROISXA;
%  results3C{1,26} = SXAresults.bkgrSXA1;
%  results3C{1,27} = SXAresults.bkgrSXA2;
%  results3C{1,28} = SXAresults.bkgrSXA3;
%  results3C{1,29} =  SXAresults.slopeSXA;
%  results3C{1,30} =  SXAresults.offsetSXA;
%  results3C{1,31} = SXAresults.breastSXA;
%  results3C{1,32} = maps.results.negROIW;
%  results3C{1,33} = maps.results.negROIL;
%  results3C{1,34} = maps.results.negROIP;
%  results3C{1,35} = maps.results.negbreastW ;
%  results3C{1,36} = maps.results.negbreastL;
%  results3C{1,37} = maps.results.negbreastP; 
%  results3C{1,38} = maps.results.negbkgrW1;
%  results3C{1,39} = maps.results.negbkgrL1;
%  results3C{1,40} = maps.results.negbkgrP1;
%  results3C{1,41} = maps.results.negbkgrW2;
%  results3C{1,42} = maps.results.negbkgrL2;
%  results3C{1,43} = maps.results.negbkgrP2;
%  results3C{1,44} = maps.results.negbkgrW3;
%  results3C{1,45} = maps.results.negbkgrL3;
%  results3C{1,46} = maps.results.negbkgrP3;
 
%   results3C =  cell(1,165);
%  results3C{1,   1   } = maps.patient_ID;
%  results3C{1,	2	} =	maps.results.ROIWmean	;
% results3C{1,	3	} =	maps.results.ROIWmed	;
% results3C{1,	4	} =	maps.results.ROIWskew	;
% results3C{1,	5	} =	maps.results.ROIWkurt	;
% results3C{1,	6	} =	maps.results.ROIWent	;
% results3C{1,	7	} =	maps.results.ROILmean	;
% results3C{1,	8	} =	maps.results.ROILmed	;
% results3C{1,	9	} =	maps.results.ROILskew	;
% results3C{1,	10	} =	maps.results.ROILkurt	;
% results3C{1,	11	} =	maps.results.ROILent	;
% results3C{1,	12	} =	maps.results.ROIPmean	;
% results3C{1,	13	} =	maps.results.ROIPmed	;
% results3C{1,	14	} =	maps.results.ROIPskew	;
% results3C{1,	15	} =	maps.results.ROIPkurt	;
% results3C{1,	16	} =	maps.results.ROIPent	;
% results3C{1,	17	} =	maps.results.bkgrW1mean	;
% results3C{1,	18	} =	maps.results.bkgrW1med	;
% results3C{1,	19	} =	maps.results.bkgrW1skew	;
% results3C{1,	20	} =	maps.results.bkgrW1kurt	;
% results3C{1,	21	} =	maps.results.bkgrW1ent	;
% results3C{1,	22	} =	maps.results.bkgrL1mean	;
% results3C{1,	23	} =	maps.results.bkgrL1med	;
% results3C{1,	24	} =	maps.results.bkgrL1skew	;
% results3C{1,	25	} =	maps.results.bkgrL1kurt	;
% results3C{1,	26	} =	maps.results.bkgrL1ent	;
% results3C{1,	27	} =	maps.results.bkgrP1mean	;
% results3C{1,	28	} =	maps.results.bkgrP1med	;
% results3C{1,	29	} =	maps.results.bkgrP1skew	;
% results3C{1,	30	} =	maps.results.bkgrP1kurt	;
% results3C{1,	31	} =	maps.results.bkgrP1ent	;
% results3C{1,	32	} =	maps.results.bkgrW2mean	;
% results3C{1,	33	} =	maps.results.bkgrW2med	;
% results3C{1,	34	} =	maps.results.bkgrW2skew	;
% results3C{1,	35	} =	maps.results.bkgrW2kurt	;
% results3C{1,	36	} =	maps.results.bkgrW2ent	;
% results3C{1,	37	} =	maps.results.bkgrL2mean	;
% results3C{1,	38	} =	maps.results.bkgrL2med	;
% results3C{1,	39	} =	maps.results.bkgrL2skew	;
% results3C{1,	40	} =	maps.results.bkgrL2kurt	;
% results3C{1,	41	} =	maps.results.bkgrL2ent	;
% results3C{1,	42	} =	maps.results.bkgrP2mean	;
% results3C{1,	43	} =	maps.results.bkgrP2med	;
% results3C{1,	44	} =	maps.results.bkgrP2skew	;
% results3C{1,	45	} =	maps.results.bkgrP2kurt	;
% results3C{1,	46	} =	maps.results.bkgrP2ent	;
% results3C{1,	47	} =	maps.results.bkgrW3mean	;
% results3C{1,	48	} =	maps.results.bkgrW3med	;
% results3C{1,	49	} =	maps.results.bkgrW3skew	;
% results3C{1,	50	} =	maps.results.bkgrW3kurt	;
% results3C{1,	51	} =	maps.results.bkgrW3ent	;
% results3C{1,	52	} =	maps.results.bkgrL3mean	;
% results3C{1,	53	} =	maps.results.bkgrL3med	;
% results3C{1,	54	} =	maps.results.bkgrL3skew	;
% results3C{1,	55	} =	maps.results.bkgrL3kurt	;
% results3C{1,	56	} =	maps.results.bkgrL3ent	;
% results3C{1,	57	} =	maps.results.bkgrP3mean	;
% results3C{1,	58	} =	maps.results.bkgrP3med	;
% results3C{1,	59	} =	maps.results.bkgrP3skew	;
% results3C{1,	60	} =	maps.results.bkgrP3kurt	;
% results3C{1,	61	} =	maps.results.bkgrP3ent	;
% results3C{1,	62	} =	maps.results.breastWmean	;
% results3C{1,	63	} =	maps.results.breastWmed	;
% results3C{1,	64	} =	maps.results.breastWskew	;
% results3C{1,	65	} =	maps.results.breastWkurt	;
% results3C{1,	66	} =	maps.results.breastWent	;
% results3C{1,	67	} =	maps.results.breastLmean	;
% results3C{1,	68	} =	maps.results.breastLmed	;
% results3C{1,	69	} =	maps.results.breastLskew	;
% results3C{1,	70	} =	maps.results.breastLkurt	;
% results3C{1,	71	} =	maps.results.breastLent	;
% results3C{1,	72	} =	maps.results.breastPmean	;
% results3C{1,	73	} =	maps.results.breastPmed	;
% results3C{1,	74	} =	maps.results.breastPskew	;
% results3C{1,	75	} =	maps.results.breastPkurt	;
% results3C{1,	76	} =	maps.results.breastPent	;
% results3C{1,	77	} =	maps.results.slopeWmean	;
% results3C{1,	78	} =	maps.results.offsetWmean	;
% results3C{1,	79	} =	maps.results.slopeWmed	;
% results3C{1,	80	} =	maps.results.offsetWmed	;
% results3C{1,	81	} =	maps.results.slopeWstd	;
% results3C{1,	82	} =	maps.results.offsetWstd	;
% results3C{1,	83	} =	maps.results.slopeWskew	;
% results3C{1,	84	} =	maps.results.offsetWskew	;
% results3C{1,	85	} =	maps.results.slopeWkurt	;
% results3C{1,	86	} =	maps.results.offsetWkurt	;
% results3C{1,	87	} =	maps.results.slopeWent	;
% results3C{1,	88	} =	maps.results.offsetWent	;
% results3C{1,	89	} =	maps.results.slopePmean	;
% results3C{1,	90	} =	maps.results.offsetPmean	;
% results3C{1,	91	} =	maps.results.slopePmed	;
% results3C{1,	92	} =	maps.results.offsetPmed	;
% results3C{1,	93	} =	maps.results.slopePstd	;
% results3C{1,	94	} =	maps.results.offsetPstd	;
% results3C{1,	95	} =	maps.results.slopePskew	;
% results3C{1,	96	} =	maps.results.offsetPskew	;
% results3C{1,	97	} =	maps.results.slopePkurt	;
% results3C{1,	98	} =	maps.results.offsetPkurt	;
% results3C{1,	99	} =	maps.results.slopePent	;
% results3C{1,	100	} =	maps.results.offsetPent	;
% results3C{1,	101	} =	maps.results.slopeLmean	;
% results3C{1,	102	} =	maps.results.slopeLmed	;
% results3C{1,	103	} =	maps.results.offsetLmed	;
% results3C{1,	104	} =	maps.results.slopeLstd	;
% results3C{1,	105	} =	maps.results.offsetLstd	;
% results3C{1,	106	} =	maps.results.slopeLskew	;
% results3C{1,	107	} =	maps.results.offsetLskew	;
% results3C{1,	108	} =	maps.results.slopeLkurt	;
% results3C{1,	109	} =	maps.results.offsetLkurt	;
% results3C{1,	110	} =	maps.results.slopeLent	;
% results3C{1,	111	} =	maps.results.offsetLent	;
% results3C{1,	112	} =	 maps.results.ROISXAmean 	;
% results3C{1,	113	} =	maps.results.ROISXAmed	;
% results3C{1,	114	} =	maps.results.ROISXAskew	;
% results3C{1,	115	} =	maps.results.ROISXAkurt	;
% results3C{1,	116	} =	maps.results.ROISXAent	;
% results3C{1,	117	} =	maps.results.bkgrSXA1mean	;
% results3C{1,	118	} =	maps.results.bkgrSXA1med	;
% results3C{1,	119	} =	maps.results.bkgrSXA1skew	;
% results3C{1,	120	} =	maps.results.bkgrSXA1kurt	;
% results3C{1,	121	} =	maps.results.bkgrSXA1ent	;
% results3C{1,	122	} =	maps.results.bkgrSXA2mean	;
% results3C{1,	123	} =	maps.results.bkgrSXA2med	;
% results3C{1,	124	} =	maps.results.bkgrSXA2skew	;
% results3C{1,	125	} =	maps.results.bkgrSXA2kurt	;
% results3C{1,	126	} =	maps.results.bkgrSXA2ent	;
% results3C{1,	127	} =	maps.results.bkgrSXA3mean	;
% results3C{1,	128	} =	maps.results.bkgrSXA3med	;
% results3C{1,	129	} =	maps.results.bkgrSXA3skew	;
% results3C{1,	130	} =	maps.results.bkgrSXA3kurt	;
% results3C{1,	131	} =	maps.results.bkgrSXA3ent	;
% results3C{1,	132	} =	maps.results.breastSXAmean	;
% results3C{1,	133	} =	maps.results.breastSXAmed	;
% results3C{1,	134	} =	maps.results.breastSXAskew	;
% results3C{1,	135	} =	maps.results.breastSXAkurt	;
% results3C{1,	136	} =	maps.results.breastSXAent	;
% results3C{1,	137	} =	maps.results.slopeSXAmean	;
% results3C{1,	138	} =	maps.results.offsetSXAmean	;
% results3C{1,	139	} =	maps.results.slopeSXAmed	;
% results3C{1,	140	} =	maps.results.offsetSXAmed	;
% results3C{1,	141	} =	maps.results.slopeSXAstd	;
% results3C{1,	142	} =	maps.results.offsetSXAstd	;
% results3C{1,	143	} =	maps.results.slopeSXAskew	;
% results3C{1,	144	} =	maps.results.offsetSXAskew	;
% results3C{1,	145	} =	maps.results.slopeSXAkurt	;
% results3C{1,	146	} =	maps.results.offsetSXAkurt	;
% results3C{1,	147	} =	maps.results.slopeSXAent	;
% results3C{1,	148	} =	maps.results.offsetSXAent	;
% results3C{1,    149 } = maps.results.lesion_area;
% results3C{1,    150 } = maps.results.breast_area;
% results3C{1,	149	} =	maps.results.lesion_area;
% results3C{1,	150	} =	maps.results.breast_area;
% results3C{1,	151	} =	maps.results.negROIW;
% results3C{1,	152	} =	maps.results.negROIL;
% results3C{1,	153	} =	maps.results.negROIP;
% results3C{1,	154	} =	maps.results.negbkgrW1;
% results3C{1,	155	} =	maps.results.negbkgrL1;
% results3C{1,	156	} =	maps.results.negbkgrP1;
% results3C{1,	157	} =	maps.results.negbkgrW2;
% results3C{1,	158	} =	maps.results.negbkgrL2;
% results3C{1,	159	} =	maps.results.negbkgrP2;
% results3C{1,	160	} =	maps.results.negbkgrW3;
% results3C{1,	161	} =	maps.results.negbkgrL3;
% results3C{1,	162	} =	maps.results.negbkgrP3;
% results3C{1,	163	} =	maps.results.negbreastW;
% results3C{1,	164	} =	maps.results.negbreastL;
% results3C{1,	165	} =	maps.results.negbreastP;
% results3C{1,	166	} =	maps.results.lesionID;
% results3C{1,	167	} =	maps.results.Analysis_date;
% results3C{1,	168	} =	maps.results.Analysis_run;

%%
 results3C =  cell(1,188);
 results3C{1,   1   } = maps.patient_ID;
results3C{1,	2	} =	maps.results.ROIWmean	;
results3C{1,	3	} =	maps.results.ROIWmed	;
results3C{1,	4	} =	maps.results.ROIWskew	;
results3C{1,	5	} =	maps.results.ROIWkurt	;
results3C{1,	6	} =	maps.results.ROIWent	;
results3C{1,	7	} =	maps.results.ROIWstd	;
results3C{1,	8	} =	maps.results.ROILmean	;
results3C{1,	9	} =	maps.results.ROILmed	;
results3C{1,	10	} =	maps.results.ROILskew	;
results3C{1,	11	} =	maps.results.ROILkurt	;
results3C{1,	12	} =	maps.results.ROILent	;
results3C{1,	13	} =	maps.results.ROILstd	;
results3C{1,	14	} =	maps.results.ROIPmean	;
results3C{1,	15	} =	maps.results.ROIPmed	;
results3C{1,	16	} =	maps.results.ROIPskew	;
results3C{1,	17	} =	maps.results.ROIPkurt	;
results3C{1,	18	} =	maps.results.ROIPent	;
results3C{1,	19	} =	maps.results.ROIPstd	;
results3C{1,	20	} =	maps.results.bkgrW1mean	;
results3C{1,	21	} =	maps.results.bkgrW1med	;
results3C{1,	22	} =	maps.results.bkgrW1skew	;
results3C{1,	23	} =	maps.results.bkgrW1kurt	;
results3C{1,	24	} =	maps.results.bkgrW1ent	;
results3C{1,	25	} =	maps.results.bkgrW1std	;
results3C{1,	26	} =	maps.results.bkgrL1mean	;
results3C{1,	27	} =	maps.results.bkgrL1med	;
results3C{1,	28	} =	maps.results.bkgrL1skew	;
results3C{1,	29	} =	maps.results.bkgrL1kurt	;
results3C{1,	30	} =	maps.results.bkgrL1ent	;
results3C{1,	31	} =	maps.results.bkgrL1std	;
results3C{1,	32	} =	maps.results.bkgrP1mean	;
results3C{1,	33	} =	maps.results.bkgrP1med	;
results3C{1,	34	} =	maps.results.bkgrP1skew	;
results3C{1,	35	} =	maps.results.bkgrP1kurt	;
results3C{1,	36	} =	maps.results.bkgrP1ent	;
results3C{1,	37	} =	maps.results.bkgrP1std	;
results3C{1,	38	} =	maps.results.bkgrW2mean	;
results3C{1,	39	} =	maps.results.bkgrW2med	;
results3C{1,	40	} =	maps.results.bkgrW2skew	;
results3C{1,	41	} =	maps.results.bkgrW2kurt	;
results3C{1,	42	} =	maps.results.bkgrW2ent	;
results3C{1,	43	} =	maps.results.bkgrW2std	;
results3C{1,	44	} =	maps.results.bkgrL2mean	;
results3C{1,	45	} =	maps.results.bkgrL2med	;
results3C{1,	46	} =	maps.results.bkgrL2skew	;
results3C{1,	47	} =	maps.results.bkgrL2kurt	;
results3C{1,	48	} =	maps.results.bkgrL2ent	;
results3C{1,	49	} =	maps.results.bkgrL2std	;
results3C{1,	50	} =	maps.results.bkgrP2mean	;
results3C{1,	51	} =	maps.results.bkgrP2med	;
results3C{1,	52	} =	maps.results.bkgrP2skew	;
results3C{1,	53	} =	maps.results.bkgrP2kurt	;
results3C{1,	54	} =	maps.results.bkgrP2ent	;
results3C{1,	55	} =	maps.results.bkgrP2std	;
results3C{1,	56	} =	maps.results.bkgrW3mean	;
results3C{1,	57	} =	maps.results.bkgrW3med	;
results3C{1,	58	} =	maps.results.bkgrW3skew	;
results3C{1,	59	} =	maps.results.bkgrW3kurt	;
results3C{1,	60	} =	maps.results.bkgrW3ent	;
results3C{1,	61	} =	maps.results.bkgrW3std	;
results3C{1,	62	} =	maps.results.bkgrL3mean	;
results3C{1,	63	} =	maps.results.bkgrL3med	;
results3C{1,	64	} =	maps.results.bkgrL3skew	;
results3C{1,	65	} =	maps.results.bkgrL3kurt	;
results3C{1,	66	} =	maps.results.bkgrL3ent	;
results3C{1,	67	} =	maps.results.bkgrL3std	;
results3C{1,	68	} =	maps.results.bkgrP3mean	;
results3C{1,	69	} =	maps.results.bkgrP3med	;
results3C{1,	70	} =	maps.results.bkgrP3skew	;
results3C{1,	71	} =	maps.results.bkgrP3kurt	;
results3C{1,	72	} =	maps.results.bkgrP3ent	;
results3C{1,	73	} =	maps.results.bkgrP3std	;
results3C{1,	74	} =	maps.results.breastWmean	;
results3C{1,	75	} =	maps.results.breastWmed	;
results3C{1,	76	} =	maps.results.breastWskew	;
results3C{1,	77	} =	maps.results.breastWkurt	;
results3C{1,	78	} =	maps.results.breastWent	;
results3C{1,	79	} =	maps.results.breastWstd	;
results3C{1,	80	} =	maps.results.breastLmean	;
results3C{1,	81	} =	maps.results.breastLmed	;
results3C{1,	82	} =	maps.results.breastLskew	;
results3C{1,	83	} =	maps.results.breastLkurt	;
results3C{1,	84	} =	maps.results.breastLent	;
results3C{1,	85	} =	maps.results.breastLstd	;
results3C{1,	86	} =	maps.results.breastPmean	;
results3C{1,	87	} =	maps.results.breastPmed	;
results3C{1,	88	} =	maps.results.breastPskew	;
results3C{1,	89	} =	maps.results.breastPkurt	;
results3C{1,	90	} =	maps.results.breastPent	;
results3C{1,	91	} =	maps.results.breastPstd	;
results3C{1,	92	} =	maps.results.slopeWmean	;
results3C{1,	93	} =	maps.results.offsetWmean	;
results3C{1,	94	} =	maps.results.slopeWmed	;
results3C{1,	95	} =	maps.results.offsetWmed	;
results3C{1,	96	} =	maps.results.slopeWstd	;
results3C{1,	97	} =	maps.results.offsetWstd	;
results3C{1,	98	} =	maps.results.slopeWskew	;
results3C{1,	99	} =	maps.results.offsetWskew	;
results3C{1,	100	} =	maps.results.slopeWkurt	;
results3C{1,	101	} =	maps.results.offsetWkurt	;
results3C{1,	102	} =	maps.results.slopeWent	;
results3C{1,	103	} =	maps.results.offsetWent	;
results3C{1,	104	} =	maps.results.slopePmean	;
results3C{1,	105	} =	maps.results.offsetPmean	;
results3C{1,	106	} =	maps.results.slopePmed	;
results3C{1,	107	} =	maps.results.offsetPmed	;
results3C{1,	108	} =	maps.results.slopePstd	;
results3C{1,	109	} =	maps.results.offsetPstd	;
results3C{1,	110	} =	maps.results.slopePskew	;
results3C{1,	111	} =	maps.results.offsetPskew	;
results3C{1,	112	} =	maps.results.slopePkurt	;
results3C{1,	113	} =	maps.results.offsetPkurt	;
results3C{1,	114	} =	maps.results.slopePent	;
results3C{1,	115	} =	maps.results.offsetPent	;
results3C{1,	116	} =	maps.results.slopeLmean	;
results3C{1,	117	} =	maps.results.slopeLmed	;
results3C{1,	118	} =	maps.results.offsetLmed	;
results3C{1,	119	} =	maps.results.slopeLstd	;
results3C{1,	120	} =	maps.results.offsetLstd	;
results3C{1,	121	} =	maps.results.slopeLskew	;
results3C{1,	122	} =	maps.results.offsetLskew	;
results3C{1,	123	} =	maps.results.slopeLkurt	;
results3C{1,	124	} =	maps.results.offsetLkurt	;
results3C{1,	125	} =	maps.results.slopeLent	;
results3C{1,	126	} =	maps.results.offsetLent	;
results3C{1,	127	} =	 maps.results.ROISXAmean 	;
results3C{1,	128	} =	maps.results.ROISXAmed	;
results3C{1,	129	} =	maps.results.ROISXAskew	;
results3C{1,	130	} =	maps.results.ROISXAkurt	;
results3C{1,	131	} =	maps.results.ROISXAent	;
results3C{1,	132	} =	maps.results.ROISXAstd	;
results3C{1,	133	} =	maps.results.bkgrSXA1mean	;
results3C{1,	134	} =	maps.results.bkgrSXA1med	;
results3C{1,	135	} =	maps.results.bkgrSXA1skew	;
results3C{1,	136	} =	maps.results.bkgrSXA1kurt	;
results3C{1,	137	} =	maps.results.bkgrSXA1ent	;
results3C{1,	138	} =	maps.results.bkgrSXA1std	;
results3C{1,	139	} =	maps.results.bkgrSXA2mean	;
results3C{1,	140	} =	maps.results.bkgrSXA2med	;
results3C{1,	141	} =	maps.results.bkgrSXA2skew	;
results3C{1,	142	} =	maps.results.bkgrSXA2kurt	;
results3C{1,	143	} =	maps.results.bkgrSXA2ent	;
results3C{1,	144	} =	maps.results.bkgrSXA2std	;
results3C{1,	145	} =	maps.results.bkgrSXA3mean	;
results3C{1,	146	} =	maps.results.bkgrSXA3med	;
results3C{1,	147	} =	maps.results.bkgrSXA3skew	;
results3C{1,	148	} =	maps.results.bkgrSXA3kurt	;
results3C{1,	149	} =	maps.results.bkgrSXA3ent	;
results3C{1,	150	} =	maps.results.bkgrSXA3std	;
results3C{1,	151	} =	maps.results.breastSXAmean	;
results3C{1,	152	} =	maps.results.breastSXAmed	;
results3C{1,	153	} =	maps.results.breastSXAskew	;
results3C{1,	154	} =	maps.results.breastSXAkurt	;
results3C{1,	155	} =	maps.results.breastSXAent	;
results3C{1,	156	} =	maps.results.breastSXAstd	;
results3C{1,	157	} =	maps.results.slopeSXAmean	;
results3C{1,	158	} =	maps.results.offsetSXAmean	;
results3C{1,	159	} =	maps.results.slopeSXAmed	;
results3C{1,	160	} =	maps.results.offsetSXAmed	;
results3C{1,	161	} =	maps.results.slopeSXAstd	;
results3C{1,	162	} =	maps.results.offsetSXAstd	;
results3C{1,	163	} =	maps.results.slopeSXAskew	;
results3C{1,	164	} =	maps.results.offsetSXAskew	;
results3C{1,	165	} =	maps.results.slopeSXAkurt	;
results3C{1,	166	} =	maps.results.offsetSXAkurt	;
results3C{1,	167	} =	maps.results.slopeSXAent	;
results3C{1,	168	} =	maps.results.offsetSXAent	;
results3C{1,	169	} =	maps.results.lesion_area	;
results3C{1,	170	} =	maps.results.breast_area	;
results3C{1,	171	} =	maps.results.negROIW	;
results3C{1,	172	} =	maps.results.negROIL	;
results3C{1,	173	} =	maps.results.negROIP	;
results3C{1,	174	} =	maps.results.negbkgrW1	;
results3C{1,	175	} =	maps.results.negbkgrL1	;
results3C{1,	176	} =	maps.results.negbkgrP1	;
results3C{1,	177	} =	maps.results.negbkgrW2	;
results3C{1,	178	} =	maps.results.negbkgrL2	;
results3C{1,	179	} =	maps.results.negbkgrP2	;
results3C{1,	180	} =	maps.results.negbkgrW3	;
results3C{1,	181	} =	maps.results.negbkgrL3	;
results3C{1,	182	} =	maps.results.negbkgrP3	;
results3C{1,	183	} =	maps.results.negbreastW	;
results3C{1,	184	} =	maps.results.negbreastL	;
results3C{1,	185	} =	maps.results.negbreastP	;
results3C{1,	186	} =	maps.results.lesionID	;
results3C{1,	187	} =	maps.results.Analysis_date	;
results3C{1,	188	} =	maps.results.Analysis_run	;

 %%
  save(fname_results,'maps');
 maps.results
 write_3CtoExcel(results3C,center);
 copyfile(fname_results,results_dir);
end
 a = 1;
% % % [fileName,pathName]=uigetfile('.png','Please select presentation image to be saved with calculated images.  Otherwise, LE attenuation image will be used.');
% % % if isempty(ROI)
% % %     ROI.ymin=1;
% % %     ROI.xmin=1;
% % %     ROI.rows=2047;
% % %     ROI.columns=1663;
% % % end
% % % %hack
% % % if isnumeric(fileName)
% % %     presentationImage=fredData.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% % % else
% % %     presentationImage=double(imread([pathName,fileName]));
% % % end
% % % waterImage=fredData.water;
% % % lipidImage=fredData.lipid;
% % % proteinImage=fredData.protein;
% % % thicknessImage=fredData.thickness;
% % % leImage=fredData.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% % % heImage=fredData.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% % % if isfield(fredData, 'SXAImage')
% % %     SXAImage=fredData.SXAImage;
% % % else
% % %     SXAImage=1;
% % % end
% % % [fileName,pathName]=uiputfile('.mat','Please choose name for mat file.');
% % % if isnumeric(fileName)
% % %     return
% % % else
% % %     save([pathName,fileName],'presentationImage','waterImage','lipidImage','proteinImage','thicknessImage','leImage','heImage', 'SXAImage');
% % % end
% % % end

