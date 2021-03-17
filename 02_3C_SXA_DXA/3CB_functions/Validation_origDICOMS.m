
clear maps;
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_maps_wo3CBorig\3C01021_ML.mat');
figure;imagesc(maps.LEatten);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')
figure;imagesc(maps.LEPres);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')
figure;imagesc(maps.LEPresOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')
figure;imagesc(maps.LERawOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\3C01021_ML_annotation.mat');
figure;imagesc(image);colormap(gray);hold on;
plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-b');
figure;imagesc(maps.ROI_orig.BackGround);colormap(gray);
figure;imagesc(~maps.ROI_orig.BackGround.*double(maps.LERawOrig));colormap(gray);
a = 1;

%%
clear maps;
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3CB_maps_wo3CBorig\3C02073_ML.mat');
figure;imagesc(maps.LEatten);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')
figure;imagesc(maps.LEPres);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')
figure;imagesc(maps.LEPresOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')
figure;imagesc(maps.LERawOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\3C02073_ML_annotation.mat');
figure;imagesc(image);colormap(gray);hold on;
plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-b');
% figure;imagesc(maps.ROI_orig.BackGround);colormap(gray);
% figure;imagesc(~maps.ROI_orig.BackGround.*double(maps.LERawOrig));colormap(gray);
a = 1;
