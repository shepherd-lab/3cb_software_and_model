
 clear maps;
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_maps_wo3CBorig\3C01018_ML.mat');
figure;imagesc(maps.LEatten);colormap(gray);hold on;
sz = size(maps.lesion);
len = sz(2);
for i=1:len  
plot(maps.lesion(i).xy(:,1),maps.lesion(i).xy(:,2),'b-')
end
figure;imagesc(maps.LEPres);colormap(gray);hold on;
for i=1:len  
plot(maps.lesion(i).xy(:,1),maps.lesion(i).xy(:,2),'b-')
end
figure;imagesc(maps.LEPresOrig);colormap(gray);hold on;
for i=1:len  
plot(maps.lesion(i).xy_orig(:,1),maps.lesion(i).xy_orig(:,2),'b-')
end
figure;imagesc(maps.LERawOrig);colormap(gray);hold on;
for i=1:len  
plot(maps.lesion(i).xy_orig(:,1),maps.lesion(i).xy_orig(:,2),'b-')
end
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\3C01018_ML_annotation.mat');
figure;imagesc(image);colormap(gray);hold on;
for i=1:len
plot(FreeForm.FreeFormCluster(i).face(:,1),FreeForm.FreeFormCluster(i).face(:,2),'-b');
end
figure;imagesc(maps.ROI_orig.BackGround);colormap(gray);
figure;imagesc(~maps.ROI_orig.BackGround.*double(maps.LERawOrig));colormap(gray);
a = 1;

%%
clear maps;
load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3CB_maps_wo3CBorig\3C02023_CC.mat');
figure;imagesc(maps.LEatten);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')

figure;imagesc(maps.LEPres);colormap(gray);hold on;
plot(maps.lesion.xy(:,1),maps.lesion.xy(:,2),'b-')

figure;imagesc(maps.LEPresOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')

figure;imagesc(maps.LERawOrig);colormap(gray);hold on;
plot(maps.lesion.xy_orig(:,1),maps.lesion.xy_orig(:,2),'b-')

load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\3C02023_CC_annotation.mat');
figure;imagesc(image);colormap(gray);hold on;
plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-b');

figure;imagesc(maps.ROI_orig.BackGround);colormap(gray);

figure;imagesc(~maps.ROI_orig.BackGround.*double(maps.LERawOrig));colormap(gray);
a = 1;
