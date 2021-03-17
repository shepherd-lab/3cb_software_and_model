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
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0cmDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0.4cm(1cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.2cm(2cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-2.2cm(3cm)FatDo not know-1.tif';  
%filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
filename='P:\Vidar Images\test\StepCalibrate4cm5050Do not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-4.4cm(5cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.2cm(6cm)FatDo not know-1.tif';   
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-6.2cm(7cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)50-50Do not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)50-50Do not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)50-50Do not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)GlandDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.3cm(4cm)GlandDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-2.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)RachelDo not know-1.tif';  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DIRECTORIES FROM JEFF'S HOME COMPUTER %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-0cmDo not know-1.tif';
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-0.4cm(1cm)FatDo not know-1.tif'; 
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-1.2cm(2cm)FatDo not know-1.tif'; 
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-2.2cm(3cm)FatDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-4.4cm(5cm)FatDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-5.2cm(6cm)FatDo not know-1.tif';   
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-6.2cm(7cm)FatDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-1.4cm(2cm)50-50Do not know-1.tif';
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-3.4cm(4cm)50-50Do not know-1.tif';
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-5.4cm(6cm)50-50Do not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-1.4cm(2cm)GlandDo not know-1.tif';
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-3.3cm(4cm)GlandDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-1.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-2.tif';  
% filename='/Users/oranges/Work/Vidar Images/test/Epsilon@3cm3cm-5.4cm(6cm)RachelDo not know-1.tif'; 


global xf1 yf1 BBSPLOT Mammo pixelCm
Mammo=imread(filename);
clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=-32;

figure;imagesc(Mammo);colormap(gray);
% xlim([-200 1500]);
% ylim([-200 2000]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MEASURED COORDINATES OF EPSILON-01 BBS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Phantom(1).x=4.22402;Phantom(1).y=0.9017;Phantom(1).z=0.2032;
%Phantom(2).x=4.0513;Phantom(2).y=-1.09728;Phantom(2).z=0.2159;
%Phantom(3).x=-1.14808;Phantom(3).y=0.91948;Phantom(3).z=6.63448;
%Phantom(4).x=2.97688;Phantom(4).y=-2.4384;Phantom(4).z=1.8161;
%Phantom(5).x=3.48996;Phantom(5).y=1.94564;Phantom(5).z=0.87376;
%Phantom(6).x=-1.71704;Phantom(6).y=-3.42646;Phantom(6).z=7.49554;
%Phantom(7).x=0.0635;Phantom(7).y=0.90424;Phantom(7).z=0.16764;
%Phantom(8).x=-0.09906;Phantom(8).y=-1.0541;Phantom(8).z=0.127;
%{
Phantom(1).x=-2.1971;Phantom(1).y=-2.08026;Phantom(1).z=6.42874;
Phantom(2).x=-3.18008;Phantom(2).y=-2.0701;Phantom(2).z=4.70662;
Phantom(3).x=-0.76708;Phantom(3).y=-2.02184;Phantom(3).z=0.32512;
Phantom(4).x=-3.13182;Phantom(4).y=-2.08534;Phantom(4).z=0.26162;
Phantom(5).x=-2.19964;Phantom(5).y=2.0574;Phantom(5).z=6.42366;
Phantom(6).x=-3.1115;Phantom(6).y=2.05994;Phantom(6).z=4.70662;
Phantom(7).x=-0.68326;Phantom(7).y=2.0701;Phantom(7).z=0.2921;
Phantom(8).x=-3.05308;Phantom(8).y=2.05486;Phantom(8).z=0.2921;
Phantom(9).x=-5.73278;Phantom(9).y=-0.03048;Phantom(9).z=7.24662;
Phantom(10).x=0;Phantom(10).y=0.03302;Phantom(10).z=0.30734;
%}
%%%%%%%%%%%previous coordinates
%
Phantom(1).x=-4.55;Phantom(1).y=2.08026;Phantom(1).z=6.42874;
Phantom(2).x=-3.18008;Phantom(2).y=2.0701;Phantom(2).z=4.70662;
Phantom(3).x=-0.76708;Phantom(3).y=2.02184;Phantom(3).z=0.32512;
Phantom(4).x=-3.13182;Phantom(4).y=2.08534;Phantom(4).z=0.26162;
Phantom(5).x=-4.55;Phantom(5).y=-2.0574;Phantom(5).z=6.42366;
Phantom(6).x=-3.1115;Phantom(6).y=-2.05994;Phantom(6).z=4.70662;
Phantom(7).x=-0.68326;Phantom(7).y=-2.0701;Phantom(7).z=0.2921;
Phantom(8).x=-3.05308;Phantom(8).y=-2.05486;Phantom(8).z=0.2921;
Phantom(9).x=-5.73278;Phantom(9).y=0.03048;Phantom(9).z=7.24662;
Phantom(10).x=0;Phantom(10).y=-0.03302;Phantom(10).z=0.30734;
%
%{
Phantom(1).x=4.66852;Phantom(1).y=-2.03708;Phantom(1).z=6.428744;
Phantom(2).x=3.075948;Phantom(2).y=-2.08788;Phantom(2).z=4.70662;
Phantom(3).x=0.76708;Phantom(3).y=-2.02184;Phantom(3).z=0.32512;
Phantom(4).x=3.13182;Phantom(4).y=-2.08534;Phantom(4).z=0.26162;
Phantom(5).x=4.6609;Phantom(5).y=2.10566;Phantom(5).z=6.42366;
Phantom(6).x=3.048;Phantom(6).y=2.10566;Phantom(6).z=4.70662;
Phantom(7).x=0.68326;Phantom(7).y=2.0701;Phantom(7).z=0.2921;
Phantom(8).x=3.05308;Phantom(8).y=2.05486;Phantom(8).z=0.2921;
Phantom(9).x=5.35686;Phantom(9).y=-0.00762;Phantom(9).z=7.24662;
Phantom(10).x=-0.02032;Phantom(10).y=0;Phantom(10).z=0.30734;
%}
%1	4.66852	-2.03708	6.428744
%2	3.075948	-2.08788	4.70662
%3	0.76708	-2.02184	0.32512
%4	3.13182	-2.08534	0.26162
%5	4.6609	2.10566	6.42366
%6	3.048	2.10566	4.70662
%7	0.68326	2.0701	0.2921
%8	3.05308	2.05486	0.2921
%9	5.35686	-0.00762	7.24662
%10	-0.02032	0	0.30734

%-2.1971	-2.08026	6.42874
%-3.18008	-2.0701	4.70662
%-0.76708	-2.02184	0.32512
%-3.13182	-2.08534	0.26162
%-2.19964	2.0574	6.42366
%-3.1115	2.05994	4.70662
%-0.68326	2.0701	0.2921
%-3.05308	2.05486	0.2921
%-5.73278	-0.03048	7.24662
%0	0.03302	0.30734

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
% 0cm
% Phantom(1).mx=1061;Phantom(1).my=241;
% Phantom(2).mx=1055;Phantom(2).my=367;
% Phantom(3).mx=817;Phantom(3).my=171;
% Phantom(4).mx=1018;Phantom(4).my=437;
% Phantom(5).mx=1029;Phantom(5).my=175;
% Phantom(6).mx=800;Phantom(6).my=460;
% Phantom(7).mx=804;Phantom(7).my=244;
% Phantom(8)

% 1cm fat
% Phantom(1).mx=1075;Phantom(1).my=222;
% Phantom(2).mx=1068;Phantom(2).my=350;
% Phantom(3).mx=839;Phantom(3).my=146;
% Phantom(4).mx=1032;Phantom(4).my=421;
% Phantom(5).mx=1043;Phantom(5).my=155
% Phantom(6).mx=821;Phantom(6).my=440;
% Phantom(7).mx=817;Phantom(7).my=222;
% Phantom(8)

% 2cm fat
% Phantom(1).mx=1089;Phantom(1).my=233;
% Phantom(2).mx=1083;Phantom(2).my=362;
% Phantom(3).mx=855;Phantom(3).my=152;
% Phantom(4).mx=1047;Phantom(4).my=432;
% Phantom(5).mx=1058;Phantom(5).my=165;
% Phantom(6).mx=837;Phantom(6).my=449;
% Phantom(7).mx=827;Phantom(7).my=234;
% Phantom(8).mx=811;Phantom(8).my=359;

% 3cm fat
% Phantom(1).mx=1107;Phantom(1).my=220;
% Phantom(2).mx=1100;Phantom(2).my=353;
% Phantom(3).mx=870;Phantom(3).my=137;
% Phantom(4).mx=1064;Phantom(4).my=423;
% Phantom(5).mx=1075;Phantom(5).my=151;
% Phantom(6).mx=852;Phantom(6).my=440;
% Phantom(7).mx=841;Phantom(7).my=222;
% Phantom(8).mx=833;Phantom(8).my=351;

% 4cm fat
%Phantom(1).mx=1128;Phantom(1).my=208;
%Phantom(2).mx=1120;Phantom(2).my=341;
%Phantom(3).mx=886;Phantom(3).my=123;
%Phantom(4).mx=1085;Phantom(4).my=413;
%Phantom(5).mx=1096;Phantom(5).my=137;
%Phantom(6).mx=869;Phantom(6).my=431;
%Phantom(7).mx=857;Phantom(7).my=208;
%Phantom(8).mx=851;Phantom(8).my=339;

Phantom(1).mx=734.6511;Phantom(1).my=101.0292;
Phantom(2).mx=807.687;Phantom(2).my=66.2847;
Phantom(3).mx=882.6223;Phantom(3).my=37.6715;
Phantom(4).mx=747.4281;Phantom(4).my=110.4818;
Phantom(5).mx=879.3417;Phantom(5).my=367.2336;
Phantom(6).mx=948.7518;Phantom(6).my=322.2701;
Phantom(7).mx=1012.8093;Phantom(7).my=272.4526;
Phantom(8).mx=876.9245;Phantom(8).my=346.7956;
Phantom(9).mx=772.2914;Phantom(10).my=249.7153;
Phantom(10).mx=989.1547;Phantom(9).my=134.2409;





% 5cm fat
% Phantom(1).mx=1147;Phantom(1).my=190;
% Phantom(2).mx=1139;Phantom(2).my=327;
% Phantom(3).mx=901;Phantom(3).my=104
% Phantom(4).mx=1103;Phantom(4).my=400;
% Phantom(5).mx=1114;Phantom(5).my=118;
% Phantom(6).mx=883;Phantom(6).my=418;
% Phantom(7).mx=870;Phantom(7).my=192;
% Phantom(8).mx=864;Phantom(8).my=326;

% 6cm fat
% Phantom(1).mx=1156;Phantom(1).my=177;
% Phantom(2).mx=1149;Phantom(2).my=315;
% Phantom(3).mx=913;Phantom(3).my=86;
% Phantom(4).mx=1116;Phantom(4).my=388;
% Phantom(5).mx=1124;Phantom(5).my=105;
% Phantom(6).mx=898;Phantom(6).my=403;
% Phantom(7).mx=878;Phantom(7).my=179;
% Phantom(8).mx=873;Phantom(8).my=314;

% 7cm fat
% Phantom(1).mx=1181;Phantom(1).my=170;
% Phantom(2).mx=1172;Phantom(2).my=310;
% Phantom(3).mx=935;Phantom(3).my=75;
% Phantom(4).mx=1138;Phantom(4).my=383;
% Phantom(5).mx=1148;Phantom(5).my=95;
% Phantom(6).mx=919;Phantom(6).my=396;
% Phantom(7).mx=897;Phantom(7).my=171;
% Phantom(8).mx=897;Phantom(8).my=308;

% 2cm 50/50
% Phantom(1).mx=1088;Phantom(1).my=220;
% Phantom(2).mx=1081;Phantom(2).my=350;
% Phantom(3).mx=848;Phantom(3).my=142;
% Phantom(4).mx=1044;Phantom(4).my=421;
% Phantom(5).mx=1056;Phantom(5).my=153;
% Phantom(6).mx=830;Phantom(6).my=441;
% Phantom(7).mx=825;Phantom(7).my=222;
% Phantom(8).mx=816;Phantom(8).my=347;

% 4cm 50/50
% Phantom(1).mx=1128;Phantom(1).my=200;
% Phantom(2).mx=1121;Phantom(2).my=334;
% Phantom(3).mx=884;Phantom(3).my=116;
% Phantom(4).mx=1085;Phantom(4).my=406;
% Phantom(5).mx=1096;Phantom(5).my=129;
% Phantom(6).mx=865;Phantom(6).my=424;
% Phantom(7).mx=856;Phantom(7).my=201;
% Phantom(8).mx=851;Phantom(8).my=333;

% 6cm 50/50
% Phantom(1).mx=1165;Phantom(1).my=166;
% Phantom(2).mx=1156;Phantom(2).my=312;
% Phantom(3).mx=916;Phantom(3).my=82;
% Phantom(4).mx=1122;Phantom(4).my=384;
% Phantom(5).mx=1135;Phantom(5).my=103;
% Phantom(6).mx=899;Phantom(6).my=400;
% Phantom(7).mx=885;Phantom(7).my=173;
% Phantom(8).mx=880;Phantom(8).my=308;

% 2cm gland
% Phantom(1).mx=1090;Phantom(1).my=230;
% Phantom(2).mx=1083;Phantom(2).my=359;
% Phantom(3).mx=851;Phantom(3).my=151;
% Phantom(4).mx=1048;Phantom(4).my=429;
% Phantom(5).mx=1058;Phantom(5).my=162;
% Phantom(6).mx=834;Phantom(6).my=449;
% Phantom(7).mx=826;Phantom(7).my=231;
% Phantom(8).mx=819;Phantom(8).my=357;

% 4cm gland
% Phantom(1).mx=1126;Phantom(1).my=211;
% Phantom(2).mx=1118;Phantom(2).my=345;
% Phantom(3).mx=883;Phantom(3).my=127;
% Phantom(4).mx=1083;Phantom(4).my=416;
% Phantom(5).mx=1094;Phantom(5).my=140;
% Phantom(6).mx=865;Phantom(6).my=433;
% Phantom(7).mx=855;Phantom(7).my=211;
% Phantom(8).mx=849;Phantom(8).my=343;

% 6cm gland-1
% Phantom(1).mx=1168;Phantom(1).my=166;
% Phantom(2).mx=1159;Phantom(2).my=307;
% Phantom(3).mx=927;Phantom(3).my=70;
% Phantom(4).mx=1123;Phantom(4).my=377;
% Phantom(5)
% Phantom(6).mx=903;Phantom(6).my=396;
% Phantom(7).mx=888;Phantom(7).my=169;
% Phantom(8).mx=883;Phantom(8).my=304;
% to test:
% Phantom(1).mx=1168;Phantom(1).my=166;
% Phantom(2).mx=1159;Phantom(2).my=307;
% Phantom(3).mx=927;Phantom(3).my=70;
% Phantom(4).mx=1123;Phantom(4).my=377;
% Phantom(5).mx=903;Phantom(5).my=396;
% Phantom(6).mx=888;Phantom(6).my=169;
% Phantom(7).mx=883;Phantom(7).my=304;

% 6cm gland-2
% Phantom(1).mx=1166;Phantom(1).my=177;
% Phantom(2).mx=1157;Phantom(2).my=316;
% Phantom(3).mx=930;Phantom(3).my=89;
% Phantom(4).mx=1123;Phantom(4).my=389;
% Phantom(5)
% Phantom(6).mx=906;Phantom(6).my=400;
% Phantom(7).mx=884;Phantom(7).my=179;
% Phantom(8).mx=877;Phantom(8).my=313;
% to test:
% Phantom(1).mx=1166;Phantom(1).my=177;
% Phantom(2).mx=1157;Phantom(2).my=316;
% Phantom(3).mx=930;Phantom(3).my=89;
% Phantom(4).mx=1123;Phantom(4).my=389;
% Phantom(5).mx=906;Phantom(5).my=400;
% Phantom(6).mx=884;Phantom(6).my=179;
% Phantom(7).mx=877;Phantom(7).my=313;

% Rachel 
% Phantom(1).mx=1166;Phantom(1).my=177;
% Phantom(2).mx=1157;Phantom(2).my=316;
% Phantom(3).mx=918;Phantom(3).my=88;
% Phantom(4).mx=1122;Phantom(4).my=390;
% Phantom(5).mx=1133;Phantom(5).my=104;
% Phantom(6).mx=898;Phantom(6).my=408;
% Phantom(7).mx=884;Phantom(7).my=178;
% Phantom(8).mx=877;Phantom(8).my=314;

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

tz=5;
% tx=0;
% ty=0;
tx=(MeanMX-MeanX);
ty=(MeanMY-MeanY);
[xf,yf]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz,s);
set (BBSPLOT,'xdata',pixelCm*xf,'ydata',size(Mammo,1)/2 -pixelCm*yf,'marker','o','MarkerFaceColor','b');

merit0=merit(Phantom,pixelCm*xf,size(Mammo,1)/2 -pixelCm*yf);

ya = 0;
StepSize=0.02;
for bigindex=1:5

    %test x distances
    [xf1,yf1]=projectionsimulation(Phantom,tx+StepSize,ty,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya -pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);

    end

    %test y distances
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty+StepSize,tz,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty-StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        ty=ty+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty+Sign*StepSize,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test z(+xy) distances
    [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz+StepSize,rx,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-StepSize*tx/s,ty-StepSize*ty/s,tz-StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        tx=tx-Sign*StepSize*tx/s;
        ty=ty-Sign*StepSize*ty/s;
        tz=tz+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx-Sign*StepSize*tx/s,ty-Sign*StepSize*ty/s,tz+Sign*StepSize,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test rx
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+StepSize,ry,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        rx=rx+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx+Sign*StepSize,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %test ry
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+StepSize,rz,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        ry=ry+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry+Sign*StepSize,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end

    %StepSize=StepSize*0.8;


 %test rz
    [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz+Sign*StepSize,s);
    merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    if merit1>merit0
        Sign=-1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz+Sign*StepSize,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    else
        Sign=1;
    end

    while merit1<merit0
        rz=rz+Sign*StepSize;
        merit0=merit1;
        [xf1,yf1]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz+Sign*StepSize,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
%         pause(StepSize);
        redrawGraph;
    end
    dev_intermediate =  merit1
    StepSize=StepSize*0.4;
end

dev_final = merit1

output=tx,ty,tz,rx,ry,rz

% phantom epsilon-01 roi placement
%{
             x	y	z		       x	y	z		x	y	z		x	y	z
    F1a	-0.11	0.299	0.383	b	-0.11	0.6	0.383	c	-0.398	0.6	0.383	d	-0.398	0.299	0.383
	F2a	-0.225	0	0.752	b	-0.225	0.299	0.752	c	-0.499	0.299	0.752	d	-0.499	0	0.752
	F3a	-0.629	0.299	1.147	b	-0.629	0.6	1.147	c	-0.914	0.6	1.147	d	-0.914	0.299	1.147
	F4a	-0.742	0	1.517	b	-0.742	0.299	1.517	c	-1.022	0.299	1.517	d	-1.022	0	1.517
	F5a	-1.153	0.299	1.915	b	-1.153	0.6	1.915	c	-1.437	0.6	1.915	d	-1.437	0.299	1.915
	F6a	-1.261	0	2.275	b	-1.261	0.299	2.275	c	-1.54	0.299	2.275	d	-1.54	0	2.275
	F7a	-1.669	0.299	2.665	b	-1.669	0.6	2.665	c	-1.949	0.6	2.665	d	-1.949	0.299	2.665
	F8a	-1.773	0	3.022	b	-1.773	0.299	3.022	c	-2.056	0.299	3.022	d	-2.056	0	3.022
%}
%{
Phantom_a7(1).x= ;Phantom_a(1).y=0.299*2.54;Phantom_a(1).z=0.383*2.54;
Phantom_a(2).x=-0.11*2.54;Phantom_a(2).y=0.6*2.54;Phantom_a(2).z=	0.383*2.54;
Phantom_a(3).x=-0.398*2.54;Phantom_a(3).y=0.6*2.54;Phantom_a(3).z=0.383*2.54;
Phantom_a(4).x=-0.398*2.54;Phantom_a(4).y=0.299*2.54;Phantom_a(4).z=0.383*2.54;


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
%}