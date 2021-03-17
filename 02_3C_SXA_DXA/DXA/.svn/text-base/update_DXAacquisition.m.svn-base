function update_DXAacquisition()
  Database.Name = 'mammo_DXA'; 
 dxa_data = textread('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\dxa_filed.txt', '%s');
 
 pat_id =   char(dxa_data) 
 patient_id = pat_id(1,:);
 file_name = pat_id(2,:);

 
%for 
    mxDatabase(Database.Name,['update acquisition set Calibration_filename=''',file_name,''' where patient_id=',patient_id]);
%end
% mxDatabase(Database.Name,['update acquisition set phantom_id=''',num2str(Analysis.PhantomID),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
a =1;
