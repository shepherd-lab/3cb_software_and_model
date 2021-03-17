% test speed for reporecessing 200 scans

tic
AnalysisBegin=hour
global Database ctrl Info
AcqList=mxDatabase(Database.Name,'select sxaanalysis_id from acquisition, commonanalysis, sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id',20);
for index=1:size(AcqList)
    set(ctrl.Cor,'value',0);
    Info.SXAAnalysisKey=cell2mat(AcqList(index));
    Database.Step=1;    %before 2
    RetrieveInDatabase('SXAANALYSIS');
end
AnalysisEnd=hour
toc
