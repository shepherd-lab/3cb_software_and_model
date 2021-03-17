function mask = lesion_segmentation(mat_file, png_file )
% % Examples of png and mat file
% % mat_file = '\3C01001_ML_annotation.mat';
% % png_file = '\3CBset\3C01001_CC.png';
load(mat_file);
im = imread(png_file);
mask0 = zeros(size(im));
figure;imagesc(im);colormap(gray); hold on; %only for displaying 
for i = 1:length(FreeForm.FreeFormCluster(1,:))
  plot(FreeForm.FreeFormCluster(1,i).face(:,1),FreeForm.FreeFormCluster(1,i).face(:,2),'g-');
  mask(:,:,i) =  double(roipoly(im,FreeForm.FreeFormCluster(1,i).face(:,1),FreeForm.FreeFormCluster(1,i).face(:,2)));
  mask = mask0 | mask(:,:,i);
end 
 figure;imagesc(mask);colormap(gray); %only for displaying 

