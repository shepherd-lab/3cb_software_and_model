function test_spline()
    %{
    x = pi*[0:.5:2]; 
    y = [0  1  0 -1  0  1  0; 
         1  0  1  0 -1  0  1];
    pp = spline(x,y);
    yy = ppval(pp, linspace(0,2*pi,101));
    plot(yy(1,:),yy(2,:),'-b',y(1,2:5),y(2,2:5),'or'), axis equal
    
    xx = -4:0.1:0;
    x = [-4:0, -1:-1:-4]
    y = [1 .3 0.3 0.8 1 1.5 1.8 1.8 1];
    cs = spline(x, y,xx );
    xx = linspace(-4,4,101);
    plot(x,y,'o',xx,ppval(cs,xx),'-');
%}
 
    figure;%('position',get(0,'screensize'))
    axes('position',[0 0 1 1]); hold on;
    xlim([-5 5]);
    ylim([0 10]);
    x = 0
    y = 0;
    for i = 1:15
      [x(i+1),y(i+1)] = ginput(1);
      plot(x(i+1), y(i+1),'ro'); 
    
    end
    x(1) = x(end);
    y(1) = y(end);
    x = x';
    y = y';
    ManualEdge.NumberPoints = length(x);
    ManualEdge.Points = [x,y];
    Curve=funcComputeInterpolationCurve(ManualEdge)
    plot(Curve(:,1), Curve(:,2), '-r');
    x1 =  [0,diff(x')]
    t1 = sqrt(x1.^2)
    x2 = [0,diff(y')]
    t2 = sqrt(x2.^2)
    T = t1 + t2
    %t = cumsum(sqrt([0,diff(x')].^2 + [0,diff(y')].^2));
    t = cumsum(T);
    ti = linspace(t(1),t(end),100);

    xi = interp1(t,x',ti,'spline');
    yi = interp1(t,y',ti,'spline');

    xc = sum(xi)/ length(xi);
    yc = sum(yi)/ length(yi);
    
    x25 = xc + (xi-xc)*0.25;
    y25 = yc + (yi-yc)*0.25;
    
    x50 = xc + (xi-xc)*0.50;
    y50 = yc + (yi-yc)*0.50;
    
    x75 = xc + (xi-xc)*0.75;
    y75 = yc + (yi-yc)*0.75;
    
    plot(x,y,'b.',xi,yi,'r-', xc, yc,'*k', x75,y75, 'b-',x25, y25, 'g-', x50, y50, 'm-' ); 
    
    function Curve=funcComputeInterpolationCurve(ManualEdge)

        param = 1:ManualEdge.NumberPoints;
        listparam=[1:(ManualEdge.NumberPoints-1)/100:ManualEdge.NumberPoints];
        ManualEdgeX = spline(param',ManualEdge.Points(:,1),listparam);
        ManualEdgeY = spline(param',ManualEdge.Points(:,2),listparam);    
        Curve=[ManualEdgeX' ManualEdgeY'];
    