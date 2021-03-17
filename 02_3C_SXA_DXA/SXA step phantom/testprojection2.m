
clear Phantom

s=60;
tx=4; ty=0; tz=0;
rx=0; ry=0; rz=0;

figure;
    Phantom(1).x=0;Phantom(1).y=1;Phantom(1).z=0;
    Phantom(2).x=0;Phantom(2).y=-1;Phantom(2).z=0;
    Phantom(3).x=4;Phantom(3).y=1;Phantom(3).z=0;
    Phantom(4).x=4;Phantom(4).y=-1;Phantom(4).z=0;
    Phantom(5).x=-1.557;Phantom(5).y=-2;Phantom(5).z=7.729;
    Phantom(6).x=-1.557;Phantom(6).y=2;Phantom(6).z=6.764;
    Phantom(7).x=2.986;Phantom(7).y=-2;Phantom(7).z=1.933;
    Phantom(8).x=2.986;Phantom(8).y=2;Phantom(8).z=0.965;

 for ry=0:40
    for index=1:size(Phantom,2)
        [xf(index),yf(index)]=projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
    end
    plot(xf,yf,'p','MarkerFaceColor','b');hold on;plot(0,0);hold off;
    set(gca,'Xlim',[0,20],'Ylim',[-15,15]);
    pause(0.5);
end
    
