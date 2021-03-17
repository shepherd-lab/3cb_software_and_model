function Muscle_Removal_MLO

global temproi

% % s= regionprops(temproi, 'BoundingBox');
% % BW3 = imcrop(BW2,s.BoundingBox);%crop the image 

BW3 =temproi;

BW3 = double(BW3);
BW3 = BW3 + 128 - 700;
l1 = BW3<=0;
l2 = BW3>=255;
BW3(l1)=0;
BW3(l2)=255;


BW2 = imclearborder(BW3);
Result = BW3 - BW2;

%Starting from the upper left corner, find the column index of the pixel in the first row, which is white. Let's denote it by j0.

j0 = 1;
while BW3(1, j0) ~= 1 
  j0 = j0 + 1;
end 

%2. Starting again from the upper left corner, find the row index of the pixel in the first column, which is white. Denote it by i0.

i0 = 1;
while BW3(i0, 1) ~= 1 
  i0 = i0 + 1;
end 

%3. The coordinates of these two white pixels are (1, j0) and (i0, 1), respectively. The points on the upper left side of the line connecting these two points (equation: j = a * i + b) have to be colored black:

a = (1 - j0) / (i0 - 1);
b = j0 - a;
for i = 1:i0
   for j = 1:round(a * i + b)
      BW3(i, j) = 0;
   end
end

%4. Some pixels on the lower right side of this line remain black. We have to color these white. The easiest way is to set the color of a strip of pixels on the lower right side of the line to white. Let's denote the width of this strip by w.

w = 20; % This depends on the resolution and the noise level of the image
for i = 1:round(i0 - w / a)
   for j = max(1, round(a * i + b + 1)):round(a * i + b + w)
      BW3(i, j) = 1; 
   end
end


end

 

% % % Notes
% % % 
% % % In step 1., instead of checking the value of a single pixel on the first row, it's better to compare the mean value of its neighborhood (of size n) to a threshold (t):
% % % 
% % % n = 10; t = 0.9; % These depend on the resolution and the noise level of the image
% % % c = 0:(n - 1);
% % % j0 = 1;
% % % while mean(mean(BW3(1 + c, j0 + c))) < t 
% % %   j0 = j0 + 1;
% % % end 
% % % 
% % % Similarly, in step 2.:
% % % 
% % % i0 = 1;
% % % while mean(mean(BW3(i0 + c, 1 + c))) < t 
% % %   i0 = i0 + 1;
% % % end 
% % % 
% % % Result