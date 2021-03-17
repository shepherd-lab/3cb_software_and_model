%Lionel HERVE
%5-25-04
%retrieve all the SXA analysis

global Database Info Image Analysis ctrl Threshold
PercentThreshold=0.3;

%content={};
columntitle={'acquisitionID';'Lean Wegde Thickness'};
Results=[];

SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
for index=1:size(SXAIDList)
    index
    Info.SXAAnalysisKey=SXAIDList(index);
    Database.Step=2;    
    RetrieveInDatabase('SXAANALYSIS');    
    set(ctrl.Cor,'value',true);
    ButtonProcessing('CorrectionAsked');
    ComputeDensity;
    Results=[Results;Analysis.DensityPercentage];
    mxDatabase(Database.Name,['update sxaanalysis set sxaresult=''',num2str(Analysis.DensityPercentageAngle),''' where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)]);
end
