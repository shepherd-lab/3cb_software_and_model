function redrawGraph;

global BBSPLOT Mammo pixelCm xf1 yf1
set(BBSPLOT,'xdata',xf1/0.0169,'ydata',size(Mammo,1)/2-yf1/0.0169,'marker','o','MarkerFaceColor','b');
