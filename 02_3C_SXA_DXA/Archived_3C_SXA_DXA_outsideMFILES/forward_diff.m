function forward_diff(signal)
    %load Altitude.txt -ascii
    datax = (1:length(signal))' ;
    datay = signal;
    
    fresult = fit(xdata(50:300),ydata(50:300),'poly1');
    figure;
    %lin_y = fresult.p1*
    plot(
    
    
    v=diff(datay)./diff(datax);
    datav = datax(1:end-1);
    v2 = smooth(diff(v)./diff(datav),20);
    plot(datav(100:500),v2(100:500));
    
    
    
    for n=1:10:length(signal)-1;
        v=((datay(n+1))-datay(n))/((datax(n+1))-datax(n));
        hold on;
        plot(datax(n),v,'o');
    end