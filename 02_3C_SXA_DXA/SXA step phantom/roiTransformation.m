% ROI transformation
% 1/26/2005 Keyna Chow

% Phantom at height 0cm with no angle
% filename='P:\Vidar Images\test\bbs5.tif';
% tx=12.8351; ty=9.1476; tz=0.8260;
% rx=0.2767; ry=-1.1801; rz=0;

% Phantom at height 6cm with 1.43 degree angle
filename='P:\Vidar Images\test\bbs10.tif';
tx=13.3627; ty=9.2943; tz= 4.4683;
rx=-0.7750; ry=-1.5049; rz=0;

Mammo=imread(filename);
figure;imagesc(Mammo);colormap(gray);

% Phantom Delta Series
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

s=60;

pixelCm=150/2.54;


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



