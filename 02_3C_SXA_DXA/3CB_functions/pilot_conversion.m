function pilot_conversion()
 global Image  Info Analysis
 
 Analysis.PhantomID = 9;
 Info.study_3C = true;
 init_pat = [];
 annot_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
 annot_dir_mat = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\mat_files';
  for ik=[1:52]
%       for i=[164:164] 
 try
  root_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\';
   pat_dirs = dir(root_dir);
%    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\3C01',num2str(i,'%03.0f')];
  patient = ['3CB',num2str(ik,'%03.0f')];
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
    patient_dir = [root_dir,'\', cur_dir];
    file_names = dir(patient_dir);
    for i=3:length(file_names)
%          hnd = get(0,'Children');
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
        if  ~(~isempty(strfind(lower(file_names(i).name),'39kv')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'CP'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filename = [root_dir,cur_dir,'\',file_names(i).name];
            full_filename_mat = [full_filename(1:end-4),'.mat'];
            funcOpenImage(full_filename,1);
%             PhantomDetection;
            ROIDetection('ROOT');
            SkinDetection('FROMGUI');
%             Periphery_calculation; 
            tophatFiltered = TOPHAT();
            image_pres = deflip_image(tophatFiltered);
            if ~isempty(strfind(file_names(i).name,'CC'))
                pres_filename = [root_dir,patient,'_CC.png'];
            elseif ~isempty(strfind(file_names(i).name,'ML'))
                pres_filename = [root_dir,patient,'_ML.png'];
            else
                 break;
            end    
                pres_filename_mat = [pres_filename(1:end-4),'.mat'];
                imwrite(uint16(image_pres),pres_filename,'PNG');
%                 copyfile(full_filename_mat,root_dir);
                copyfile(pres_filename,annot_dir);
                copyfile(full_filename_mat,root_dir);
                old_matname = [root_dir,file_names(i).name(1:end-4),'.mat'];
                movefile(old_matname, pres_filename_mat);
                copyfile(pres_filename_mat,annot_dir_mat);
                
            a = 1;
        end
    end
catch
    init_pat = [init_pat;patient]
end
  end
  a = 1;
  


