% Update OtherSXAinfo
% since the new table othersxainfo was created, to obtain complete sxa
% results, we need to fill this table

global Database Info

AcqList=mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis,commonanalysis,acquisition where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''SXADXA''');

for index=1:size(AcqList,1)
    Info.SXAAnalysisKey=AcqList{index};
    Database.Step=1;
    RetrieveInDatabase('SXAANALYSIS');
    SaveInDatabase('OTHERSXAINFO')
end