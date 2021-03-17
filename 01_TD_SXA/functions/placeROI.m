function placeROI();

%prompt user for coordinate & ROI values
prompt = {'Enter x-coordinate of ROI centroid','Enter y-coordinate of ROI centroid','Enter radius in cm of ROI'};
dlg_title = 'ROI info';
num_lines = 1;
ROIinfo = inputdlg(prompt,dlg_title,num_lines);

%set resolution scale
%resolution=200/2; %appropriate for GE images
resolution=140/2; %appropriate for Hologic images

%calculate coordinates for downsized images
x=str2num(cell2mat(ROIinfo(1,1)))/2;
y=str2num(cell2mat(ROIinfo(2,1)))/2;
r=str2num(cell2mat(ROIinfo(3,1)))/2*10000/resolution;

%plot centroid and circle with radius r
plot(x,y);
c=circle([x,y],r,1000,'-');
% d=circle([x,y],r*1.2,1000,'-');

