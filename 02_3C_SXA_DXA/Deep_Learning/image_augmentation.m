function image_augm =  image_augmentation(image)
%    I2 = imcrop(I,[75 68 130 112]);
%    J = imtranslate(I,[25.3, -10.1],'FillValues',0);
%    tform = affine2d([1 0 0; .5 1 0; 0 0 1])
%    J = imwarp(I,tform);
%    J = imrotate(I,-1,'bilinear','crop'); %'loose'
%    B = imresize(A,scale)
   %1 rotate 90 _1 rotate 20 degree _1 translate 0.2
%    image = imread('S:\Breast_Studies\DREAM\Our_presentation_png_dicoms\UCSF_dream_png\trainingData_png\1000096560.png');
%    figure;imagesc(image);colormap(gray);
   sz =size(image);
   x_tr = round(sz(2)*0.15);
   y_tr = round(sz(1)*0.15);
   width = sz(2)- x_tr;
   height = sz(1)- y_tr; 
   
   % warping
%    tform = affine2d([1 0 0; .15 1 0; 0 0 1])
%    image1_3 = imwarp(image,tform);
%    figure;figure;imagesc(image1_3);colormap(gray);
   
   image1_1_1 = image;
   image1_1 = flip(image,1);   
   image1_2 = flip(image,2);
   image1_2_1 = imrotate(image1_1_1,10,'crop'); %figure;figure;imagesc(image1_2_1);colormap(gray);
   image1_3_1 = imrotate(image1_1_1,-10,'crop'); %figure;imagesc(image1_3_1);colormap(gray);
   
   image1_1_2 = imcrop(imtranslate(image1_1_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);% figure;imagesc(image1_1_2);colormap(gray);
   image1_1_3 = imcrop(imtranslate(image1_1_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]); %figure;imagesc(image1_1_3);colormap(gray);
   image1_1_4 = imcrop(imtranslate(image1_1_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]); %figure;imagesc(image1_1_4);colormap(gray);
   image1_1_5 = imcrop(imtranslate(image1_1_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]); %figure;imagesc(image1_1_5);colormap(gray);
   image1_2_2 = imcrop(imtranslate(image1_2_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]); %figure;imagesc(image1_2_2);colormap(gray);
   image1_2_3 = imcrop(imtranslate(image1_2_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]); %figure;imagesc(image1_2_3);colormap(gray);
   image1_2_4 = imcrop(imtranslate(image1_2_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]); %figure;imagesc(image1_2_4);colormap(gray);
   image1_2_5 = imcrop(imtranslate(image1_2_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]); %figure;imagesc(image1_2_5);colormap(gray);
   image1_3_2 = imcrop(imtranslate(image1_3_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]); %figure;imagesc(image1_3_2);colormap(gray);
   image1_3_3 = imcrop(imtranslate(image1_3_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]); %figure;imagesc(image1_3_3);colormap(gray);
   image1_3_4 = imcrop(imtranslate(image1_3_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]); %figure;imagesc(image1_3_4);colormap(gray);
   image1_3_5 = imcrop(imtranslate(image1_3_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]); %figure;imagesc(image1_3_5);colormap(gray);
   
   image2_1_1 = imrotate(image,180,'crop');
%    image2_1_1 = flip(image,2);
   image2_2_1 = imrotate(image2_1_1,10,'crop');
   image2_3_1 = imrotate(image2_1_1,-10,'crop');
   image2_1_2 = imcrop(imtranslate(image2_1_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
   
   image2_1_3 = imcrop(imtranslate(image2_1_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
   image2_1_4 = imcrop(imtranslate(image2_1_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);
   image2_1_5 = imcrop(imtranslate(image2_1_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
   image2_2_2 = imcrop(imtranslate(image2_2_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
   image2_2_3 = imcrop(imtranslate(image2_2_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
   image2_2_4 = imcrop(imtranslate(image2_2_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
   image2_2_5 = imcrop(imtranslate(image2_2_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
   image2_3_2 = imcrop(imtranslate(image2_3_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
   image2_3_3 = imcrop(imtranslate(image2_3_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
   image2_3_4 = imcrop(imtranslate(image2_3_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);
   image2_3_5 = imcrop(imtranslate(image2_3_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
   
   
   image_augm(:,:,1) = image1_1_1;
   image_augm(:,:,2) = image1_1; 
   image_augm(:,:,3) = image1_2;   
  image_augm(:,:,4) = image1_2_1;
  image_augm(:,:,5) = image1_3_1;
  
  image_augm(:,:,6) = imresize(image1_1_2,[224 224]);% figure;imagesc(image1_1_2);colormap(gray);
   image_augm(:,:,7)= imresize(image1_1_3,[224 224]); %figure;imagesc(image1_1_3);colormap(gray);
   image_augm(:,:,8) = imresize(image1_1_4,[224 224]); %figure;imagesc(image1_1_4);colormap(gray);
  image_augm(:,:,9) = imresize(image1_1_5,[224 224]); %figure;imagesc(image1_1_5);colormap(gray);
  image_augm(:,:,10) = imresize(image1_2_2,[224 224]); %figure;imagesc(image1_2_2);colormap(gray);
  image_augm(:,:,11) = imresize(image1_2_3,[224 224]); %figure;imagesc(image1_2_3);colormap(gray);
  image_augm(:,:,12) = imresize(image1_2_4,[224 224]); %figure;imagesc(image1_2_4);colormap(gray);
   image_augm(:,:,13) = imresize(image1_2_5,[224 224]); %figure;imagesc(image1_2_5);colormap(gray);
  image_augm(:,:,14) = imresize(image1_3_2,[224 224]) ; %figure;imagesc(image1_3_2);colormap(gray);
  image_augm(:,:,15) = imresize(image1_3_3,[224 224]) ; %figure;imagesc(image1_3_3);colormap(gray);
  image_augm(:,:,16) = imresize(image1_3_4,[224 224]) ; %figure;imagesc(image1_3_4);colormap(gray);
 image_augm(:,:,17) = imresize(image1_3_5,[224 224]); %figure;imagesc(image1_3_5);colormap(gray);
   
  image_augm(:,:,18) = image2_1_1;
%    image2_1_1 = flip(image,2);
  image_augm(:,:,19) = image2_2_1;
  image_augm(:,:,20) = image2_3_1;
   
  image_augm(:,:,21) = imresize(image2_1_2,[224 224]);
   image_augm(:,:,22) = imresize(image2_1_3,[224 224]);
  image_augm(:,:,23) = imresize(image2_1_4,[224 224]);
  image_augm(:,:,24) = imresize(image2_1_5,[224 224]);
  image_augm(:,:,25) = imresize(image2_2_2,[224 224]);
  image_augm(:,:,26) = imresize(image2_2_3,[224 224]);
  image_augm(:,:,27) = imresize(image2_2_4,[224 224]);
  image_augm(:,:,28) = imresize(image2_2_5,[224 224]);
  image_augm(:,:,29) = imresize(image2_3_2,[224 224]) ;
  image_augm(:,:,30) = imresize(image2_3_3,[224 224]);
  image_augm(:,:,31) = imresize(image2_3_4,[224 224]);
  image_augm(:,:,32) = imresize(image2_3_5,[224 224]);
   
%% 
% % %    image3_1_1 = imrotate(image,90,'crop');
% % % %    image3_1_1 = flip(image,2);
% % %    image3_2_1 = imrotate(image3_1_1,10,'crop');
% % %    image3_3_1 = imrotate(image3_1_1,-10,'crop');
% % %    image3_1_2 = imcrop(imtranslate(image3_1_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image3_1_3 = imcrop(imtranslate(image3_1_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image3_1_4 = imcrop(imtranslate(image3_1_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image3_1_5 = imcrop(imtranslate(image3_1_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    image3_2_2 = imcrop(imtranslate(image3_2_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image3_2_3 = imcrop(imtranslate(image3_2_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image3_2_4 = imcrop(imtranslate(image3_2_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image3_2_5 = imcrop(imtranslate(image3_2_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    image3_3_2 = imcrop(imtranslate(image3_3_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image3_3_3 = imcrop(imtranslate(image3_3_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image3_3_4 = imcrop(imtranslate(image3_3_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image3_3_5 = imcrop(imtranslate(image3_3_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    
% % %    image4_1_1 = imrotate(image,270,'crop');
% % % %    image4_1_1 = flip(image,1);
% % % %   image4_1_1 = flip(image4_1_1,2);
% % %    image4_2_1 = imrotate(image4_1_1,10,'crop');
% % %    image4_3_1 = imrotate(image4_1_1,-10,'crop');
% % %    image4_1_2 = imcrop(imtranslate(image4_1_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image4_1_3 = imcrop(imtranslate(image4_1_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image4_1_4 = imcrop(imtranslate(image4_1_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image4_1_5 = imcrop(imtranslate(image4_1_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    image4_2_2 = imcrop(imtranslate(image4_2_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image4_2_3 = imcrop(imtranslate(image4_2_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image4_2_4 = imcrop(imtranslate(image4_2_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image4_2_5 = imcrop(imtranslate(image4_2_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    image4_3_2 = imcrop(imtranslate(image4_3_1,[x_tr, y_tr],'FillValues',0),[x_tr, y_tr,width, height]);
% % %    image4_3_3 = imcrop(imtranslate(image4_3_1,[-x_tr, y_tr],'FillValues',0),[1, y_tr,width, height]);
% % %    image4_3_4 = imcrop(imtranslate(image4_3_1,[x_tr, -y_tr],'FillValues',0),[x_tr, 1,width, height]);;
% % %    image4_3_5 = imcrop(imtranslate(image4_3_1,[-x_tr, -y_tr],'FillValues',0),[1, 1,width, height]);
% % %    
     a = 1;
end

