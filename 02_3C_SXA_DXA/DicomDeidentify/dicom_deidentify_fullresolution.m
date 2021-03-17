function params = dicominfo_fromdirectory()
    
   dirname_toread ='\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_decompressed\'; 
   dir_towrite = '\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_deidentified\';  
    file_names = dir(dirname_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
  
    for k = 3: lenf      
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);
        
        if (strcmp(lower(ext), '.dcm') | strcmp(ext, '')) &  ~isdir(fullfilename_read)
            
            count = count + 1;
            info_dicom = dicominfo(fullfilename_read);
            XX=dicomread(fullfilename_read);
            %              info_dicom.PatientName = '3CB_Pres';
            info_dicom.PatientName = 'DE-IDENTIFIED';
            info_dicom.PatientBirthDate = '20000101';
            info_dicom.PatientBirthTime = 'DE-IDENTIFIED';
            info_dicom.OtherPatientName = 'DE-IDENTIFIED';
            info_dicom.PatientAge = '16Y';
            info_dicom.NamesOfIntendedRecipientsOfResults ='DE-IDENTIFIED';
            info_dicom.AccessionNumber = 'DE-IDENTIFIED';  
             info_dicom.GantryID = [];
             info_dicom.RequestingPhysician = 'DE-IDENTIFIED';
             info_dicom.OtherPatientName = 'DE-IDENTIFIED';
             info_dicom.PatientID = 'DE-IDENTIFIED';
             info_dicom.ReferringPhysicianName = 'DE-IDENTIFIED';
             fname_deidentified = [dir_towrite,name,'_DEID',ext];
            dicomwrite(XX,fname_deidentified,info_dicom,'CreateMode','copy');
%              dos(['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe "', fname_deidentified,'"'],'-echo')
            count = count + 1            
        end
        
    end
     
      
%        dicomwrite(uint16(Image.image), [filename(1:end-4),'.dcm'], 'PatientID',PatientID,'StudyID',StudyID,'PatientOrientation',View);
%        save([dirname_towrite,'selenia_digi.txt'],params, '-ascii');%        
%       S = dicominfo('RS.dcm');

  
 