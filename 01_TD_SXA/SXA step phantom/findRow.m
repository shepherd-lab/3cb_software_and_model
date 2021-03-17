% The function that find the first on pixel based on search orientation
% 
%
% findRow.m
% 03-19-2005  Qin   Created


function [col row]=findRow(BW, rowmin, rowmax,startcol, orientation)

col = startcol;

%starting from right edge, find the edge of bb
%This assumes that bb is placed correctly and straight
if(orientation == 'right2left')
while col > 1 
   row = min(find(BW(rowmin:rowmax,col))); 
   if(isempty(row)== 0)
       break;
   end
   col = col -1 ;
end
row = row + rowmin;
end


