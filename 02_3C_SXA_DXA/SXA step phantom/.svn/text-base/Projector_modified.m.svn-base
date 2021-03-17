function [xf,yf]=Projector2(x,y,z,tx,ty,tz,rx,ry,rz,s)
% Today is 10/15/2003
% Keyna Chow

Tinv=[1,0,0,tx;...
   0,1,0,ty;...
   0,0,1,tz;...
   0,0,0,1];

T =[1,0,0,-tx;...
   0,1,0,-ty;...
   0,0,1,-tz;...
   0,0,0,1];

Rx = [1, 0, 0;
      0, cos(rx/180*pi), sin(rx/180*pi);
      0, -sin(rx/180*pi), cos(rx/180*pi)];

  
Ry = [cos(ry/180*pi), 0, -sin(ry/180*pi);
      0, 1, 0;
      sin(ry/180*pi, 0, cos(ry/180*pi)];
      
Rz = [cos(rz/180*pi), sin(rz/180*pi),0;
      -sin(rz/180*pi), cos(rz/180*pi), 0;
      0, 0, 1];

Rxyz = Rz * Ry * Rx;
R0(1:3,1:3) = R;
R0(4,1:4) = [ 0, 0, 0, 1];
R0(1:4, 4) = [ 0; 0; 0; 1];

R = Tivn * R0 * T;

%{
F=[1,0,0,0;...
   0,cos(rx/180*pi),-sin(rx/180*pi),0;...
   0,sin(rx/180*pi),cos(rx/180*pi) ,0;...
   0,0             ,0              ,1];

G=[cos(ry/180*pi)  ,0,sin(ry/180*pi),0;...
   0               ,1,0             ,0;...
    -sin(ry/180*pi),0,cos(ry/180*pi),0;...
   0               ,0,0             ,1];
H=[cos(rz/180*pi)  ,-sin(rz/180*pi),0,0;...
   sin(rz/180*pi)  ,cos(rz/180*pi) ,0,0;...
   0               ,0              ,1,0;...
   0               ,0              ,0,1];

BB=H*G*F*E*[x;y;z;1];
%}
BB = Tivn * R0 * T * [x;y;z;1]; 

xb=BB(1);
yb=BB(2);
zb=BB(3);

xf=s/(s-zb)*xb;
yf=s/(s-zb)*yb;
zf=0;




