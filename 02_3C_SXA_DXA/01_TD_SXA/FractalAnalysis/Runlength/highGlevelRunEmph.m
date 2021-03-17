function HGRE = highGlevelRunEmph(runLenMat, numRuns)
%calculate the high gray-level run emphasis based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

[m, n] = size(runLenMat.matrix);
glevelMin = runLenMat.glevelMin;
HGREsum = 0;
for i = 1:m
    glevel = glevelMin + i - 1;
    for j = 1:n
        HGREsum = HGREsum + (glevel^2)*runLenMat.matrix(i, j);
    end
end

HGRE = HGREsum/numRuns;

end
