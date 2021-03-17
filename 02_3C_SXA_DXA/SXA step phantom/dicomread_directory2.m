function dicomread_Site()
    global ctrl figuretodraw
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\';
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\7February\png_files\';
    
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\3August_BlankDXACalib\';
    
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\3August_BlankDXACalib\png_files\';
    dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\New_bars28Febr\';
    dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\New_bars28Febr\png_files\';
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
            index_dots = find(filename_read=='.');
            num = filename_read(index_dots(end-1)+1:index_dots(end)-1);
            fullfilename_read = [dirname_toread,filename_read];
            [pathstr,name,ext,versn] = fileparts(fullfilename_read);
            if ((strcmp(ext, '.dcm') | isempty(ext)) & ~isdir(name)  )
                info_dicom = dicominfo(fullfilename_read);
               % info_dicom_blinded = BlindDicomHeader(info_dicom);
               %
               comments = info_dicom.ImageComments; 
               index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
               index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
               index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
               if ~isempty(comments)
                filename_read = [comments, '.', num2str(num)];
               end
               %}
                %filename_read = comments(find(comments~=[]));
                
                %if isempty(ext)
                 % mat_filename=[dirname_towrite, filename_read, '.mat' ];
                 % png_filename=[dirname_towrite, filename_read, 'raw.png' ];
                
                %else %filename_read(1) == 'r' | filename_read(1) == 'R'
                if 1%filename_read(1) == 'r' | filename_read(1) == 'R' | filename_read(1) == 'L' | filename_read(1) == 'H'
                %if filename_read(1) == 'f'
                   mat_filename=[dirname_towrite, filename_read(1:end), 'raw.mat' ]; 
                   png_filename=[dirname_towrite, filename_read(1:end), 'raw.png' ]; 
                    
                   %mat_filename=[dirname_towrite, filename_read(1:end-4), '.mat' ]; 
                       %png_filename=[dirname_towrite, filename_read(1:end-4), 'raw.png' ];
                    %end  
                    save(mat_filename, 'info_dicom');
                   % 
                    XX = dicomread(fullfilename_read,'Raw', '1');
                    XX1=round(UnderSamplingN(XX,2));
                    clear XX;
                    %mmax = max(max(XX1))
                    %mmin = min(min(XX1))
                    %I = -log( XX1 /mmax )* 10000;

                    imwrite(uint16(XX1),png_filename,'PNG');
                    %delete(fullfilename_read);
                    %}
                    count = count + 1
                    %figure(figuretodraw);
                    set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
                end
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
   
  
  
  
  %mmax = max(max(XX1))
    %mmin = min(min(XX1))
    %I = -log( XX1 /mmax )* 10000;
    %mmax = max(max(I))
    %mmin = min(min(I))
    %{  
    XX1 = -log( XX /mmax );
    mmax1 = max(max(XX1))
    mmin1 = min(min(XX1))
    XX2 = XX1 * 10000;  
    mmax2 = max(max(XX2))
    mmin2 = min(min(XX2))
    %XX3 = XX2 - mmin2;
    %} 
    %figure;imagesc(I); colormap(gray);
  
    
   % parameters{1} = info.KVP;
   % parameters{2} = info.Exposure;
   % parameters{3} = info.ExposureControlMode;
   % parameters{4} = info.FilterMaterial;
   % parameters{5} = info.AnodeTargetMaterial;
   % parameters{6} = info.BodyPartThickness;
    %parameters{7} = info.ImageComments;
   % s = xlswrite('tempdata2.xls',parameters );
    %p = parameters
