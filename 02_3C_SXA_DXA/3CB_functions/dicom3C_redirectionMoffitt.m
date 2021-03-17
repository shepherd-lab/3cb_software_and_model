function dicom3C_redirectionMoffitt(first,last )
   
for i=first:last
     
    dirname_toread = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_DICOMs\3C-02-',num2str(i,'%03.0f')];
    dirname_towrite = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02',num2str(i,'%03.0f')];
    copyfile(dirname_toread,dirname_towrite,'f');

end

