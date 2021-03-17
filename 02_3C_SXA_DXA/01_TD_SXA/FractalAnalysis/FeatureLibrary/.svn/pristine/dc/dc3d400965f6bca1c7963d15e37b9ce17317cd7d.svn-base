function [roi, isNewCalc] = featureCalcBreast(imageObj, comId, database)
%calculate breast outline and mask for feature analysis
%if comId is provided, read the breast outline parameters from
%'automaticBreast' and calculate breast mask
%if comId is absent, calculate breast outline and breast mask

if nargin == 1
    %calculate breast outline
    %step i: detect breast ROI region based on view position
    switch imageObj.imageInfo.viewPos
    case 'CC'
        findROI = @P01ROIDetection;
    case 'MLO'
        findROI = @P01MLOROIDetection;
    end
    %creast variable SXAInfo with necessary for findROI
    SXAInfo.PhantomData.DigitizerID = imageObj.imageInfo.digiId;
    if strcmpi(imageObj.imageInfo.padSize, 'small')
        SXAInfo.PhantomData.SmallPaddle = 1;
    else
        SXAInfo.PhantomData.SmallPaddle = 0;
    end
    [Analysis, SXAInfo] = findROI(SXAInfo, imageObj.image);
    
    %step ii: detect skin
    [Analysis, SXAInfo] = P01SkinDetectionv2(Analysis, SXAInfo);
    roi.xmin = SXAInfo.ROI.xmin;
    roi.ymin = SXAInfo.ROI.ymin;
    roi.rows = SXAInfo.ROI.rows;
    roi.cols = SXAInfo.ROI.columns;
    roi.midPoint = SXAInfo.ROI.midpoint;
    roi.outline.px = SXAInfo.ROI.Outline.px;
    roi.outline.py = SXAInfo.ROI.Outline.py;
    roi.breastMask = SXAInfo.ROI.BreastMask;
    isNewCalc = 1;
else
    %read outline parameters
    obs = database.getObs(commonTable, comId);
    roi.xmin = obs.roi_xmin;
    roi.ymin = obs.roi_ymin;
    roi.rows = obs.roi_rows;
    roi.cols = obs.roi_cols;
    roi.midPoint = obs.mid_point;
    
    roi.outline.px = zeros(1, 13);
    roi.outline.py = zeros(1, 13);
    for i = 1:13
        power = 12 - i + 1;
        roi.outline.px(i) = obs.(['x_p', num2str(power)]);
        roi.outline.py(i) = obs.(['y_p', num2str(power)]);
    end
    outline = P01calcOutline(roi.outline);
    roi.breastMask = P01calcBreastMask(outline, roi.rows, roi.cols);
    isNewCalc = 0;
end

% %convert the roi.breastMask to the whole image breastMask
% breastMask = zeros(imageObj.imageInfo.rows, imageObj.imageInfo.cols);
% xRange = roi.xmin:(roi.xmin + roi.cols - 1);
% yRange = roi.ymin:(roi.ymin + roi.rows - 1);
% breastMask(yRange, xRange) = roi.breastMask;
