function test_interp()
    x = [ 3 4  5 4.1 ] ; 
    y = [ 4 10   5 1 ]; 
    %pp = spline(x,y);
    %yy = ppval(pp, linspace(3,0.25,5));
    xx = 3:.25:5; 
    yy = spline(x,y,xx);
    figure;
    plot(x,y,'o',xx,yy)
    %yi = interp1(x,y,xi,'pchip'); 
   
   % plot(yy(1,:),yy(2,:),'-b');
   % plot(x,y,'o',xi,yi);