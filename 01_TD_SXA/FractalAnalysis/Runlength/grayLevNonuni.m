function GLN = grayLevNonuni(runLenMat, numRuns)
%calculate the gray level nonuniformity based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

GLN = sum((sum(runLenMat.matrix, 2)).^2)/numRuns;

end
