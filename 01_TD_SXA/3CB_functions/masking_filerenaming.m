function masking_MGHset()
    
%     dir_towrite = '\\researchstg\aaData\Breast Studies\Masking\Masking_fullresolutions\MGH\';
%     dir_toread = '\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_deidentified\';
%     dir_towrite_mat = '\\researchstg\aaData\Breast Studies\Masking\Masking_fullresolutions\MGH\mat_files\';
     count = 0;
     count2=0;
    Database.Name = 'mammo_CPMC';
    %%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%
    dir_toread = '\\researchstg\aaData\Breast Studies\Masking\Masking_diag_last\CPMC\Old_files\';
    
    file_names = dir(dir_toread);
     sza = size(file_names);
     count = 0;
    lenf = sza(1);
    warning off;
   
    interval_acqs = load('\\researchstg\aaData\Breast Studies\Masking\txt_excels\cpmc_masking.txt');
    ScreenDetected = load('\\researchstg\aaData\Breast Studies\Masking\txt_excels\masking_diag_last_cpmc.txt');
    interval_acqs = '\\researchstg\aadata\Breast Studies\Masking\PrelimAnalysis\Interval\';
    ScreenDetected = '\\aadata\Breast Studies\Masking\PrelimAnalysis\ScreenDetected\';
     
    
    for k = 3: lenf
        filename_read = file_names(k).name;
        fullfilename_read = [dir_toread,filename_read];
%         fullfilename_read = '\\researchstg\aaData\Breast Studies\Masking\Masking_diag_last\CPMC\Old_files\00279280_20111027RCC.mat';
        
        if  ~isdir(fullfilename_read)
            [pathstr,name,ext] = fileparts(fullfilename_read);
            
            if  ~isempty(strfind(ext,'mat'))
                load(fullfilename_read,'info_dicom_blinded');
                delete(fullfilename_read);
                save(fullfilename_read,'info_dicom_blinded');
            end
            
            patient_id = name(1:8);
            date_acquisition = name(10:17);
            if ~isempty(strfind(name,'LCC'))
                view_id = 3;
            elseif ~isempty(strfind(name,'RCC'))
                view_id = 2;
            elseif ~isempty(strfind(name,'LML'))
                view_id = 5;
            elseif ~isempty(strfind(name,'RML'))
                view_id = 4;
            else
                view_id = 1;
            end
            
            SQLStatement = ['SELECT acquisition_id FROM acquisition  WHERE patient_id like ''%',num2str(patient_id),'%''  and  date_acquisition like ''%',num2str(date_acquisition),'%'' and view_id =',num2str(view_id), ' order by acquisition_id'];
            a1 =mxDatabase(Database.Name,SQLStatement);
            acq_id = a1(end,:);
            acquisition_id = num2str(cell2mat(acq_id));
            
            new_filename = [pathstr,'\', acquisition_id,ext]; %,name(9:end)
             movefile(fullfilename_read,new_filename);
%             copyfile(fullfilename_read,new_filename);
            count = count + 1
        end
        a = 1;
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
           
