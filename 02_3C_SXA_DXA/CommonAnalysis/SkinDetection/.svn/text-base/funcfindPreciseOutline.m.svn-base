function [PreciseOutline_x,PreciseOutline_y] = funcfindOutline(outline_x,outline_y);
%
% PreciseOutline search 
%   
%    
%       
%
%   Author: Lionel HERVE  2-03 
%   Revision History:
%   use the outline calculated before and fill the holes
%------------------------------------------------------------------

PreciseOutline_x=0;
PreciseOutline_y=0;
indexpreciseoutline=1;
same=false;
[toto,npoint]=size(outline_x);
for indexoutline = 1:npoint-1
    for i=0:abs(outline_y(indexoutline+1)-outline_y(indexoutline)) %compute the vertical distance between 2 adjacent points
        PreciseOutline_x(indexpreciseoutline)=outline_x(indexoutline);  %fill the gap
        PreciseOutline_y(indexpreciseoutline)=outline_y(indexoutline)+sign(outline_y(indexoutline+1)-outline_y(indexoutline))*i;
        indexpreciseoutline=indexpreciseoutline+1;
    end
end
