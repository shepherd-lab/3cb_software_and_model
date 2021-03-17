function [midpoint,p] = funcFindMidPoint(outline_x,outline_y);
%
% find midpoint from the rough outline
%   Author: Lionel HERVE  2-03 
%   Revision History:
%       return analytic expression of mid curve (2/03)
% --------------------------------------------------------------------

[C,I]=max(outline_x); %find the right edge of the breast

%figure;
%plot(outline_x);
[toto,npoint]=size(outline_x); %length of the outline curve
outline1_x=outline_x(1:I-1);outline1_y=outline_y(1:I-1); %upper part of the breas
outline2_x=outline_x(I+1:npoint);outline2_y=outline_y(I+1:npoint); %lower part of the breast


curve_y=(rot90(rot90(outline2_y))+outline1_y)/2; %mid curve
curve_x=outline1_x;  
p=polyfit(curve_x,curve_y,1); %fit the the mid curve with a first degree polynomial
%figure;plot(curve_x,curve_y,'b-');

midpoint=round(polyval(p,1));
a =1;

