function make_3Cdirs()
 for i= [202:250]
    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\'];
    patient_name = ['3C01',num2str(i,'%03.0f')];
    pat_dirname = [parentdir, patient_name];
     dirname_towritepngcut = 'png_files';
    dirname_towritematcut = 'mat_files';
    dirname_forprescut = 'ForPresentation';
    dirname_forpres = [pat_dirname,'\',dirname_forprescut];
    parentdir = [parentdir,patient_name];
    %actual making directories
%     mkdir(parentdir,patient_name);
%     mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
%     mkdir(parentdir,dirname_towritematcut);
%     mkdir(parentdir,dirname_forprescut);
%     mkdir(dirname_forpres,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
%     mkdir(dirname_forpres,dirname_towritematcut);
    a = 1
 end