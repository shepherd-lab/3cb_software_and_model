[fileName,pathName]=uigetfile('','Please select dicom file for conversion', 'MultiSelect','on');
dirName=uigetdir('*.*','Please select location for tiff file');
for i=1:numel(fileName)
    dicomImage=dicomread(fullfile(pathName,fileName{i}));
    imwrite(dicomImage,fullfile(dirName,[fileName{i},'.tif']),'tif');
    imwrite(dicomImage,fullfile(dirName,[fileName{i},'.png']),'png');
    imwrite(double(dicomImage),fullfile(dirName,[fileName{i},'.bmp']),'bmp');
    info_dicom=BlindDicomHeader(dicominfo(fullfile(pathName,fileName{i})));
    save(fullfile(dirName,fileName{i}), 'info_dicom');
end