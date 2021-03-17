function roi_orig = convert_ROI(roi)
 roi_orig.xmin = roi.xmin*2;
 roi_orig.xmax = roi.xmax*2;
 roi_orig.ymin = roi.ymin*2;
 roi_orig.ymax = roi.ymax*2;
 roi_orig.columns = roi.columns*2;
 roi_orig.rows = roi.rows*2;
 roi_orig.BackGround = imresize(roi.BackGround, size(roi.BackGround)*2);
end

