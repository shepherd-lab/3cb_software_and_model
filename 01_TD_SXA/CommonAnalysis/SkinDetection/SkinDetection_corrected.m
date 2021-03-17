function [thicknessimage_real] = image_reprojection(thicknessimage_projected,mid_point)
    global thickness_ROI MachineParams Analysis ROI
    y0 = mid_point;
    x0 = 1;
    S = 66.3;
    %res = 0.014;
    res = Analysis.Filmresolution/10;
    h = MachineParams.bucky_distance;
    ymax = ROI,rows;
    xmax = ROI.columns;
    
    upper_image = thicknessimage_projected(1:y0,:)
    lower_image = thicknessimage_projected(y0+1:end,:);
    
        % temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
     thicknessimage_real = zeros(ROI.rows, ROI.columns);
        %upper_ROI = temproi(1:y0,:);
        y_uppervect = (1:y0)';
        %thickness_ROIupper = thickness_ROI(1:y0,:);
       % figure; imagesc(thickness_ROIupper);colormap(gray);
        sz = size(thickness_mapreal);
        thickness_maprealvect = reshape(thickness_mapreal',1,sz(1)*sz(2));
        %figure; imagesc(thickness_mapreal);colormap(gray);
        tic
        for i = 1:ROI.columns
            upper_L(:,1) = sqrt(i^2 + (y_uppervect-y0).^2);
            %upper_L = sqrt(upper_L2);
            upper_alfa(:,1) = atan(i ./ (y0 -y_uppervect+1));
            
            upper_beta = atan(upper_L*res/S);
            %upper_d = thickness_ROIupper(:,i)/2.*sin(upper_beta);
            upper_d = thickness_ROIupper(:,i)/2.*(1./cos(upper_beta) - 1);
            upper_dh = upper_d.*tan(pi/2-upper_beta);
            upper_Lcorr(:,1) = (S - thickness_ROIupper(:,i)/2 - h - upper_dh).* upper_L / S;
            x_corr(:,1) = upper_Lcorr.*sin(upper_alfa);
            y_corr(:,1) = y0 - upper_Lcorr.*cos(upper_alfa);
           % mx = min(x_corr);
           % my = min(y_corr);
            index_vect = round(x_corr) + round(y_corr-1)*sz(2);
            %min_index = min(index_vect);
            %max_index = max(index_vect);
            
            cur_vect = thickness_maprealvect(index_vect);
            thickness_mapproj(:,i) = cur_vect';
            proj_vect = thickness_mapproj(:,i);
            real_vect = thickness_mapreal(1:y0,i);
        end
        
        low_ROI = temproi(y0:end,:);
        y_lowvect = (y0:sz(1))';
        clear x_corr y_corr;
        
        thickness_ROIlow = thickness_ROI(y0:end,:);
        %figure; imagesc(thickness_ROIlow);colormap(gray);
        %sz = size(thickness_mapreal);
        %thickness_maprealvect = reshape(thickness_mapreal',1,sz(1)*sz(2));
        %figure; imagesc(thickness_mapreal);colormap(gray);
      
        for i = 1:ROI.columns
            low_L(:,1) = sqrt(i^2 + (y_lowvect-y0).^2);
            %upper_L = sqrt(upper_L2);
            low_alfa(:,1) = atan(i ./ (y_lowvect-y0+1));
            
            low_beta = atan(low_L*res/S);
            %low_dh = thickness_ROIlow(:,i)/2.*sin(low_beta);
            low_d = thickness_ROIlow(:,i)/2.*(1./cos(low_beta) - 1);
            low_dh = low_d.*tan(pi/2-low_beta);
            
            low_Lcorr(:,1) = (S - thickness_ROIlow(:,i)/2 - h - low_dh).* low_L / S;
            x_corr = low_Lcorr.*sin(low_alfa);
            y_corr = y0 + low_Lcorr.*cos(low_alfa);
           % mx = min(x_corr);
           % my = min(y_corr);
            index_vect = round(x_corr) + round(y_corr-1)*sz(2);
            %min_index = min(index_vect);
            %max_index = max(index_vect);
            
            cur_vect = thickness_maprealvect(index_vect);
            thickness_mapproj(y0:sz(1),i) = cur_vect';
            proj_vect = thickness_mapproj(y0:sz(1),i);
            real_vect = thickness_mapreal(y0:sz(1),i);
        end
    
        
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
        
     
        