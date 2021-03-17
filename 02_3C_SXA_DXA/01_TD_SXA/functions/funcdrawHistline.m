function drawHistline(x0,xmax,Handleline1,Handleline2,maxy);

%funcdrawHistline
%author Lionel HERVE
%date of creation 4-11-2003

set(Handleline1,'xdata',[x0 x0],'ydata',[0 maxy]);
set(Handleline2,'xdata',[xmax xmax],'ydata',[0 maxy]);
