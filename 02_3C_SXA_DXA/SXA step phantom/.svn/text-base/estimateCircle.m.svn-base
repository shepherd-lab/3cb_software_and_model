% The function that estimate a circle based on points on a circle
% 
%
% estimateCircle.m
% 03-19-2005  Qin   created. Rewrite based on matlab sample.
%                   Rewrite basic equation for a circle:(x-xc)^2 + (y-yc)^2 = radius^2,  
%                   where (xc,yc) is the centerin terms of parameters 
%                   a, b, c asx^2 + y^2 + a*x + b*y + c = 0,  where a = -2*xc, b = -2*yc, and
%                   c = xc^2 + yc^2 - radius^2Solve for parameters a, b, c, and use them to 
%                   calculate the radius.


function circle=estimateCircle(contour)

x = contour(:,2);
y = contour(:,1);

% solve for parameters a, b, and c in the least-squares sense by 
% using the backslash operator
abc=[x y ones(length(x),1)]\[-(x.^2+y.^2)];
a = abc(1); b = abc(2); c = abc(3);

% calculate the location of the center and the radius
circle.x = -a/2;
circle.y = -b/2;
circle.r  =  sqrt((circle.x^2+circle.y^2)-c)


