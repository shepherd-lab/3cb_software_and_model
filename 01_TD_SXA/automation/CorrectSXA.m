%recompute the SXA results by putting >100% value at 100%
%
global Recognition Database Analysis

for localIndex=9:601
    localIndex
    Info.SXAAnalysisKey=localIndex;
    try
        RetrieveInDatabase('SXAANALYSIS');
        mxDatabase(Database.Name,['update sxaanalysis set SXAresult=',num2str(Analysis.DensityPercentage),'where sxaanalysis_id=',num2str(localIndex)])
    end
end