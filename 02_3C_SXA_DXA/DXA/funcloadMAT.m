function mask=funcloadMAT(fname,Option)
global Result Info flag Image  MachineParams Analysis

Info.DICOMfile=0;  %default value for this flag
Info.Alfilter = true;


%%%%%%%%%% extraction of room name as global variable Info.centerlistactivated %%%%%%%%%%%%%%%


maxsignalDXA=2000;
mask=[];
if ~exist('Option', 'var')
    Option='NONE';
end
%initialization
%selenia DXA file
tempStruct=load(fname, 'imageData', 'headerInfo');
info_dicom=tempStruct.headerInfo;
info_dicom.PatientOrientation
info_dicom.ImageLaterality
if strcmp(info_dicom.PatientOrientation,'A\R') && strcmp(info_dicom.ImageLaterality,'L')
    tempStruct.imageData=flipud(fliplr(tempStruct.imageData));
end
Result.image=tempStruct.imageData;
room_name = info_dicom.StationName;
Info.Position = info_dicom.ViewPosition;
Info.Laterality = info_dicom.ImageLaterality;
Info.orientation = info_dicom.PatientOrientation;
if ~isempty(strfind(lower(info_dicom.ManufacturerModelName),lower('Selenia')))
    Info.DigitizerId = 4;
    Analysis.Filmresolution = 0.14;
else
    Info.DigitizerId = 4;
    Analysis.Filmresolution = 0.14;
end
if Info.Database == false
    if strcmp(room_name,'cpbmam1')
        Info.centerlistactivated = 1;
    elseif strcmp(room_name,'cpbmam2')
        Info.centerlistactivated = 2;
    elseif strcmp(room_name,'cpbmam3')
        Info.centerlistactivated = 3;
    elseif strcmp(room_name,'cpbmam4')
        Info.centerlistactivated = 4;
    elseif strcmp(room_name,'cpbmam5')
        Info.centerlistactivated = 5;
    elseif strcmp(room_name,'cpbmam6')
        Info.centerlistactivated = 6;
    elseif strcmp(room_name,'cpbmam7')
        Info.centerlistactivated = 7;
    elseif strcmp(room_name,'UCSF-ZM10')
        Info.centerlistactivated = 39; %116
    else
        Info.centerlistactivated = 39;  %if unknown 116
    end
else
    if Info.DigitizerId < 4
        MachineParams.dark_counts = 0;
    else
        RetrieveInDatabase('MACHINEPARAMETERS'); % for temporary
        % dark_counts =MachineParams.dark_counts;
    end
end
%what the heck is centerlist
if (Info.DigitizerId >= 4 | flag.Selenia_image == true) & flag.RawImage == false
    if Result.DXASelenia == true & Info.Database == false
        Info.kVp = info_dicom.KVP;
        Info.mAs = info_dicom.ExposureInuAs/1000;
        Info.thickness = info_dicom.BodyPartThickness;
        Info.comments = info_dicom.ImageComments;
        
        if Info.kVp < 38
            Info.kVpLE = info_dicom.KVP;
            Info.mAsLE = info_dicom.ExposureInuAs/1000;
        end
    end
    if isempty(Result.image)
        %used to be ~isempty, but that seemed silly
    else
        Result.image2 = Result.image;
    end
    max_image = max(max(Result.image2));
    min_image = min(min(Result.image2));
    flag.RawImage = false;
end
sz = size(Result.image2)
if length( Result.image2) > 2
    Result.image(1:sz(1),1:sz(2)) = Result.image2(:, :, 1);
end
if Result.flagHE
    Result.RST = Image.LE./(Result.image);
end
end

    