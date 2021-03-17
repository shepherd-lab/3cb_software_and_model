function [Xf]=bbProjector(X,tx,ty,tz,R,s)
% 
T=[1,0,0,tx;...
   0,1,0,ty;...
   0,0,1,tz;...
   0,0,0,1];

RT = T * R' ;
szx = size(X);
len = ones(szx(1),1);
seed = RT * [X(:,1)';X(:,2)';X(:,3)';len'];
xb=seed(1,:);
yb=seed(2,:);
zb=seed(3,:);

%PR = [1, 0, 0,0  ; 0, 1, 0, 0; 0, 0, 1, 0;s/(s-zb)*xb, s/(s-zb)*yb, 0, 1]; 
%xfm = PR * seed;

xf=s./(s-zb).*xb;
yf=s./(s-zb).*yb;
len0 = zeros(szx(1),1);
zf=len0;
Xf = [xf',yf',zf];
;




