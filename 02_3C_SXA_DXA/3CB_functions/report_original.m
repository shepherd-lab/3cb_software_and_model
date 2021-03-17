function [ output_args ] = report_original(center)
global patient_id
dirname_toread = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3CB_maps_wo3CBorig';
file_names = dir(dirname_toread);
 sza = size(file_names);
 lenf = sza(1);
 warning off;   
 try
  for k = 3:lenf
   filename_read = file_names(k).name;
   patient_id = filename_read(1:7);
   CreateReport('MOFFITTIMAGES');
  end
  
 catch
   pt  =  patient_id 
 end

end

