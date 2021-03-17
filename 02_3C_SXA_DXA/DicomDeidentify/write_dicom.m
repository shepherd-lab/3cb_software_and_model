function write_dicom()
[imageFile,imagePath]=uigetfile('.tif','Please select image file');
if isnumeric(imageFile)
    return
end
[matFile,matPath]=uigetfile('.mat','Please select mat file');
if isnumeric(matFile)
    return
end
imageData=imread(fullfile(imagePath,imageFile));
tempStruct=load(fullfile(matPath,matFile),'info_dicom');
[dicomFile,dicomPath]=uiputfile('.dcm','Please choose location for dicom file');
info_dicom=tempStruct.info_dicom;
dicomwrite(imageData,fullfile(dicomPath,dicomFile),info_dicom,'CreateMode','copy');
end