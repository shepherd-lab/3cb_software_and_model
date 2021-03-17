function maskDefList = mask_centralquadrant(imageObj, coordStruct, mask) %#ok<INUSL>
%This function masks off a central region, a peak density region, and 4
%quadrants.  It is written to maintain compatability with previous
%versions.
%mask.maskFcn.parameter_1 determines how the square size is calculated
%pixels - in pixels, centimeter - in centimeters, relative - relative to
%coordinate system (not implemented)
%mask.maskFcn.parameter_2 determines the radius in the above unit.
maskDefList.name=mask.name;
maskDefList.maskDefinition={};
xmax0=size(imageObj.imageRaw, 1);
ymax0=size(imageObj.imageRaw, 2);
switch mask.maskFcn.parameter_1
    case 'pixels'
        radius=str2num(mask.maskFcn.parameter_2);        %#ok<ST2NM>
    case 'centimeter'
        radius=10*str2num(mask.maskFcn.parameter_2)/(imageObj.resolution); %#ok<ST2NM>
    otherwise
        error('mask_centralquadrant:UNSUPPORTEDUNITTYPE', 'pixels and centimeter are supported');
end
[x,y] = mask_coord_centerROIDensity(imageObj);
maskDefList.maskDefinition{1}=mask_circle_film([x,y],radius,1000,imageObj.imageRaw);
tempROI=zeros(xmax0, ymax0);
maskDefList.maskDefinition{2}.xmin=1;
maskDefList.maskDefinition{2}.xmax=xmax0;
maskDefList.maskDefinition{2}.ymin=1;
maskDefList.maskDefinition{2}.ymax=ymax0;
maskDefList.maskDefinition{2}.roiMask=tempROI;
maskDefList.maskDefinition{2}.roiMask(1:y, 1:x)=1;

maskDefList.maskDefinition{3}.xmin=1;
maskDefList.maskDefinition{3}.xmax=xmax0;
maskDefList.maskDefinition{3}.ymin=1;
maskDefList.maskDefinition{3}.ymax=ymax0;
maskDefList.maskDefinition{3}.roiMask=tempROI;
maskDefList.maskDefinition{3}.roiMask(1:y, x:end)=1;


maskDefList.maskDefinition{4}.xmin=1;
maskDefList.maskDefinition{4}.xmax=xmax0;
maskDefList.maskDefinition{4}.ymin=1;
maskDefList.maskDefinition{4}.ymax=ymax0;
maskDefList.maskDefinition{4}.roiMask=tempROI;
maskDefList.maskDefinition{4}.roiMask(y:end, 1:x)=1;

maskDefList.maskDefinition{5}.xmin=1;
maskDefList.maskDefinition{5}.xmax=xmax0;
maskDefList.maskDefinition{5}.ymin=1;
maskDefList.maskDefinition{5}.ymax=ymax0;
maskDefList.maskDefinition{5}.roiMask=tempROI;
maskDefList.maskDefinition{5}.roiMask(y:end, x:end)=1;

[x, y]=mask_get_peakDensity(imageObj.imageAtten);
%arguably wrong
maskDefList.maskDefinition{6}=mask_circle_film([x,y],radius,1000,imageObj.imageRaw);
end