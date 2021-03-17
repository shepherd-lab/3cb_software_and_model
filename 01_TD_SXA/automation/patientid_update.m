function dupl_delete()
   output = [];
   count = 0;
   acq = [];
 Database.Name = 'mammo_CPMC';
%SQLStatement = ['SELECT rfilename FROM dbo.DXAacq GROUP BY rfilename HAVING (COUNT(rfilename) > 1)'];
% % % SQLStatement = [
% % %  'SELECT     acquisition.acquisition_id, dbo.DICOMinfo.AdmissionID  FROM  dbo.DICOMinfo INNER JOIN',...
% % %  ' dbo.acquisition ON dbo.DICOMinfo.DICOM_ID = dbo.acquisition.DICOM_ID',...
% % %  ' WHERE (dbo.acquisition.machine_id = 46) AND (dbo.acquisition.film_identifier LIKE ''%Marsden_11-07-2012% '') AND (dbo.acquisition.patient_id = '' '')'];
% % % 
% % % patient_id=mxDatabase(Database.Name,SQLStatement);
load('e:\documents and settings\smalkov.RRCS\My Documents\patient_id.mat');

for index=1:length(patient_id(:,1))
     %name = char(file_dupl{index})
     %SQLStatement = ['SELECT * FROM dbo.DXAacq WHERE (rfilename lIKE ''', name(1:12), '''',')', ' AND (dxaacquisition_id > ', num2str(342), ') '];
     SQLStatement = ['update acquisition set patient_id =''',char(patient_id(index,2)),''' where acquisition_id = ',num2str(cell2mat(patient_id(index,1)))];
     a1 = mxDatabase(Database.Name,SQLStatement);
     SQLStatement = ['update acquisition set resolution = ',num2str(131),  '  where acquisition_id = ',num2str(cell2mat(patient_id(index,1)))];
     a2 = mxDatabase(Database.Name,SQLStatement);
    count = count + 1
end
  
     
      a = 1;
      
 