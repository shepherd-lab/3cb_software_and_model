function    dicom_3CBdeidentify(dicom_file)
            info_dicom = dicominfo(dicom_file);
            XX=dicomread(dicom_file);
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
            %dicom_fileDeid = [dir_towrite,name,'_DEID',ext];
            dicomwrite(XX,dicom_file,info_dicom,'CreateMode','copy');
%             figure;imagesc(XX);colormap(gray);
%             XX2=dicomread(dicom_file);
%             figure;imagesc(XX2);colormap(gray);
            %dos(['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe "', dicom_file,'"'],'-echo')               
    end

  
 