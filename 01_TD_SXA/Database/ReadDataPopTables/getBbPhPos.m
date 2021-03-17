function bbInPh = getBbPhPos(site, numBb)

bbInPh(numBb) = struct('x', [], 'y', [], 'z', []);     %initialization
group1 = {'CPMC', 'Marin', 'UCSF', 'NC', 'Shanghai'};
group2 = {'Vermont', 'London'};

if (sum(strcmpi(site, group1)))
    delta = 1;
    dh = 4;
    l = 14.5618 + 2*0.04953;
    x = [-1 1 -1 1 -1 1 -1 1 -1 1 -1 1 1 1]*l/2;
    y = [zeros(1,4), ones(1,4)*3, ones(1,4)*7, ones(1,2)*10.5];
    z = delta + [0 0 dh dh 0 0 dh dh 0 0 dh dh 0 dh];
    for i = 1:numBb
        bbInPh(i).x = x(i);
        bbInPh(i).y = y(i);
        bbInPh(i).z = z(i);
    end
elseif (sum(strcmpi(site, group2)))
    
else
    error('Wrong site name!');
end