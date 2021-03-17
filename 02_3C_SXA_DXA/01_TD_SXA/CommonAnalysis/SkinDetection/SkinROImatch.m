function SkinROImatch()
global Outline ROI Image

   sz_ROI = size(ROI.image); 
     sz_image = size(Image.image);
    y0 = round(sz_image(1)/2 - ROI.ymin);
%      upper_x = outline_x(outline_y<=y0);       
     m1up = min(Outline.x);
     m2up = max(Outline.x);
        if m2up > sz_ROI(2)
%             max_index = find(upper_x >= sz_ROI(2)); %was upper_x == m2up
              ROI.xmax = m2up+1;
              ROI.columns = ROI.xmax - ROI.xmin +1;
              ROI.image = imresize(ROI.image,[ROI.rows ROI.columns]); 
              ROI.BackGround = imresize(ROI.BackGround,[ROI.rows ROI.columns]); 
             a = 1;
            ;
        end

end

