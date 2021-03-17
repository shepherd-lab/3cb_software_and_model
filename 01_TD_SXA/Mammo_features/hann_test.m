function hann_test()

    
    rn = -15:15;
%     R = 30;
%     hn = 0.5*(cos(2*pi*rn/R)+1);
     %Rn = 15;
     R = 30;
     hn = 0.5*(cos(2*pi*rn/R)+1);
    r = 0:30;
    h = 0.5*(1-cos(2*pi*r/R));
    figure;plot(hn,'bo'); hold on; plot(h,'r-');
    a = 1;
    
    