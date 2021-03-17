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
function saveMat3C(src, event)
global fredData ROI Image patient_ID flip_info FreeForm file MaskROI_breast

 pname = file.startpath;
 [pathstr,name,ext] = fileparts(file.fname)
 maps = [];
 maps.LEPres= Image.LEPresFlipped(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  
 fname = ['3CBResults_',patient_ID,'_SM_2.mat'];
 fname_results = [pname,fname];
 maps.water = Image.material;
 maps.lipid = Image.thickness;
 maps.protein = Image.thirdcomponent;
 maps.thickness = Image.CTmask3C;
 %maps.LEPres = Image.LEPres_flipped;
 maps.LEatten  = Image.CLE;
 maps.ROI = ROI;
% %   mn = mean(mean(Image.CTmask3C));
% %   MaskROI_breast = Image.CTmask3C>(mn/crop_coef);
% %  maps.breast_mask = ~maps.ROI.BackGround;
 maps.breast_mask = MaskROI_breast;
 se = strel('disk',25);        
 maps.breast_mask = double(imerode(maps.breast_mask,se));
% %  figure;imagesc(maps.breast_mask);colormap(gray);
 
% % %  FreeForm.FreeFormCluster.face(:,1) = FreeForm.FreeFormCluster.face(:,1)- ROI.xmin;
% % %  FreeForm.FreeFormCluster.face(:,2) = FreeForm.FreeFormCluster.face(:,2)- ROI.ymin;
for i = 1:length(FreeForm.FreeFormCluster(1,:))
 maps.lesion(1,i).xy(:,1) = FreeForm.FreeFormCluster(1,i).face(:,1)- ROI.xmin;
 maps.lesion(1,i).xy(:,2) = FreeForm.FreeFormCluster(1,i).face(:,2)- ROI.ymin;
end
 
 FreeForm_flipped = FreeForm;
 maps.patient_ID = patient_ID;
 maps.flip_info = flip_info;
 maps.ROI = ROI;
  
 lesion_ROI = double(roipoly(maps.LEPres,maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2)));
%  figure;imagesc(maps.LEPres);colormap(gray);hold on; plot(maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2),'g-');
 
 distbw =  bwdist(lesion_ROI);
 distbw = distbw*0.014;
 distbw_thresh = distbw<0.25;
 lesion_periph = double(~(~lesion_ROI - distbw_thresh));
  

 %% lesion ROI
 lesion_ROI(lesion_ROI==0) = NaN;
 filter_ROIW = maps.water.*lesion_ROI;
 maps.results.ROIW = mean(filter_ROIW(~isnan(filter_ROIW)));
 filter_ROIL = maps.lipid.*lesion_ROI;
 maps.results.ROIL = mean(filter_ROIL(~isnan(filter_ROIL)));
 filter_ROIP = maps.protein.*lesion_ROI;
 maps.results.ROIP = mean(filter_ROIP(~isnan(filter_ROIP)));
% %  figure; imagesc(lesion_ROI); colormap(gray);
% %  figure; imagesc(filter_ROIW); colormap(gray);
%  figure; imagesc(filter_ROIL); colormap(gray);
% %  figure; imagesc(filter_ROIP); colormap(gray);

 %% lesion periphery
 lesion_periph(lesion_periph==0) = NaN;
 filter_bkgrW1 = maps.water.*lesion_periph;
 maps.results.bkgrW1 = mean(filter_bkgrW1(~isnan(filter_bkgrW1)));
 filter_bkgrL1 = maps.lipid.*lesion_periph;
 maps.results.bkgrL1 = mean(filter_bkgrL1(~isnan(filter_bkgrL1)));
 filter_bkgrP1 = maps.protein.*lesion_periph;
 maps.results.bkgrP1 = mean(filter_bkgrP1(~isnan(filter_bkgrP1)));
% %  figure; imagesc(lesion_periph); colormap(gray);
% %  figure; imagesc(filter_bkgrW1); colormap(gray);
%  figure; imagesc(filter_bkgrL1); colormap(gray);
% %  figure; imagesc(filter_bkgrP1); colormap(gray);
 %% breast
 maps.breast_mask(maps.breast_mask==0) = NaN;
 filter_breastW = maps.water.*maps.breast_mask;
 maps.results.breastW = mean(filter_breastW(~isnan(filter_breastW)));
 filter_breastL = maps.lipid.*maps.breast_mask;
 maps.results.breastL = mean(filter_breastL(~isnan(filter_breastL)));
 filter_breastP = maps.protein.*maps.breast_mask;
 maps.results.breastP = mean(filter_breastP(~isnan(filter_breastP)));
% %  figure; imagesc(maps.breast_mask); colormap(gray);
% %  figure; imagesc(filter_breastW); colormap(gray);
%  figure; imagesc(filter_breastL); colormap(gray);
% %  figure; imagesc(filter_breastP); colormap(gray);

 %%
 
  save(fname_results,'maps');
 maps.results
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

