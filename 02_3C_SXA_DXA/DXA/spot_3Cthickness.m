function spot_3Cthickness()
   global  Image;
   im1 = Image.image;
%    figure;imagesc(im1);colormap(gray);
   se = strel('disk',100);
   %se = strel('rect',[100 100]);
   I_opened = imopen(im1,se);%figure; imagesc(I_opened);colormap(gray);
   im2 = im1-I_opened; %figure; imagesc(im2);colormap(gray);
    se1 = strel('disk',15);
     bw = im2>0.4*max(max(im2));
   bw1 = imdilate(bw,se1);
%      figure;imagesc(bw);colormap(gray); hold on;
%      [centers2, radii2, metric2] = imfindcircles(bw,[300 400],'Sensitivity',0.998);
%    delete h2;
%    h2 = viscircles(centers2(1:3,:),radii2(1:3)); hold off;%,'Method','twostage' 'ObjectPolarity','bright'
     
 
br_image = Image.image.*~bw1;
%     BW1edge = edge(br_image,'Canny'); hold on;
   figure;imagesc(br_image);colormap(gray);hold on;
   [centers, radii, metric] = imfindcircles(br_image,[300 400],'Sensitivity',0.998);
   delete h;
   
   [max_cent,max_ind] = max(radii);
   n_cent = min(max_ind,10);
   
   h = viscircles(centers(1:n_cent,:),radii(1:n_cent)); %,'Method','twostage' 'ObjectPolarity','bright', 
   
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
   radii_circ = cent_metr(Imet,3);
    delete hf;
   figure;imagesc(br_image);colormap(gray);hold on;
   hn = viscircles(center_circ,radii_circ); hold off;
   
   
   
   br_2 = imopen(br_image,se);
   br_3 = br_image - br_2;
%    figure;imagesc(bw1);colormap(gray);
   
%     BW3edge = edge(br_3,'Canny');
   [centers3, radii3, metric3] = imfindcircles(br_3,[300 400],'Sensitivity',0.998,'Method','twostage');
%    figure;imagesc(BW3edge);colormap(gray);
    figure;imagesc(br_3);colormap(gray);hold on;
    delete h3;
h3 = viscircles(centers3(2,:),radii3(2));
   total = bwarea(bw)
   
   
   
   
   
   
   a = 1;
   
   