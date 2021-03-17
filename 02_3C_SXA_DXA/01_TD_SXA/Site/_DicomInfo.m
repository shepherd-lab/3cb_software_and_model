%dicom info
% open a file and put the info on the command window

[file,path]=uigetfile();
A=dicominfo([path,file]);