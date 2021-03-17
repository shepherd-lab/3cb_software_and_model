function [imageOut maskOut] = applyLawsFilter(image, mask, fVer, fHor)
%ApplyLawsFilter will do 2D convolution on the masked region using the 
%specified Laws filters: horizontal filter (fHor) and vertical filter (fVer).

%define Laws filters
L3 = [1 2 1];
E3 = [-1 0 1];
S3 = [-1 2 -1];

L5 = [1 4 6 4 1];
E5 = [-1 -2 0 2 1];
S5 = [-1 0 2 0 -1];
W5 = [-1 2 0 -2 1];
R5 = [1 -4 6 -4 1];

L7 = [1 6 15 20 15 6 1];        %leverl filter
E7 = [-1 -4 -5 0 5 4 1];        %edge filter
S7 = [-1 -2 1 4 1 -2 -1];       %spot filter
W7 = [-1 0 3 0 -3 0 1];         %wave filter
R7 = [1 -2 -1 4 -1 -2 1];       %ripple filter
O7 = [-1 6 -15 20 -15 6 -1];    %oscillation filter

%construct 2D filter using the specified fHor and fVer
filterV = eval(fVer)';
filterH = eval(fHor);
filter2D = conv2(filterV, filterH);

% %get the minimum rectangular area to apply 2D filter
% xmin = maskObj.minRect(1);
% ymin = maskObj.minRect(2);
% xmax = maskObj.minRect(3);
% ymax = maskObj.minRect(4);
% imageIn = imageObj.image(ymin:ymax, xmin:xmax);
% maskOut = maskObj.image(ymin:ymax, xmin:xmax);
imageIn = image .* mask;

%apply 2D filter
imageOut = conv2(imageIn, filter2D, 'same');

%remove the edge effect
maskOut = mask;
imageOut = imageOut .* maskOut;