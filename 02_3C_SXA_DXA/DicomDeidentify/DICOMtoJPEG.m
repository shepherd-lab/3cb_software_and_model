[fileName,pathName]=uigetfile('','Please select dicom file for conversion', 'MultiSelect','on');
for i=1:numel(fileName)
    dicomImage=dicomread(fullfile(pathName,fileName{i}));    
    info_dicom=BlindDicomHeader(dicominfo(fullfile(pathName,fileName{i})));
    niceName=name_3C(info_dicom);
    if info_dicom.KVP == 39
        continue;
    end
    imwrite(imadjust(1-im2double((dicomImage))),fullfile(pathName,niceName),'bmp');
end