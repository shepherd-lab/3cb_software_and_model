function group = groupingPairs(b)
global Info
%This function groups the 8 bbs in the middle of the GEN3 phantom into 4
%groups. Each group contains a pair of bbs in vertical orientation.
%Input: the coordinate of all bbs found from image. Each row is [x, y].
%
%The return values are:
%group_indices: indices of the 8 bbs as stored in the input array 'b'
%group_coord: the coord of the 8 bbs, coorespondingly

global ROI
 kGE = 0.71;
 if Info.DigitizerId == 5 | Info.DigitizerId == 6 | Info.DigitizerId == 7 
        crop_coef = kGE;
    else
        crop_coef = 1;
    end


group(4).index = zeros(2, 1);
group(4).coord = zeros(2, 2);

mid_X = round(ROI.columns/2);
mid_Y = round(ROI.rows/2);
quarter_X = round(ROI.columns/4);

group(1).index = find(b(:,1) > quarter_X & b(:,1) < mid_X & b(:,2) < mid_Y)  %- 400*crop_coef);
group(2).index = find(b(:,1) > mid_X & b(:,1) < mid_X+quarter_X & b(:,2) < mid_Y) %- 400*crop_coef);
group(3).index = find(b(:,1) > quarter_X & b(:,1) < mid_X & b(:,2) > mid_Y) %+ 400*crop_coef);
group(4).index = find(b(:,1) > mid_X & b(:,1) < mid_X+quarter_X & b(:,2) > mid_Y) %+ 400*crop_coef);

group(5).index = find(b(:,1) > mid_X+quarter_X & b(:,2) > mid_Y) %+ 40 bottom right
group(6).index = find(b(:,1)< quarter_X & b(:,2) > mid_Y) %+ 40 bottom left
group(7).index = find(b(:,1)< quarter_X & b(:,2) < mid_Y) %+ 40 bottom left

for i = 1:7
    group(i).coord = b(group(i).index,:);
end
