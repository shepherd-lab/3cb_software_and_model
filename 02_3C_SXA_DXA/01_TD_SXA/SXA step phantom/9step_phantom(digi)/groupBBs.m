function [groups, coordOrdered] = groupBBs(coordUnorder)

%Group the 14 BBs into 7 pairs depending on their distance
%Return variable groups is a structure array, containing:
%BB index (which BBs are in a groups)
%BB position (x = #col, y = #row)

%initialize groups and coordOrdered
pairs = 7;
groups(pairs).index = zeros(2, 1);
groups(pairs).coord = zeros(2, 2);
groupCount = 0;
coordOrdered = zeros(size(coordUnorder));

%group BBs based on their relative separation
coordCopy = coordUnorder;
while groupCount < pairs
    %select a ref point
    x0 = coordCopy(1, 1);
    y0 = coordCopy(1, 2);
    
    %calculate the nearest point to ref
    distSqr = (x0 - coordCopy(2:end, 1)).^2 + (y0 - coordCopy(2:end, 2)).^2;
    [dist, nearestPt] = min(distSqr);
    nearestPt = nearestPt + 1;  %shift by 1 because the 1st point is not
                                %considered in distance calculation
    
    %assign these two points to a group
    groupCount = groupCount + 1;
    groups(groupCount).coord(1, :) = coordCopy(1, :);
    groups(groupCount).coord(2, :) = coordCopy(nearestPt, :);
    
    %remove these two points from data
    coordCopy(nearestPt, :) = [];
    coordCopy(1, :) = [];
end

%order the groups (See Song Note I, p. 70)
for indexGroup = 1:pairs-1
    if mod(indexGroup, 2)    %odd group
        targetGroup = findOddGroup(groups, indexGroup);
        groups = groupSwap(groups, targetGroup, indexGroup);
    else    %even group: the minimal x-separation to last odd group
        targetGroup = findEvenGroup(groups, indexGroup);
        groups = groupSwap(groups, targetGroup, indexGroup);
    end
end

%order BB indeces in each group
for groupIdx = 1:pairs
    %assign lower index to the first BB in each group
    groups(groupIdx).index(1) = 2*groupIdx - (2 - mod(groupIdx, 2));
    groups(groupIdx).index(2) = min(groups(groupIdx).index(1) + 2, 14);
    
    %reordering the BBs if the order is wrong
    if mod(groupIdx, 2) && groupIdx ~= pairs   %odd group: higher y has lower index
        if groups(groupIdx).coord(1, 2) < groups(groupIdx).coord(2, 2)
            groups = swapGroupBBcoord(groups, groupIdx);
        end
    else    %even group and last group: lower y has lower index
        if groups(groupIdx).coord(1, 2) > groups(groupIdx).coord(2, 2)
            groups = swapGroupBBcoord(groups, groupIdx);
        end
    end
end

%assign values to coordOrdered
for groupIdx = 1:pairs
    for BBinGroup = 1:2
        BBindex = groups(groupIdx).index(BBinGroup);
        coordOrdered(BBindex, :) = groups(groupIdx).coord(BBinGroup, :);
    end
end


%%
function groupIndex = findOddGroup(groups, idx)

%odd group: the nearest group to origin

pairs = length(groups);
minDist = inf;

for i = idx:pairs
    distToOrig = groups(i).coord(1, 1)^2 + groups(i).coord(1, 2)^2;
    if minDist > distToOrig
        minDist = distToOrig;
        groupIndex = i;
    end
end


%%
function groupIndex = findEvenGroup(groups, idx)

%even group: the minimal x-separation to last odd group

pairs = length(groups);
minxSep = inf;

for i = idx:pairs
    xSep = groups(i).coord(1, 1) - groups(idx-1).coord(1, 1);
    if minxSep > xSep
        minxSep = xSep;
        groupIndex = i;
    end
end


%%
function groupsOut = groupSwap(groupsIn, idx1, idx2)

if idx1 ~= idx2
    temp = groupsIn(idx2).index;
    groupsIn(idx2).index = groupsIn(idx1).index;
    groupsIn(idx1).index = temp;

    temp = groupsIn(idx2).coord;
    groupsIn(idx2).coord = groupsIn(idx1).coord;
    groupsIn(idx1).coord = temp;
end

groupsOut = groupsIn;


%%
function groupsOut = swapGroupBBcoord(groupsIn, idx)

temp = groupsIn(idx).coord(2, :);
groupsIn(idx).coord(2, :) = groupsIn(idx).coord(1, :);
groupsIn(idx).coord(1, :) = temp;

groupsOut = groupsIn;

