function [x_edge, y_edge] = line_edge(current_image) 
    global Image figuretodraw
    sz = size(current_image); % 1407 1408 
    xmax = sz(2);
    ymax = sz(1);
    xindex = 1:xmax;
    yindex = ymax/2 - round(xindex*tan( 32 * 6.28 / 360));
    
    line_points = improfile(current_image,xindex,yindex);
    onepoint_index = find(line_points==0);
    edge_index =  min(onepoint_index);
    x_edge = xindex(edge_index);
    y_edge = yindex(edge_index);
    figure(figuretodraw);
    plot([1 x_edge ],[ ymax/2 y_edge],'Linewidth',2,'color','r');