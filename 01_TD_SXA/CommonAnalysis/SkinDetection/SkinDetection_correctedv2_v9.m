function [outline_xcorr,outline_ycorr] = SkinDetection_correctedv2(outline_x, outline_y)
    global thickness_ROI MachineParams Analysis AutomaticAnalysis Image ROI
%     y0 = Analysis.midpoint;
     sz_image = size(Image.image);
    y0 = round(sz_image(1)/2 - ROI.ymin);
    S = 66.3;
    %res = 0.014;
    res = Analysis.Filmresolution/10;
    h = MachineParams.bucky_distance;
    S = MachineParams.source_height;
    
    if AutomaticAnalysis.PhantomlessSXA==false;
        
      Analysis.tx = Analysis.params(5); 
      
    end

     X_position=Analysis.tx;
    
         sz_ROI = size(thickness_ROI); 
        upper_index = find(outline_y<=y0);
        upper_y = outline_y(outline_y<=y0);
        upper_x = outline_x(outline_y<=y0);
        upper_L = sqrt(upper_x.^2 + (upper_y-y0).^2);
        m1up = min(upper_x);
        m2up = max(upper_x);
        if m2up > sz_ROI(2)
            max_index = find(upper_x >= sz_ROI(2)); %was upper_x == m2up
            upper_x(max_index) = sz_ROI(2);
        end
        m3up = min(upper_y);
        m4up = max(upper_y);
        thickness_ROIupper = zeros(length(upper_x),1);
        for i = 1:length(upper_x)
           thickness_ROIupper(i,1) =  thickness_ROI(upper_y(i),upper_x(i))';           
        end
        %upper_diff = (thickness_ROIupper/2+h).*upper_L/(S-h);
        %upper_Lcorr = upper_L-upper_diff;
        upper_beta = atan(upper_L*res/S);
        upper_d = thickness_ROIupper/2.*(1./cos(upper_beta) - 1);
        upper_Lcorr = (S - thickness_ROIupper/2 - h).* upper_L / S - upper_d;
        upper_alfa = atan(upper_x ./ abs(upper_y-y0));
        outline_xcorr(upper_index) = upper_Lcorr.*sin(upper_alfa);
        outline_ycorr(upper_index) =  y0 - upper_Lcorr.*cos(upper_alfa);
        %figure;
        %plot(outline_x,outline_y,'b-', outline_xcorr, outline_ycorr,'r-');
       
        low_index = find(outline_y>y0);
        low_y = outline_y(outline_y>y0);
        low_x = outline_x(outline_y>y0);
        low_L = sqrt(low_x.^2 + (low_y-y0).^2);
        m1low = min(low_x);
        m2low = max(low_x);
        if m2low > sz_ROI(2)
            max_index = find(low_x >= sz_ROI(2)); %low_x == m2low
            low_x(max_index) = sz_ROI(2);
        end
        m3low = min(low_y);
        m4low = max(low_y);
        %thickness_ROIlow(i,1)
        
        thickness_ROIlow = zeros(length(low_x),1);
        for i = 1:round(length(low_x))
            thickness_ROIlow(i,1) =  thickness_ROI(low_y(i),low_x(i))';
%            j= i
        end
        %low_diff = (thickness_ROIlow/2+h).*low_L/(S-h);
        %low_Lcorr = low_L-low_diff;
        low_beta = atan(low_L*res/S);
        low_d = thickness_ROIlow/2.*(1./cos(low_beta) - 1);
        low_Lcorr = (S - thickness_ROIlow/2 - h).* low_L / S - low_d;
        low_alfa = atan(low_x ./ abs(low_y-y0));
        outline_xcorr(low_index) = low_Lcorr.*sin(low_alfa);
        outline_ycorr(low_index) = y0 + low_Lcorr.*cos(low_alfa);
        outline_xcorr = outline_xcorr';
        outline_ycorr = outline_ycorr';
        % figure; plot(outline_x,outline_y,'b-', outline_xcorr, outline_ycorr,'r-');
        a = 1;
        
     
        