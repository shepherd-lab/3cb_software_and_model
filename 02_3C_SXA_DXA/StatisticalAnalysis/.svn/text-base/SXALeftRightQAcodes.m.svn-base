%Statistical Analysis to check correlation between left and right sxa
%results
global Database
QAcodeListTitle=mxDatabase(Database.Name,'select description from QAcode');
[Data,title]=mxDatabase(Database.Name,'select * from acquisition,commonanalysis,sxaanalysis,othersxainfo where othersxainfo.sxaanalysis_id=sxaanalysis.sxaanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by patient_id');
indexView=find(strcmp(title','view_id'));
indexInvalidAutoSXA=find(strcmp(deblank(QAcodeListTitle'),'Invalid auto SXA'));
indexSXAmode=find(strcmp(title','Mode'));

CurrentPatientID=0;
CurrentData=[];
Results=[];
DataComptetion=0;
for i=1:size(Data,1)
    i
    PatientID=Data{i,3};
    if ~strcmp(PatientID,CurrentPatientID)
        if DataComptetion==3
            Results=[Results;CurrentData{1} CurrentData{2}];
        end
        CurrentData={};
        DataComptetion=0;
    end
    NewData=Data(i,:);
 
    %%Add QA codes
    QAcode=zeros(1,size(QAcodeListTitle,1));
    QAcodeID=mxDatabase(Database.Name,['select QA_code from QA_code_results where acquisition_id=',num2str(NewData{1})]);
    for index=1:size(QAcodeID,1)
        QAcode(QAcodeID{index})=1;
    end
    NewData=[NewData num2cell(QAcode)];
    
    if ~(strcmpi(deblank(NewData{indexSXAmode}),'Auto')&QAcode(indexInvalidAutoSXA))  %check if rejected analysis
	    DataComptetion=bitor(DataComptetion,2^(NewData{indexView}-2));
	    CurrentData(NewData{indexView}-1)={NewData};
    end
    CurrentPatientID=PatientID;
end

title=[title QAcodeListTitle' title QAcodeListTitle'];