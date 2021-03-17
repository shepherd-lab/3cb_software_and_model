function Recalculate_3CAnalysis_UCSF()
 global Info X FreeForm flag
 FreeForm.FreeFormnumber = [];
 Info.study_3C = true;
 flag.MLO =true;
 flag.CC = true;
 init_pat = [];
 init_pat1 = [];
 init_pat2 = [];
 flag.spot_paddle = false;
 for ik=[92,107,180]
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
    patient_dir = [root_dir,'\', cur_dir,'\png_files\*.png'];
    file_names = dir(patient_dir);
      h1 = findobj('tag','hInit')
         if ~isempty(h1)
             for k = 1:length(h1)
                 delete(h1(k));
             end
         end
        
        h2 = findobj('tag','h_slope')
         if ~isempty(h2)
             for n = 1:length(h2)
                 delete(h2(n));
             end
         end
    for i=3:length(file_names)
%          hnd = get(0,'Children');
       
         fn = file_names(i).name
%         if  ~(~isempty(strfind(file_names(i).name,'LECC')) | ~isempty(strfind(file_names(i).name,'LEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
%             full_filenameLE = [root_dir,cur_dir,'\',file_names(i).name];
%         end
%         if  ~(~isempty(strfind(file_names(i).name,'HECC')) | ~isempty(strfind(file_names(i).name,'HEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
%             full_filenameHE = [root_dir,cur_dir,'\',file_names(i).name];
%         end
%         
%         if ~isempty(strfind(file_names(i).name,'LECC')) & ~isempty(strfind(file_names(i).name(end-2:end),'png')) &  ~(~isempty(strfind(file_names(i).name,'LEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig')))
%             full_filenameLE = [root_dir,cur_dir,'\',file_names(i).name];
%         end
        if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameLECC = [root_dir,cur_dir,'\png_files\',file_names(i).name];   
             view = file_names(i).name(3:4);
        end
        if  ~isempty(strfind(file_names(i).name,'LEML')) && ~( ~isempty(strfind(file_names(i).name,'LECC')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameLEML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
             view = file_names(i).name(3:4);
        end
        if  ~isempty(strfind(file_names(i).name,'HECC')) && ~( ~isempty(strfind(file_names(i).name,'HEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameHECC = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
          if  ~isempty(strfind(file_names(i).name,'HEML')) && ~( ~isempty(strfind(file_names(i).name,'HECC')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameHEML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
        
        if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) &  ( ~isempty(strfind(file_names(i).name,'Density8_0SXA')) | ~isempty(strfind(file_names(i).name,'Density8_1SXA')) &  ~isempty(strfind(file_names(i).name(end-2:end),'png')))
            full_filenameDensityCC = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
         
        if  ~isempty(strfind(file_names(i).name,'LEML')) && ~( ~isempty(strfind(file_names(i).name,'LECC')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) &  ( ~isempty(strfind(file_names(i).name,'Density8_0SXA')) | ~isempty(strfind(file_names(i).name,'Density8_1SXA')) &  ~isempty(strfind(file_names(i).name(end-2:end),'png')))
            full_filenameDensityML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
    end 
     
   catch
      init_pat = [init_pat;patient]
  end
    
   try
        if flag.CC == true      
            view = 'CC';
           annot_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
          lehe_fnames.LEfname =  full_filenameLECC; 
          lehe_fnames.HEfname =  full_filenameHECC; 
          lehe_fnames.mat_annotation = [annot_dir,patient,'_',view,'_annotation.mat'];
          lehe_fnames.Density = full_filenameDensityCC;
           calibration_type = 'Breast ZM10new';
           funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
            if ik <61  & ik ~= 59
              mat_thick = ['LE',view,'raw_Mat_v8.0.mat'];
            elseif  (ik >=61 & ik < 135) | ik == 59
              mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.0.mat']; 
             elseif  ik >=135 
              mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];   
            end
            lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];           
            Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
            update_3CResults_auto(lehe_fnames.Density,'ucsf');           
        end
     catch
      init_pat1 = [init_pat1;patient]
    end
        try
        if  flag.MLO == true   
            view = 'ML';
           lehe_fnames.LEfname =  full_filenameLEML; 
          lehe_fnames.HEfname =  full_filenameHEML; 
          lehe_fnames.Density = full_filenameDensityML;
         
          calibration_type = 'Breast ZM10new';
           funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
             if ik <61 & ik ~= 59
              mat_thick = ['LE',view,'raw_Mat_v8.1.mat'];
            elseif  ik >=61 | ik == 59
              mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];   
             end
           lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];
           Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
           update_3CResults_auto(lehe_fnames.Density,'ucsf');           
        end          
      
            a = 1;
        
   
catch
    init_pat2 = [init_pat2;patient]
end
  end
  a = 1;

