% EPSILON-01 SXA PHANTOM ANALYSIS
% (PADDLE HEIGHT & ANGLE DETERMINATION, ROI PLACEMENT)
% optimization6.m
% March. 10, 2005
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
filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 1.8cm 50-50Do not know-1.tif';
% Phantom at height 3.8cm, scanning 4cm 50/50
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 3.8cm 50-50Do not know-1.tif';
% Phantom at height 5.8cm, scanning 6cm 50/50
% filename='P:\Vidar Images\test\epsilon vs gamma_epsilon 5.8cm 50-50Do not know-1.tif';
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
clear Phantom xf yF
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MEASURED BBS COORDINATES USING PHOTOSHOP %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phantom at height 0cm
% Phantom(1).mx=1071;Phantom(1).my=147;
% Phantom(2).mx=1068;Phantom(2).my=274;
% Phantom(3).mx=829;Phantom(3).my=72;
% Phantom(4).mx=1032;Phantom(4).my=344;
% Phantom(5).mx=1037;Phantom(5).my=81;
% Phantom(6).mx=819;Phantom(6).my=363;

% Phantom at height 1.8cm, scanning 2cm 100% fat
% Phantom(1).mx=1105;Phantom(1).my=110;
% Phantom(2).mx=1101;Phantom(2).my=239;
% Phantom(3).mx=850;Phantom(3).my=34;
% Phantom(4).mx=1063;Phantom(4).my=311;
% Phantom(5).mx=1070;Phantom(5).my=41;
% Phantom(6).mx=838;Phantom(6).my=334;

% Phantom at height 3.8cm, scanning 4cm 100% fat
% Phantom(1).mx=1140;Phantom(1).my=75;
% Phantom(2).mx=1135;Phantom(2).my=210;
% Phantom(3).mx=882;Phantom(3).my=-7;
% Phantom(4).mx=1098;Phantom(4).my=284;
% Phantom(5).mx=1103;Phantom(5).my=5;
% Phantom(6).mx=871;Phantom(6).my=303;
% Phantom(7).mx=863;Phantom(7).my=84;

% Phantom at height 5.8cm, scanning 6cm 100% fat
% Phantom(1).mx=1177;Phantom(1).my=91;
% Phantom(2).mx=1172;Phantom(2).my=230;
% Phantom(3).mx=913;Phantom(3).my=5;
% Phantom(4).mx=1135;Phantom(4).my=304;
% Phantom(5).mx=1141;Phantom(5).my=18;
% Phantom(6).mx=901;Phantom(6).my=323;
% Phantom(7).mx=893;Phantom(7).my=101;
% Phantom(8).mx=889;Phantom(8).my=237;

% Phantom at height 1.8cm, scanning 2cm 50/50
Phantom(1).mx=1108;Phantom(1).my=127;
Phantom(2).mx=1104;Phantom(2).my=258;
Phantom(3).mx=853;Phantom(3).my=51;
Phantom(4).mx=1066;Phantom(4).my=331;
Phantom(5).mx=1072;Phantom(5).my=59;
Phantom(6).mx=840;Phantom(6).my=352;
Phantom(7).mx=839;Phantom(7).my=137;

% Phantom at height 3.8cm, scanning 4cm 50/50
% Phantom(1).mx=1140;Phantom(1).my=124;
% Phantom(2).mx=1135;Phantom(2).my=259;
% Phantom(3).mx=884;Phantom(3).my=42;
% Phantom(4).mx=1099;Phantom(4).my=332;
% Phantom(5).mx=1105;Phantom(5).my=54;
% Phantom(6).mx=872;Phantom(6).my=351;
% Phantom(7).mx=864;Phantom(7).my=134;
% Phantom(8).mx=862;Phantom(8).my=266;

% Phantom at height 5.8cm, scanning 6cm 50/50
% note: BB'S 3, 5 were completely off the film.  therefore we have no
% coordinates for them.
% % % values entered so will not work with current calculations:
% % % Phantom(1).mx=1179;Phantom(1).my=58;
% % % Phantom(2).mx=1173;Phantom(2).my=199;
% % % Phantom(4).mx=1139;Phantom(4).my=263;
% % % Phantom(6).mx=905;Phantom(6).my=291;
% % % Phantom(7).mx=896;Phantom(7).my=69;
% % % Phantom(8).mx=893;Phantom(8).my=206;
% in order to test the optimization code, BB 4 is renamed 3, BB 6 is 4, 
% BB 7 is 5, BB 8 is 6 (see above at measured bb's phantom coordinates)
% use these values when testing this situation:
% Phantom(1).mx=1179;Phantom(1).my=58;
% Phantom(2).mx=1173;Phantom(2).my=199;
% Phantom(3).mx=1139;Phantom(3).my=263;
% Phantom(4).mx=905;Phantom(4).my=291;
% Phantom(5).mx=896;Phantom(5).my=69;
% Phantom(6).mx=893;Phantom(6).my=206;

% Phantom at height 1.8cm, scanning 2cm 100% glandular
% Phantom(1).mx=1106;Phantom(1).my=146;
% Phantom(2).mx=1101;Phantom(2).my=277;
% Phantom(3).mx=853;Phantom(3).my=70;
% Phantom(4).mx=1063;Phantom(4).my=349;
% Phantom(5).mx=1071;Phantom(5).my=79;
% Phantom(6).mx=840;Phantom(6).my=369;
% Phantom(7).mx=838;Phantom(7).my=155;

% Phantom at height 3.8cm, scanning 4cm 100% glandular
% Phantom(1).mx=1141;Phantom(1).my=122;
% Phantom(2).mx=1136;Phantom(2).my=257;
% Phantom(3).mx=885;Phantom(3).my=39;
% Phantom(4).mx=1100;Phantom(4).my=328;
% Phantom(5).mx=1106;Phantom(5).my=52;
% Phantom(6).mx=872;Phantom(6).my=347;
% Phantom(7).mx=866;Phantom(7).my=151;
% Phantom(8).mx=863;Phantom(8).my=263;

% Phantom at height 5.3cm, scanning 6cm 100% glandular
% Phantom(1).mx=1168;Phantom(1).my=104;
% Phantom(2).mx=1163;Phantom(2).my=242;
% Phantom(3).mx=918;Phantom(3).my=10;
% Phantom(4).mx=1130;Phantom(4).my=311;
% Phantom(5).mx=1133;Phantom(5).my=31;
% Phantom(6).mx=909;Phantom(6).my=318;
% Phantom(7).mx=888;Phantom(7).my=112;
% Phantom(8).mx=887;Phantom(8).my=247;

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
for bigindex=1:100

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

    StepSize=StepSize*0.5;
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