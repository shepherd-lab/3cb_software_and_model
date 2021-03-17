function dicominfo_fromdirectory()
    %global ctrl figuretodraw
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\';
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\png_files\';
    
   % dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\';
    dirname_toread = 'B:\DicomImagesBlinded(digi)';
    dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\CPMC\step_phantom\';
    
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\png_files\';
    file_names = dir(dirname_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
       for k = 3:lenf
         % try
            filename_read = file_names(k).name;
            fullfilename_read = [dirname_toread,filename_read];
            [pathstr,name,ext,versn] = fileparts(fullfilename_read);
            if strcmp(ext, '.mat') 
                count = count + 1;
               load(fullfilename_read);
                parameters{1} = info.KVP;
                parameters{2} = info.ExposureInAs;
                if strcmp(info.AnodeTargetMaterial,'MOLYBDENUM')&strcmp(info.AnodeTargetMaterial,'MOLYBDENUM')
                   parameters{3} = 1;
                else
                   parameters{3} = 2;
                end
                parameters{4} = info.BodyPartThickness; 
            end
            params(count,:) = cell2mat(parameters);
       end
       ;
       save([dirname_towrite,'selenia_digi.txt'],params, '-ascii');
  
  