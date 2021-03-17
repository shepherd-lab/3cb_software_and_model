fullfilename_readPres = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02213\1.2.826.0.1.3680043.2.135.735890.53688745.7.1498219501.609.81_0002_000003_1498219501005d.dcm'
png_filenamePres = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02213\png_files\LEML32raw.png'
png_filenameMat = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02213\png_files\LEML32raw.mat'

info_dicom = dicominfo(fullfilename_readPres)
save(png_filenameMat,'info_dicom')

%%
XX = dicomread(info_dicom);

XX1=round(UnderSamplingN(XX,2)); % downsizing the image
clear XX;


imwrite(uint16(XX1),png_filenamePres,'PNG');