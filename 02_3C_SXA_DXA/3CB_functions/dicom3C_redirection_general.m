function dicom3C_redirection_general()
%Purpose - transfer DICOMs to UCSF_Dicoms folder 
%Input parameters - numerical patient number
global ctrl
  parentdir = uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\');          
  dirname_toread = parentdir;
   dirname_toread_png = [parentdir,'png_files'];
   dirname_toread_mat = [parentdir,'mat_files'];
   srtlist = fuf (parentdir ,1,'detail');
   
    sza = size(srtlist);
     count = 0;
     count2 = 0;
      count1 = 0;
    lenf = sza(1);
    warning off;    
    
       for k = 1:lenf
            filename_read =  char(srtlist(k));
            try
             info_dicom = dicominfo(filename_read);
             folder = [];              
           
%            if strcmp(info_dicom.PresentationIntentType, 'FOR PROCESSING')
              copyfile([filename_read],dirname_toread);  %,'_t1'
%             end

            catch
                count2 = count2 + 1
               continue;                
            end
             
      count = count + 1
                
       end    
end
  
   

