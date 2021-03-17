function [xf,yf]=Projector2(x,y,z,tx,ty,tz,rx,ry,rz,s)
% 
% modified code of Keyna Chow

T=[1,0,0,tx;...
   0,1,0,ty;...
   0,0,1,tz;...
   0,0,0,1];

Tinv =[1,0,0,-tx;...
   0,1,0,-ty;...
   0,0,1,-tz;...
   0,0,0,1];

Rx = [1, 0, 0;
      0, cos(rx/180*pi), sin(rx/180*pi);
      0, -sin(rx/180*pi), cos(rx/180*pi)];

  
Ry = [cos(ry/180*pi), 0, -sin(ry/180*pi);
      0, 1, 0;
      sin(ry/180*pi), 0, cos(ry/180*pi)];
      
Rz = [cos(rz/180*pi), sin(rz/180*pi),0;
      -sin(rz/180*pi), cos(rz/180*pi), 0;
      0, 0, 1];

%Rxyz =  Rx * Ry *  Rz;
Rxyz = Rz * Ry * Rx; %initial
R0(1:3,1:3) = Rxyz;
R0(4,1:4) = [ 0, 0, 0, 1];
R0(1:4, 4) = [ 0; 0; 0; 1];
%R = T * R0  * Tinv;
%seed1 = R0 * [x;y;z;1]; 
%seed = T * seed1;

RT = T * R0 ;
szx = size(x);

len = ones(szx(1),1);
%seed = RT * [x';y';z';len'];
seed = RT * [x';y';z';len'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = hgtransform;
    set([x';y';z'],'Parent',t);
    
    ry_angle = ry*pi/180; % Convert to radians
    Ry = makehgtform('yrotate',ry_angle);
    rx_angle = rx*pi/180; % Convert to radians
    Rx = makehgtform('xrotate',rx_angle);
    rz_angle = rz*pi/180; % Convert to radians
    Rz = makehgtform('zrotate',rz_angle);
    
    %set(t,'Matrix',Rz*Ry*Rx);
    
    Tx1 = makehgtform('translate',[-tx,-ty,-tz]);
    Tx2 = makehgtform('translate',[tx,ty,tz]);
    set(t,'Matrix',Tx2*Rz*Ry*Rx*Tx1);
    t = seed;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xb=seed(1,:);
yb=seed(2,:);
zb=seed(3,:);


%PR = [1, 0, 0,0  ; 0, 1, 0, 0; 0, 0, 1, 0;s/(s-zb)*xb, s/(s-zb)*yb, 0, 1]; 
%xfm = PR * seed;

xf=s./(s-zb).*xb;
yf=s./(s-zb).*yb;
zf=zeros(1,len);




