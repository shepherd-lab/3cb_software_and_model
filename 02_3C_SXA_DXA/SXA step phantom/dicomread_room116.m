function dicomread_room116()
    global ctrl figuretodraw
    dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\18May\';
    dirname_towrite = dirname_toread;  %'D:\DicomImageBlinded\';
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
            if strcmp(ext, '.dcm')
                info_dicom_blinded = dicominfo(fullfilename_read);
               % info_dicom_blinded = BlindDicomHeader(info_dicom);
                mat_filename=[dirname_towrite, filename_read(1:end-4), '.mat' ];
                save(mat_filename, 'info_dicom_blinded');
                XX = dicomread(fullfilename_read,'Raw', '1');
                XX1=round(UnderSamplingN(XX,2));
                clear XX;
                %mmax = max(max(XX1))
                %mmin = min(min(XX1))
                %I = -log( XX1 /mmax )* 10000;
                png_filename=[dirname_towrite, filename_read(1:end-4), 'raw.png' ];
                imwrite(uint16(XX1),png_filename,'PNG');
                delete(fullfilename_read);
                count = count + 1
                %figure(figuretodraw);
                set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
            else
                if  ~isdir(fullfilename_read)
                  delete(fullfilename_read);
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
