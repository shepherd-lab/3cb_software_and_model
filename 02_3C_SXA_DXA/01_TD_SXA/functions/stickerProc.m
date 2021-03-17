function [stickFound,tempImage]=stickerProc(tempImage)
sticker=zeros(144,166);
[xMin,xMax,yMin,yMax, maxArea]=locate_sticker_fast(tempImage, sticker);
imageMask = zeros(size(tempImage));
imageMask(yMin:yMax,xMin:xMax) = 1;
stickFound=0;
if maxArea > 0 %originally 500
    if sum(sum(imageMask.*(tempImage==16383)))>=0 %originally 2000
        tempImage=roifill(tempImage,imageMask);
        stickFound=1;
    end
end
end
