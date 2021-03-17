% EPSILON-01 SXA PHANTOM ANALYSIS
% (PADDLE HEIGHT & ANGLE DETERMINATION, ROI PLACEMENT)
% optimization7.m
% March. 10, 2005
% using new set of films with Epsilon phantom at 3cm x 3cm
% further testing to optimize height & angle determination
% height determination for any pixel based on phantom position/angle calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TEST IMAGE SELECTION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
  

global xf1 yf1 BBSPLOT Mammo pixelCm
Mammo=imread(filename);
clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0;

figure;imagesc(Mammo);colormap(gray);
% xlim([-200 1500]);
% ylim([-200 2000]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MEASURED COORDINATES OF EPSILON-01 BBS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Phantom(1).x=4.22402;Phantom(1).y=0.9017;Phantom(1).z=0.2032;
Phantom(2).x=4.0513;Phantom(2).y=-1.09728;Phantom(2).z=0.2159;
Phantom(3).x=-1.14808;Phantom(3).y=0.91948;Phantom(3).z=6.63448;
Phantom(4).x=2.97688;Phantom(4).y=-2.4384;Phantom(4).z=1.8161;
Phantom(5).x=3.48996;Phantom(5).y=1.94564;Phantom(5).z=0.87376;
Phantom(6).x=-1.71704;Phantom(6).y=-3.42646;Phantom(6).z=7.49554;
Phantom(7).x=0.0635;Phantom(7).y=0.90424;Phantom(7).z=0.16764;
Phantom(8).x=-0.09906;Phantom(8).y=-1.0541;Phantom(8).z=0.127;

% to test 6cm gland films:
% Phantom(1).x=4.22402;Phantom(1).y=0.9017;Phantom(1).z=0.2032;
% Phantom(2).x=4.0513;Phantom(2).y=-1.09728;Phantom(2).z=0.2159;
% Phantom(3).x=-1.14808;Phantom(3).y=0.91948;Phantom(3).z=6.63448;
% Phantom(4).x=2.97688;Phantom(4).y=-2.4384;Phantom(4).z=1.8161;
% Phantom(5).x=-1.71704;Phantom(5).y=-3.42646;Phantom(5).z=7.49554;
% Phantom(6).x=0.0635;Phantom(6).y=0.90424;Phantom(6).z=0.16764;
% Phantom(7).x=-0.09906;Phantom(7).y=-1.0541;Phantom(7).z=0.127;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MEASURED BBS COORDINATES USING PHOTOSHOP %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4cm fat
Phantom(1).mx=1128;Phantom(1).my=208;
Phantom(2).mx=1120;Phantom(2).my=341;
Phantom(3).mx=886;Phantom(3).my=123;
Phantom(4).mx=1085;Phantom(4).my=413;
Phantom(5).mx=1096;Phantom(5).my=137;
Phantom(6).mx=869;Phantom(6).my=431;
Phantom(7).mx=857;Phantom(7).my=208;
Phantom(8).mx=851;Phantom(8).my=339;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on;
BBSPLOT=plot(0,0,'EraseMode','xor','LineStyle','none');

% plot of bbs at height 0cm with no angle using coordinates from photoshop
% plot([1016 1018 764 985 978],[263 385 123 438 192],'+')
% plot of bbs at height 1.8cm, scanning 2cm 50/50
% plot([-4 -8 -259 -46 -40 -272 -273],[-785 -654 -861 -581 -853 -560 -775],'+')

% compute a first crude tx, ty
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
% tx=0;
% ty=0;
tx=(MeanMX-MeanX);
ty=(MeanMY-MeanY);
[xf,yf]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz,s);
set (BBSPLOT,'xdata',pixelCm*xf,'ydata',size(Mammo,1)/2-pixelCm*yf,'marker','o','MarkerFaceColor','b');

merit0=merit(Phantom,pixelCm*xf,size(Mammo,1)/2-pixelCm*yf);

StepSize=0.01;
for bigindex=1:5

    %test x distances
    [xf1,yf1]=projectionsimulation(Phantom,tx+StepSize,ty,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
%         pause(StepSize);

    end

    %test y distances
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty+StepSize,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty-StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        ty=ty+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty+Sign*StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test z(+xy) distances
    [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz+StepSize,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz-StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx-Sign*StepSize*tx/s;
        ty=ty-Sign*StepSize*ty/s;
        tz=tz+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-Sign*StepSize*tx/s,ty-Sign*StepSize*ty/s,tz+Sign*StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test rx
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+StepSize,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        rx=rx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test ry
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+StepSize,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        ry=ry+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    StepSize=StepSize*0.8;
end

output=tx,ty,tz,rx,ry,rz

% phantom epsilon-01 roi placement
Phantom_a(1).x=-1.71958;Phantom_a(1).y=0.83566;Phantom_a(1).z=6.731;
Phantom_a(2).x=-0.69342;Phantom_a(2).y=0.83058;Phantom_a(2).z=6.73608;
Phantom_a(3).x=-0.77978;Phantom_a(3).y=-1.20396;Phantom_a(3).z=6.731;
Phantom_a(4).x=-1.79832;Phantom_a(4).y=-1.20904;Phantom_a(4).z=6.73608;

Phantom_b(1).x=-0.1651;Phantom_b(1).y=1.16586;Phantom_b(1).z=4.8387;
Phantom_b(2).x=0.83566;Phantom_b(2).y=1.16586;Phantom_b(2).z=4.83362;
Phantom_b(3).x=0.762;Phantom_b(3).y=-0.78486;Phantom_b(3).z=4.83616;
Phantom_b(4).x=-0.23114;Phantom_b(4).y=-0.74676;Phantom_b(4).z=4.8514;

Phantom_c(1).x=1.37668;Phantom_c(1).y=1.57734;Phantom_c(1).z=2.94894;
Phantom_c(2).x=2.37744;Phantom_c(2).y=1.57988;Phantom_c(2).z=2.9083;
Phantom_c(3).x=2.31394;Phantom_c(3).y=-0.4572;Phantom_c(3).z=2.90576;
Phantom_c(4).x=1.29032;Phantom_c(4).y=-0.36576;Phantom_c(4).z=2.91084;

Phantom_d(1).x=2.87274;Phantom_d(1).y=1.91516;Phantom_d(1).z=1.04902;
Phantom_d(2).x=3.89636;Phantom_d(2).y=1.91516;Phantom_d(2).z=1.01346;
Phantom_d(3).x=3.82016;Phantom_d(3).y=-0.12954;Phantom_d(3).z=1.01854;
Phantom_d(4).x=2.86004;Phantom_d(4).y=-0.0381;Phantom_d(4).z=1.01854;

Phantom_e(1).x=-2.07772;Phantom_e(1).y=-1.27508;Phantom_e(1).z=7.71144;
Phantom_e(2).x=-1.05918;Phantom_e(2).y=-1.2827;Phantom_e(2).z=7.71398;
Phantom_e(3).x=-1.14554;Phantom_e(3).y=-3.33756;Phantom_e(3).z=7.69874;
Phantom_e(4).x=-2.17424;Phantom_e(4).y=-3.32486;Phantom_e(4).z=7.70128;

Phantom_f(1).x=-0.51308;Phantom_f(1).y=-0.93726;Phantom_f(1).z=5.8293;
Phantom_f(2).x=0.49276;Phantom_f(2).y=-0.96266;Phantom_f(2).z=5.83692;
Phantom_f(3).x=0.39878;Phantom_f(3).y=-2.97688;Phantom_f(3).z=5.8166;
Phantom_f(4).x=-0.65278;Phantom_f(4).y=-3.00736;Phantom_f(4).z=5.81406;

Phantom_g(1).x=0.99314;Phantom_g(1).y=-0.60198;Phantom_g(1).z=3.937;
Phantom_g(2).x=2.02692;Phantom_g(2).y=-0.62992;Phantom_g(2).z=3.937;
Phantom_g(3).x=1.92278;Phantom_g(3).y=-2.65176;Phantom_g(3).z=3.7338;
Phantom_g(4).x=0.88646;Phantom_g(4).y=-2.65684;Phantom_g(4).z=3.683;

Phantom_h(1).x=2.55778;Phantom_h(1).y=-0.26162;Phantom_h(1).z=1.97866;
Phantom_h(2).x=3.56108;Phantom_h(2).y=-0.29718;Phantom_h(2).z=1.97612;
Phantom_h(3).x=3.4544;Phantom_h(3).y=-2.30124;Phantom_h(3).z=1.95834;
Phantom_h(4).x=2.4257;Phantom_h(4).y=-2.30886;Phantom_h(4).z=2.00406;

Phantom_i(1).x=0.04318;Phantom_i(1).y=2.08026;Phantom_i(1).z=0;
Phantom_i(2).x=0;Phantom_i(2).y=0;Phantom_i(2).z=0;
Phantom_i(3).x=-0.05334;Phantom_i(3).y=-2.01168;Phantom_i(3).z=0;
Phantom_i(4).x=3.95732;Phantom_i(4).y=-2.01168;Phantom_i(4).z=0;
Phantom_i(5).x=4.06908;Phantom_i(5).y=0;Phantom_i(5).z=0;
Phantom_i(6).x=4.1529;Phantom_i(6).y=2.08026;Phantom_i(6).z=0;

[xf_a,yf_a]=projectionsimulation(Phantom_a,tx,ty,tz,rx,ry,rz,s);
[xf_b,yf_b]=projectionsimulation(Phantom_b,tx,ty,tz,rx,ry,rz,s);
[xf_c,yf_c]=projectionsimulation(Phantom_c,tx,ty,tz,rx,ry,rz,s);
[xf_d,yf_d]=projectionsimulation(Phantom_d,tx,ty,tz,rx,ry,rz,s);
[xf_e,yf_e]=projectionsimulation(Phantom_e,tx,ty,tz,rx,ry,rz,s);
[xf_f,yf_f]=projectionsimulation(Phantom_f,tx,ty,tz,rx,ry,rz,s);
[xf_g,yf_g]=projectionsimulation(Phantom_g,tx,ty,tz,rx,ry,rz,s);
[xf_h,yf_h]=projectionsimulation(Phantom_h,tx,ty,tz,rx,ry,rz,s);
[xf_i,yf_i]=projectionsimulation(Phantom_i,tx,ty,tz,rx,ry,rz,s);

hold on;
plot([xf_a,xf_a(1)]*pixelCm,size(Mammo,1)/2-[yf_a,yf_a(1)]*pixelCm)
hold on;
plot([xf_b,xf_b(1)]*pixelCm,size(Mammo,1)/2-[yf_b,yf_b(1)]*pixelCm)
hold on;
plot([xf_c,xf_c(1)]*pixelCm,size(Mammo,1)/2-[yf_c,yf_c(1)]*pixelCm)
hold on;
plot([xf_d,xf_d(1)]*pixelCm,size(Mammo,1)/2-[yf_d,yf_d(1)]*pixelCm)
hold on;
plot([xf_e,xf_e(1)]*pixelCm,size(Mammo,1)/2-[yf_e,yf_e(1)]*pixelCm)
hold on;
plot([xf_f,xf_f(1)]*pixelCm,size(Mammo,1)/2-[yf_f,yf_f(1)]*pixelCm)
hold on;
plot([xf_g,xf_g(1)]*pixelCm,size(Mammo,1)/2-[yf_g,yf_g(1)]*pixelCm)
hold on;
plot([xf_h,xf_h(1)]*pixelCm,size(Mammo,1)/2-[yf_h,yf_h(1)]*pixelCm)
hold on;
plot([xf_i,xf_i(1),xf_i(2),xf_i(5)]*pixelCm,size(Mammo,1)/2-[yf_i,yf_i(1),yf_i(2),yf_i(5)]*pixelCm)