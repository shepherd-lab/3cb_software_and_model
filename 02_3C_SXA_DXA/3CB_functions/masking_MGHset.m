function masking_MGHset()
    
    dir_towrite = '\\researchstg\aaData\Breast Studies\Masking\Masking_fullresolutions\MGH\';
    dir_toread = '\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_deidentified\';
    dir_towrite_mat = '\\researchstg\aaData\Breast Studies\Masking\Masking_fullresolutions\MGH\mat_files\';
     count = 0;
     count2=0;
  
    %%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%
     file_names = dir(dir_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
  
    for k = 3: lenf
       
        filename_read = file_names(k).name;
        fullfilename_read = [dir_toread,filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);
        if (strcmp(lower(ext), '.dcm') | strcmp(ext, '')) &  ~isdir(fullfilename_read)           
           
            info_dicom = dicominfo(fullfilename_read);
            mat_filename=[dir_towrite_mat, name, '.mat' ];
            png_filename=[dir_towrite, name, '.png' ];
            save(mat_filename, 'info_dicom');
            XX = dicomread(info_dicom);  
            imwrite(uint16(XX),png_filename,'PNG');
            count = count + 1   
        end
    end
            
            
%      
%     
%     [pathstr,name,ext] = fileparts(fname); 
%    
%          
%     copyfile(fname,dir_towrite);  
%     fname_old = [dir_towrite,name,ext];
%     fname_new = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,ext];
%     copyfile([fname(1:end-7),'.mat'],dir_towrite);
%     movefile( fname_old, fname_new);
%     fname_oldm = [dir_towrite,name(1:end-3),'.mat'];
%     fname_newm = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'.mat'];
%     movefile( fname_oldm, fname_newm);
%     load(fname_newm);
%     info_dicom_blinded.AccessionNumber = key;
% %     save(fname_newm);
%      save(fname_newm,'info_dicom_blinded');
%     
%      %%%presentation
%      
%      
%      
%     [pathstr,name,ext] = fileparts(pres_filename); 
%     copyfile(pres_filename,dir_towrite_pres);  
%     fname_old = [dir_towrite_pres,'\',name,ext];
%     fname_new = [dir_towrite_pres,'\',strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'_pres',ext];
%     copyfile([pres_filename(1:end-12),'.mat'],dir_towrite_pres);
%     movefile( fname_old, fname_new);
%     fname_oldm = [dir_towrite_pres,'\',name(1:end-8),'.mat'];
%     fname_newm = [dir_towrite_pres,'\',strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'_pres','.mat'];
%     movefile( fname_oldm, fname_newm);
%     load(fname_newm);
%     info_dicom_blinded.AccessionNumber = key;
% %     save(fname_newm);
%     save(fname_newm,'info_dicom_blinded');
%     
%     count = count + 1
%         catch
%            key = [key; Info.AcquisitionKey];
%            count2 = count2 + 1
%         end
%     end
%         try
%       Excel('INIT');
%     Excel('TRANSFERT',key);
%     catch
%     a = 1;
%      end
%     a = 1;
%     
%                fname_deidentified = [dir_towrite,name,'_DEID',ext];
%     if Info.ViewId  == 2
%         view_str = 'RCC';
%     elseif Info.ViewId  == 3
%         view_str = 'LCC';
%     elseif Info.ViewId  == 4
%         view_str = 'RML0';
%     elseif Info.ViewId  == 5
%         view_str = 'LMLO';
%     end
%     
%     
%        
% %%%%        creation names for saving mat and png files
%            mode = info_dicom.ExposureControlMode;
%            thickness = info_dicom.BodyPartThickness;
%            paddle = uint8(info_dicom.Private_0019_1026);
%            kvp = info_dicom.KVP;
%            view = info_dicom.ViewPosition;
% % % %            mas = info_dicom.ExposureInuAs/1000;
%             if isfield(info_dicom,'ExposureInuAs')
%                 mas = info_dicom.ExposureInuAs/1000;
%            else
%                mas = info_dicom.ExposureinuAs/1000;
%            end
% % %                  
%         file_short2 = [];
%       if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
%             file_short = ['LECC',num2str(kvp),'_orig'];
%             file_short2 = [patient_name,'_CC_orig'];
%              count2 = count2 + 1
%       elseif (strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER'))
%             file_short = ['LEML',num2str(kvp),'_orig'];
%             file_short2 = [patient_name,'_ML_orig'];
%       else
%                 continue;     
% 
%         end
           
