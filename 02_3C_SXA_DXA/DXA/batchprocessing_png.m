parent = ('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\DXAGirls_Hawaii07\');
folder=dir(parent);
count=0;
for i=6:length(folder)
    fldname=folder(i).name;
    if size(fldname,2)==6
        parentdir=[parent fldname];
        convert_png;
        addHawaii_Images_V3;
        count=count+1
    end;
end;