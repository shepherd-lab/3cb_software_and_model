function params = dicominfo_fromdirectory()
    %global ctrl figuretodraw
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\';
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\png_files\';
    %
   % dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\';
    dirname_toread = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Mayo Subtype Mammo\Analysis Code\Mammo Image for testing\dicom\44050\';
    dirname_towrite = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Mayo Subtype Mammo\Analysis Code\Mammo Image for testing\dicom\44050';
    % count = 0;
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\17July\png_files\';
  
    file_names = dir(dirname_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
  
    for k = 3: lenf
        %       % try
        %filename_read = '1.2.840.113681.2211300624.1852.3322153137.328.mat';
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,filename_read];
        [pathstr,name,ext,versn] = fileparts(fullfilename_read);
        if strcmp(ext, '.mat')
            count = count + 1;
            load(fullfilename_read);
            if isexist(info_dicom_blinded)
                parameters{1} = info_dicom_blinded.KVP;
                parameters{2} = info_dicom_blinded.ExposureInuAs;
                if strcmp(info_dicom_blinded.AnodeTargetMaterial,'MOLYBDENUM')&strcmp(info_dicom_blinded.FiterMaterial,'MOLYBDENUM')
                    parameters{3} = 1;
                else
                    parameters{3} = 2;
                end
                parameters{4} = info_dicom_blinded.BodyPartThickness;
            end
            params(count,:) = cell2mat(parameters);
            if count == 50
                c = count
            end
        end
    end ;
       save([dirname_towrite,'selenia_digi.txt'],params, '-ascii');
  
  