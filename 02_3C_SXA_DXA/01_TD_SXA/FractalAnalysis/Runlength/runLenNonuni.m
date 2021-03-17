function RLN = runLenNonuni(runLenMat, numRuns)
%calculate run length nonuniformity based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

RLN = sum((sum(runLenMat.matrix, 1)).^2)/numRuns;

end
