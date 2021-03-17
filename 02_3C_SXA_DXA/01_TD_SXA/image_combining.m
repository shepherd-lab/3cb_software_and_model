function [ combine_image ] = image_combining(im2,im3, im4, im5)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% figure;imagesc(im2);colormap(gray);
% figure;imagesc(im3);colormap(gray);
% figure;imagesc(im4);colormap(gray);
% figure;imagesc(im5);colormap(gray);
global Image;
im_size = size(im2);
im_size2 = [im_size(1)*2 im_size(2)*2];
combine_image = zeros(im_size2);

im3 = flipdim(im3,2); %vertical = 1, horizontal = 2
im4 = flipdim(im4,1);
im5 = flipdim(im5,1);
im5 = flipdim(im5,2);
combine_image(1:im_size(1),1:im_size(2)) = im3; 
combine_image(1:im_size(1),im_size(2)+1:im_size2(2)) = im2;
combine_image(im_size(1)+1:im_size2(1),1:im_size(2)) = im3; 
combine_image(im_size(1)+1:im_size2(1),1:im_size(2)) = im5; 
combine_image(im_size(1)+1:im_size2(1),im_size(2)+1:im_size2(2)) = im4; 
%combine_image(1:im_size(1)+1:combine_image(1),1:im_size(2)) = im2;
%1:im_size(2)+1:combine_image(1)
figure;imagesc(combine_image);colormap(gray);
Image.image = combine_image;
Image.OriginalImage = combine_image;
ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
a = 1;
end

