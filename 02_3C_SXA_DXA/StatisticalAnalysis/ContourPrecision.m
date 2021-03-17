%Statistical Analysis to check the precision of contour reading.
%take the first and last BBD reading acquisition


[Data,title]=mxDatabase(Database.Name,'select * from acquisition,commonanalysis,freeformanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and study_id=''BBD'' order by patient_id');

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
    NewData=[cell2mat(Data(i,34)) cell2mat(Data(i,8)) cell2mat(Data(i,27))];
    if (NewData(2)==2)||(NewData(2)==3)
        DataComptetion=bitor(DataComptetion,2^(NewData(2)-2));
        CurrentData(NewData(2)-1,:)=NewData;
    end
    CurrentPatientID=PatientID;
end
