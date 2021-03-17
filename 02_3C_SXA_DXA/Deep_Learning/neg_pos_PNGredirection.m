function pilot_conversion()
 global Image  Info Analysis Result ctrl
 
 Analysis.PhantomID = 9;
 Info.study_3C = true;
 Result.DXASelenia = false;
  numrows = 1152;
 numcols = 896;
 init_pat = [];
 count = 0;
  xls_name = 'F:\Dream_contest2\Training_1\training_files\malignant_filenames.xlsx';
  [num,txt,raw] = xlsread(xls_name);
  input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXA';      %DICOMS_3CBraw';
  output_pos_dir = 'F:\Dream_contest2\Training_Li\end2end-all-conv-master\full_test_1152x896\pos\';
  output_neg_dir = 'F:\Dream_contest2\Training_Li\end2end-all-conv-master\full_test_1152x896\neg\';
    file_names = dir(input_dir);
    for i=3:length(file_names)   
          cur_name = file_names(i).name;          
          full_filename = [input_dir,'\',cur_name];
           if ~isdir(full_filename) & isdicom(full_filename)  %((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )                          
%                ind = cell2mat(strfind(txt,file_names(i).name(1:end-4)));
                 ind = find(contains(txt,file_names(i).name(1:end-4)));
                 image=double(dicomread(full_filename));
                 image2 = imresize(image,[numrows numcols]);
                 if ~isempty(ind)    
                  if num(ind) == 1
                    png_fname = [output_pos_dir,file_names(i).name(1:end-4),'.png'];
                    imwrite(uint16(image2),png_fname);                   
                    count = count + 1
                  else
                    png_fname = [output_neg_dir,file_names(i).name(1:end-4),'.png'];
                    imwrite(uint16(image2),png_fname);    
                    count = count + 1  
                  end
              else
               init_pat = [init_pat;file_names(i).name]
               end
           end         
    end



