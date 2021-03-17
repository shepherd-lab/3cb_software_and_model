function [zero_prc ] = zero_percrnt(roi_image )
 totind = find(roi_image ~= NaN);
 zindex = find(roi_image ==0); 
zero_prc = length(zindex)/length(totind)*100;
end

