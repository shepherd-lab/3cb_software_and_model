function thickness_ROI = thickness_ROIcreation_v8(X_angle,Y_angle)
   global Analysis  ROI MachineParams Image Info ctrl flag
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%% v9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if Info.ViewId == 4 | Info.ViewId == 5
    if flag.small_paddle ==  true  %small paddle
        X_angle_calc = (Analysis.rx - MachineParams.rx_correction);
        X_angle = -0.1; %run=17
        if Info.ViewId == 5
            Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
        elseif Info.ViewId == 4
            Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
        else
            Y_angle = Analysis.ry - MachineParams.ry_correction;
        end
    else
        X_angle_calc = Analysis.rx - MachineParams.rx_correction;% - MachineParams.rx_correction;
        X_angle = -0.1; %run=17
        if Info.ViewId == 5
            Y_angle = Analysis.ry -MachineParams.ry_correction + X_angle_calc;
        elseif Info.ViewId == 4
            Y_angle = Analysis.ry -MachineParams.ry_correction  + X_angle_calc;
        else
            Y_angle = Analysis.ry-MachineParams.ry_correction;
        end
        
    end
else
    if flag.small_paddle ==  true  %small paddle
        if Info.ViewId == 2
            X_angle_calc = (Analysis.rx - MachineParams.rx_correction) -0.1;
        elseif Info.ViewId == 3
            X_angle_calc = (Analysis.rx - MachineParams.rx_correction) +0.1;
        else
            X_angle_calc = Analysis.rx - MachineParams.rx_correction;
        end
         Y_angle = Analysis.ry  - MachineParams.ry_correction;
        if X_angle_calc > -0.2
            X_angle = -0.2;
            if Y_angle > 8
                Y_angle = 8;
            end
           if Y_angle < 4
                Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
           end         
        else
            X_angle = X_angle_calc;
              if Y_angle > 8
                Y_angle = 8;                      
              end             
        end
    else
        if Info.ViewId == 2
            X_angle_calc = (Analysis.rx- MachineParams.ry_correction) -0.1;
        elseif Info.ViewId == 3
            X_angle_calc = (Analysis.rx- MachineParams.ry_correction) +0.1;
        else
            X_angle_calc = Analysis.rx- MachineParams.ry_correction ;
        end
        Y_angle = Analysis.ry -MachineParams.ry_correction;
        if X_angle_calc > -0.2
            X_angle = -0.2;
            if Y_angle > 8
                Y_angle = 8;
            end    
            if Y_angle < 4
                Y_angle = Analysis.ry -MachineParams.ry_correction + X_angle_calc;
            end
        else
            X_angle = X_angle_calc;
             Y_angle = Analysis.ry -MachineParams.ry_correction
            if Y_angle > 8
                Y_angle = 8;
            end
            
        end
    end
 end 
  Analysis.X_angle = X_angle;    
  Analysis.Y_angle = Y_angle;
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
   tx = Analysis.params(5);    %/0.014); % 
   ty = Analysis.params(6);    %/0.014);
   tz = Analysis.params(4);    %/0.014);
   x0_shift = -MachineParams.x0_shift;
   y0_shift = -MachineParams.y0_shift;
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
   
   %tz = 5.946;
   %resolution = 0.014; %in cm 
   resolution = Analysis.Filmresolution/10;
  % size_ROI = size(temproi);
   x_ROI = ROI.columns; %size_ROI(2)
   y_ROI = ROI.rows;   %size_ROI(1)
   Xcoord = 1:x_ROI;
   X_position = Analysis.params(5);
   Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
   %YXcoord_ROI = thickness;
   YXcoord_ROI = Xcoord_ROI;
   x_linspace = 1:x_ROI;
   y_linspace = ((1:y_ROI)')*resolution;  
   
   % calculation of the plane parameters 
   x_lnsparce = 1:3:x_ROI;
   y_lnsparce = ((1:3:y_ROI)')*resolution;  %cm
   leny = length(y_lnsparce);
   lenx = length(x_linspace);
   X = repmat(x_linspace', leny,1);
   Y = ones(lenx,1);
   for i = 2:leny
       Y = [Y;(3*(i-1)+1)*ones(lenx,1)];
   end    
   Z = ones(lenx*leny, 1)*tz;
   %figure; imagesc(Z);colormap(gray);
  % Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k
   X = X - x0_shift ;
   Y = ymax_pixels/2 + y0_shift  - Y - ROI.ymin; %-ROI.ymin
   
   one_colm = ones(lenx*leny,1);
   XYZ_matrix = [[X,Y]*resolution, Z,one_colm];    % in cm
   mmax1 = max(XYZ_matrix);
   mmin1 = min(XYZ_matrix);
   Tx1 = makehgtform('translate',[-tx -ty -tz]);
   Tx2 = makehgtform('translate',[tx ty tz]);
   %Y_angle = 0;
   Ry = makehgtform('yrotate',Y_angle*pi/180); 
   Rx = makehgtform('xrotate',X_angle*pi/180);           
   XYZ_trans = Tx2*Ry*Rx*Tx1*XYZ_matrix';
   mmax2 = max(XYZ_trans');
   mmin2 = min(XYZ_trans');
   %figure; imagesc(XYZ_trans);
   %xROI_trans = round(XYZ_trans(1:x_ROI,1));
   plane_coef = plane_fittting(XYZ_trans'); %*resolution
   
   
   thickness_ROI = zeros(size(ROI.image));
  % thickness_ROI = zeros(sz);
   X = X - x0_shift ;
   Y = ymax_pixels/2 + y0_shift  - Y- ROI.ymin ;
   
   % in real space
    %xmax_pixels = sz(2);
    %ymax_pixels = sz(1);
   % y_linspace = 1:ymax_pixels;
   if Info.ViewId == 4 | Info.ViewId == 5 | get(ctrl.CheckAutoSkin,'value')== false
       middle = (ROI.ymax-ROI.ymin)/2;
   else
   middle = Analysis.ROIbreast_midpoint; 
   end
  % middle = (ROI.ymax-ROI.ymin)/2;
   half =  round(ymax_pixels/2);
   y_linspace = (1:ROI.rows) + ROI.ymin ;
%    X_angle = -2;
  middle = round(middle);
%%%%%%%%%%%%%%%%%%%%%% v8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i = 1:x_ROI %x_ROI %xmax_pixels
       %middle = round(y_ROI/2)+ROI.ymin;  
       %middle =  round(ymax_pixels/2);
       X1 = (i )*resolution;   %remove the coordinate shift x0_shift - x0_shift
       Y1 = (half - y_linspace(1:middle))*resolution ; % + y0_shift
       % X1 = (i- x0_shift + ROI.xmin)*resolution
      % Y1 =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(1:middle);
       %Yneg =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(middle+1:end);
       %Ypos =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - (y_ROI*resolution-y_linspace(middle+1:end));
       Yneg =  (half - y_linspace(middle+1:end))*resolution; %    + y0_shift                (ymax_pixels/2 -y_linspace(middle+1:end))*resolution;
       Ypos =  (half -  y_linspace(middle+1:end))*resolution; %    + y0_shift                       %(ymax_pixels/2-y_linspace(middle+1:end)*resolution;
       %thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
       thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
       if X_angle >= 0
          %thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 + plane_coef(2)*Ypos + plane_coef(3);
       else
         % thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
          %FD 2012/01/12 Corrected discontinuity;
       end
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%% end of v8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
  
    
    %{
    for i = 1:x_ROI
       middle = round(y_ROI/2);  
       thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
       if X_angle < 0
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
       else
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
       end
    end
   %}
    thickness_ROI = thickness_ROI - MachineParams.bucky_distance;
    a = 1;
     