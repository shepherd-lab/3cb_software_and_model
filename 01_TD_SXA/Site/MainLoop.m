%Main Loop for QC Management
%Lionel HERVE
%5-9-04

global Analysis Info f0 Database ctrl Hist Image


figure (f0.handle)
Dicom.Database='eFilmDatabase';
Database.Name='mammo_cpmc';
set(ctrl.Cor,'value',false);


AcquisitionIDList=mxDatabase(Database.Name,'select acquisition_id from acquisition where patient_id=''111111111111''');
for index=5:size(AcquisitionIDList,1)
    %Open it
    Info.AcquisitionKey=cell2mat(AcquisitionIDList(index,1));
    fullname=cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=''',num2str(Info.AcquisitionKey),'''']));
    RetrieveInDatabase('ACQUISITION');
    
    QCManagement;
    EnterNewMotif;
end
