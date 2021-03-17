function LRE = longRunsEmph(runLenMat, numRuns)
%calculate the long run emphasis based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

[m, n] = size(runLenMat.matrix);
LREsum = 0;
for i = 1:m
    for j = 1:n
        LREsum = LREsum + (j^2)*runLenMat.matrix(i, j);
    end
end

LRE = LREsum/numRuns;

end
