function Automatic3CAnalysis()
 global Info X FreeForm flag

 for ik=[1]
%       for i=[164:164] 
 try
  root_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
   pat_dirs = dir(root_dir);
%    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\3C01',num2str(i,'%03.0f')];
  patient = ['3C01',num2str(ik,'%03.0f')];
  sz_dirs = size(pat_dirs);
  patient_dir = [];
    for ii=1:length(pat_dirs)
       if ~isempty(strfind(pat_dirs(ii).name,patient))
           cur_dir = pat_dirs(ii).name;
           break;
       end
    end
    if isempty(cur_dir)
        break;
    end
    patient_dir = [root_dir,'\', cur_dir,'DCM*.png'];
    file_names = dir(patient_dir);
    
    for i=3:length(file_names)
%          hnd = get(0,'Children');
      if  ~isempty(strfind(file_names(i).name,'LECC'))
         dicom_3CBdeidentify(dicom_file);
      end   
        
    if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameLECC = [root_dir,cur_dir,'\png_files\',file_names(i).name];   
  
      end    
   
catch
    init_pat2 = [init_pat2;patient]
end
  end
  a = 1;

