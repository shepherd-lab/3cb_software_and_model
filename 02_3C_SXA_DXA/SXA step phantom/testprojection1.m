clear Phantom

tx=10; ty=0; tz=0;
s=60;
rx=0; ry=0; rz=0;

figure;
    Phantom(1).x=0;Phantom(1).y=0;Phantom(1).z=0;
    Phantom(2).x=2*cos(30/180*pi);Phantom(2).y=2*sin(30/180*pi);Phantom(2).z=0;
    Phantom(3).x=2*cos(30/180*pi);Phantom(3).y=-2*sin(30/180*pi);Phantom(3).z=0;
    Phantom(4).x=sin(30/180*pi);Phantom(4).y=0;Phantom(4).z=10;
 
for tz=0:0.5:10
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end

for ty=0:0.5:5
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end

for tx=0:0.5:10
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end

for rx=mod(0:0.5:20,2)*15
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end

for ry=mod(0:0.5:20,2)*15
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end

for rz=mod(0:0.5:20,2)*15
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,24],'Ylim',[-15,15]);
    pause(0.1);
end