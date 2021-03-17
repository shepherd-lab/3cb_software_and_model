function thickness_ROI = thickness_ROIcreation(X_angle,Y_angle)
   global Analysis  ROI MachineParams Image
   
   tx = Analysis.params(5);    %/0.014); % 
   ty = Analysis.params(6);    %/0.014);
   tz = Analysis.params(4);    %/0.014);
   x0_shift = -MachineParams.x0_shift;
   y0_shift = -MachineParams.y0_shift;
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
   
   %tz = 5.946;
   resolution = 0.014; %in cm 
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
   Y = ymax_pixels/2 + y0_shift  - Y;
   
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
   Y = ymax_pixels/2 + y0_shift  - Y;
   
   % in real space
    %xmax_pixels = sz(2);
    %ymax_pixels = sz(1);
   % y_linspace = 1:ymax_pixels;
   middle = Analysis.midpoint; 
   half =  round(ymax_pixels/2);
   y_linspace = 1:ROI.rows;
    for i = 1:x_ROI %x_ROI %xmax_pixels
       %middle = round(y_ROI/2)+ROI.ymin;  
       %middle =  round(ymax_pixels/2);
       X1 = (i - x0_shift)*resolution;
       Y1 = (half - y_linspace(1:middle) + y0_shift)*resolution ;
       % X1 = (i- x0_shift + ROI.xmin)*resolution
      % Y1 =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(1:middle);
       %Yneg =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(middle+1:end);
       %Ypos =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - (y_ROI*resolution-y_linspace(middle+1:end));
       Yneg =  (half - y_linspace(middle+1:end) + y0_shift)*resolution; %                   (ymax_pixels/2 -y_linspace(middle+1:end))*resolution;
       Ypos =  (half -  y_linspace(middle+1:end) + y0_shift)*resolution;                           %(ymax_pixels/2-y_linspace(middle+1:end)*resolution;
       %thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
       thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
       if X_angle >= 0
          %thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 + plane_coef(2)*Ypos + plane_coef(3);
       else
         % thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3);
       end
    end
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
     