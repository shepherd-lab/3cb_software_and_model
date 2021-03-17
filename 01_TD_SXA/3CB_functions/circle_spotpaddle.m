function breastspot_mask  = spot_circle()
   global  Image;
   im1 = Image.image;
%    figure;imagesc(im1);colormap(gray);
   se = strel('disk',100);
   %se = strel('rect',[100 100]);
   I_opened = imopen(im1,se);%figure; imagesc(I_opened);colormap(gray);
   im2 = im1-I_opened; %figure; imagesc(im2);colormap(gray);
    se1 = strel('disk',15);
     bw = im2>0.3*max(max(im2));
   bw1 = imdilate(bw,se1);
%      figure;imagesc(bw);colormap(gray); hold on;
%      [centers2, radii2, metric2] = imfindcircles(bw,[300 400],'Sensitivity',0.998);
%    delete h2;
%    h2 = viscircles(centers2(1:3,:),radii2(1:3)); hold off;%,'Method','twostage' 'ObjectPolarity','bright'
     
 
br_image = Image.image.*~bw1;
%     BW1edge = edge(br_image,'Canny'); hold on;
% %    figure;imagesc(br_image);colormap(gray);hold on;
   [centers, radii, metric] = imfindcircles(br_image,[300 400],'Sensitivity',0.999);
   delete h;
   
   [max_cent,max_ind] = max(metric);
   n_cent = min(max_ind,10);
   
%    h = viscircles(centers(1:n_cent,:),radii(1:n_cent)); %,'Method','twostage' 'ObjectPolarity','bright', 
   
   reg1 = regionprops(bw1,'centroid', 'Area');
   for i=1:length(reg1)
       area1(i) = reg1(i).Area;
   end
   [C,I] = max(area1);
   y_centr = reg1(I).Centroid(2);
   
   ind = find(centers(:,2) < (y_centr+10) & centers(:,2) > (y_centr-10));
   cent_metr = [centers(ind,:),radii(ind), metric(ind)];
   [Cmet,Imet] = max(metric(ind));
   center_circ = cent_metr(Imet,1:2);
   radii_circ = cent_metr(Imet,3)-10;
    delete hf;
%     figure;imagesc(br_image);colormap(gray);hold on;
%    hn = viscircles(center_circ,radii_circ); hold off;
   
if ~isempty(radii)   
    
     im_size = size(Image.image);
   spot_mask = zeros(im_size);
   disk.ind = circle_roi(center_circ, radii_circ,im_size);
   spot_mask(disk.ind) = 1;
   breastspot_mask = spot_mask.*~bw1
else   

   br_2 = imopen(br_image,se);
   br_3 = br_image - br_2;
   [centers3, radii3, metric3] = imfindcircles(br_3,[300 400],'Sensitivity',0.998,'Method','twostage');
   [max_cent3,max_ind3] = max(metric3);
   n_cent3 = min(max_ind3,10);     
    
   ind3 = find(centers3(:,2) < (y_centr+10) & centers3(:,2) > (y_centr-10));
   cent_metr3 = [centers3(ind3,:),radii3(ind3), metric3(ind3)];
   [Cmet3,Imet3] = max(metric3(ind3));
   center_circ3 = cent_metr3(Imet3,1:2);
   radii_circ3 = cent_metr3(Imet3,3)-20;   

%    figure;imagesc(BW3edge);colormap(gray);
%     figure;imagesc(br_3);colormap(gray);hold on;
%     delete h3;
%     h3 = viscircles(centers3(2,:),radii3(2));
%    total = bwarea(bw)
   
   im_size = size(Image.image);
   spot_mask3 = zeros(im_size);
   disk3.ind = circle_roi(center_circ3, radii_circ3,im_size);
   spot_mask3(disk3.ind) = 1;
   breastspot_mask = spot_mask3.*~bw1;
end
   
  
   
% %    figure;imagesc(spot_mask);colormap(gray);
%    spot_image = Image.image.*breastspot_mask;
%    figure;imagesc(spot_image);colormap(gray);
   
   
   
   
   
   a = 1;
   
   