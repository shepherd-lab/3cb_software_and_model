function [xMin,xMax,yMin,yMax, maxArea]=locate_sticker_fast(image, sticker)
%FUNCTION_NAME - this function finds the  position of a sticker image in an image (H1 line)
%pretty efficient, should be done rarely.  
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [xMin, xMax,yMin, yMax, maxArea] = locate_sticker(image, sticker)
%
% Inputs:
%    image - input image with sticker located somewhere in it
%    sticker - sticker image
% Outputs:
%    xMin, xMax - x position of left and right edges of sticker
%    yMin, yMax - y position of top and bottom edges of sticker
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Fred Duewer
% UCSF
% email: fwduewer@radiology.ucsf.edu 
% Website: http://www.ucsf.edu
% May 2004; Last revision: 12-May-2004

%------------- BEGIN CODE --------------
binImage=(image<5); %originally image==1
%Trick is - for processing images, sticker values at 16383.
binImage(1:10, :)=0;
%Ignore the top few lines.
labelBinImage=bwlabel(binImage);
%Convert to a matrix with defined regions - purely out of laziness
regionInfo=regionprops(labelBinImage);
%Use regionInfo to get information on all defined regions.
allArea=[regionInfo.Area];
allCentroid=[regionInfo.Centroid];
if ~isempty(allArea)
    %make sure that at least one region was defined
    [maxArea, maxAreaIndex]=max(allArea);
    %pick the largest region with a defined area.  For the sticker I'm
    %using - there are 2 areas, one of which is really tiny - inside of R.
    %Really should be the weighted average.  If this ever fails - add
    %comparison to bounding box and sticker dimensions.
    centroidSticker=[allCentroid(2*maxAreaIndex-1), allCentroid(2*maxAreaIndex)];
    x=centroidSticker(1);
    y=centroidSticker(2);
    yLength=size(sticker, 1);
    xLength=size(sticker,2);
    yImage=size(image, 1);
    xImage=size(image, 2);
    xMax=min([xImage-1, round(x+0.6*xLength)]);
    xMin=max([2, round(x-0.6*xLength)]);
    yMax=min([yImage-1, round(y+0.6*yLength)]);
    yMin=max([2, round(y-0.6*yLength)]);
    tempTestImage=image(yMin:yMax,xMin:xMax)==1;
    maxArea=min(nnz(tempTestImage), maxArea);
    %choose coordinates a bit outside the sticker dimension and inside the
    %image.
else
    maxArea=0;
    xMin=[];
    xMax=[];
    yMin=[];
    yMax=[];
    %return empty matrix if area does not exist.
end
end
