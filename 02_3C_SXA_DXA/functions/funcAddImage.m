%Substract two images which can have different dimensions. The result will
%have the dimension of image1; the multiplication considere have the same
%'midpoint'  (=mid of the left edge)

%author Lionel HERVE 5-2-03

function image1=funcSubImage(image1,image2);

[y1,x1]=size(image1);
[y2,x2]=size(image2);
rangex=min(x1,x2);
rangey=min(y1,y2);
y2min=round((y2-rangey)/2);
y1min=round((y1-rangey)/2);
% figure('Name', 'ImageLinear');
%  imagesc(image1); colormap(gray);
 %  figure('Name', 'ImageInterp1');
 % imagesc(image2); colormap(gray);
 image1(y1min+1:y1min+rangey,1:rangex)=image1(y1min+1:y1min+rangey,1:rangex)+image2(y2min+1:y2min+rangey,1:rangex);

  %figure('Name', 'Linear-Interp1');
  %imagesc(image1); colormap(gray);