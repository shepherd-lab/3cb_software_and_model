function dream_python_pngcreationUCSF()
global Image Info

input_dir = 'C:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXA';

 dcm_files = dir(input_dir);
 len = length(dcm_files);
 %results = zeros(2,len-2);
 results = cell(len-1,5);
 results{1,1} ='patientId';
 results{1,2} = 'examIndex'; 
 results{1,3} = 'imageView'; 
 results{1,4} = 'imageIndex'; 
 results{1,5} = 'filename';
 
 for i = 3:len
    dicom_fname = [dcm_files(i).folder,'\',dcm_files(i).name];
    info_dicom = dicominfo(dicom_fname);
    results{i-1,1} = dcm_files(i).name(1:end-4);
    results{i-1,2} = 1;
    if ~isempty(findstr(dcm_files(i).name(end-5:end-4),'CC'))
       results{i-1,4} = 1;  
    else
       results{i-1,4} = 2; 
    end
    results{i-1,3} =info_dicom.ImageLaterality;
    results{i-1,5} = dcm_files(i).name;
    a= 1;
 end
  Excel('INIT');
  Excel('TRANSFERT',results);
a = 1;
end