function save_maps_wo3CB(dirname_towrite_maps, patient_id, view)
   global Image FreeForm ROI flip_info maps;
 maps = [];
 if isfield(ROI,'image') 
     ROI = rmfield(ROI,'image'); 
 end
 %% raw orig image
 image = imread(Image.fname_LEorig);
 Image.LERawOrigFlipped = flip_image(image);
 clear image;
 maps.LERawOrig = Image.LERawOrigFlipped(ROI.ymin*2:ROI.ymin*2+ROI.rows*2-1,ROI.xmin*2:ROI.xmin*2+ROI.columns*2-1);  
 %% presentation orig image
 image = imread(Image.fname_LEorigPres);
 Image.LERawOrigFlippedPres = flip_image(image);
 clear image;
 maps.LEPresOrig = Image.LERawOrigFlippedPres(ROI.ymin*2:ROI.ymin*2+ROI.rows*2-1,ROI.xmin*2:ROI.xmin*2+ROI.columns*2-1);  
 %%
 image = imread(Image.fname_LEPres);
 Image.LEPresFlipped = flip_image(image);
 clear image;
 maps.LEPres= Image.LEPresFlipped(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  
% fname = ['3CBResults_',patient_ID,'.mat'];
Image.CLE= Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  %%%for breas
 maps.LEatten  = Image.CLE;
 maps.ROI = ROI;
% % %  maps.breast_mask = MaskROI_breast;
% % %  se = strel('disk',25);        
% % %  maps.breast_mask = double(imerode(maps.breast_mask,se));
 maps.ROI_orig = convert_ROI(maps.ROI);

    for i = 1:length(FreeForm.FreeFormCluster(1,:))
     maps.lesion(1,i).xy(:,1) = FreeForm.FreeFormCluster(1,i).face(:,1)- ROI.xmin;
     maps.lesion(1,i).xy(:,2) = FreeForm.FreeFormCluster(1,i).face(:,2)- ROI.ymin;
     maps.lesion(1,i).xy_orig(:,1) = (FreeForm.FreeFormCluster(1,i).face(:,1)- ROI.xmin)*2;
     maps.lesion(1,i).xy_orig(:,2) = (FreeForm.FreeFormCluster(1,i).face(:,2)- ROI.ymin)*2;
    
    end
    
    
 FreeForm_flipped = FreeForm;
 maps.patient_ID = patient_id;
 maps.flip_info = flip_info;
 fname_results = [dirname_towrite_maps,patient_id,'_',view]; 
 lesion_ROI = double(roipoly(maps.LEPres,maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2)));
%  figure;imagesc(maps.LEPres);colormap(gray);hold on; plot(maps.lesion(1,i).xy(:,1),maps.lesion(1,i).xy(:,2),'g-');
  save(fname_results,'maps'); 
end

