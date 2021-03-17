function Periphery_calculation()
global X_angle ROI ROI2  MachineParams Analysis Outline thickness_ROI Info thickness_mapproj  thickness_mapreal breast_Maskcorr PreciseOutline Error
global flag BreastMask

% %    Error.PeripheryCalculation = false;
% %  try
%     ROI = ROI2;  %commented because ROI2 is commmented
     [v,d] = version;
    k = strfind(v, 'R2007a');
    if ~isempty(k)
        if isempty(getNumberOfComputationalThreads)
            fprintf('Multithreaded computation is disabled in your MATLAB session.\n');
            fprintf('Use Preferences to enable.\n');
            return
        end
        num = getNumberOfComputationalThreads;
        setNumberOfComputationalThreads(num);
    end
    
   tic
   Info.PeripheryComputed = false; 
    Analysis.Step = 3; %2.5;
    res = Analysis.Filmresolution/10;
    coef = 0.9;
    
    
    %Y_angle = (Analysis.ry + MachineParams.ry_correction)* 0.9 ;
    %X_angle = Analysis.rx + MachineParams.rx_correction/1.2; % ??? for sign of angle
     if flag.small_paddle ==  true  %small paddle
         X_angle = Analysis.rx - MachineParams.rx_correction;
         Y_angle = Analysis.ry - MachineParams.ry_correction;
     else
         X_angle = Analysis.rx;% - MachineParams.rx_correction;
         Y_angle = Analysis.ry - MachineParams.ry_correction;

     end
     
     
     thickness_ROI = thickness_ROIcreation_v8(X_angle,Y_angle); 
    % figure;plot(PreciseOutline.x, PreciseOutline.y,'-r');hold on;
    %figure;imagesc(thickness_ROI);colormap(gray);hold on; 
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %[inter_outline_x,inter_outline_x] = internal_SkinDetection(xt, yt,midpoint);
    %%%%%%%%%% internal skin detection - UNCOMMENT %%%%%%%%%%%%%%%%%%%%%%% 
    %
    
    %thickness_mapreal = ROI.image;
    % thickness_mapproj = projection_conversion(thickness_mapreal,midpoint)
    %figure; imagesc(thickness_ROI); colormap(gray);
   % [outline_xcorr,outline_ycorr] = SkinDetection_corrected(Outline.x',Outline.y' ,midpoint,thickness_ROI);
   
   
    [outline_xcorr,outline_ycorr] = SkinDetection_correctedv2(Outline.x',Outline.y');
    
    
    % [outline_xcorr,outline_ycorr] = SkinDetection_correctedv2(PreciseOutline.x(1:2:end)',PreciseOutline.y(1:2:end)');
    %figure; plot(Outline.x',Outline.y','m-', outline_xcorr,outline_ycorr,'b-');
    % [outline_xcorr,outline_ycorr] = SkinDetection_corrected(xt, yt,midpoint,thickness_ROI)
     breast_Maskcorr = (1 - roipoly(ROI.image,outline_xcorr,outline_ycorr));
     brestmask_corr=roipoly(ROI.image,outline_xcorr,outline_ycorr);
     Analysis.breast_areacorr  = bwarea(brestmask_corr);
     %figure; imagesc(breast_Maskcorr); colormap(gray);
     distbw =  bwdist(breast_Maskcorr);
    % zero_index = find(distbw == 0);
    % distbw(zero_index) = -130;
     distbw = distbw*res; %0.014;
     % [i,j,s] = find(distbw<thickness_ROI/2);
     %figure; imagesc(distbw); colormap(gray);
     %figure; imagesc(thickness_ROI); colormap(gray);
     distbw_thresh = distbw<thickness_ROI/2;
     
    % figure; imagesc(distbw_thresh); colormap(gray);
     periph_area = ~(~breast_Maskcorr - distbw_thresh);
     %figure; imagesc(periph_area); colormap(gray);
     %[iy1,jx1,s1] = find(breast_Maskcorr == 0 );
     %[iy2,jx2,s2] = find(distbw_thresh == 0);
     
     x = 2;
     inner_mask = ~distbw_thresh;
%      figure; imagesc(inner_mask);colormap(gray);
     
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
    
    % index1 = find(boundary(:,1)):
    % boundary(boundary(:,1) = [];
    % figure; plot(boundary(:,2), boundary(:,1), 'b-');
    % figure; imagesc(distbw_thresh);colormap(gray);hold on;  plot(boundary(:,2), boundary(:,1), 'b-');
    
    % figure; imagesc(periph_area); colormap(gray); hold on;
    %{
     plot(PreciseOutline.x, PreciseOutline.y,'-r');hold on;
     plot(outline_xcorr,outline_ycorr,'-y');hold on;
     plot(inner_x, inner_y, 'b-');
     %}
     %periph_index = (periph_area == 1);
     
     
     %distbw(i,j) = 0;
    % figure; imagesc(distbw); colormap(gray);
    %{
    [iy,jx,s] = find(periph_area);
     yx_inarea = [iy,jx];
     yxone_upperindex = find(yx_inarea(:,2) == 1 & yx_inarea(:,1)<(ymax-ymin)/2);
     yxone_upper = yx_inarea(yxone_upperindex,1);
     upper_one = max(yxone_upper);
     yxone_lowindex = find(yx_inarea(:,2) == 1 & yx_inarea(:,1)>(ymax-ymin)/2);
     yxone_low = yx_inarea(yxone_lowindex,1);
     low_one = min(yxone_low);
     %}
     
     inout_distance = sqrt((outline_xcorr - 1).^2 + (outline_ycorr - upper_one).^2);
     figure; plot(inout_distance); 
     min_distance = min(inout_distance);
     index_up = find(inout_distance == min_distance);
     x_up = outline_xcorr(index_up);
     y_up = outline_ycorr(index_up);
     
     inout_distance = sqrt((outline_xcorr - 1).^2 + (outline_ycorr - low_one).^2);
    figure; plot(inout_distance); 
    
     min_distance = min(inout_distance);
     index_low = find(inout_distance == min_distance);
     x_low = outline_xcorr(index_low);
     y_low = outline_ycorr(index_low);
     
     tanalfa_upper = abs((x_up-1)/(y_up-upper_one));
     x_poly =  upper_one * tanalfa_upper;
     upper_triangle = [[1, x_poly, 1]', [1, 1, upper_one]'];
     upper_corner = (1 - roipoly(ROI.image,upper_triangle(:,1),upper_triangle(:,2)));
      figure; imagesc(upper_corner); colormap(gray);
     
     %outline_xcorr,outline_ycorr
     
     tanalfa_low = abs((x_low-1)/(y_low-low_one));
     tanalfa_low = tanalfa_upper; % correction for MLO
     x_poly2 =  (ROI.rows-low_one) * tanalfa_low;
     low_triangle = [[1, x_poly2, 1]', [ROI.rows, ROI.rows, low_one]'];
     low_corner = (1 - roipoly(ROI.image,low_triangle(:,1),low_triangle(:,2)));
     two_corners = low_corner.*upper_corner;
     
      figure; imagesc(two_corners); colormap(gray); 
     
      thickness_mapreal = zeros(size(ROI.image));
     res2 = res^2;
          
     
     up_area = logical(~upper_corner).*periph_area;
     low_area = logical(~low_corner).*periph_area;
     
    figure; imagesc(up_area); colormap(gray);
    figure; imagesc(periph_area.*distbw); colormap(gray);
     figure; imagesc(low_area); colormap(gray);
     
     [iy_up,jx_up,s_up] = find(up_area);
     [iy_low,jx_low,s_low] = find(low_area);
     figure;
    plot(jx_up,iy_up,'.r'); hold on;
    plot(jx_low,iy_low,'.m'); hold on
     plot(outline_xcorr, outline_ycorr, '-b');hold on;
    plot(x_low, y_low,'*b',x_up, y_up,'*k');
     
    % index_up = find(jx_up==1);
    % jx_up(index_up) = [];
    % iy_up(index_up) = [];
     lenxy_up = length(iy_up);
     lenxy_low = length(iy_low); 
     
     maxx = max(jx_up);
     minx = min(jx_up);
     maxy = max(iy_up);
     miny = min(iy_up);
          
   % figure; plot(outline_xcorr,outline_ycorr,'-b');hold on;
   % plot(jx_up,iy_up, '.r',jx_low, iy_low, '.m');
    
    ab = [outline_xcorr,outline_ycorr];
    max_indexlow = max(find(outline_xcorr(1:round(end/2))<x_low));
    half_index = round(length(outline_xcorr)/2);
    values = outline_xcorr(half_index:end);
    min_indexup = min(find(values < (x_up))) + half_index;
   % max_indexup = find(values < (x_up+10));
    %max_indexup = min();
   % dist_value = distbw(maxy,minx);
    dist_valueup = distbw(inner_y(end),inner_x(end));
    dist_valuelow = distbw(inner_y(1),inner_x(1));
    %figure;
    min_indexup = find(outline_xcorr(half_index:end) == x_up);
    min_indexup = index_up;
    max_indexlow = index_low;
    t0 = toc
    
    tic
    for i= 1:lenxy_up-1 
         in_distance = (outline_xcorr(1:min_indexup)-jx_up(i)).^2 + (outline_ycorr(1:min_indexup)-iy_up(i)).^2; %min_indexup
        % plot(outline_xcorr(min_indexup:end), outline_ycorr(min_indexup:end), '-b', jx_up(i),iy_up(i),'.r'); hold on;
         min_distance = sqrt(min(in_distance));
         thickness_mapreal(iy_up(i),jx_up(i)) = dist_valueup^2 - (dist_valueup-min_distance*res)^2*coef;
    end 
    t1 = toc
%     figure; imagesc(thickness_mapreal); colormap(gray); 
    %dist_valuelow = distbw(inner_y(1),inner_x(1));
    tic
    for i= 1:lenxy_low-1 
         in_distance = (outline_xcorr(max_indexlow:end)-jx_low(i)).^2 + (outline_ycorr(max_indexlow:end)-iy_low(i)).^2;
         %plot(outline_xcorr(1:max_indexlow), outline_ycorr(1:max_indexlow), '-k', jx_low(i),iy_low(i),'.m'); hold on;
         min_distance = sqrt(min(in_distance));
         thickness_mapreal(iy_low(i),jx_low(i)) = dist_valuelow^2 - (dist_valuelow-min_distance*res)^2*coef;
    end 
    t2 = toc
    %figure; imagesc(thickness_mapreal); colormap(gray); 
     periph_areacorr = periph_area .* two_corners;
    figure; imagesc(periph_areacorr); colormap(gray); 
     
     B = logical(periph_areacorr);
    %  figure; imagesc(B); colormap(gray); 
     [iy,jx,s] = find(B); %periph_areacorr > 0 
     
     %{
     dbw = distbw(B);
     figure; imagesc(dbw); colormap(gray);
     BW = im2bw(periph_areacorr,0.4);
     lbw = bwlabel(BW); 
     stats2 = regionprops(lbw,'all');
     figure; plot(stats2(1,1).PixelList(:,1),stats2(1,1).PixelList(:,2),'r.'); 
     h = islogical(periph_areacorr);
     h2 = islogical(BW);
     figure; imagesc(BW); colormap(gray);
     A = nonzeros(B);
     axy = find(B == true);
     %}
     index = find(jx==1);
     %jx(index) = [];
     %iy(index) = [];
     lenxy = length(iy);
     
     
     
    % figure;imagesc(distbw); colormap(gray);
          
   % figure; plot(inner_x, inner_y, 'b-'); 
      %{
         in_distance = (inner_x(1:end)-jx(i)).^2 + (inner_y(1:end)-iy(i)).^2;
         min_distance = min(in_distance);
         index = find(in_distance == min_distance);
         thickness_mapreal(iy(i),jx(i)) = (distbw(inner_y(index(1)),inner_x(index(1)))^2 - min_distance*res2*coef)*0.996; 
      %}
       % setNumberOfComputationalThreads(8);  
        tic
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
   
    
   t3 = toc
% % %       cur_map = thickness_mapreal;
% % %       tic
% % %       coef2 = 0.996;
% % %       thickness_mapreal = (thickness_mapmex(res2,coef, coef2,int32(inner_x),int32(inner_y), int32(jx), int32(iy), distbw'))'; 
% % %       t_mex = toc
% % %      diff = cur_map - thickness_mapreal;
% % %      index = find(diff == 0);
% % %      figure;imagesc(cur_map);colormap(gray);
% % %      figure;imagesc(thickness_mapreal);colormap(gray);
% % %      figure;imagesc(diff);colormap(gray);
    % thickness_mapreal(thickness_ROIreal<0) = 0;
     tic
     thickness_mapreal(thickness_mapreal<0) = 0;
     thickness_mapreal = sqrt(thickness_mapreal)*2;
     thickness_mapreal = (thickness_ROI.* inner_mask) + thickness_mapreal;
     t4 = toc
     %figure; imagesc(thickness_mapreal); colormap(gray);
     %{
     figure; imagesc(thickness_mapreal); colormap(gray);
     x = (1:3:ROI.columns)*0.014;
     y = (1:3:ROI.rows)*0.014;
     [X,Y] = meshgrid(x,y);
     %figure;surf(X,Y,thickness_mapreal(1:2:end,1:2:end),'FaceColor','red','EdgeColor','none')
    
     figure;surfl(X,Y,thickness_mapreal(1:3:end,1:3:end));%colormap(gray); %camlight left; lighting phong
     %figure;plot3(X,Y,thickness_mapreal);
     %surfl(x,y,z);
     camlight left
     shading interp
     colormap(gray);
     volume = nansum(nansum(thickness_mapreal))*res2;
     %}
     
     thickness_mapproj = projection_conversion(thickness_mapreal); %thickness_mapreal,
    % figure; imagesc(thickness_mapproj);colormap(gray); 
     szmpr = size(thickness_mapproj);
     szbm = size(BreastMask);
     xbrmax = min([szmpr(2) szbm(2)]);
     
     BreastMask = BreastMask(:,1:xbrmax);
     thickness_mapproj = thickness_mapproj(:,1:xbrmax).*BreastMask;
    
     Info.PeripheryComputed = true;
     % commented for automatic analysis
     %
        draweverything;
        FuncActivateDeactivateButton; 
        
         figure;imagesc( thickness_mapproj); colormap(gray);
         a = 1;
     %}
     %{
     yxnoone_inareaindex = find(yx_inarea(:,2) ~= 1);
     yxnoone_inarea = yx_inarea(yxnoone_inareaindex,:);
     figure;plot(yxnoone_inarea(:,2), yxnoone_inarea(:,1),'r.');
     figure;plot(yxnoone_inarea(:,2), yxnoone_inarea(:,1),'r.');
     %}
    % a = 1;
     %}
     %figure; plot(inner_x,inner_y,'r-');
     
     %}
       % periphery region
     %{
         % figure; imagesc(im); colormap(gray);
         %
         im = 1- ROI.BackGround;
         distbw =  bwdist(1-im);
         figure; imagesc(distbw); colormap(gray);
         % figure; imagesc(L); colormap(gray);
             %bw = Zs1>0.3*max(max(Zs1));
             periph2 = 1 - (distbw < 77);
             figure; imagesc(periph2); colormap(gray);
             periph = im.*(distbw < 77);
             figure; imagesc(periph); colormap(gray);
             [Outline_inner.x,Outline_inner.y,error]=funcfindOutline(periph2);
             figure;plot(Outline.x,Outline.y, '-r', Outline_inner.x,Outline_inner.y,'-b');
                
             av = 1;
       %}
% %  catch
% %      errmsg = lasterr
% %    Error.PeripheryCalculation = true;
% %  end