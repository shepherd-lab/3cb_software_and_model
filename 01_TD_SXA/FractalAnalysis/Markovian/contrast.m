function result = contrast(diffVec)
%contrast computes Contrast

n = length(diffVec);
result = 0;

for k = 1:n
    result = result + (k-1)^2 * diffVec(k);
end