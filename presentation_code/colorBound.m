function [range] = colorBound(arg)
minimum = min(min(arg));
maximum = max(max(arg));
if ~(maximum>minimum)
    maximum = inf
end
range = [minimum, maximum];

