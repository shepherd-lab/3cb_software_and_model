function params = dicominfo_fromdirectory()
    %global ctrl figuretodraw
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\';
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\png_files\';
    %
   % dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\';
%     dirname_toread = '\\researchstg\aaData\Breast Studies\3C_data\3CB_fromMyResearch\DICOMS\';   
    dirname_root = '\\researchstg\aaData\Breast Studies\3C_data\ConvertIntoPresentation\';
%     dirname_towrite = '\\researchstg\aaData\Breast Studies\3C_data\3CB_fromMyResearch\DICOMS';
    % count = 0;
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\png_files\';
  dirname_toread = [dirname_root,'DICOM_forprocessing\'];
    file_names = dir(dirname_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
  
    for k = 3: 5
       
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);
        
        if (strcmp(lower(ext), '.dcm') | strcmp(ext, '')) &  ~isdir(fullfilename_read)
            
            count = count + 1;
            info_dicom = dicominfo(fullfilename_read);
            XX=dicomread(fullfilename_read);
%              info_dicom.PatientName = '3CB_Pres';
            info_dicom.PatientBirthDate = '19800101';
            filename_mod  = [dirname_root,'DICOM_forpresentation\',name,'_mod3',ext]
            dicomwrite(XX,filename_mod,info_dicom,'CreateMode','copy');
            count = count + 1
           
        end
        
    end
     
      
%        dicomwrite(uint16(Image.image), [filename(1:end-4),'.dcm'], 'PatientID',PatientID,'StudyID',StudyID,'PatientOrientation',View);
%        save([dirname_towrite,'selenia_digi.txt'],params, '-ascii');%        
%       S = dicominfo('RS.dcm');

  
 