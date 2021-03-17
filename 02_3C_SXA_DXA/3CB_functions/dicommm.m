function [] = readAllDicomDirectory(pathFrom, pathToPng, pathToMat)

fullfilename_readPres = pathFrom;

listing = dir([fullfilename_readPres,'\*.dcm']);
listingStart = listing(1).name;
listingEnd = listing(end).name;
listingLen = length(listing);

for ii = 1:listingLen
    
info_dicom = dicominfo([fullfilename_readPres,'\',listing(ii).name])

name = info_dicom.StudyID
kvp = info_dicom.KVP;
viewType = info_dicom.ProtocolName;

png_filenamePng = [pathToPng,name,num2str(kvp),viewType]
png_filenameMat = [pathToMat,name,num2str(kvp),viewType]

save(png_filenameMat,'info_dicom')

%%
XX = dicomread(info_dicom);

XX1=round(downsample(XX,2)); % downsizing the image
clear XX;


imwrite(uint16(XX1),png_filenamePng,'PNG');
end