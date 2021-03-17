%%%%%%%%%%%%%%%%%%%%%%%%%
% read the table Image  %
%%%%%%%%%%%%%%%%%%%%%%%%%
% version that use  Matlab's dicomread and Dicominfo
% need to add the entry (0048,1350) in the dicom dictionary
% if error happens (x3), reboot itself automatically
% do the undersampling during the night
% check the patient ID; if it is '111111111' undersample all the images
% (and not just CC viewa)
global SOPInstanceUIDList
global Database
Database.Name='mammo';
RepositoryPath='d:\DicomImageToBlind\';

if (size(SOPInstanceUIDList,1)>0)
    SOPInstanceUID=cell2mat(SOPInstanceUIDList(1));
        
    %find the file location
    [Path1stPart]=cell2mat(mxDatabase(Dicom.Database,['select StudyInstanceUID from Image where SOPInstanceUID=''',SOPInstanceUID,'''']));
    [Path2ndPart]=cell2mat(mxDatabase(Dicom.Database,['select SeriesInstanceUID from Image where SOPInstanceUID=''',SOPInstanceUID,'''']));
    path=['d:\dicomImages\',Path1stPart,'\',Path2ndPart];
    filename=[SOPInstanceUID,'.dcm'];
    fullname=[path,'\',filename];
        
    %read the header (use modified dictionary)
    tempInfo=dicominfo(fullname,'dictionary','dicom-dict.txt');
    AcquisitionDate=cell2mat(mxDatabase(Dicom.Database,['select imageDate from Image where SOPInstanceUID=''',SOPInstanceUID,'''']));    

    %the image must be RCC or LCC to be processed. The other are erazed!
    PatientID=cell2mat(mxDatabase(Dicom.Database,['select PatientID from Image where SOPInstanceUID=''',SOPInstanceUID,'''']));
    SaveName=[filename,'.png'];
    SaveFullName=[path,'\',SaveName];
    RepositoryFullName=[RepositoryPath,SaveName];
             
        
    if strcmp(deblank(PatientID),'111111111111')|(strcmp(tempInfo.PatientOrientation,'A\R')|strcmp(tempInfo.PatientOrientation,'P\L'))
        %find the laterality 
        Laterality=tempInfo.ImageLaterality
            
        XX=round(UnderSamplingN(dicomread(fullname,'dictionary','dicom-dict.txt'),3)*16);
        if strcmp(Laterality,'R')
            XX=rot90(rot90(XX));
            LateralityID='2';
        else
            LateralityID='3';
        end
        if FlipOrNotFlip(XX);
            XX=flipdim(XX,1);
        end
            
        imwrite(uint16(XX),SaveFullName,'PNG');
            
        axes(f0.axisHandle);imagesc(XX); colormap (gray);
        figure(CPMC.figure);
            
        %fill acquisition in mammo database
        clear field;                
        field(1)={'CPUCSFnotBlinded'};  %studyID
        field(2)={num2str(PatientID)};
        field(3)={'1'};    %visit ID
        field(4)={num2str(tempInfo.PatientsName.FamilyName)};    %film identifier
        field(5)={num2str(AcquisitionDate)};
        field(6)={'10'};   %CPMC machine ID
        field(7)={LateralityID};   %Laterality
        field(8)={'0'};   %mAs (Unknown)
        field(9)={'0'};   %kVp  (Unknown)  
        field(10)={'3'};   %technique (Unknown)
        field(11)={'6'};   %phantom (version4)
        field(12)={'3'};   %digitizer (R2)    
        PixelSpacing=str2num(cell2mat(mxDatabase(Dicom.Database,['select PixelSpacingRow from Image where SOPInstanceUID=''',SOPInstanceUID,''''])));
        field(13)={num2str(round(25.4/PixelSpacing/3))};
        Depth=cell2mat(mxDatabase(Dicom.Database,['select BitsAllocated from Image where SOPInstanceUID=''',SOPInstanceUID,'''']));
        field(14)={num2str(Depth)};
        field(15)={date}; %digitization date
        field(16)={RepositoryFullName}; %filename
        field(17)={'0'}; %thickness
        field(18)={'0'}; %force
        [key,error]=funcaddinDatabase(Database,'acquisition',field);
        if error
            display('ERROR in database entry');
        end
      
        %move the undersampled image to a directory to wait for blind 'DicomImageToBlind'
        movefile(SaveFullName,RepositoryFullName);
      
        
    end       
    
    %check if the barcode has been recycled 
    %erase previous scan from disk and from database

    
     %put the new scan in the R2 database
        clear field;
        field(1)={num2str(tempInfo.PatientsName.FamilyName)};
        field(2)={num2str(PatientID)};
        field(3)={'WAITING'};
        field(4)={num2str(AcquisitionDate)};
        field(5)={funcEndFileName(fullname)};
        [key,error]=funcaddinDatabase(Database,'FileOnInternalDrive',field);
        
        %move Original Dicom in the 'Root' directory
        movefile(fullname,'d:\DicomImages\');
        
        %check if the current directory is empty 
        %if yes, delete it 
        [name,filepath]=funcEndFileName(fullname);
        DirResult=dir (filepath);NumberOfFile=size(DirResult,1)-2;
        if NumberOfFile==0
            rmdir(filepath);
        end
        
        %check if the parent directory is empty 
        %if yes delete it
        [name,filepath]=funcEndFileName(filepath);
        DirResult=dir (filepath);NumberOfFile=size(DirResult,1)-2;
        if NumberOfFile==0
            rmdir(filepath);
        end
    
    
    %delete the entry in eFilm Database
    mxDatabase(Dicom.Database,['delete from Image where SOPInstanceUID=''',SOPInstanceUID,'''']);

end


