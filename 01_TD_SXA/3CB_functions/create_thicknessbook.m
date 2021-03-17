function thickness_ROI = create_thicknessbook(thick,xdir_angle);
   global Analysis  ROI Info ctrl 
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%% v9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  X_angle = -0.2;    
  Y_angle = xdir_angle;
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
   tx = Analysis.tx;    %/0.014); % 
   ty = Analysis.ty;    %/0.014);
   xmax_pixels = Analysis.xmax_pixels;
    ymax_pixels = Analysis.ymax_pixels;
    resolution = Analysis.resolution_cm;
    %resolution = 0.014; %in cm 
   x_ROI = ROI.columns; %size_ROI(2)
   y_ROI = ROI.rows;   %size_ROI(1)
   Xcoord = 1:x_ROI;
   Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
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
   Z = ones(lenx*leny, 1)*thick;
   %figure; imagesc(Z);colormap(gray);
   Y = ymax_pixels/2   - Y - ROI.ymin; %-ROI.ymin
   
   one_colm = ones(lenx*leny,1);
   XYZ_matrix = [[X,Y]*resolution, Z,one_colm];    % in cm
   mmax1 = max(XYZ_matrix);
   mmin1 = min(XYZ_matrix);
   Tx1 = makehgtform('translate',[-tx -ty -thick]);
   Tx2 = makehgtform('translate',[tx ty thick]);
   %Y_angle = 0;
   Ry = makehgtform('yrotate',Y_angle*pi/180); 
   Rx = makehgtform('xrotate',X_angle*pi/180);           
   XYZ_trans = Tx2*Ry*Rx*Tx1*XYZ_matrix';
   mmax2 = max(XYZ_trans');
   mmin2 = min(XYZ_trans');
   %figure; imagesc(XYZ_trans);
   plane_coef = plane_fittting(XYZ_trans'); %*resolution  
   thickness_ROI = zeros(size(ROI.image));
    Y = ymax_pixels/2 - Y- ROI.ymin ;
    
   if Info.ViewId == 4 | Info.ViewId == 5 | get(ctrl.CheckAutoSkin,'value')== false
       middle = (ROI.ymax-ROI.ymin)/2;
   else
      middle = Analysis.ROIbreast_midpoint; 
   end
  % middle = (ROI.ymax-ROI.ymin)/2;
   half =  round(ymax_pixels/2);
   y_linspace = (1:ROI.rows) + ROI.ymin ;

%%%%%%%%%%%%%%%%%%%%%% v8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i = 1:x_ROI %x_ROI %xmax_pixels
       X1 = (i )*resolution;   %remove the coordinate shift x0_shift - x0_shift
       Y1 = (half - y_linspace(1:middle))*resolution ; % + y0_shift
       Yneg =  (half - y_linspace(middle+1:end))*resolution; %    + y0_shift                (ymax_pixels/2 -y_linspace(middle+1:end))*resolution;
       Ypos =  (half -  y_linspace(middle+1:end))*resolution; %    + y0_shift                       %(ymax_pixels/2-y_linspace(middle+1:end)*resolution;
       thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
       if X_angle >= 0
          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 + plane_coef(2)*Ypos + plane_coef(3);
       else
         thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
          %FD 2012/01/12 Corrected discontinuity;
       end
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%% end of v8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    a = 1;
     