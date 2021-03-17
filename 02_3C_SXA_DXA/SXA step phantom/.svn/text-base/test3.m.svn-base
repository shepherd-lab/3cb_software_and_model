% Phantom at height 1.8cm, scanning 2cm 50/50
filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 1.8cm 50-50Do not know-1.tif';

global xf1 yf1 BBSPLOT Mammo pixelCm
Mammo=imread(filename);
clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0;

% Phantom at height 1.8cm, scanning 2cm 50/50
figure;imagesc(-1112,-912,Mammo);colormap(gray);

hold on;
BBSPLOT=plot(0,0,'EraseMode','xor','LineStyle','none');

plot([-4 -8 -259 -46 -40 -272 -273],[-785 -654 -861 -581 -853 -560 -775],'+')

% MEASURED COORDINATES OF EPSILON-01 BBS
Phantom(1).x=4.22402;Phantom(1).y=0.9017;Phantom(1).z=0.2032;
Phantom(2).x=4.0513;Phantom(2).y=-1.09728;Phantom(2).z=0.2159;
Phantom(3).x=-1.14808;Phantom(3).y=0.91948;Phantom(3).z=6.63448;
Phantom(4).x=2.97688;Phantom(4).y=-2.4384;Phantom(4).z=1.8161;
Phantom(5).x=3.48996;Phantom(5).y=1.94564;Phantom(5).z=0.87376;
Phantom(6).x=-1.71704;Phantom(6).y=-3.42646;Phantom(6).z=7.49554;
Phantom(7).x=0.0635;Phantom(7).y=0.90424;Phantom(7).z=0.16764;
% Phantom(8).x=-0.09906;Phantom(8).y=-1.0541;Phantom(8).z=0.127;

% Phantom at height 1.8cm, scanning 2cm 50/50
Phantom(1).mx=-4;Phantom(1).my=-785;
Phantom(2).mx=-8;Phantom(2).my=-654;
Phantom(3).mx=-259;Phantom(3).my=-861;
Phantom(4).mx=-46;Phantom(4).my=-581;
Phantom(5).mx=-40;Phantom(5).my=-853;
Phantom(6).mx=-272;Phantom(6).my=-560;
Phantom(7).mx=-273;Phantom(7).my=-775;

% %compute a first crude tx, ty
MeanX=0;MeanY=0;MeanMX=0;MeanMY=0;
for index=1:size(Phantom,2)
    MeanX=MeanX+Phantom(index).x;
    MeanY=MeanY+Phantom(index).y;
    MeanMX=MeanMX+Phantom(index).mx;
    MeanMY=MeanMY+Phantom(index).my;
end
MeanX=MeanX/size(Phantom,2);
MeanY=MeanY/size(Phantom,2);
MeanMX=MeanMX/size(Phantom,2)/pixelCm;
MeanMY=-(MeanMY/size(Phantom,2)-size(Mammo,1)/2)/pixelCm;

tz=0;
tx=(MeanMX-MeanX);
ty=(MeanMY-MeanY);
[xf,yf]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz,s);
set (BBSPLOT,'xdata',pixelCm*xf,'ydata',size(Mammo,1)/2-pixelCm*yf,'marker','o','MarkerFaceColor','b');
