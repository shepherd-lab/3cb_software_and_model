%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Blind Tag Tool for CPMC project    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lionel HERVE  3-30-03
% version that use  Matlab's dicomread and Dicominfo
% need to add the entry (0048,1350) in the dicom dictionary
global Analysis Info f0 ctrl 

figure (f0.handle)
%addpath('..\functions');
Dicom.Database='eFilmDatabase';
Database.Name='mammo_cpmc';
DestinatitionPath='d:\DicomImageblinded\';

while (1)
    %check if there are some files in RepositoryPath
    AcquisitionIDList=mxDatabase(Database.Name,'select acquisition_id,patient_id from acquisition where study_id=''CPUCSFnotBlinded''');
    SIZE=size(AcquisitionIDList,1);
    if SIZE==0      %an empty directory as '.' and '..' files
       %otherwise breask
        break
    end
    
    %Open it
    fullname=cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=''',num2str(cell2mat(AcquisitionIDList(1,1))),'''']));
    Info.AcquisitionKey=cell2mat(AcquisitionIDList(1,1));        
    PatientID=cell2mat(AcquisitionIDList(1,2));
    RetrieveInDatabase('ACQUISITION');
    
    set(ctrl.text_zone,'string',num2str(SIZE));
    
    %Ask the operator to blind the Tag
    AutomaticAttemptOn=true; %Don't blind if the image is a reference image
    if strcmp(deblank(PatientID),'111111111111')
        TagImageBlinded=true;
    else
        TagImageBlinded=false;
    end
    while ~TagImageBlinded 
        TagImageBlinded=blindtag(AutomaticAttemptOn); %after this operation, the file is replaced by the blind image.
        AutomaticAttemptOn=false;
    end
 
    %move the blinded image in DestinatitionPath
    NewFileName=[DestinatitionPath,Analysis.filename];
    movefile(fullname,NewFileName);
    
    %modify the filename in the database
    mxDatabase(Database.Name,['update acquisition set study_id=''CPUCSF'' where acquisition_id=''',num2str(cell2mat(AcquisitionIDList(1,1))),'''']);  %study CPUCSFnotBlinded  --> CPUCSF
    mxDatabase(Database.Name,['update acquisition set filename=''',NewFileName,''' where acquisition_id=''',num2str(cell2mat(AcquisitionIDList(1,1))),'''']);  %filename 
end
