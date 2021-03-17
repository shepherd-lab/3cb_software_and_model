function test_rotate()
    figure;
   % h = surf(peaks(40));
   m = zeros(40,40);
   m(1:end,1:end) = 5;
   h = mesh(1:40,1:40,m);
    view(-20,30)
    t = hgtransform;
    set(h,'Parent',t);
    
    ry_angle = -30*pi/180; % Convert to radians
    Ry = makehgtform('yrotate',ry_angle);
    rx_angle = 30*pi/180; % Convert to radians
    Rx = makehgtform('xrotate',rx_angle);
    set(t,'Matrix',Ry*Rx);
    
    Tx1 = makehgtform('translate',[-20 0 0]);
    Tx2 = makehgtform('translate',[20 0 0]);
    set(t,'Matrix',Tx2*Ry*Tx1)
    ax = get(gca,'userdata');
    b = 1;
    
    