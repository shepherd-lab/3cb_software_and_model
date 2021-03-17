function funcMenuOpenImage(Option)
% Load Lumisys Files
% This file will load the acquisition files.

%revision history:
%4-01-03 compatible now with my own farmat : .mat
%4-25-03 accept .tiff and .bmp
global file Info flag

if ~exist('Option', 'var')
    Option='NULL';
end

savFilePath=file.startpath;
flag.FileFromDatabase=false;
[FileName,file.startpath] = uigetfile(strcat(file.startpath,'*.*'));
if FileName~=0
    fname = [file.startpath,FileName];
    file.fname = fname;
    fid = fopen(fname,'r','b');
    if fid~=-1
        fclose(fid);
        Info.AcquisitionKey=0;  %to prevent from a new loaded image
        funcOpenImage(fname,Option);
    else
        fclose(fid);
        file.startpath=savFilePath;
    end
else
    file.startpath=savFilePath;
end
end