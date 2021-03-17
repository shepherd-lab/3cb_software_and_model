function LGRE = lowGlevelRunEmph(runLenMat, numRuns)
%calculate the low gray-level run emphasis based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

[m, n] = size(runLenMat.matrix);
glevelMin = runLenMat.glevelMin;
LGREsum = 0;
for i = 1:m
    glevel = glevelMin + i - 1;
    for j = 1:n
        LGREsum = LGREsum + runLenMat.matrix(i, j)/(glevel^2);
    end
end

LGRE = LGREsum/numRuns;

end
