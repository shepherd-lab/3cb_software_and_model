function [x, y]=mask_get_peakDensity(image)
imSize=min(size(image));
h=fspecial('gaussian', imSize, 100); %3 mm blur
blurImage=imfilter(image, h);
[yMax yIndex]=max(blurImage);
[xMax x]=max(yMax); %#ok<ASGLU>
y=yIndex(x);
end