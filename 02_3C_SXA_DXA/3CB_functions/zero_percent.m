function [zero_prc ] = zero_percent(roi_image )
 nan_roi = isnan(roi_image);
 totind = find(nan_roi==0);
 zindex = find(roi_image < 0); 
zero_prc = length(zindex)/length(totind)*100;
end

