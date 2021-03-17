function dicom_decompressed()
%Purpose - transfer DICOMs to UCSF_Dicoms folder 
%Input parameters - numerical patient number
global ctrl
%   parentdir = uigetdir('\\researchstg\R:\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM');
   parentdir ='\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM'; 
   dir_towrite = '\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_decompressed\';  
     srtlist = fuf (parentdir ,1,'detail');
%    srtlist = dir(parentdir);
      sza = size(srtlist);
     count = 0;
     count2 = 0;
      count1 = 0;
    lenf = sza(1);
    warning off;
     
    
  
                
           for k = 1:lenf
             count = count + 1   
            fname_compressed =  char(srtlist(k));
            [pathstr,name,ext] = fileparts(fname_compressed);  
            fname_decompressed = [dir_towrite,name,'_',num2str(count),ext];
            try
%              dcmdjpeg [options] dcmfile-in dcmfile-out  
             dos(['C:\dcmtk-3.6.0-win32-i386\bin\dcmdjpeg.exe "', fname_compressed,'" "',fname_decompressed,'"'],'-echo')
                    
            catch
                fname_no = [fname_no,fname_compressed];
               continue;                
            end
                         
           end
    
       a = 1;      
     
       end      
       

