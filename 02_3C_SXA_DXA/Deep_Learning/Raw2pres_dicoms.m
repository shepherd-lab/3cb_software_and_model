function raw2pres_dicom()
 global Image  Info Analysis Result ctrl
 
 Analysis.PhantomID = 9;
 Info.study_3C = true;
 Result.DXASelenia = false;
  numrows = 1152;
 numcols = 832;
 init_pat = [];
 count = 0;
 
%  input_dir = '\\researchstg\aaStudies\Breast Studies\UCSF-GE Collaboration\GE_reconstruction\Projections';
%  output_dir = '\\researchstg\aaStudies\Breast Studies\UCSF-GE Collaboration\GE_reconstruction\Projections_presentation';
%  input_dir = 'Z:\Breast Studies\3C_data\RO1_3Cimages\UCSF\Upenn_dual\png_files\Projections';
%  output_dir = 'Z:\Breast Studies\3C_data\RO1_3Cimages\UCSF\Upenn_dual\png_files\Projections_presentation';
 
  input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\Temp';      %DICOMS_3CBraw';
  output_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApngfromraw\';
    file_names = dir(input_dir);
    for i=3:length(file_names)
        try
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
        
          full_filename = [input_dir,'\',file_names(i).name];
           if ~isdir(full_filename) & isdicom(full_filename)    %((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
           info_dicom = dicominfo(full_filename);
           mode2 = info_dicom.ExposureControlMode;
           Info.view = info_dicom.ViewPosition;
           Info.kVp = info_dicom.KVP;
          
           if isfield(info_dicom,'ExposureInuAs')
                Info.mAs = info_dicom.ExposureInuAs/1000;
           else
               Info.mAs = info_dicom.ExposureinuAs/1000;
            end
           %file_short = 'LECC';
%            if ~(~isempty(strfind(info_dicom.PatientID,'DE-IDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'DEIDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'3C11')))
%                dicom_3CBdeidentify(full_filename);
% %                     mat_filenamePres=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];                       
% %                     save(mat_filenamePres, 'info_dicom');
%            end
          
          funcOpenImage(full_filename,1);
%           Image.image = Image.image +  25000;
%           Image.OriginalImage = Image.image;
%           figure;imagesc(Image.image);colormap(gray);
%             I = log_convertSXA(image,mAs, kVp)
%           image_lograw = deflip_image(Image.image);
%           Analysis.BackGroundComputed=false
%             ComputeBackGroundV2(Analysis,Image,Info,ctrl);
%             PhantomDetection;
%             ROIDetection('ROOT');
%             SkinDetection('FROMGUI');
%             Periphery_calculation; 
           tophatFiltered = TOPHAT();
            image_pres = deflip_image(tophatFiltered);
            image_pres(image_pres<0) = 0;
            
           % image_pres = exp(-double(image_pres/10000));
            
            
%             if ~isempty(strfind(file_names(i).name,'CC'))
%                 pres_filename = [annot_dir,patient,'pres_CC.png'];
%                 raw_filename =  [annot_dir,patient,'raw_CC.png'];
%             elseif ~isempty(strfind(file_names(i).name,'ML'))
%                 pres_filename = [annot_dir,patient,'pres_ML.png'];
%                 raw_filename =  [annot_dir,patient,'raw_ML.png'];
%             else
%                  break;
%             end    
%                 pres_filename_mat = [pres_filename(1:end-4),'.mat'];
%             [pathstr,name,ext] = fileparts(full_filename);
%             pres_filename = [output_dir,'\',name,'_pres',ext];
%             pres_filename2 = [output_dir,'\',name,'_pres','.png'];

            image2 = imresize(image_pres,[numrows numcols]);
            png_fname = [output_dir,file_names(i).name(1:end-4),'.png'];
            imwrite(uint16(image2),png_fname);             
            
%             imwrite(uint16(image_pres),pres_filename2,'PNG');
%             image_pres = double(image_pres);
%             figure;imagesc(image_pres);colormap(gray);
%             info_dicom.PresentationIntentType = 'FOR PRESENTATION';
%             dicomwrite(image_pres,pres_filename,info_dicom,'CreateMode','copy');
            
          %  imwrite(uint16(image_lograw),raw_filename,'PNG');
%                 copyfile(full_filename_mat,root_dir);
%                 copyfile(pres_filename,annot_dir);
%                 copyfile(full_filename_mat,root_dir);
%                 old_matname = [root_dir,file_names(i).name(1:end-4),'.mat'];
%                 movefile(old_matname, pres_filename_mat);
%                 copyfile(pres_filename_mat,annot_dir_mat);
%             XX = double(dicomread(pres_filename)/4);
%             figure;imagesc(XX);colormap(gray);
            count = count + 1
            a = 1;
       
    end
catch
    init_pat = [init_pat;file_names(i).name]
end
  end
  a = 1;
  
%   copyfile(fname,dir_towrite);  
%     fname_old = [dir_towrite,name,ext];
%     fname_new = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,ext];
%     copyfile([fname(1:end-7),'.mat'],dir_towrite);
%     movefile( fname_old, fname_new);
%     fname_oldm = [dir_towrite,name(1:end-3),'.mat'];
%     fname_newm = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'.mat'];
%     movefile( fname_oldm, fname_newm);
  
  
  
% % %   dirname_toread = parentdir;
% % %   index = strfind(parentdir, '\');
% % %   patient_name = parentdir(index(end-1)+1:index(end)-1);
% % %     dirname_towritepngcut = '\png_files';
% % %     dirname_towritematcut = '\mat_files';
% % %     %dirname_forprescut = '\ForPresentation';
% % %     dirname_forpres = dirname_toread; 
% % %     dirname_towritepngPres = [dirname_toread,'\png_files\'];
% % %     dirname_towritematPres = [dirname_toread,'\mat_files\'];%dirname_patient
% % %    % dirname_towritepngPres = [dirname_forpres,'\png_files\'];
% % %    % dirname_towritematPres = [dirname_forpres,'\mat_files\'];
% % %    
   
   
   
% %    
% %     dirname_toread = parentdir;
% %    index = strfind(parentdir, '\');
% %   patient_name = parentdir(index(end)+1:end);
% %   
% %     dirname_towritepngcut = '\png_files';
% %     dirname_towritematcut = '\mat_files';
% %     dirname_forprescut = '\ForPresentation';
% %     dirname_forpres = [dirname_toread,dirname_forprescut];
% %     
% %     mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
% %     mkdir(parentdir,dirname_towritematcut);
% %      mkdir(parentdir,dirname_forprescut);
% %      
% %     mkdir(dirname_forpres,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
% %     mkdir(dirname_forpres,dirname_towritematcut);
% %      
% %     dirname_towritepng = [dirname_toread,'\png_files\'];
% %     dirname_towritemat = [dirname_toread,'\mat_files\'];
% %     
% %     dirname_towritepngPres = [dirname_forpres,'\png_files\'];
% %     dirname_towritematPres = [dirname_forpres,'\mat_files\'];
% %    
% %    
% %    
% %     dirnamepng_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
% %     dirnamemat_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\mat_files\';   
% %        
% %     
% %     %%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     file_names = dir(dirname_toread); %returns the list of files in the specified directory
% %     sza = size(file_names);
% %     count = 0;
% %     lenf = sza(1);
% %     warning off;   
% %         
% % % % %      for k = 3:lenf
% % % % %          count2 = count2 + 1
% % % % %         filename_read = [dirname_toread,'\',file_names(k).name];
% % % % %         info_dicom = dicominfo(filename_read);
% % % % %         info_dicom_vect(count2) = info_dicom;
% % % % %      end
% % % % %      
% % % % %      szdc = size(info_dicom_vect);
% % % % %      
% %   for k = 3:lenf
% %     
% %     filename_read = file_names(k).name;
% %     fullfilename_read = [dirname_toread,'\',filename_read];
% %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% %     name2 = [pathstr,'\',name];
% %      if length(ext) > 4 
% %         ext = [];
% %      end
% %     
% %     if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %         npres = name2
% %     
% % %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %         
% %         info_dicom = dicominfo(fullfilename_read);
% % % % %         inf = info_dicom.ImageComments
% % % % %         if exist('inf')
% % % % %             comments = info_dicom.ImageComments;
% % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % %             if ~isempty(comments)
% % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % %             end
% % % % %         end
% % %%%%        creation names for saving mat and png files
% %            pivot_str='dd-mmm-yyyy HH:MM:SS';
% %            mode = info_dicom.ExposureControlMode;
% %            thickness = info_dicom.BodyPartThickness;
% %            paddle = uint8(info_dicom.Private_0019_1026);
% %            kvp = info_dicom.KVP;
% %            view = info_dicom.ViewPosition;
% %            
% %             if isfield(info_dicom,'ExposureInuAs')
% %                 mas = info_dicom.ExposureInuAs/1000;
% %            else
% %                mas = info_dicom.ExposureinuAs/1000;
% %            end
% %            
% %            comments = info_dicom.ImageComments;
% %            force = info_dicom.CompressionForce;
% %            %time =  str2num(info_dicom.AcquisitionTime);
% %            time_acq =info_dicom.AcquisitionTime;
% %            date_acq =info_dicom.AcquisitionDate;
% %            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
% %            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
% %            date_vect = [date_arr,time_arr];
% %            time = datenum(date_vect);
% % % % %                    
% % % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % %                   file_short = 'LECC';
% % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % %                   file_short = 'HECC';
% % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % %                   file_short = 'LEML';
% % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % %                   file_short = 'HEML';       
% % % % %            elseif strfind(mode, 'MANUAL')   
% %               
% % file_short2 = [];
% % if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% %    % file_short = 'LECC';
% %     file_short = ['LECC',num2str(kvp)];
% %     %file_short2 = [patient_name,'_CC'];
% % elseif  (strfind(view, 'CC') & ((kvp == 39 | kvp == 38) & (mas>53 && mas<57)) & strfind(mode, 'MANUAL')  ) %&  (~(~isempty(comments) & strfind(lower(comments), 'hecp')))
% %     file_short = 'HECC';
% % 
% % elseif  (strfind(view, 'CC') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
% %     file_short = 'HECCTEC';
% % elseif (strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER'))
% %     %file_short = 'LEML';
% %     file_short = ['LEML',num2str(kvp)];
% %     %file_short2 = [patient_name,'_ML'];
% % elseif  (strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39)
% %     file_short = 'HEML';
% % elseif  (strfind(view, 'ML') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
% %     file_short = 'HEMLTEC';
% % elseif strfind(mode, 'MANUAL')
% %     if ~isempty(comments) & strfind(lower(comments), 'gen3')
% %        file_short = ['GEN3',num2str(kvp)];        
% %     elseif (kvp==25 & strfind(lower(comments), 'dc'))%& paddle(1:4) ~= uint8([78;111;110;101])) (mas>99 && mas<101)
% %         file_short = 'DC';
% %     elseif ((kvp == 39 | kvp == 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% %         %file_short = 'CPHE';
% %         if  (strfind(dirname_toread,'3C01006') &  time < 735483.5810)
% %             file_short = ['CPHE','old'];  %num2str(kvp)
% %         else
% %             file_short = 'CPHE';
% %         end
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >= 81 & time > 735500))
% %         file_short = ['CPLE',num2str(kvp)];
% %         thLECP = thickness
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & ((thickness < 81 & time > 735500) | (thickness < 70 & time < 735500)))
% %         file_short = ['GEN3',num2str(kvp)];
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >70 & time < 735500))
% %         if  (strfind(dirname_toread,'3C01006')) 
% %             if  time < 735483.5810
% %             file_short = ['CPLE',num2str(kvp),'old'];
% %             else
% %                 if thickness > 82
% %                     file_short = ['CPLE',num2str(kvp)];
% %                 else
% %                     file_short = ['GEN3',num2str(kvp)];
% %                 end                 
% %               
% %             end
% %         else
% %             file_short = ['CPLE',num2str(kvp)];
% %         end
% %     elseif ((kvp == 39 | kvp == 38) & paddle(1:4) == uint8([78;111;110;101]))
% %         file_short = 'FFHE';
% %     elseif ((kvp ~= 39 | kvp ~= 38) & paddle(1:4) == uint8([78;111;110;101]))
% %         file_short = ['FFLE',num2str(kvp)];
% %         % % %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
% %         % % %                   file_short = ['GEN3',num2str(kvp)];
% %         
% %     end
% % end
% %                  %commented for test
% %             mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% %             png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
% %              save(mat_filename, 'info_dicom');
% %             copyfile(mat_filename,dirname_towritepng);
% %             XX = dicomread(info_dicom);
% %            
% %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% %             clear XX;
% %            
% %              imwrite(uint16(XX1),png_filename,'PNG');
% %             count = count + 1
% %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% %         
% %     else
% %         if  ~isdir(fullfilename_read)
% %            
% %         end
% %     end
% %    
% %   end
% %      
% %    %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     file_names = dir(dirname_forpres); %returns the list of files in the specified directory
% %     sza = size(file_names);
% %     count = 0;
% %    
% %     lenf = sza(1);
% %     warning off;   
% %   
% %   for k = 3:lenf
% %     
% %     filename_readPres = file_names(k).name;
% %     fullfilename_readPres = [dirname_forpres,'\',filename_readPres];
% %     [pathstr,name,ext] = fileparts(fullfilename_readPres);     %,versn
% %     name2Pres = [pathstr,'\',name];
% %      if length(ext) > 4 
% %         ext = [];
% %      end
% %     
% %     if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2Pres)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %         npres = name2Pres
% % %     if ~isdir(name2Pres)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %         
% %         info_dicom = dicominfo(fullfilename_readPres);
% % % % %         inf = info_dicom.ImageComments
% % % % %         if exist('inf')
% % % % %             comments = info_dicom.ImageComments;
% % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % %             if ~isempty(comments)
% % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % %             end
% % % % %         end
% % %%%%        creation names for saving mat and png files
% %            mode = info_dicom.ExposureControlMode;
% %            thickness = info_dicom.BodyPartThickness;
% %            paddle = uint8(info_dicom.Private_0019_1026);
% %            kvp = info_dicom.KVP;
% %            view = info_dicom.ViewPosition;
% %            if isfield(info_dicom,'ExposureInuAs')
% %                 mas = info_dicom.ExposureInuAs/1000;
% %            else
% %                mas = info_dicom.ExposureinuAs/1000;
% %             end
% %            % info_dicom.ExposureInuAs/1000;
% %            comments = info_dicom.ImageComments;
% %            force = info_dicom.CompressionForce;
% %           %time = info_dicom.AcquisitionTime;
% %             time_acq =info_dicom.AcquisitionTime;
% %            date_acq =info_dicom.AcquisitionDate;
% %            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
% %            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
% %            date_vect = [date_arr,time_arr];
% %            time = datenum(date_vect);
% %           
% % % % %           if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % %                   file_short = 'LECC';
% % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % %                   file_short = 'HECC';
% % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % %                   file_short = 'LEML';
% % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % %                   file_short = 'HEML';       
% % % % %            elseif strfind(mode, 'MANUAL') 
% % file_short2 = [];
% % if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% %    % file_short = 'LECC';
% %     file_short = ['LECC',num2str(kvp)];
% %     file_short2 = [patient_name,'_CC'];
% % elseif  (strfind(view, 'CC') & ((kvp == 39 | kvp == 38) & (mas>53 && mas<57)) & strfind(mode, 'MANUAL'))
% %     file_short = 'HECC';
% %     elseif  (strfind(view, 'CC') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
% %     file_short = 'HECCTEC';
% % elseif (strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER'))
% %     %file_short = 'LEML';
% %     file_short = ['LEML',num2str(kvp)];
% %     file_short2 = [patient_name,'_ML'];
% % elseif  (strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39)
% %     file_short = 'HEML';
% % elseif  (strfind(view, 'ML') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
% %     file_short = 'HEMLTEC';
% % elseif strfind(mode, 'MANUAL')
% %     if (kvp==25 & (mas>99 && mas<101))%& paddle(1:4) ~= uint8([78;111;110;101]))
% %         file_short = 'DC';
% %     elseif ((kvp == 39 | kvp == 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% %         %file_short = 'CPHE';
% %         if  (strfind(dirname_toread,'3C01006') &  time < 735483.5810)
% %             file_short = ['CPHE','old'];  %num2str(kvp)
% %         else
% %             file_short = 'CPHE';
% %         end
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >= 81 & time > 735500))
% %         file_short = ['CPLE',num2str(kvp)];
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & ((thickness < 81 & time > 735500) | (thickness < 70 & time < 735500)))
% %         file_short = ['GEN3',num2str(kvp)];
% %     elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >70 & time < 735500))
% %         if  (strfind(dirname_toread,'3C01006')) 
% %             if  time < 735483.5810
% %             file_short = ['CPLE',num2str(kvp),'old'];
% %             else
% %                 if thickness > 82
% %                     file_short = ['CPLE',num2str(kvp)];
% %                 else
% %                     file_short = ['GEN3',num2str(kvp)];
% %                 end                 
% %               
% %             end
% %         else
% %             file_short = ['CPLE',num2str(kvp)];
% %         end
% %     elseif ((kvp == 39 | kvp == 38) & paddle(1:4) == uint8([78;111;110;101]))
% %         file_short = 'FFHE';
% %     elseif ((kvp ~= 39 | kvp ~= 38) & paddle(1:4) == uint8([78;111;110;101]))
% %         file_short = ['FFLE',num2str(kvp)];
% %         % % %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
% %         % % %                   file_short = ['GEN3',num2str(kvp)];
% %         
% %     end
% % end
% %            
% %             mat_filenamePres=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];  
% %             png_filenamePres=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];
% %            
% %            
% %             
% %             
% %             save(mat_filenamePres, 'info_dicom');
% %             XX = dicomread(info_dicom);
% %            
% %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% %             clear XX;
% %            
% %             imwrite(uint16(XX1),png_filenamePres,'PNG');
% %             
% %             if ~isempty(file_short2)
% %                 mat_filenameRAD=[dirname_towritematPres, file_short2(1:end), '.mat' ];
% %                 png_filenameRAD=[dirname_towritepngPres, file_short2(1:end), '.png' ];
% %                 save(mat_filenameRAD, 'info_dicom');
% %                 imwrite(uint16(XX1),png_filenameRAD,'PNG');
% %                 copyfile(png_filenameRAD,dirnamepng_UCSF); 
% %                 copyfile(mat_filenameRAD,dirnamemat_UCSF);
% %             end
% %             
% %             count = count + 1
% %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% %         
% %     else
% %         if  ~isdir(fullfilename_readPres)
% %            
% %         end
% %     end
% %    
% %   end
% %   end
% %   
% %    
% % % % % % % %  6 times       
% % % % % % % %          
% % % % % % % %     file_names = dir(dirname_toread); %returns the list of files in the specified directory
% % % % % % % %     sza = size(file_names);
% % % % % % % %     count = 0;
% % % % % % % %     lenf = sza(1);
% % % % % % % %     warning off;   
% % % % % % % %         
% % % % % % % % % % %      for k = 3:lenf
% % % % % % % % % % %          count2 = count2 + 1
% % % % % % % % % % %         filename_read = [dirname_toread,'\',file_names(k).name];
% % % % % % % % % % %         info_dicom = dicominfo(filename_read);
% % % % % % % % % % %         info_dicom_vect(count2) = info_dicom;
% % % % % % % % % % %      end
% % % % % % % % % % %      
% % % % % % % % % % %      szdc = size(info_dicom_vect);
% % % % % % % % % % %      
% % % % % % % %   for k = 3:lenf
% % % % % % % %     
% % % % % % % %     filename_read = file_names(k).name;
% % % % % % % %     fullfilename_read = [dirname_toread,'\',filename_read];
% % % % % % % %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% % % % % % % %     name2 = [pathstr,'\',name];
% % % % % % % %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% % % % % % % %         
% % % % % % % %         info_dicom = dicominfo(fullfilename_read);
% % % % % % % % % % %         inf = info_dicom.ImageComments
% % % % % % % % % % %         if exist('inf')
% % % % % % % % % % %             comments = info_dicom.ImageComments;
% % % % % % % % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % % % % % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % % % % % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % % % % % % % %             if ~isempty(comments)
% % % % % % % % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % % % % % % % %             end
% % % % % % % % % % %         end
% % % % % % % % %%%%        creation names for saving mat and png files
% % % % % % % %            mode = info_dicom.ExposureControlMode;
% % % % % % % %            thickness = info_dicom.BodyPartThickness;
% % % % % % % %            paddle = uint8(info_dicom.Private_0019_1026);
% % % % % % % %            kvp = info_dicom.KVP;
% % % % % % % %            view = info_dicom.ViewPosition;
% % % % % % % %            mas = info_dicom.ExposureInuAs/1000;
% % % % % % % %           
% % % % % % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % % % % %                   file_short = 'LECC';
% % % % % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % % % % %                   file_short = 'HECC';
% % % % % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % % % % %                   file_short = 'LEML';
% % % % % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % % % % %                   file_short = 'HEML';       
% % % % % % % %            elseif strfind(mode, 'MANUAL')      
% % % % % % % %               if kvp==25  
% % % % % % % %                   file_short = 'DC';
% % % % % % % %               elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% % % % % % % %                   file_short = 'CPHE';
% % % % % % % %               elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))                                          )
% % % % % % % %                   file_short = ['CPLE',num2str(kvp)];
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % % % %                    file_short = 'FFHE';
% % % % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % % % %                    file_short = ['FFLE',num2str(kvp)]; 
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness > 30)
% % % % % % % %                   file_short = ['H4cm'];    
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness < 30)
% % % % % % % %                   file_short = ['H0cm'];  
% % % % % % % %               end
% % % % % % % %            end
% % % % % % % %                  
% % % % % % % %             mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% % % % % % % %             png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
% % % % % % % %             save(mat_filename, 'info_dicom');
% % % % % % % %             XX = dicomread(info_dicom);
% % % % % % % %            
% % % % % % % %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% % % % % % % %             clear XX;
% % % % % % % %            
% % % % % % % %             imwrite(uint16(XX1),png_filename,'PNG');
% % % % % % % %             count = count + 1
% % % % % % % %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% % % % % % % %         
% % % % % % % %     else
% % % % % % % %         if  ~isdir(fullfilename_read)
% % % % % % % %            
% % % % % % % %         end
% % % % % % % %     end
% % % % % % % %    
% % % % % % % %   end
% % % % % % % %   %%
% % % % % % % %   %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % %     file_names = dir(dirname_forpres); %returns the list of files in the specified directory
% % % % % % % %     sza = size(file_names);
% % % % % % % %     count2 = 0;
% % % % % % % %     lenf = sza(1);
% % % % % % % %     warning off;   
% % % % % % % %         
% % % % % % % % % % %      for k = 3:lenf
% % % % % % % % % % %          count2 = count2 + 1
% % % % % % % % % % %         filename_read = [dirname_toread,'\',file_names(k).name];
% % % % % % % % % % %         info_dicom = dicominfo(filename_read);
% % % % % % % % % % %         info_dicom_vect(count2) = info_dicom;
% % % % % % % % % % %      end
% % % % % % % % % % %      
% % % % % % % % % % %      szdc = size(info_dicom_vect);
% % % % % % % % % % %      
% % % % % % % %   for k = 3:lenf
% % % % % % % %     
% % % % % % % %     filename_read = file_names(k).name;
% % % % % % % %     fullfilename_read = [dirname_forpres,'\',filename_read];
% % % % % % % %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% % % % % % % %     name2 = [pathstr,'\',name];
% % % % % % % %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% % % % % % % %         
% % % % % % % %         info_dicom = dicominfo(fullfilename_read);
% % % % % % % % % % %         inf = info_dicom.ImageComments
% % % % % % % % % % %         if exist('inf')
% % % % % % % % % % %             comments = info_dicom.ImageComments;
% % % % % % % % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % % % % % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % % % % % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % % % % % % % %             if ~isempty(comments)
% % % % % % % % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % % % % % % % %             end
% % % % % % % % % % %         end
% % % % % % % % %%%%        creation names for saving mat and png files
% % % % % % % %            mode = info_dicom.ExposureControlMode;
% % % % % % % %            thickness = info_dicom.BodyPartThickness;
% % % % % % % %            paddle = uint8(info_dicom.Private_0019_1026);
% % % % % % % %            kvp = info_dicom.KVP;
% % % % % % % %            view = info_dicom.ViewPosition;
% % % % % % % %            mas = info_dicom.ExposureInuAs/1000;
% % % % % % % %           
% % % % % % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % % % % %                   file_short = 'LECC';
% % % % % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % % % % %                   file_short = 'HECC';
% % % % % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % % % % %                   file_short = 'LEML';
% % % % % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % % % % %                   file_short = 'HEML';       
% % % % % % % %            elseif strfind(mode, 'MANUAL')      
% % % % % % % %               if kvp==25  
% % % % % % % %                   file_short = 'DC';
% % % % % % % %               elseif (kvp == 39 & paddle(1:4) == uint8([50;52;99;109]))
% % % % % % % %                   file_short = 'CPHE';
% % % % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([50;52;99;109]))
% % % % % % % %                   file_short = ['CPLE',num2str(kvp)];
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % % % %                    file_short = 'FFHE';
% % % % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % % % %                    file_short = ['FFLE',num2str(kvp)]; 
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness > 30)
% % % % % % % %                   file_short = ['H4cm'];    
% % % % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness < 30)
% % % % % % % %                   file_short = ['H0cm'];  
% % % % % % % %               end
% % % % % % % %            end
% % % % % % % %                  
% % % % % % % %             mat_filename=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];
% % % % % % % %             png_filename=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];
% % % % % % % %             save(mat_filename, 'info_dicom');
% % % % % % % %             XX = dicomread(info_dicom);
% % % % % % % %            
% % % % % % % %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% % % % % % % %             clear XX;
% % % % % % % %            
% % % % % % % %             imwrite(uint16(XX1),png_filename,'PNG');
% % % % % % % %             count2 = count2 + 1
% % % % % % % %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% % % % % % % %         
% % % % % % % %     else
% % % % % % % %         if  ~isdir(fullfilename_read)
% % % % % % % %            
% % % % % % % %         end
% % % % % % % %     end
% % % % % % % %    
% % % % % % % % end
% % % % % % % %   
% % % % % % % % 
% % % % % % % %   
% % % % % % % %   
% % % % % % % %  
% % % % % % % % end
% % % % % % % % 
% % % % % % % % function [info_dicom] = search_heimage(time,infodicom_set)
% % % % % % % %     
% % % % % % % % 
% % % % % % % % end
% % % % % % % % 
% % % % % % % %  
% % % % % % % % 
% % % % % % % % 

% % end

