%Statistical Analysis to check correlation between left and right sxa
%results
global Database

[Data,title]=mxDatabase(Database.Name,'select * from acquisition,commonanalysis,sxaanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id');

CurrentPatientID=0;
CurrentData=[];
Results=[];
DataComptetion=0;
for i=1:size(Data,1)
    PatientID=cell2mat(Data(i,3));
    if ~strcmp(PatientID,CurrentPatientID)
        if DataComptetion==3
            Results=[Results;str2num(CurrentPatientID) CurrentData(1,:) CurrentData(2,:)];
        end
        CurrentData=[];
        DataComptetion=0;
    end
    NewData=[cell2mat(Data(i,34)) cell2mat(Data(i,8))];
    if (sum(NewData==-1)==0)
        DataComptetion=bitor(DataComptetion,2^(NewData(2)-2));
        CurrentData(NewData(2)-1,:)=NewData;
    end
    CurrentPatientID=PatientID;
end
