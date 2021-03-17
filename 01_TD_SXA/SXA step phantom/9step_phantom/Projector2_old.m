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

Rxyz = Rz * Ry * Rx;
R0(1:3,1:3) = Rxyz;
R0(4,1:4) = [ 0, 0, 0, 1];
R0(1:4, 4) = [ 0; 0; 0; 1];
%R = T * R0  * Tinv;
%seed1 = R0 * [x;y;z;1]; 
%seed = T * seed1;

RT = T * R0 ;
szx = size(x);
len = ones(szx(1),1);
seed = RT * [x';y';z';len'];
xb=seed(1,:);
yb=seed(2,:);
zb=seed(3,:);

%PR = [1, 0, 0,0  ; 0, 1, 0, 0; 0, 0, 1, 0;s/(s-zb)*xb, s/(s-zb)*yb, 0, 1]; 
%xfm = PR * seed;

xf=s./(s-zb).*xb;
yf=s./(s-zb).*yb;
zf=zeros(1,len);




