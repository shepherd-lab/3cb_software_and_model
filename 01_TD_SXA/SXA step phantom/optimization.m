% Phantom at height 0cm with no angle
% filename='P:\Vidar Images\test\bbs5.tif';

% Phantom at height 2cm with no angle
% filename='P:\Vidar Images\test\bbs7.tif';

% Phantom at height 4cm with no angle
% filename='P:\Vidar Images\test\bbs9.tif';

% Phantom at height 6cm with no angle
% filename='P:\Vidar Images\test\bbs11.tif';

% Phantom at height 2cm with 1.43 degree angle
filename='P:\Vidar Images\test\bbs6.tif';

% Phantom at height 6cm with 1.43 degree angle
% filename='P:\Vidar Images\test\bbs10.tif';

Mammo=imread(filename);
clear Phantom xf yf
pixelCm=150/2.54;
s=60;
rx=0; ry=0; rz=0;

figure;imagesc(Mammo);colormap(gray);

Phantom(1).x=4.00304;Phantom(1).y=1.03886;Phantom(1).z=0.18542;
Phantom(2).x=3.99542;Phantom(2).y=-0.97536;Phantom(2).z=0.23114;
Phantom(3).x=-1.38684;Phantom(3).y=2.07518;Phantom(3).z=6.53542;
Phantom(4).x=3.05816;Phantom(4).y=-2.09804;Phantom(4).z=1.78562;
Phantom(5).x=3.2385;Phantom(5).y=2.10058;Phantom(5).z=0.79248;

%Phantom(1).x=4;Phantom(1).y=1;Phantom(1).z=0;
%Phantom(2).x=4;Phantom(2).y=-1;Phantom(2).z=0;
%Phantom(3).x=-1.557;Phantom(3).y=2;Phantom(3).z=6.764;
%Phantom(4).x=2.986;Phantom(4).y=-2;Phantom(4).z=1.933;
%Phantom(5).x=2.986;Phantom(5).y=2;Phantom(5).z=0.965;

% Phantom at height 0cm with no angle
% Phantom(1).mx=1016;Phantom(1).my=263;
% Phantom(2).mx=1018;Phantom(2).my=385;
% Phantom(3).mx=764;Phantom(3).my=123;
% Phantom(4).mx=985;Phantom(4).my=438;
% Phantom(5).mx=978;Phantom(5).my=192;

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
filename='P:\Vidar Images\test\bbs8.tif';
Phantom(1).mx=1074;Phantom(1).my=223;
Phantom(2).mx=1074;Phantom(2).my=354;
Phantom(3).mx=819;Phantom(3).my=66;
Phantom(4).mx=1044;Phantom(4).my=409;
Phantom(5).mx=1034;Phantom(5).my=147;

% Phantom at height 6cm with 1.43 degree angle
% Phantom(1).mx=1108;Phantom(1).my=207;
% Phantom(2).mx=1109;Phantom(2).my=341;
% Phantom(3).mx=848;Phantom(3).my=42;
%Phantom(4).mx=1079;Phantom(4).my=399;
% Phantom(5).mx=1069;Phantom(5).my=128;

hold on;
BBSPLOT=plot(0,0,'EraseMode','xor','LineStyle','none');
plot([1016 1018 764 985 978],[263 385 123 438 192],'+')

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
redrawGraph

    
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
    
