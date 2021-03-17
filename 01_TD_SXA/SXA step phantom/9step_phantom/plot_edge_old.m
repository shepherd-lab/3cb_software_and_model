function [x_edge2,y_edge2] =  plot_edge(dist_coef, angle) 
    global Image figuretodraw Analysis
    %dist_coef  = 0.7;
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax = sz(2);
    ymax = sz(1);
    % breast edge small paddle
    y_edgeinit = 305; 
    x_edgeinit = 794;
     % breast edge big paddle
    %y_edgeinit = 353;
    %x_edgeinit = 1030;
    
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
    