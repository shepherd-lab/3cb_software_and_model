function dicom_3C_CDupload()
   parentdir = uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\');
   dirname_toread = parentdir;
   for pn = 1:200  
       numI = num2str(pn, '%03i');
       parentfolder = '3C01';
        mkdir(dirname_toread,strcat(parentfolder,num2str(numI)));
        parentdir = [dirname_toread, '\',strcat(parentfolder,num2str(numI))];
        dirname_towritepngcut = '\png_files';
        dirname_towritematcut = '\mat_files';
        dirname_forprescut = '\ForPresentation';
        dirname_forpres = [parentdir,dirname_forprescut];

        mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
        mkdir(parentdir,dirname_towritematcut);
         mkdir(parentdir,dirname_forprescut);

        mkdir(dirname_forpres,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
        mkdir(dirname_forpres,dirname_towritematcut);
    end
   
    
 
     
   