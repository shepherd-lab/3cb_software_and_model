function [output, outputFeature_id]=mean_gradient(imageObj,maskObj,inputParam) 
CurrentImage=do_mask(imageObj.breastMask.*imageObj.imageRaw, maskObj);
%%%%%%%%%%%%%%%% MEAN GRADIENT %%%%%%%%%%%%%%%%%%%%%%%%%
im_size=size(CurrentImage);
d = 3;
im_xplusd = zeros(size(CurrentImage));
im_xminusd = zeros(size(CurrentImage));
im_yplusd = zeros(size(CurrentImage));
im_yminusd = zeros(size(CurrentImage));
im_xplusd(1:im_size(1)-d,:) = CurrentImage(d+1:im_size(1),:);
im_xminusd(d+1:im_size(1),:) = CurrentImage(1:im_size(1)-d,:);
im_yplusd(:,1:im_size(2)-d) = CurrentImage(:,d+1:im_size(2));
im_yminusd(:,d+1:im_size(2)) = CurrentImage(:,1:im_size(2)-d);
gd_image = abs(CurrentImage-im_xplusd) + abs(CurrentImage-im_xminusd) + abs(CurrentImage-im_yplusd) + abs(CurrentImage-im_yminusd);
gd_image = gd_image(d+1:im_size(1)-d,d+1:im_size(2)-d);
gd_size = size(gd_image);
mean_gd = sum(sum(gd_image))/(gd_size(1)*gd_size(2));
output=mean_gd;
outputFeature_id=inputParam.sub_func{1}.feature_id;
end

