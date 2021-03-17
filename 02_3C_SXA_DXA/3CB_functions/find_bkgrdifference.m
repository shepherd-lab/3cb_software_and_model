function [mean_diff] = find_bkgrmask() 
%function calculates difference between backgrounds of log images of CP
%phantom and breast
%Input - no (not decided yet) 
%Outputs - mean value of background difference
%
global Image ;
breast.le = Image.LE;  %brast low energy log image
breast.he = Image.HE;  %breast high energy log image
phantom.le = Image.CPLE; %CP phantom low energy log image
phantom.he = Image.CPHE; %CP phantom high energy log image
sz = size(breast.le);

%upper-right mask coordinates 
row = [0, 0, 300];
col = [sz(2)-250,sz(2), sz(2)];
%
if sz(1) <1800  %small paddle
    corner_mask = ~roipoly(breast.le, col, row);
else    
%large paddle, corner mask includes upper-right corner and right side strip 
    corner_mask = roipoly(breast.le, col, row);
    row_strip = [0, 0, sz(1), sz(1)]; 
    col_strip = [sz(2)-300,sz(2), sz(2), sz(2)-300];
    right_mask = roipoly(breast.le, col_strip, row_strip); %right strip mask 
    corner_mask = ~imadd(corner_mask, right_mask); %union of the corner and right strip masks
end
corner_mask = corner_mask>=1; 
% threshold is 2000 for testing, would be  calculated for each image 
cpmask_le = (phantom.le>2000);  %calibration phantom mask
brmask_le = breast.le>2000; %breast mask
ttmask_le =imadd(cpmask_le,brmask_le);
ttmask_le = ttmask_le>=1;  %phantom and breast union mask
se = strel('disk',20);
ttmask_le = imdilate(ttmask_le,se);
ttmask_le = ~ttmask_le.*corner_mask; %background mask

ttmask_le(ttmask_le==0) = NaN; %assign NaN for 0 pixels
difimage_le = (breast.le-phantom.le).*ttmask_le; % different image of backgrounds of phantom and breast 
mean_diff  = mean(difimage_le(~isnan(difimage_le))) %mean value of the background difference

a = 1;


end

