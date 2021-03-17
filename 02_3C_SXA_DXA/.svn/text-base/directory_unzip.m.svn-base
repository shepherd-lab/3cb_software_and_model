function directory_unzip()
    dirname_toread = 'E:\Dicom\';
    dirname_towrite = 'D:\DicomImages\Bo_files\';
    %dirname_toread = 'P:\Dicom Images\Calibration\mat_files\';
    %dirname_towrite = 'P:\Dicom Images\Calibration\mat_files\SE2';
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
             if strcmp(ext, '.zip') | strcmp(ext, '.gz')
                 gunzip2(fullfilename_read,dirname_towrite)
                     
             else
                if  ~isdir(fullfilename_read)
                  %delete(fullfilename_read);
                end
            end
         %  catch
          %     set(ctrl.text_zone,'String',['Error in image',filename_read]);
          %     k = k + 1;
          % end
        end
   