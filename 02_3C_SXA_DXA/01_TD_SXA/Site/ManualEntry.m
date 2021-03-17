%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manual Entry of CPMC scans from dicom files  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% after a dicom file has been opened 
% use the dicom tag to fill the database pieces of onformation

%Lionel HERVE
%8-2-04
global f0 Image Info

Dicom.Database='eFilmDatabase';
Database.Name='mammo_CPMC';
RepositoryPath='d:\DicomImageToBlind\';
SOPInstanceUID=Info.DICOMinfo.SOPInstanceUID;
tempInfo=Info.DICOMinfo;
tempInfo.PatientOrientation;

%find the laterality
Laterality=tempInfo.ImageLaterality;
XX=round(UnderSamplingN(Image.image,3)*16);
filename=[SOPInstanceUID,'.dcm'];
SaveName=[filename,'.png'];
SaveFullName=['c:\',SaveName];
RepositoryFullName=[RepositoryPath,SaveName];
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

axes(f0.axisHandle);hold off;imagesc(XX); colormap (gray);

%fill acquisition in mammo database
clear field;
field(1)={'CPUCSFnotBlinded'};  %studyID
field(2)={num2str(Info.DICOMinfo.PatientID)};
field(3)={'1'};    %visit ID
field(4)={''};    %film identifier
AcquisitionDate=Info.DICOMinfo.ImageDate;
field(5)={num2str(AcquisitionDate)};
field(6)={'10'};   %CPMC machine ID
field(7)={LateralityID};   %Laterality
field(8)={'0'};   %mAs (Unknown)
field(9)={'0'};   %kVp  (Unknown)
field(10)={'3'};   %technique (Unknown)
field(11)={'6'};   %phantom (Unknown)
field(12)={'3'};   %digitizer (R2)
field(13)={'169'};
field(14)={'16'};
field(15)={date}; %digitization date
field(16)={RepositoryFullName}; 
[key,error]=funcaddinDatabase(Database,'acquisition',field);
if error
    display('ERROR in database entry');
end

%move the undersampled image to a directory to wait for blind 'DicomImageToBlind'
movefile(SaveFullName,RepositoryFullName);






