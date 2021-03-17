function RPT = runPercent(runLenMat, numRuns)
%calculate the run percentage based on the run-length matrix

if nargin == 1
    numRuns = sum(sum(runLenMat.matrix));
end

runLen = 1:size(runLenMat.matrix, 2);
numPixels = sum(runLen.*sum(runLenMat.matrix, 1));

RPT = numRuns/numPixels;

end
