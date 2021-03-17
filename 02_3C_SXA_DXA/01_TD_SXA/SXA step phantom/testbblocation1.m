% EPSILON-01 SXA PHANTOM ANALYSIS
% (PADDLE HEIGHT & ANGLE DETERMINATION, ROI PLACEMENT)
% testphantomtype.m
% 2-16-2005

% filename='E:\john\newtestimage\Epsilon@3cm3cm-0cmDo not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-0.4cm(1cm)FatDo not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-1.2cm(2cm)FatDo not know-1.tif';
% 3cm not tested?
% filename='E:\john\newtestimage\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
% filename='E:\john\newtestimage\Epsilon@3cm3cm-4.4cm(5cm)FatDo not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-5.2cm(6cm)FatDo not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-6.2cm(7cm)FatDo not know-1.tif';  %ok but will have problem with
% filename='E:\john\newtestimage\Epsilon@3cm3cm-1.4cm(2cm)50-50Do not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-3.4cm(4cm)50-50Do not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-5.4cm(6cm)50-50Do not know-1.tif';  %failed because edge detection failed
% filename='E:\john\newtestimage\Epsilon@3cm3cm-1.4cm(2cm)GlandDo not know-1.tif';
% filename='E:\john\newtestimage\Epsilon@3cm3cm-3.3cm(4cm)GlandDo not know-1.tif';  %#6 is a problem
% filename='E:\john\newtestimage\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-1.tif';  %failed because edge detection failed
% filename='E:\john\newtestimage\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-2.tif';  %failed because edge detection failed
% filename='E:\john\newtestimage\Epsilon@3cm3cm-5.4cm(6cm)RachelDo not know-1.tif';


% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0cmDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0.4cm(1cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.2cm(2cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-2.2cm(3cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-4.4cm(5cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.2cm(6cm)FatDo not know-1.tif';   %problem with bb#4
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-6.2cm(7cm)FatDo not know-1.tif';  %problems with bbs#3,4,5,6
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)50-50Do not know-1.tif';
filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)50-50Do not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)50-50Do not know-1.tif';  %failed because edge detection failed
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)GlandDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.3cm(4cm)GlandDo not know-1.tif';  %problem with bb#6
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-1.tif';  %failed because edge detection failed
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-2.tif';  %failed because edge detection failed
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)RachelDo not know-1.tif';  %problem with bbs#4,6

% filename='P:\Vidar Images\test\conv2result1.tif';
% filename='P:\Vidar Images\test\conv2resultbad1.tif';
% filename='P:\Vidar Images\test\conv2result2.tif';
% filename='P:\Vidar Images\test\conv2resultbad2.tif';



global xf1 yf1 BBSPLOT Mammo pixelCm bin background threshold pos Mask0 maximage testImage
global  DEBUG
DEBUG=1;  %plot a lot of stuffs if debug==1

Mammo=imread(filename);
[x, y] = size(Mammo);
testImage =  imcrop(Mammo,[y/2 0 3*y/8 x/3]);
% four-element vector with the form [xmin ymin width height];
% testImage = Mammo

clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0; 

if DEBUG figure;imagesc(testImage);colormap(gray); end
 
%newImg = adapthisteq(testImage);
%newImg = histeq(testImage);
newImg = imadjust(testImage,stretchlim(testImage),[]);
newImg = adapthisteq(newImg);
%newImg = testImage;
if DEBUG figure;imagesc(newImg);colormap(gray);end

threshold = graythresh(newImg);
BW = im2bw(newImg,threshold);
if DEBUG figure;imagesc(BW),title('bw image');end


BW = imfill(BW, 'holes');
if DEBUG figure;imagesc(BW),title('fill holes ');end

[BW,thresh] = edge(double(BW),'sobel')
if DEBUG figure;imagesc(BW), title('sobel');end
 
BW = bwareaopen(BW,30);
if DEBUG figure, imshow(BW), title('small objects removed');end
 

%Now find the locations of bb #1 and #2
dim = size(BW);
col = round(dim(2));
offset = 50;

[col row] = findRow(BW, offset, round(dim(1)/2), col, 'right2left');

hold on; 
if DEBUG plot(col,row,'yx','LineWidth',2);end

%trace the edge of the bb circle, going down first
connectivity = 8;
num_points_down  = 15;
contour1 = bwtraceboundary(BW, [row, col], 'S', connectivity, num_points_down,'clockwise');

%getting around a bug in bwtraceboundary...
[sizex, sizey] = size(contour1);
if(sizex==0)
    col = col -1;
    [col row] = findRow(BW, offset, round(dim(1)/2), col, 'right2left');
end

if DEBUG plot(col,row,'yx','LineWidth',2);end
contour1 = bwtraceboundary(BW, [row, col], 'S', connectivity, num_points_down,'clockwise');

%trace the edge of the bb circle, going up, but take few pixels
num_points_up   = 15;
contour2 = bwtraceboundary(BW, [row, col], 'N', connectivity, num_points_up,'counterclockwise');

%estimate the 
contour = cat(1, contour1, contour2);
hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(1).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(1).my=circle.y;

% plot the entire circle
% use parametric representation of the circle to obtain coordinates
% of points on the circle
if DEBUG
theta = 0:0.01:2*pi;
Xfit = circle.r*cos(theta) + circle.x;
Yfit = circle.r*sin(theta) + circle.y;
hold on;
plot(Xfit, Yfit);
end

%detect bb #2
col = col + 2;      %start where we left of, but ignore area of bb#1
offset = round(circle.y)+15;

[col row] = findRow(BW, offset, round(dim(1)-100), col, 'right2left');

if DEBUG plot(col,row,'yx','LineWidth',2); end

contour1 = bwtraceboundary(BW, [row, col], 'S', connectivity, num_points_down,'clockwise');

[sizex, sizey] = size(contour1);
if(sizex==0)
    col = col -1;
    [col row] = findRow(BW, offset, round(dim(1)/2), col, 'right2left');
end

if DEBUG plot(col,row,'yx','LineWidth',2);end
contour1 = bwtraceboundary(BW, [row, col], 'S', connectivity, num_points_down,'clockwise');

%hold on;
%plot(contour1(:,2),contour1(:,1),'r','LineWidth',2);

%trace the edge of the bb circle, going up, but take few pixels

contour2 = bwtraceboundary(BW, [row, col], 'N', connectivity, num_points_up,'counterclockwise');
%hold on;
%plot(contour2(:,2),contour2(:,1),'g','LineWidth',2);

%estimate the 
contour = cat(1, contour1, contour2);
%hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(2).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(2).my=circle.y;

%detecting bb #3
row = 50;
offset = 50;

[col row] = findCol(BW, offset, round(dim(2)/2), row, 'top2bottom');

if DEBUG plot(col,row,'yx','LineWidth',2); end

contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');

[sizex, sizey] = size(contour1);
if(sizex==0)
    row = row+1;
    [col row] = findCol(BW, offset, round(dim(2)/2), row, 'top2bottom');
    if DEBUG plot(col,row,'yx','LineWidth',2);end
    contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');
end

%trace the edge of the bb circle, going up, but take few pixels

contour2 = bwtraceboundary(BW, [row, col], 'E', connectivity, num_points_up,'counterclockwise');
%hold on;
%plot(contour2(:,2),contour2(:,1),'g','LineWidth',2);

%estimate the 
contour = cat(1, contour1, contour2);
%hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(3).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(3).my=circle.y;

%detecting bb #5
row = row + 2;
offset = round(circle.x)+15;

[col row] = findCol(BW, offset, round(dim(2)-50), row, 'top2bottom');

if DEBUG plot(col,row,'yx','LineWidth',2); end

contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');

[sizex, sizey] = size(contour1);
if(sizex==0)
    row = row+1;
    [col row] = findCol(BW, offset, round(dim(2)/2), row, 'top2bottom');
    if DEBUG plot(col,row,'yx','LineWidth',2);end
    contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');
end

%trace the edge of the bb circle, going up, but take few pixels

contour2 = bwtraceboundary(BW, [row, col], 'E', connectivity, num_points_up,'counterclockwise');
%hold on;
%plot(contour2(:,2),contour2(:,1),'g','LineWidth',2);

%estimate the 
contour = cat(1, contour1, contour2);
%hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(5).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(5).my=circle.y;

%detecting bb #6
row = round(dim(1));;
offset = 50;

[col row] = findCol(BW, offset, round(dim(2)-50), row, 'bottom2top');

if DEBUG plot(col,row,'yx','LineWidth',2); end

contour1 = bwtraceboundary(BW, [row, col], 'E', connectivity, num_points_down,'clockwise');

[sizex, sizey] = size(contour1);
if(sizex==0)
    row = row-1;
    [col row] = findCol(BW, offset, round(dim(2)-50), row, 'bottom2top');
    if DEBUG plot(col,row,'yx','LineWidth',2);end
    contour1 = bwtraceboundary(BW, [row, col], 'E', connectivity, num_points_down,'clockwise');
end

%trace the edge of the bb circle, going up, but take few pixels

contour2 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_up,'counterclockwise');
%hold on;
%plot(contour2(:,2),contour2(:,1),'g','LineWidth',2);

%estimate the 
contour = cat(1, contour1, contour2);
%hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(6).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(6).my=circle.y;

%detecting bb #4
row = row - 2;
offset = round(circle.x)+150;

[col row] = findCol(BW, offset, round(dim(2)-50), row, 'bottom2top');

if DEBUG plot(col,row,'yx','LineWidth',2); end

contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');

[sizex, sizey] = size(contour1);
if(sizex==0)
    row = row-1;
    [col row] = findCol(BW, offset, round(dim(2)/2), row, 'bottom2top');
    if DEBUG plot(col,row,'yx','LineWidth',2);end
    contour1 = bwtraceboundary(BW, [row, col], 'W', connectivity, num_points_down,'clockwise');
end

%trace the edge of the bb circle, going up, but take few pixels

contour2 = bwtraceboundary(BW, [row, col], 'E', connectivity, num_points_up,'counterclockwise');
%hold on;
%plot(contour2(:,2),contour2(:,1),'g','LineWidth',2);

%estimate the 
contour = cat(1, contour1, contour2);
%hold on
if DEBUG plot(contour(:,2),contour(:,1),'g','LineWidth',2);end
circle = estimateCircle(contour);

% display the calculated center
hold on;
if DEBUG plot(circle.x,circle.y,'yx','LineWidth',2);end

%write the calculated output
Phantom(5).mx=circle.x + y/2;  %adjust to the orginal image size  
Phantom(5).my=circle.y;


