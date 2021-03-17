function maskDefList = mask_square(imageObj, coordStruct, mask)
%This function masks off a square region in an image.
%It creates a square mask, centered on coordStruct.XY
%mask.maskFcn.parameter_1 determines how the square size is calculated
%pixels - in pixels, centimeter - in centimeters, relative - relative to
%coordinate system (not implemented)
maskDefList.name=mask.name;
maskDefList.maskDefinition={};
xmin0=1;
ymin0=1;
xmax0=size(imageObj.imageRaw, 1);
ymax0=size(imageObj.imageRaw, 2);
squareSize=str2num(mask.maskFcn.parameter_2); %#ok<ST2NM>
for i=1:size(coordStruct.XY, 1)
    yCenter=interp2(imageObj.breastCoord.lateralMatrix, imageObj.breastCoord.distMatrix,...
        imageObj.breastCoord.xMatrix, coordStruct.XY(i,2), coordStruct.XY(i,1));
    xCenter=interp2(imageObj.breastCoord.lateralMatrix, imageObj.breastCoord.distMatrix,...
        imageObj.breastCoord.yMatrix, coordStruct.XY(i,2), coordStruct.XY(i,1));
    switch mask.maskFcn.parameter_1
        case 'pixels'
            xmin=round(xCenter-squareSize/2);
            xmax=round(xCenter+squareSize/2);
            ymin=round(yCenter-squareSize/2);
            ymax=round(yCenter+squareSize/2);
        case 'centimeter'
            pixelLength=round(10000*squareSize/(imageObj.resolution));
            xmin=round(xCenter-pixelLength/2);
            xmax=round(xCenter+pixelLength/2);
            ymin=round(yCenter-pixelLength/2);
            ymax=round(yCenter+pixelLength/2);
        otherwise
            error('mask_square:UNSUPPORTEDUNITTYPE', 'pixels and centimeter are supported');
    end
     maskDefList.maskDefinition{i}.xCenter=xCenter;
     maskDefList.maskDefinition{i}.yCenter=yCenter;
     maskDefList.maskDefinition{i}.nipRelPos=coordStruct.XY(i,1);
     maskDefList.maskDefinition{i}.edgeRelPos=coordStruct.XY(i,2);
     xmin2=limit_range(xmin, xmin0, xmax0);
     xmax2=limit_range(xmax, xmin0, xmax0);
     ymin2=limit_range(ymin, ymin0, ymax0);
     ymax2=limit_range(ymax, ymin0, ymax0);
     maskDefList.maskDefinition{i}.xmin=xmin2;
     maskDefList.maskDefinition{i}.xmax=xmax2;
     maskDefList.maskDefinition{i}.ymin=ymin2;
     maskDefList.maskDefinition{i}.ymax=ymax2;
     maskDefList.maskDefinition{i}.roiMask=ones(xmax2-xmin2+1, ymax2-ymin2+1);
end
end