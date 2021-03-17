% check if some acquisition have a automatic and a manual sxa analysis and
% no QA codes "invalid SXA analysis"

global Database;

List1=cell2mat(mxdatabase(Database.Name,'select acquisition_id from commonanalysis,sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and mode=''auto'''));
List2=cell2mat(mxdatabase(Database.Name,'select acquisition_id from commonanalysis,sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and mode=''manual'''));

for index=1:length(List2)
    acqID=List2(index); 
    if (sum(List1==acqID)>0)&&~size(mxDatabase(Database.Name,['select * from QA_code_results where QA_code=30 and acquisition_id=',num2str(acqID)]),1)
        ['pb with',num2str(acqID)]
    end
end