% DELTA-01 SXA PHANTOM ANALYSIS
% (PADDLE HEIGHT & ANGLE DETERMINATION, ROI PLACEMENT)
% optimization3.m
% OCT. 15, 2004

% Phantom at height 0cm with no angle
filename='P:\Vidar Images\test\bbs5.tif';

% Phantom at height 2cm with no angle
% filename='P:\Vidar Images\test\bbs7.tif';

% Phantom at height 4cm with no angle
% filename='P:\Vidar Images\test\bbs9.tif';

% Phantom at height 6cm with no angle
% filename='P:\Vidar Images\test\bbs11.tif';

% Phantom at height 2cm with 1.43 degree angle
% filename='P:\Vidar Images\test\bbs6.tif';

% Phantom at height 4cm with 1.43 degree angle
% filename='P:\Vidar Images\test\bbs8.tif';

% Phantom at height 6cm with 1.43 degree angle
% filename='P:\Vidar Images\test\bbs10.tif';

global xf1 yf1 BBSPLOT Mammo pixelCm
Mammo=imread(filename);
clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0;

figure;imagesc(Mammo);colormap(gray);

% original measured bbs coordinates
% Phantom(1).x=4;Phantom(1).y=1;Phantom(1).z=0;
% Phantom(2).x=4;Phantom(2).y=-1;Phantom(2).z=0;
% Phantom(3).x=-1.557;Phantom(3).y=2;Phantom(3).z=6.764;
% Phantom(4).x=2.986;Phantom(4).y=-2;Phantom(4).z=1.933;
% Phantom(5).x=2.986;Phantom(5).y=2;Phantom(5).z=0.965;

% new (more accurate) measured bbs coordinates
Phantom(1).x=4.00304;Phantom(1).y=1.03886;Phantom(1).z=0.18542;
Phantom(2).x=3.99542;Phantom(2).y=-0.97536;Phantom(2).z=0.23114;
Phantom(3).x=-1.38684;Phantom(3).y=2.07518;Phantom(3).z=6.53542;
Phantom(4).x=3.05816;Phantom(4).y=-2.09804;Phantom(4).z=1.78562;
Phantom(5).x=3.2385;Phantom(5).y=2.10058;Phantom(5).z=0.79248;

% Phantom at height 0cm with no angle
Phantom(1).mx=1016;Phantom(1).my=263;
Phantom(2).mx=1018;Phantom(2).my=385;
Phantom(3).mx=764;Phantom(3).my=123;
Phantom(4).mx=985;Phantom(4).my=438;
Phantom(5).mx=978;Phantom(5).my=192;

% Phantom at height 2cm with no angle
% Phantom(1).mx=1048;Phantom(1).my=259;
% Phantom(2).mx=1049;Phantom(2).my=385;
% Phantom(3).mx=792;Phantom(3).my=111;
% Phantom(4).mx=1017;Phantom(4).my=440;
% Phantom(5).mx=1009;Phantom(5).my=185;

% Phantom at height 4cm with no angle
% Phantom(1).mx=1083;Phantom(1).my=231;
% Phantom(2).mx=1084;Phantom(2).my=361;
% Phantom(3).mx=823;Phantom(3).my=76;
% Phantom(4).mx=1053;Phantom(4).my=418;
% Phantom(5).mx=1043;Phantom(5).my=155;

% Phantom at height 6cm with no angle
% Phantom(1).mx=1122;Phantom(1).my=193;
% Phantom(2).mx=1123;Phantom(2).my=327;
% Phantom(3).mx=856;Phantom(3).my=26;
% Phantom(4).mx=1091;Phantom(4).my=386;
% Phantom(5).mx=1081;Phantom(5).my=114;

% Phantom at height 2cm with 1.43 degree angle
% Phantom(1).mx=1039;Phantom(1).my=250;
% Phantom(2).mx=1040;Phantom(2).my=376;
% Phantom(3).mx=788;Phantom(3).my=102;
% Phantom(4).mx=1010;Phantom(4).my=429;
% Phantom(5).mx=1000;Phantom(5).my=176;

% Phantom at height 4cm with 1.43 degree angle
% Phantom(1).mx=1074;Phantom(1).my=223;
% Phantom(2).mx=1074;Phantom(2).my=354;
% Phantom(3).mx=819;Phantom(3).my=66;
% Phantom(4).mx=1044;Phantom(4).my=409;
% Phantom(5).mx=1034;Phantom(5).my=147;

% Phantom at height 6cm with 1.43 degree angle
% Phantom(1).mx=1108;Phantom(1).my=207;
% Phantom(2).mx=1109;Phantom(2).my=341;
% Phantom(3).mx=848;Phantom(3).my=42;
% Phantom(4).mx=1079;Phantom(4).my=399;
% Phantom(5).mx=1069;Phantom(5).my=128;

% % Phantom at imaginary position (phantom at 0cm mirrored across x-axis)
% % Phantom(1).mx=1016;Phantom(1).my=1337;
% % Phantom(2).mx=1018;Phantom(2).my=1215;
% % Phantom(3).mx=764;Phantom(3).my=1477;
% % Phantom(4).mx=985;Phantom(4).my=1162;
% % Phantom(5).mx=978;Phantom(5).my=1408;

hold on;
BBSPLOT=plot(0,0,'EraseMode','xor','LineStyle','none');

% plot of bbs at height 0cm with no angle using coordinates from photoshop
% plot([1016 1018 764 985 978],[263 385 123 438 192],'+')

%compute a first crude tx, ty
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
        pause(StepSize);

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
        pause(StepSize);
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
        pause(StepSize);
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
        pause(StepSize);
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
        pause(StepSize);
        redrawGraph;
    end

    StepSize=StepSize*0.8;
end

output=tx,ty,tz,rx,ry,rz

% Phantom Delta Series roi placement
Phantom_a(1).x=-1.7272;Phantom_a(1).y=1.98374;Phantom_a(1).z=6.70306;
Phantom_a(2).x=-0.78232;Phantom_a(2).y=1.99644;Phantom_a(2).z=6.7437;
Phantom_a(3).x=-0.73406;Phantom_a(3).y=0;Phantom_a(3).z=6.77926;
Phantom_a(4).x=-1.7272;Phantom_a(4).y=0;Phantom_a(4).z=6.77164;

Phantom_b(1).x=-0.24384;Phantom_b(1).y=1.9939;Phantom_b(1).z=4.8514;
Phantom_b(2).x=0.77978;Phantom_b(2).y=1.99136;Phantom_b(2).z=4.82346;
Phantom_b(3).x=0.8001;Phantom_b(3).y=0;Phantom_b(3).z=4.82854;
Phantom_b(4).x=-0.23876;Phantom_b(4).y=0;Phantom_b(4).z=4.83362;

Phantom_c(1).x=1.28524;Phantom_c(1).y=1.9939;Phantom_c(1).z=2.92354;
Phantom_c(2).x=2.26822;Phantom_c(2).y=1.99644;Phantom_c(2).z=2.91846;
Phantom_c(3).x=2.28092;Phantom_c(3).y=0;Phantom_c(3).z=2.96164;
Phantom_c(4).x=1.30048;Phantom_c(4).y=0;Phantom_c(4).z=3.00736;

Phantom_d(1).x=2.77876;Phantom_d(1).y=2.00406;Phantom_d(1).z=0.99568;
Phantom_d(2).x=3.77952;Phantom_d(2).y=2.0066;Phantom_d(2).z=0.98298;
Phantom_d(3).x=3.84556;Phantom_d(3).y=0;Phantom_d(3).z=0.99568;
Phantom_d(4).x=2.7686;Phantom_d(4).y=0;Phantom_d(4).z=1.0033;

Phantom_e(1).x=-2.06502;Phantom_e(1).y=0;Phantom_e(1).z=7.67588;
Phantom_e(2).x=-1.09474;Phantom_e(2).y=0;Phantom_e(2).z=7.69366;
Phantom_e(3).x=-1.08966;Phantom_e(3).y=-2.01676;Phantom_e(3).z=7.72668;
Phantom_e(4).x=-2.11074;Phantom_e(4).y=-2.0193;Phantom_e(4).z=7.7343;

Phantom_f(1).x=-0.5969;Phantom_f(1).y=0;Phantom_f(1).z=5.76326;
Phantom_f(2).x=0.4191;Phantom_f(2).y=0;Phantom_f(2).z=5.76326;
Phantom_f(3).x=0.4318;Phantom_f(3).y=-2.02184;Phantom_f(3).z=5.79374;
Phantom_f(4).x=-0.58674;Phantom_f(4).y=-2.02184;Phantom_f(4).z=5.78612;

Phantom_g(1).x=0.93218;Phantom_g(1).y=0;Phantom_g(1).z=3.85572;
Phantom_g(2).x=1.9177;Phantom_g(2).y=0;Phantom_g(2).z=3.85064;
Phantom_g(3).x=1.93548;Phantom_g(3).y=-2.02438;Phantom_g(3).z=3.87604;
Phantom_g(4).x=0.97282;Phantom_g(4).y=-2.02438;Phantom_g(4).z=3.87604;

Phantom_h(1).x=2.42824;Phantom_h(1).y=0;Phantom_h(1).z=1.93294;
Phantom_h(2).x=3.42138;Phantom_h(2).y=0;Phantom_h(2).z=1.92024;
Phantom_h(3).x=3.4671;Phantom_h(3).y=-2.02184;Phantom_h(3).z=1.94564;
Phantom_h(4).x=2.46634;Phantom_h(4).y=-2.0193;Phantom_h(4).z=1.95072;

Phantom_i(1).x=0;Phantom_i(1).y=2.02184;Phantom_i(1).z=0;
Phantom_i(2).x=0;Phantom_i(2).y=0;Phantom_i(2).z=0;
Phantom_i(3).x=0;Phantom_i(3).y=-1.98882;Phantom_i(3).z=0;
Phantom_i(4).x=4.06654;Phantom_i(4).y=-1.96596;Phantom_i(4).z=0;
Phantom_i(5).x=4.0386;Phantom_i(5).y=0;Phantom_i(5).z=0;
Phantom_i(6).x=4.0259;Phantom_i(6).y=2.032;Phantom_i(6).z=0;

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