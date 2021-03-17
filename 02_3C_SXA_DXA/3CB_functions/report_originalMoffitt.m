function [ output_args ] = report_original()
global patient_id view PowerPointData
dirname_toread = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3CB_maps_wo3CBorig';
file_names = dir(dirname_toread);
 sza = size(file_names);
 lenf = sza(1);
 pt = [];
 warning off;   
 CreateReport('NEW',1);
 try
  for k = 3:lenf
      filename_read = file_names(k).name;   
      patient_id = filename_read(1:7);
      view = filename_read(9:10);
      if str2num(patient_id(5:7)) > 0        
        CreateReport('MOFFITTIMAGES');
      end
  end
  
 catch
   pt  =  [pt;str2num(patient_id(5:7))] 
 end
 a = 1;
  save moff_notdone.txt pt -ascii;
end

