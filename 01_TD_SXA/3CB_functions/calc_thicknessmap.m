function  calc_thicknessmap(thick,xdir_angle)
global X_angle ROI ROI2  MachineParams Analysis Outline thickness_ROI Info thickness_mapproj  thickness_mapreal breast_Maskcorr PreciseOutline Error
global flag BreastMask

% %    Error.PeripheryCalculation = false;
% %  try
       
%    tic
    res = Analysis.Filmresolution/10;
    coef = 0.9;
     thick_wbacky = thick + 2.3;
     thickness_ROI = create_thicknessbook(thick_wbacky,xdir_angle);  %X_angle,Y_angle 
    [outline_xcorr,outline_ycorr] = SkinDetection_correctedv2(Outline.x',Outline.y');      
     breast_Maskcorr = (1 - roipoly(ROI.image,outline_xcorr,outline_ycorr));
     distbw =  bwdist(breast_Maskcorr);
     distbw = distbw*res; %0.014;
     distbw_thresh = distbw<thickness_ROI/2;
     periph_area = ~(~breast_Maskcorr - distbw_thresh);
     x = 2;
     inner_mask = ~distbw_thresh;
     ymin = min(find(inner_mask(:,1)==1));
     ymax = max(find(inner_mask(:,1)==1));
     boundary = bwtraceboundary(inner_mask,[ymin,1],'E');
     indexes = find(boundary(:,2)==1);
     boundary(indexes(3:end),:) = []; 
     sz_bnd  = size(boundary);
     len_bnd = sz_bnd(1);
     third = (len_bnd:-1:1)';
     boundary(:,3) = third;
     boundary = sortrows(boundary,3);
     boundary(:,3) = [];
    inner_x = boundary(:,2);
    inner_y = boundary(:,1);
    upper_one = min(inner_y);
    low_one = max(inner_y);
    
     inout_distance = sqrt((outline_xcorr - 1).^2 + (outline_ycorr - upper_one).^2);
     min_distance = min(inout_distance);
     index_up = find(inout_distance == min_distance);
     x_up = outline_xcorr(index_up);
     y_up = outline_ycorr(index_up);
     
     inout_distance = sqrt((outline_xcorr - 1).^2 + (outline_ycorr - low_one).^2);  
     min_distance = min(inout_distance);
     index_low = find(inout_distance == min_distance);
     x_low = outline_xcorr(index_low);
     y_low = outline_ycorr(index_low);
     
     tanalfa_upper = abs((x_up-1)/(y_up-upper_one));
     x_poly =  upper_one * tanalfa_upper;
     upper_triangle = [[1, x_poly, 1]', [1, 1, upper_one]'];
     upper_corner = (1 - roipoly(ROI.image,upper_triangle(:,1),upper_triangle(:,2)));
     tanalfa_low = abs((x_low-1)/(y_low-low_one));
%      tanalfa_low = tanalfa_upper; % correction for MLO
     x_poly2 =  (ROI.rows-low_one) * tanalfa_low;
     low_triangle = [[1, x_poly2, 1]', [ROI.rows, ROI.rows, low_one]'];
     low_corner = (1 - roipoly(ROI.image,low_triangle(:,1),low_triangle(:,2)));
     two_corners = low_corner.*upper_corner;
    
      thickness_mapreal = zeros(size(ROI.image));
     res2 = res^2;      
     
     up_area = logical(~upper_corner).*periph_area;
     low_area = logical(~low_corner).*periph_area;
     [iy_up,jx_up,s_up] = find(up_area);
     [iy_low,jx_low,s_low] = find(low_area);
     lenxy_up = length(iy_up);
     lenxy_low = length(iy_low); 
     
     maxx = max(jx_up);
     minx = min(jx_up);
     maxy = max(iy_up);
     miny = min(iy_up);
          
    ab = [outline_xcorr,outline_ycorr];
    max_indexlow = max(find(outline_xcorr(1:round(end/2))<x_low));
    half_index = round(length(outline_xcorr)/2);
    values = outline_xcorr(half_index:end);
    min_indexup = min(find(values < (x_up))) + half_index;
    dist_valueup = distbw(inner_y(end),inner_x(end));
    dist_valuelow = distbw(inner_y(1),inner_x(1));
    %figure;
    min_indexup = find(outline_xcorr(half_index:end) == x_up);
    min_indexup = index_up;
    max_indexlow = index_low;
%     t0 = toc
    
%     tic
    for i= 1:lenxy_up-1 
         in_distance = (outline_xcorr(1:min_indexup)-jx_up(i)).^2 + (outline_ycorr(1:min_indexup)-iy_up(i)).^2; %min_indexup
         min_distance = sqrt(min(in_distance));
         thickness_mapreal(iy_up(i),jx_up(i)) = dist_valueup^2 - (dist_valueup-min_distance*res)^2*coef;
    end 
%     t1 = toc
%     tic
    for i= 1:lenxy_low-1 
         in_distance = (outline_xcorr(max_indexlow:end)-jx_low(i)).^2 + (outline_ycorr(max_indexlow:end)-iy_low(i)).^2;
         %plot(outline_xcorr(1:max_indexlow), outline_ycorr(1:max_indexlow), '-k', jx_low(i),iy_low(i),'.m'); hold on;
         min_distance = sqrt(min(in_distance));
         thickness_mapreal(iy_low(i),jx_low(i)) = dist_valuelow^2 - (dist_valuelow-min_distance*res)^2*coef;
    end 
%     t2 = toc
   periph_areacorr = periph_area .* two_corners;
     B = logical(periph_areacorr);
     [iy,jx,s] = find(B); %periph_areacorr > 0 
     index = find(jx==1);
     lenxy = length(iy);
%       tic
        in_distance = zeros(size(inner_x));  
        min_distance = 0;
        index = 0;
        i = 1;
% % % % %   attemp to optimize  
% % % % %      distbw0 = zeros(size(distbw));
% % % % %       jx_rep = zeros(length(inner_x),length(jx(1:1000)));
% % % % %     iy_rep = zeros(length(inner_x),length(jx(1:1000)));
% % % % %      innx_rep = zeros(length(inner_x),length(jx(1:1000)));
% % % % %     inny_rep = zeros(length(inner_x),length(jx(1:1000)),1);
% % % % %     tic
% % % % %     jx_rep =repmat(jx(1:1000),1, length(inner_x))';
% % % % %     iy_rep =repmat(iy(1:1000),1,length(inner_x))';
% % % % %    
% % % % %     innx_rep = repmat(inner_x',length(jx(1:1000)),1)';
% % % % %     inny_rep = repmat(inner_y',length(jx(1:1000)),1)';
% % % % %     
% % % % %     
% % % % %     in_distance = (innx_rep-jx_rep).^2 + (inny_rep-iy_rep).^2;
% % % % %    % min_distance = min(in_distance);
% % % % %     [min_distance,index] =  min(in_distance);
% % % % %     %index = find(in_distance == min_distance);
% % % % %         % thickness_mapreal(iy((1:1000)),jx((1:1000))) = (distbw(inner_y(index(1)),inner_x(index(1)))^2 - min_distance*res2*coef)*0.996; 
% % % % %        % min_d = distbw0(inny_rep(index),innx_rep(index)) ;
% % % % %         tmatr = toc
% % % % %         thickness_mapreal(iy((1:1000)),jx((1:1000))) = (distbw(inny_rep(index),innx_rep(index))^2 - min_distance*res2*coef)*0.996; 
% % % % %         
% % % % %         for i= 1:1000%lenxy-1 
% % % % %          in_distance = double((inner_x-jx(i)).^2 + (inner_y-iy(i)).^2);
% % % % %          min_distance = min(in_distance);
% % % % %          index = find(in_distance == min_distance);
% % % % %          thickness_mapreal(iy(i),jx(i)) = (distbw(inner_y(index(1)),inner_x(index(1)))^2 - distbw0*res2*coef)*0.996; 
% % % % %         end   
        
        
        % right code
   for i= 1:lenxy-1 
         in_distance = double((inner_x-jx(i)).^2 + (inner_y-iy(i)).^2);
         min_distance = min(in_distance);
         index = find(in_distance == min_distance);
         thickness_mapreal(iy(i),jx(i)) = (distbw(inner_y(index(1)),inner_x(index(1)))^2 - min_distance*res2*coef)*0.996; 
   end   
   
    
%    t3 = toc
%      tic
     thickness_mapreal(thickness_mapreal<0) = 0;
     thickness_mapreal = sqrt(thickness_mapreal)*2;
     thickness_mapreal = ((thickness_ROI.* inner_mask) + thickness_mapreal) - 2.3;
%      calc_volume = sum(sum( thickness_mapreal.*(~breast_Maskcorr)*(Analysis.resolution_cm)^2));
%      t4 = toc
         
    
    
%       draweverything;
%         FuncActivateDeactivateButton; 
%         
%          figure;imagesc( thickness_mapproj); colormap(gray);
         a = 1;
  
       %}
% %  catch
% %      errmsg = lasterr
% %    Error.PeripheryCalculation = true;
% %  end