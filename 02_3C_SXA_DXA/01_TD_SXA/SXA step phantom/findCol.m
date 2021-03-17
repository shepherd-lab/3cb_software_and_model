% The function that find the first on pixel based on search orientation
% 
%
% findRow.m
% 03-19-2005  Qin   Created
%                   

function [col row]=findCol(BW, colmin, colmax,startrow, orientation)

dim = size(BW);
col = round(dim(2));

row = startrow;
if(row == 0)
    row = 1;
end

%starting from top edge, find the edge of bb
%This assumes that bb is placed correctly and straight
if(orientation == 'top2bottom')
    while row <  round(dim(1))
        test = BW(row, round(colmin):round(colmax));
        test = test';
        col = min(find(test)); 
        if(isempty(col)== 0)
            break;
        end
        row = row +1 
    end   
else %'bottom2top'
    while row > 0
        test = BW(row, round(colmin):round(colmax));
        test = test';
        col = min(find(test)); 
        if(isempty(col)== 0)
            break;
        end
        row = row - 1 ;
    end     
end
col = col + colmin;


