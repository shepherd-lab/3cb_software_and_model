function SRE = ShortRunsEmph(runLenMat, numRuns)
%calculate short runs emphasis from a run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

[m, n] = size(runLenMat.matrix);
SREsum = 0;
for i = 1:m
    for j = 1:n
        SREsum = SREsum + runLenMat.matrix(i, j)/(j^2);
    end
end

SRE = SREsum/numRuns;

end
