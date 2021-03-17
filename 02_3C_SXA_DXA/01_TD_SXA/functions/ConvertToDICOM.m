function ConvertToDICOM(AcquisitionKey)
global Database Image

%create a simple DICOM file some header pices of information coming from
%the database

filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionKey)])));
PatientID=cell2mat(mxDatabase(Database.Name,['select patient_ID from acquisition where acquisition_id=',num2str(AcquisitionKey)]));
StudyID=cell2mat(mxDatabase(Database.Name,['select study_ID from acquisition where acquisition_id=',num2str(AcquisitionKey)]));
View=cell2mat(mxDatabase(Database.Name,['select view_description from acquisition,mammo_view where mammo_view.mammoview_id=acquisition.view_id and acquisition_id=',num2str(AcquisitionKey)]));

dicomwrite(uint16(Image.image), [filename(1:end-4),'.dcm'], 'PatientID',PatientID,'StudyID',StudyID,'PatientOrientation',View);

NextPatient(0);

