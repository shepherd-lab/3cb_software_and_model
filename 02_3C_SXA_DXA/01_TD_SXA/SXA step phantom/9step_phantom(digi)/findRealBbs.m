function BBcoord = findRealBbs(coordAll)

%This function reads in positions of all BBs found by its parent function
%and returns 14 [x, y] coord of the real BBs.

BBcoord = zeros(14, 2);
groupCenter = zeros(4, 2);

group = groupingPairs(coordAll);
BBcoord(5, :) = group(1).coord(1, :);
BBcoord(7, :) = group(1).coord(2, :);
BBcoord(6, :) = group(3).coord(1, :);
BBcoord(8, :) = group(3).coord(2, :);
BBcoord(9, :) = group(2).coord(1, :);
BBcoord(11, :) = group(2).coord(2, :);
BBcoord(10, :) = group(4).coord(1, :);
BBcoord(12, :) = group(4).coord(2, :);

BBcoord(1, :) = group(4).coord(1, :);
BBcoord(3, :) = group(4).coord(2, :);
BBcoord(2, :) = group(4).coord(1, :);
BBcoord(4, :) = group(4).coord(2, :);

for i = 1:4
    groupCenter(i, :) = mean(group(i).coord);
end

delta_x1 = groupCenter(2, 1) - groupCenter(1, 1);
delta_y1 = groupCenter(2, 2) - groupCenter(1, 2);
k1 = delta_y1/delta_x1;
delta1 = sqrt(delta_x1^2 + delta_y1^2);

delta_x2 = groupCenter(4, 1) - groupCenter(3, 1);
delta_y2 = groupCenter(4, 2) - groupCenter(3, 2);
k2 = delta_y2/delta_x2;
delta2 = sqrt(delta_x2^2 + delta_y2^2);

%average the pair separations in the 4 groups
%use the separation as critical radius to determine other pairs
group_d = zeros(4, 1);
for i = 1:4
    group_d(i) = sqrt((group(i).coord(1, 1) - group(i).coord(2, 1))^2 + ...
                      (group(i).coord(1, 2) - group(i).coord(2, 2))^2);
end
r = mean(group_d);

%define two lines passing the group centers on each side
line1 = @(x) groupCenter(1, 2) + k1*(x-groupCenter(1, 1));
line2 = @(x) groupCenter(3, 2) + k2*(x-groupCenter(3, 1));

%locate the first pair (upper left)
dist = 3/4*delta1;
regCenter = locatePtOnLine(line1, groupCenter(1, :), -dist);
BBidx = whBBinside(coordAll, group(1).index(1), 'left', regCenter, r);
BBcoord(1, :) = coordAll(BBidx(1), :);
BBcoord(3, :) = coordAll(BBidx(2), :);

%locate the second pair (lower left)
dist = 3/4*delta2;
regCenter = locatePtOnLine(line2, groupCenter(3, :), -dist);
BBidx = whBBinside(coordAll, group(1).index(1), 'left', regCenter, r);
BBcoord(2, :) =  coordAll(BBidx(1), :);
BBcoord(4, :) = coordAll(BBidx(2), :);

%locate the third pair (lower right)
dist = 3.5/4*delta2;
regCenter = locatePtOnLine(line2, groupCenter(4, :), dist);
BBidx = whBBinside(coordAll, group(4).index(2), 'right', regCenter, r);
BBcoord(13, :) = coordAll(BBidx(1), :);
BBcoord(14, :) = coordAll(BBidx(2), :);

%sort BBs in the predefined order (Song Note_I p.14)
for i = 1:3     %the first 12 BB's need reordering, divide them into 3 groups
    orderedFour = sortrows(BBcoord(4*i-3:4*i, :), 2); %in ascending order
    BBcoord(4*i-1, :) = orderedFour(1, :);
    BBcoord(4*i-3, :) = orderedFour(2, :);
    BBcoord(4*i-2, :) = orderedFour(3, :);
    BBcoord(4*i, :) = orderedFour(4, :);
end
if (BBcoord(13, 1) > BBcoord(14, 1))    %swap 13 and 14 if in wrong order
    temp = BBcoord(13, :);
    BBcoord(13, :) = BBcoord(14, :);
    BBcoord(14, :) = temp;
end

%%
function pt = locatePtOnLine(line, pt0, dist)

%Given a line function and a reference point pt0, determine a point's
%coordinate based on its distance from the reference
%dist can be negative

if (pt0(2) - line(pt0(1)) > 1e-6)
    pt = [];
    error('Error: Reference point is not on the given line!');
else
    k = (pt0(2) - line(0))/pt0(1);  %cos(th) = sqrt(1/(1+k^2))
    pt = zeros(1, 2);
    pt(1) = pt0(1) + dist*sqrt(1/(1+k^2));  %pt_x = pt0_x + d*cos(th)
    pt(2) = line(pt(1));
end


%%
function BBinIdx = whBBinside(coordAll, refIdx, direction, regCent, regRad)

%In a circular region defined by regCent and regRad, check which BBs are
%inside this region. To increase efficiency, only BBs on the specified
%direction of the referece BB will be examined
%direction : 'left' or 'right'

if strcmpi(direction, 'left')
    startIdx = 1;
    endIdx = refIdx - 1;
elseif strcmpi(direction, 'right')
    startIdx = refIdx + 1;
    endIdx = size(coordAll, 1);
end

BBfound = 0;
for i = startIdx:endIdx
    x = coordAll(i, 1);
    y = coordAll(i, 2);
    dist = sqrt((x - regCent(1))^2 + (y - regCent(2))^2);
    if dist < regRad
        BBfound = BBfound + 1;
        BBinIdx(BBfound) = i;
    end
end