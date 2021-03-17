function [output, outputFeature_id]=fractal_minkowski(imageObj,maskObj,inputParam)
%%%%%%%%%%%%%%%%%%%%%%%%%% FRACTAL MINKOWSKI DIMENSION%%%%%%%%%%%%%%%%%%%%%%%%%%
CurrentImage=do_mask(imageObj.imageRaw.*imageObj.breastMask,maskObj);
r = 1:10;
for i = 1:10
    se3 = strel('rectangle', i*[3 3]);
    bw1 = imerode(CurrentImage, se3);
    bw2 = imdilate(CurrentImage,se3);
    V(i) = log10(sum(sum((bw2-bw1)))/i^3); %#ok<AGROW>
end
pm = polyfit(log10(1./r(2:end)),V(2:end),1);
fr_mink=pm(1);
output = fr_mink;
outputFeature_id=inputParam.sub_func{1}.feature_id;
end
