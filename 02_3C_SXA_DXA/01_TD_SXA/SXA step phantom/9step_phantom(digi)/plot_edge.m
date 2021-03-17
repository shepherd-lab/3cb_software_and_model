function [x_edge2,y_edge2,film_small] =  plot_edge(dist_coef, angle) 
    global Image figuretodraw Analysis Info flag_digital
    %dist_coef  = 0.7;
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax = sz(2);
    ymax = sz(1);
    k  = Analysis.Filmresolution*0.1;
    long_diag = sqrt(xmax^2+(ymax/2)^2)* k
    angle_diag = atan(ymax/(2*xmax)) * 180/ pi
     if (sz(1) > 1900 & (Info.DigitizerId==3| flag_digital == true)) |  (sz(1) > 1700 & Info.DigitizerId~=3)
          % breast edge big paddle
          %y_edgeinit = 353; analog machine
          %x_edgeinit = 1030;
           y_edgeinit = 426;
          x_edgeinit = 1243;
          film_small = false;
     else
          % breast edge small paddle
           % y_edgeinit = 305; %analog
           % x_edgeinit = 794;
            y_edgeinit = 368; %digital
            x_edgeinit = 958;
            film_small = true;
     end
    
    ysource = ymax/2 ;%+ 2 / 0.015; 
    
    diag = sqrt(x_edgeinit^2 + (ysource-y_edgeinit)^2);
    x_edge = diag * cos(-angle * 6.28 / 360)
    y_edge = ysource - diag * sin(-angle * 6.28 / 360)
    
    
   % drawarc (diag,ymax/2);
   
    diag2 = diag * dist_coef / 12.1;
    dgx = diag2 * cos(-angle * 6.28 / 360)
    dgy = diag2 * sin(-angle * 6.28 / 360)
    
    y_edge2 = y_edge - dgy
    x_edge2 = x_edge + dgx
   % [xc,yc] =  drawarc (diag,ymax/2);
    redraw;
    figure(figuretodraw);
  %  plot(yc,xc,'r');   hold on;
    plot([1 x_edge ],[ysource y_edge],'Linewidth',2,'color','r'); hold on;
    %plot([x_edge x_edge2],[y_edge y_edge2],'Linewidth',2,'color','b');
    plot(x_edge,y_edge,'.','MarkerSize',5,'color','m');
    %plot(x_edge2, y_edge2,'.','MarkerSize',5,'color','y');
    a = 2;
    %lot(834,280,'Linewidth',2,'color','y');
    