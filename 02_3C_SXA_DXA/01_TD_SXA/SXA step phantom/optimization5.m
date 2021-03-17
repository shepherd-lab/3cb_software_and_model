% EPSILON-01 SXA PHANTOM ANALYSIS
% (PADDLE HEIGHT & ANGLE DETERMINATION, ROI PLACEMENT)
% optimization5.m
% March. 10, 2005
% changed coordinate system of digitized films to use lead tag/marker as origin
% further testing to optimize height & angle determination

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TEST IMAGE SELECTION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phantom at height 0cm
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 0cmDo not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 100% fat
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 1.8cm fatDo not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 100% fat
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 3.8cm fatDo not know-1.tif';
% Phantom at height 5.8cm, scanning 6cm 100% fat
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 5.8cm fatDo not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 50/50
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 1.8cm 50-50Do not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 50/50
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 3.8cm 50-50Do not know-1.tif';
% Phantom at height 5.8cm, scanning 6cm 50/50
filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 5.8cm 50-50Do not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 100% glandular
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 1.8cm glandDo not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 100% glandular
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 3.8cm glandDo not know-1.tif';
% Phantom at height 5.3cm, scanning 6cm 100% glandular
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 5.3cm glandDo not know-1.tif';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DIRECTORIES FROM JEFF'S HOME COMPUTER %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phantom at height 0cm
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 0cmDo not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 100% fat
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 1.8cm fatDo not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 100% fat
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 3.8cm fatDo not know-1.tif';
% Phantom at height 5.8cm, scanning 6cm 100% fat
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 5.8cm fatDo not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 50/50
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 1.8cm 50-50Do not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 50/50
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 3.8cm 50-50Do not know-1.tif';
% Phantom at height 5.8cm, scanning 6cm 50/50
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 5.8cm 50-50Do not know-1.tif';
% Phantom at height 1.8cm, scanning 2cm 100% glandular
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 1.8cm glandDo not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 100% glandular
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 3.8cm glandDo not know-1.tif';
% Phantom at height 5.3cm, scanning 6cm 100% glandular
% filename='/Users/oranges/Work/Vidar Images/test/epsilon vs gamma_epsilon 5.3cm glandDo not know-1.tif';

global xf1 yf1 BBSPLOT Mammo pixelCm
Mammo=imread(filename);
clear Phantom xf yf xo yo
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COORDINATE SYSTEM SELECTION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original image with origin at 0,0
% figure;imagesc(Mammo);colormap(gray);
% Phantom at height 0cm
% xo=-1108;
% yo=-908;
% figure;imagesc(-1108,-908,Mammo);colormap(gray);
% Phantom at height 1.8cm, scanning 2cm 100% fat
% xo=-1110;
% yo=-894;
% figure;imagesc(-1110,-894,Mammo);colormap(gray);
% Phantom at height 3.8cm, scanning 4cm 100% fat
% xo=-1112;
% yo=-884;
% figure;imagesc(-1112,-884,Mammo);colormap(gray);
% Phantom at height 5.8cm, scanning 6cm 100% fat
% xo=-1108;
% yo=-926;
% figure;imagesc(-1108,-926,Mammo);colormap(gray);
% Phantom at height 1.8cm, scanning 2cm 50/50
xo=-1112;
yo=-912;
figure;imagesc(-1112,-912,Mammo);colormap(gray);
% Phantom at height 3.8cm, scanning 4cm 50/50
% xo=-1112;
% yo=-932;
% figure;imagesc(-1112,-932,Mammo);colormap(gray);
% Phantom at height 5.8cm, scanning 6cm 50/50
% xo=-1113;
% yo=-896;
% figure;imagesc(-1113,-896,Mammo);colormap(gray);
% Phantom at height 1.8cm, scanning 2cm 100% glandular
% xo=-1112;
% yo=-930;
% figure;imagesc(-1112,-930,Mammo);colormap(gray);
% Phantom at height 3.8cm, scanning 4cm 100% glandular
% xo=-1112;
% yo=-933;
% figure;imagesc(-1112,-933,Mammo);colormap(gray);
% Phantom at height 5.3cm, scanning 6cm 100% glandular
% xo=-1114;
% yo=-932;
% figure;imagesc(-1114,-932,Mammo);colormap(gray);
xlim([-1400 400]);
ylim([-1100 1200]);

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
% Phantom(8).x=-0.09906;Phantom(8).y=-1.0541;Phantom(8).z=0.127;

% note: when Phantom at height 5.8cm, scanning 6cm 50/50
% BB'S 3, 5 were completely off the film.  therefore we have no
% coordinates for them.
% in order to test the optimization code, BB 4 is renamed 3, BB 6 is 4,
% BB 7 is 5, BB 8 is 6 (see below at measured bb's film coordinates)
% use these values when testing this situation:
% Phantom(1).x=4.22402;Phantom(1).y=0.9017;Phantom(1).z=0.2032;
% Phantom(2).x=4.0513;Phantom(2).y=-1.09728;Phantom(2).z=0.2159;
% Phantom(3).x=2.97688;Phantom(3).y=-2.4384;Phantom(3).z=1.8161;
% Phantom(4).x=-1.71704;Phantom(4).y=-3.42646;Phantom(4).z=7.49554;
% Phantom(5).x=0.0635;Phantom(5).y=0.90424;Phantom(5).z=0.16764;
% Phantom(6).x=-0.09906;Phantom(6).y=-1.0541;Phantom(6).z=0.127;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CONVERTED PHOTOSHOP COORDINATES USING LEAD TAG/MARKER AS ORIGIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phantom at height 0cm
% Phantom(1).mx=-37;Phantom(1).my=-761;
% Phantom(2).mx=-40;Phantom(2).my=-634;
% Phantom(3).mx=-279;Phantom(3).my=-836;
% Phantom(4).mx=-76;Phantom(4).my=-564;
% Phantom(5).mx=-71;Phantom(5).my=-827;
% Phantom(6).mx=-289;Phantom(6).my=-545;

% Phantom at height 1.8cm, scanning 2cm 100% fat
% Phantom(1).mx=-5;Phantom(1).my=-784;
% Phantom(2).mx=-9;Phantom(2).my=-655;
% Phantom(3).mx=-260;Phantom(3).my=-860;
% Phantom(4).mx=-47;Phantom(4).my=-583;
% Phantom(5).mx=-40;Phantom(5).my=-853;
% Phantom(6).mx=-272;Phantom(6).my=-560;

% Phantom at height 3.8cm, scanning 4cm 100% fat
% Phantom(1).mx=28;Phantom(1).my=-809;
% Phantom(2).mx=23;Phantom(2).my=-674;
% Phantom(3).mx=-230;Phantom(3).my=-891;
% Phantom(4).mx=-14;Phantom(4).my=-600;
% Phantom(5).mx=-9;Phantom(5).my=-879;
% Phantom(6).mx=-241;Phantom(6).my=-581;
% Phantom(7).mx=-249;Phantom(7).my=-800;

% Phantom at height 5.8cm, scanning 6cm 100% fat
% Phantom(1).mx=69;Phantom(1).my=-835;
% Phantom(2).mx=64;Phantom(2).my=-696;
% Phantom(3).mx=-195;Phantom(3).my=-921;
% Phantom(4).mx=27;Phantom(4).my=-622;
% Phantom(5).mx=33;Phantom(5).my=-908;
% Phantom(6).mx=-207;Phantom(6).my=-603;
% Phantom(7).mx=-215;Phantom(7).my=-825;
% Phantom(8).mx=-219;Phantom(8).my=-689;

% Phantom at height 1.8cm, scanning 2cm 50/50
Phantom(1).mx=-4;Phantom(1).my=-785;
Phantom(2).mx=-8;Phantom(2).my=-654;
Phantom(3).mx=-259;Phantom(3).my=-861;
Phantom(4).mx=-46;Phantom(4).my=-581;
Phantom(5).mx=-40;Phantom(5).my=-853;
Phantom(6).mx=-272;Phantom(6).my=-560;
Phantom(7).mx=-273;Phantom(7).my=-775;

% Phantom at height 3.8cm, scanning 4cm 50/50
% Phantom(1).mx=28;Phantom(1).my=-808;
% Phantom(2).mx=23;Phantom(2).my=-673;
% Phantom(3).mx=-228;Phantom(3).my=-890;
% Phantom(4).mx=-13;Phantom(4).my=-600;
% Phantom(5).mx=-7;Phantom(5).my=-878;
% Phantom(6).mx=-240;Phantom(6).my=-581;
% Phantom(7).mx=-248;Phantom(7).my=-798
% Phantom(8).mx=-250;Phantom(8).my=-666;

% Phantom at height 5.8cm, scanning 6cm 50/50
% note: BB'S 3, 5 were completely off the film.  therefore we have no
% coordinates for them.
% % % % % values entered so will not work with current calculations:
% % % % % Phantom(1).mx=66;Phantom(1).my=-838;
% % % % % Phantom(2).mx=60;Phantom(2).my=-697;
% % % % % Phantom(4).mx=26;Phantom(4).my=-633;
% % % % % Phantom(6).mx=-208;Phantom(6).my=-605;
% % % % % Phantom(7).mx=-217;Phantom(7).my=-827;
% % % % % Phantom(8).mx=-220;Phantom(8).my=-690;
% in order to test the optimization code, BB 4 is renamed 3, BB 6 is 4,
% BB 7 is 5, BB 8 is 6 (see above at measured bb's phantom coordinates)
% use these values when testing this situation:
% Phantom(1).mx=66;Phantom(1).my=-838;
% Phantom(2).mx=60;Phantom(2).my=-697;
% Phantom(3).mx=26;Phantom(4).my=-633;
% Phantom(4).mx=-208;Phantom(6).my=-605;
% Phantom(5).mx=-217;Phantom(7).my=-827;
% Phantom(6).mx=-220;Phantom(8).my=-690;

% Phantom at height 1.8cm, scanning 2cm 100% glandular
% Phantom(1).mx=-6;Phantom(1).my=-784;
% Phantom(2).mx=-11;Phantom(2).my=-653;
% Phantom(3).mx=-259;Phantom(3).my=-860;
% Phantom(4).mx=-49;Phantom(4).my=-581;
% Phantom(5).mx=-41;Phantom(5).my=-851;
% Phantom(6).mx=-272;Phantom(6).my=-561;
% Phantom(7).mx=-274;Phantom(7).my=-775;

% Phantom at height 3.8cm, scanning 4cm 100% glandular
% Phantom(1).mx=29;Phantom(1).my=-811;
% Phantom(2).mx=24;Phantom(2).my=-676;
% Phantom(3).mx=-227;Phantom(3).my=-894;
% Phantom(4).mx=-12;Phantom(4).my=-605;
% Phantom(5).mx=-6;Phantom(5).my=-881;
% Phantom(6).mx=-240;Phantom(6).my=-586;
% Phantom(7).mx=-246;Phantom(7).my=-782;
% Phantom(8).mx=-249;Phantom(8).my=-670;

% Phantom at height 5.3cm, scanning 6cm 100% glandular
% Phantom(1).mx=54;Phantom(1).my=-828;
% Phantom(2).mx=49;Phantom(2).my=-690;
% Phantom(3).mx=-196;Phantom(3).my=-922;
% Phantom(4).mx=16;Phantom(4).my=-621;
% Phantom(5).mx=19;Phantom(5).my=-901;
% Phantom(6).mx=-205;Phantom(6).my=-614;
% Phantom(7).mx=-226;Phantom(7).my=-820;
% Phantom(8).mx=-227;Phantom(8).my=-685;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on;
BBSPLOT=plot(0,0,'EraseMode','xor','LineStyle','none');

% plot of bbs at height 0cm with no angle using coordinates from photoshop
% plot([1016 1018 764 985 978],[263 385 123 438 192],'+')
% plot of bbs at height 1.8cm, scanning 2cm 50/50
% plot([-4 -8 -259 -46 -40 -272 -273],[-785 -654 -861 -581 -853 -560 -775],'+')

% compute a first crude tx, ty
% MeanX=0;MeanY=0;MeanMX=0;MeanMY=0;
% for index=1:size(Phantom,2)
%     MeanX=MeanX+Phantom(index).x;
%     MeanY=MeanY+Phantom(index).y;
%     MeanMX=MeanMX+Phantom(index).mx;
%     MeanMY=MeanMY+Phantom(index).my;
% end
% MeanX=MeanX/size(Phantom,2);
% MeanY=MeanY/size(Phantom,2);
% MeanMX=MeanMX/size(Phantom,2)/pixelCm;
% MeanMY=-(MeanMY/size(Phantom,2)-size(Mammo,1)/2)/pixelCm;

tz=0;
tx=0;
ty=0;
% tx=(MeanMX-MeanX);
% ty=(MeanMY-MeanY);
[xf,yf]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz,s);
set (BBSPLOT,'xdata',pixelCm*xf+xo,'ydata',size(Mammo,1)/2-pixelCm*yf+yo,'marker','o','MarkerFaceColor','b');

merit0=merit(Phantom,pixelCm*xf+xo,size(Mammo,1)/2-pixelCm*yf+yo);

StepSize=0.01;
for bigindex=1:5

    %test x distances
    [xf1,yf1]=projectionsimulation(Phantom,tx+StepSize,ty,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
%         pause(StepSize);

    end

    %test y distances
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty+StepSize,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty-StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    else
        Sign=1;
    end

    while merit1<merit0
        ty=ty+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty+Sign*StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
%         pause(StepSize);
        redrawGraph;
    end

    %test z(+xy) distances
    [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz+StepSize,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz-StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx-Sign*StepSize*tx/s;
        ty=ty-Sign*StepSize*ty/s;
        tz=tz+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-Sign*StepSize*tx/s,ty-Sign*StepSize*ty/s,tz+Sign*StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
%         pause(StepSize);
        redrawGraph;
    end

    %test rx
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+StepSize,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    else
        Sign=1;
    end

    while merit1<merit0
        rx=rx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
%         pause(StepSize);
        redrawGraph;
    end

    %test ry
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+StepSize,rz,s);
    merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
    else
        Sign=1;
    end

    while merit1<merit0
        ry=ry+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1+xo,size(Mammo,1)/2-pixelCm*yf1+yo);
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