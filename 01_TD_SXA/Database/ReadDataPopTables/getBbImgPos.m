function bbPosWld = getBbImgPos(acqID, comAnaID, pxToCm, imgRows, ROIx0, ROIy0, QCx0, QCy0)
%This function reads (x, y) positions of BB's from Phantom Region Image
%and tranlates them into the world coordinate system. It also orders the
%BB's by following "GEN3 BB numbering.bmp".
%Refer to Song_Note_I page 11 & 15 for details.

n = 14;
bbPos = zeros(n, 2);
bbPosWld = struct('x', [], 'y', []);
axes = ['x', 'y'];

%read BB locations from 'QCGen3BBlocations'
SQLstatement = ['SELECT '];
for i = 1:n
    for j = 1:2
        if (i == 14 && j == 2)    %the last number to read
            SQLstatement = [SQLstatement, 'coord_', num2str(i), axes(j), ' '];
        else
            SQLstatement = [SQLstatement, 'coord_', num2str(i), axes(j), ', '];
        end
    end
end
SQLstatement = [SQLstatement, 'FROM QCGen3BBlocationsNew ', ...
                'WHERE acquisition_id = ', num2str(acqID)];
entryRead = mxDatabase('mammo_cpmc', SQLstatement);

for i = 1:n
    for j = 1:2
        bbPos(i, j) = entryRead{2*(i-1)+j};
    end
end

%this part is commented out by Song 6/17/10 since the sorting function is
%perfomred by findRealBbs.m, which sorts the BBs out when finding them.
% %reorder BB's with a certain sequence
% for i = 1:3     %the first 12 BB's need reordering, divide them into 3 groups
%     orderedFour = sortrows(bbPos(4*i-3:4*i, :), 2); %in ascending order
%     bbPos(4*i-1, :) = orderedFour(1, :);
%     bbPos(4*i-3, :) = orderedFour(2, :);
%     bbPos(4*i-2, :) = orderedFour(3, :);
%     bbPos(4*i, :) = orderedFour(4, :);
% end
% if (bbPos(13, 1) > bbPos(14, 1))    %swap 13 and 14 if in wrong order
%     temp = bbPos(13, :);
%     bbPos(13, :) = bbPos(14, :);
%     bbPos(14, :) = temp;
% end

%calcuate middle point of (5, 7) and delta_x
mid5_7_x = (bbPos(5, 1) + bbPos(7, 1))/2;
mid5_7_y = (bbPos(5, 2) + bbPos(7, 2))/2;
mid9_11_x = (bbPos(9, 1) + bbPos(11, 1))/2;
delta_x = mid9_11_x - mid5_7_x;

%translate the bbPos from Phantom Region to the World coordinate
for i = 1:n
    bbPosWld(i).x = pxToCm*(bbPos(i, 2) - mid5_7_y - 100 + ROIy0 - imgRows/4) - QCy0;
    bbPosWld(i).y = pxToCm*(bbPos(i, 1) - mid5_7_x + delta_x + ROIx0) - QCx0;
end