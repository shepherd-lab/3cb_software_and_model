function [cal_data, comment] = read_file(filename)
%filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01002\png_files\Calibration_3C01002_CC27kVp.txt';
FID=fopen(filename);
comment = fgetl(FID)
datacell = textscan(FID, '%f%f%f%f%f',  'CollectOutput', 1); %'HeaderLines', 1,
fclose(FID);
cal_data = datacell{1};
a = 1;

end

