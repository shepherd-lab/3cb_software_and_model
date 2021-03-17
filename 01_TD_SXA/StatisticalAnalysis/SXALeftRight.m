%Statistical Analysis to check correlation between left and right sxa
%results
global Database

[Data,title]=mxDatabase(Database.Name,'select * from acquisition,commonanalysis,sxaanalysis,taginformation where taginformation.acquisitionid=acquisition.acquisition_id and commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by patient_id');
Height1=cell2mat(Data(:,45))*25.4/169+27;
Distance=cell2mat(Data(:,47));
Height2=(225*25.4/169-cell2mat(Data(:,46))*25.4/169)/0.1959./Distance*800;
Bool=abs((Height2./Height1)-1)<0.4;
MeasuredThickness=Height1.*Bool+(1-Bool).*Height2;

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
    NewData=[cell2mat(Data(i,32)) cell2mat(Data(i,50)) cell2mat(Data(i,51)) cell2mat(Data(i,52)) cell2mat(Data(i,53)) ...
            cell2mat(Data(i,54)) cell2mat(Data(i,8)) cell2mat(Data(i,27)) Height1(i) Height2(i) MeasuredThickness(i) Distance(i)];
    if (sum(NewData==-1)==0)%&&(NewData(4)==1)
        DataComptetion=bitor(DataComptetion,2^(NewData(7)-2));
        CurrentData(NewData(7)-1,:)=NewData;
    end
    CurrentPatientID=PatientID;
end
