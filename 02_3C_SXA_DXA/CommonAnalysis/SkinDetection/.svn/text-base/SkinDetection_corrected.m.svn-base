function [outline_xcorr,outline_ycorr] = SkinDetection_corrected(outline_x, outline_y,mid_point,thickness_ROI)
    global thickness_ROI MachineParams Analysis
    y0 = mid_point;
    S = 66.3;
    res = 0.014;
    h = MachineParams.bucky_distance;
    X_position = Analysis.params(5);
         
        upper_index = find(outline_y<=y0);
        upper_y = outline_y(outline_y<=y0);
        upper_x = outline_x(outline_y<=y0);
        upper_L = sqrt(upper_x.^2 + (upper_y-y0).^2);
       
        for i = 1:length(upper_x)
           thickness_ROIupper(i,1) =  thickness_ROI(upper_y(i),upper_x(i))';
        end
        %beta = atan(upper_L/s)
        upper_diff = (thickness_ROIupper/2+h).*upper_L/(S-h);
        upper_Lcorr = upper_L-upper_diff;
        upper_alfa = atan(upper_x ./ abs(upper_y-y0));
        outline_xcorr(upper_index) = upper_Lcorr.*sin(upper_alfa);
        outline_ycorr(upper_index) =  y0 - upper_Lcorr.*cos(upper_alfa);
        %figure;
        %plot(outline_x,outline_y,'b-', outline_xcorr, outline_ycorr,'r-');
        
        low_index = find(outline_y>y0);
        low_y = outline_y(outline_y>y0);
        low_x = outline_x(outline_y>y0);
        low_L = sqrt(low_x.^2 + (low_y-y0).^2);
        for i = 1:length(low_x)
           thickness_ROIlow(i,1) =  thickness_ROI(low_y(i),low_x(i))';
        end
        low_diff = (thickness_ROIlow/2+h).*low_L/(S-h);
        low_Lcorr = low_L-low_diff;
        low_alfa = atan(low_x ./ abs(low_y-y0));
        outline_xcorr(low_index) = low_Lcorr.*sin(low_alfa);
        outline_ycorr(low_index) = y0 + low_Lcorr.*cos(low_alfa);
        outline_xcorr = outline_xcorr';
        outline_ycorr = outline_ycorr';
        % figure; plot(outline_x,outline_y,'b-', outline_xcorr, outline_ycorr,'r-');
        a = 1;
        
     
        