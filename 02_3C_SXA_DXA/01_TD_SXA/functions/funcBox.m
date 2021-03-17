%Modification 7-20-04 Handler management

function handler=funcBox(x1,y1,x2,y2,color,LineWidth,handler);

if ~exist('LineWidth')
    LineWidth=1;
end

if ~exist('handler')
   
    handler=plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'color',color,'linewidth',LineWidth);
   
else
    set(handler,'xdata',[x1 x1 x2 x2 x1],'ydata',[y1 y2 y2 y1 y1],'color',color,'linewidth',LineWidth);
end