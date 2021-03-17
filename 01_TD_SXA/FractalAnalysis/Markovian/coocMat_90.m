function [comat, gmin] = coocMat_90(image, mask, dir, dist, numGray)
%COOCMAT calculates the coocurrance matrix of an input image
%dir takes four values: 0, 45, 90, 135

%determine the offset of neighbor
switch dir
    case 0
        offset = [0, dist];
    case 45
        offset = [-dist, dist];
    case 90
        offset = [dist, 0];
    case 135
        offset = [dist, dist];
    otherwise
        error('Direction must be 0, 35, 90 or 135');
end

% %crop the original image to the masked region
% xmin = maskObj.minRect(1);
% ymin = maskObj.minRect(2);
% xmax = maskObj.minRect(3);
% ymax = maskObj.minRect(4);
% image = imageObj.image(ymin:ymax, xmin:xmax);
% mask = maskObj.image(ymin:ymax, xmin:xmax);

%initialize the coocurrance matrix
% %get min and max gray levels in the masked region
% gmin = min(image(mask ~= 0));   %minimal gray level other than zero
% gmax = max(image(:));
%get the middle 90% range
g_05 = round(quantile(image(mask ~= 0), 0.05));
g_95 = round(quantile(image(mask ~= 0), 0.95));
deltaG=g_95-g_05;
g_05=g_05-0.3*deltaG;
g_95=g_95+0.3*deltaG;
comat = zeros(numGray, numGray);
%modify the mask to exclude the pixels further than 30% from the middle 90%
mask = (image >=g_05 & image <=g_95 & mask ~= 0);
image=round(((image-g_05+0.01)/(g_95-g_05+0.01)).*numGray);
image(image>numGray)=numGray;
image(image<1)=1;
%Modified to fix the number of gray levels. FD 10/18/2011
%populate the coocurrance matrix
[m, n] = size(image);
for i1 = 1:m
    for j1 = 1:n
        if mask(i1, j1) == 1
            px1 = image(i1, j1);
            i2 = i1 + offset(1);
            j2 = j1 + offset(2);
            if (i2 >= 1 && i2 <= m && j2 >=1 && j2 <=n && ...
                    mask(i2, j2) == 1)
                px2 = image(i2, j2);
                comat(px1, px2) = comat(px1, px2) + 1;
            end
        end
    end
end

comat = comat + comat';

comat = comat/sum(comat(:));
gmin = g_05;