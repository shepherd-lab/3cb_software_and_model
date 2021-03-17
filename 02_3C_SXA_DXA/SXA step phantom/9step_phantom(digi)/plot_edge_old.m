function [x_edge2,y_edge2] =  plot_edge(dist_coef, angle) 
    global Image figuretodraw Analysis
    %dist_coef  = 0.7;
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax = sz(2);
    ymax = sz(1);
    % breast edge
    y_edge = 305;
    x_edge = 794;
    
    diag = sqrt(x_edge^2 + (ymax/2-y_edge)^2)
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
    plot([1 x_edge ],[ ymax/2 y_edge],'Linewidth',2,'color','r'); hold on;
    %plot([x_edge x_edge2],[y_edge y_edge2],'Linewidth',2,'color','b');
    plot(794,305,'.','MarkerSize',5,'color','m');
    %plot(x_edge2, y_edge2,'.','MarkerSize',5,'color','y');
    a = 2;
    %lot(834,280,'Linewidth',2,'color','y');
    