function info_dicom_blinded = BlindDicomHeader(info_dicom)

    info_dicom.PatientName = [];
     info_dicom.PatientBirthDate = [];
     info_dicom.PatientBirthTime = [];
     info_dicom.OtherPatientName = [];
     info_dicom.PatientAge = [];
     info_dicom.NamesOfIntendedRecipientsOfResults = []; 
     info_dicom.AccessionNumber = [];
     


     info_dicom_blinded = info_dicom;