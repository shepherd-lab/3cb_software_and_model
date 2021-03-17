function dicom_3C_CDupload()
global ctrl
for i=[213] %211 error
    %       for i=[164:164]
    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01',num2str(i,'%03.0f')];
    
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
    
    
    
    
    dirname_toread = parentdir;
    index = strfind(parentdir, '\');
    patient_name = parentdir(index(end)+1:end);
    
    dirname_towritepngcut = '\png_files';
    dirname_towritematcut = '\mat_files';
    dirname_forprescut = '\ForPresentation';
    dirname_forpres = [dirname_toread,dirname_forprescut];
    
    mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
    mkdir(parentdir,dirname_towritematcut);
    mkdir(parentdir,dirname_forprescut);
    
    mkdir(dirname_forpres,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
    mkdir(dirname_forpres,dirname_towritematcut);
    
    dirname_towritepng = [dirname_toread,'\png_files\'];
    dirname_towritemat = [dirname_toread,'\mat_files\'];
    
    dirname_towritepngPres = [dirname_forpres,'\png_files\'];
    dirname_towritematPres = [dirname_forpres,'\mat_files\'];
    
    
    
    dirnamepng_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
    dirnamemat_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\mat_files\';
    
    file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;
    
    
% %     for k = 1:lenf
% %         filename_read = file_names(k).name;
% %         fullfilename_read = [dirname_toread,'\',filename_read];
% %         try
% %             info_dicom = dicominfo(fullfilename_read);
% %             
% %             if strcmp(info_dicom.PresentationIntentType, 'FOR PRESENTATION')
% %                 movefile(fullfilename_read,dirname_forpres);
% %             end
% %         catch
% %             continue;
% %         end
% %         
% %         a = 1;
% %         
% %     end
    
    
    
    %%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % % %      for k = 3:lenf
    % % %          count2 = count2 + 1
    % % %         filename_read = [dirname_toread,'\',file_names(k).name];
    % % %         info_dicom = dicominfo(filename_read);
    % % %         info_dicom_vect(count2) = info_dicom;
    % % %      end
    % % %
    % % %      szdc = size(info_dicom_vect);
    % % %
    for k = 3:lenf
        
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,'\',filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
        name2 = [pathstr,'\',name];
        if length(ext) > 4
            ext = [];
        end
        
        if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
            npres = name2        
            info_dicom = dicominfo(fullfilename_read);
            if strcmp(info_dicom.PresentationIntentType, 'FOR PRESENTATION')
                movefile(fullfilename_read,dirname_forpres);
            else strcmp(info_dicom.PresentationIntentType, 'FOR PROCESSING')
           
            % % %         inf = info_dicom.ImageComments
            % % %         if exist('inf')
            % % %             comments = info_dicom.ImageComments;
            % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
            % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
            % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
            % % %             if ~isempty(comments)
            % % %                 filename_read = [comments, '.', num2str(num)];
            % % %             end
            % % %         end
            %%%%        creation names for saving mat and png files
            pivot_str='dd-mmm-yyyy HH:MM:SS';
            mode = info_dicom.ExposureControlMode;
            thickness = info_dicom.BodyPartThickness;
%             bb = info_dicom.Private_0019_1026
            if isfield(info_dicom, 'Private_0019_1026')
                paddle = uint8(info_dicom.Private_0019_1026);
            else
                paddle = uint8([50;52;99;109]);
            end
            kvp = info_dicom.KVP;
            view = info_dicom.ViewPosition;
            view = view(1:2);
           
            
            if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
            else
                mas = info_dicom.ExposureinuAs/1000;
            end
            
            comments = info_dicom.ImageComments;
            force = info_dicom.CompressionForce;
            %time =  str2num(info_dicom.AcquisitionTime);
            time_acq =info_dicom.AcquisitionTime;
            date_acq =info_dicom.AcquisitionDate;
            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
            date_vect = [date_arr,time_arr];
            time = datenum(date_vect);
            % % %
            % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
            % % %                   file_short = 'LECC';
            % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
            % % %                   file_short = 'HECC';
            % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
            % % %                   file_short = 'LEML';
            % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
            % % %                   file_short = 'HEML';
            % % %            elseif strfind(mode, 'MANUAL')
            
            file_short2 = [];
            if strfind(view, 'CC') & strfind(mode, 'AUTO')
                % file_short = 'LECC';
                if kvp == 39
                    file_short = 'HECC';
                else
                    file_short = ['LECC',num2str(kvp)];
                end
                %file_short2 = [patient_name,'_CC'];
            elseif  (strfind(view, 'CC') & ((kvp == 39 | kvp == 38) & (mas>53 && mas<57)) & strfind(mode, 'MANU')  ) %&  (~(~isempty(comments) & strfind(lower(comments), 'hecp')))
                file_short = 'HECC';
                
            elseif  (strfind(view, 'CC') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
                file_short = 'HECCTEC';
            elseif (strfind(view, 'ML') & strfind(mode, 'AUTO'))
                %file_short = 'LEML';
                if kvp == 39
                    file_short = 'HEML';
                else
                    file_short = ['LEML',num2str(kvp)];
                end
                
                %file_short2 = [patient_name,'_ML'];
            elseif  (strfind(view, 'ML') & strfind(mode, 'MANU') & kvp == 39)
                file_short = 'HEML';
            elseif  (strfind(view, 'ML') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
                file_short = 'HEMLTEC';
            elseif strfind(mode, 'MANU')
                if ~isempty(comments) & strfind(lower(comments), 'gen3')
                    file_short = ['GEN3',num2str(kvp)];
                elseif (kvp==25 & strfind(lower(comments), 'dc'))%& paddle(1:4) ~= uint8([78;111;110;101])) (mas>99 && mas<101)
                    file_short = 'DC';
                elseif ((kvp == 39 | kvp == 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]) | ~isempty(strfind(comments,'CP'))))
                    %file_short = 'CPHE';
                    if  (strfind(dirname_toread,'3C01006') &  time < 735483.5810)
                        file_short = ['CPHE','old'];  %num2str(kvp)
                    else
                        file_short = 'CPHE';
                    end
                elseif (((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >= 81 & time > 735500)) | ~isempty(strfind(comments,'CP')))
                    file_short = ['CPLE',num2str(kvp)];
                    thLECP = thickness
                elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & ((thickness < 81 & time > 735500) | (thickness < 70 & time < 735500)))
                    file_short = ['GEN3',num2str(kvp)];
                elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >70 & time < 735500))
                    if  (strfind(dirname_toread,'3C01006'))
                        if  time < 735483.5810
                            file_short = ['CPLE',num2str(kvp),'old'];
                        else
                            if thickness > 82
                                file_short = ['CPLE',num2str(kvp)];
                            else
                                file_short = ['GEN3',num2str(kvp)];
                            end
                            
                        end
                    else
                        file_short = ['CPLE',num2str(kvp)];
                    end
                elseif ((kvp == 39 | kvp == 38) & paddle(1:4) == uint8([78;111;110;101]))
                    file_short = 'FFHE';
                elseif ((kvp ~= 39 | kvp ~= 38) & paddle(1:4) == uint8([78;111;110;101]))
                    file_short = ['FFLE',num2str(kvp)];
                    % % %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
                    % % %                   file_short = ['GEN3',num2str(kvp)];
                    
                end
            end
            %commented for test
            mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
            png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
            save(mat_filename, 'info_dicom');
            copyfile(mat_filename,dirname_towritepng);
            XX = dicomread(info_dicom);
            
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
            clear XX;
            
            imwrite(uint16(XX1),png_filename,'PNG');
            count = count + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
            end
        else
            if  ~isdir(fullfilename_read)
                
            end
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_names = dir(dirname_forpres); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    
    lenf = sza(1);
    warning off;
    
    for k = 3:lenf
        
        filename_readPres = file_names(k).name;
        fullfilename_readPres = [dirname_forpres,'\',filename_readPres];
        [pathstr,name,ext] = fileparts(fullfilename_readPres);     %,versn
        name2Pres = [pathstr,'\',name];
        if length(ext) > 4
            ext = [];
        end
        
        if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2Pres))  %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
            npres = name2Pres              
            info_dicom = dicominfo(fullfilename_readPres);
           if strcmp(info_dicom.PresentationIntentType, 'FOR PRESENTATION')
            % % %         inf = info_dicom.ImageComments
            % % %         if exist('inf')
            % % %             comments = info_dicom.ImageComments;
            % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
            % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
            % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
            % % %             if ~isempty(comments)
            % % %                 filename_read = [comments, '.', num2str(num)];
            % % %             end
            % % %         end
            %%%%        creation names for saving mat and png files
            mode = info_dicom.ExposureControlMode;
            thickness = info_dicom.BodyPartThickness;
%             paddle = uint8(info_dicom.Private_0019_1026);
            if isfield(info_dicom, 'Private_0019_1026')
                paddle = uint8(info_dicom.Private_0019_1026);
            else
                paddle = uint8([50;52;99;109]);
            end
            
            kvp = info_dicom.KVP;
            view = info_dicom.ViewPosition;
            view= view(1:2)
            mode = mode(1:4)
            if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
            else
                mas = info_dicom.ExposureinuAs/1000;
            end
            % info_dicom.ExposureInuAs/1000;
            comments = info_dicom.ImageComments;
            force = info_dicom.CompressionForce;
            %time = info_dicom.AcquisitionTime;
            time_acq =info_dicom.AcquisitionTime;
            date_acq =info_dicom.AcquisitionDate;
            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
            date_vect = [date_arr,time_arr];
            time = datenum(date_vect);
            
            % % %           if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
            % % %                   file_short = 'LECC';
            % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
            % % %                   file_short = 'HECC';
            % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
            % % %                   file_short = 'LEML';
            % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
            % % %                   file_short = 'HEML';
            % % %            elseif strfind(mode, 'MANUAL')
            file_short2 = [];
            if strfind(view, 'CC') & strfind(mode, 'AUTO')
                % file_short = 'LECC';
                if kvp == 39
                    file_short = 'HECC';
                else
                    file_short = ['LECC',num2str(kvp)];
                    file_short2 = [patient_name,'_CC'];
                end
                
                
            elseif  (strfind(view, 'CC') & ((kvp == 39 | kvp == 38) & (mas>53 && mas<57)) & strfind(mode, 'MANU'))
                file_short = 'HECC';
            elseif  (strfind(view, 'CC') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
                file_short = 'HECCTEC';
            elseif (strfind(view, 'ML') & strfind(mode, 'AUTO')) %AUTO_FILTER
                %file_short = 'LEML';
                if kvp == 39
                    file_short = 'HEML';
                else
                    file_short = ['LEML',num2str(kvp)];
                    file_short2 = [patient_name,'_ML'];
                end
                
            elseif  (strfind(view, 'ML') & strfind(mode, 'MANU') & kvp == 39)
                file_short = 'HEML';
            elseif  (strfind(view, 'ML') & (kvp == 39 | kvp == 38) & strfind(mode, 'TEC'))
                file_short = 'HEMLTEC';
            elseif strfind(mode, 'MANU')
                if (kvp==25 & (mas>99 && mas<101))%& paddle(1:4) ~= uint8([78;111;110;101]))
                    file_short = 'DC';
                elseif ((kvp == 39 | kvp == 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
                    %file_short = 'CPHE';
                    if  (strfind(dirname_toread,'3C01006') &  time < 735483.5810)
                        file_short = ['CPHE','old'];  %num2str(kvp)
                    else
                        file_short = 'CPHE';
                    end
                elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >= 81 & time > 735500))
                    file_short = ['CPLE',num2str(kvp)];
                elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & ((thickness < 81 & time > 735500) | (thickness < 70 & time < 735500)))
                    file_short = ['GEN3',num2str(kvp)];
                elseif ((kvp~= 39 | kvp ~= 38) & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) & (thickness >70 & time < 735500))
                    if  (strfind(dirname_toread,'3C01006'))
                        if  time < 735483.5810
                            file_short = ['CPLE',num2str(kvp),'old'];
                        else
                            if thickness > 82
                                file_short = ['CPLE',num2str(kvp)];
                            else
                                file_short = ['GEN3',num2str(kvp)];
                            end
                            
                        end
                    else
                        file_short = ['CPLE',num2str(kvp)];
                    end
                elseif ((kvp == 39 | kvp == 38) & paddle(1:4) == uint8([78;111;110;101]))
                    file_short = 'FFHE';
                elseif ((kvp ~= 39 | kvp ~= 38) & paddle(1:4) == uint8([78;111;110;101]))
                    file_short = ['FFLE',num2str(kvp)];
                    % % %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
                    % % %                   file_short = ['GEN3',num2str(kvp)];
                    
                end
            end
            
            mat_filenamePres=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];
            png_filenamePres=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];       
                       
            save(mat_filenamePres, 'info_dicom');
            XX = dicomread(info_dicom);
            
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
            clear XX;
            
            imwrite(uint16(XX1),png_filenamePres,'PNG');
            
            if ~isempty(file_short2)
                mat_filenameRAD=[dirname_towritematPres, file_short2(1:end), '.mat' ];
                png_filenameRAD=[dirname_towritepngPres, file_short2(1:end), '.png' ];
                save(mat_filenameRAD, 'info_dicom');
                imwrite(uint16(XX1),png_filenameRAD,'PNG');
                copyfile(png_filenameRAD,dirnamepng_UCSF);
                copyfile(mat_filenameRAD,dirnamemat_UCSF);
            end
            
            count = count + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
           end
        else
            if  ~isdir(fullfilename_readPres)
                
            end
        end
        
    end
end


% % % % % %  6 times
% % % % % %
% % % % % %     file_names = dir(dirname_toread); %returns the list of files in the specified directory
% % % % % %     sza = size(file_names);
% % % % % %     count = 0;
% % % % % %     lenf = sza(1);
% % % % % %     warning off;
% % % % % %
% % % % % % % % %      for k = 3:lenf
% % % % % % % % %          count2 = count2 + 1
% % % % % % % % %         filename_read = [dirname_toread,'\',file_names(k).name];
% % % % % % % % %         info_dicom = dicominfo(filename_read);
% % % % % % % % %         info_dicom_vect(count2) = info_dicom;
% % % % % % % % %      end
% % % % % % % % %
% % % % % % % % %      szdc = size(info_dicom_vect);
% % % % % % % % %
% % % % % %   for k = 3:lenf
% % % % % %
% % % % % %     filename_read = file_names(k).name;
% % % % % %     fullfilename_read = [dirname_toread,'\',filename_read];
% % % % % %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% % % % % %     name2 = [pathstr,'\',name];
% % % % % %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% % % % % %
% % % % % %         info_dicom = dicominfo(fullfilename_read);
% % % % % % % % %         inf = info_dicom.ImageComments
% % % % % % % % %         if exist('inf')
% % % % % % % % %             comments = info_dicom.ImageComments;
% % % % % % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % % % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % % % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % % % % % %             if ~isempty(comments)
% % % % % % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % % % % % %             end
% % % % % % % % %         end
% % % % % % %%%%        creation names for saving mat and png files
% % % % % %            mode = info_dicom.ExposureControlMode;
% % % % % %            thickness = info_dicom.BodyPartThickness;
% % % % % %            paddle = uint8(info_dicom.Private_0019_1026);
% % % % % %            kvp = info_dicom.KVP;
% % % % % %            view = info_dicom.ViewPosition;
% % % % % %            mas = info_dicom.ExposureInuAs/1000;
% % % % % %
% % % % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % % %                   file_short = 'LECC';
% % % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % % %                   file_short = 'HECC';
% % % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % % %                   file_short = 'LEML';
% % % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % % %                   file_short = 'HEML';
% % % % % %            elseif strfind(mode, 'MANUAL')
% % % % % %               if kvp==25
% % % % % %                   file_short = 'DC';
% % % % % %               elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% % % % % %                   file_short = 'CPHE';
% % % % % %               elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))                                          )
% % % % % %                   file_short = ['CPLE',num2str(kvp)];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % %                    file_short = 'FFHE';
% % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % %                    file_short = ['FFLE',num2str(kvp)];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness > 30)
% % % % % %                   file_short = ['H4cm'];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness < 30)
% % % % % %                   file_short = ['H0cm'];
% % % % % %               end
% % % % % %            end
% % % % % %
% % % % % %             mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% % % % % %             png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
% % % % % %             save(mat_filename, 'info_dicom');
% % % % % %             XX = dicomread(info_dicom);
% % % % % %
% % % % % %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% % % % % %             clear XX;
% % % % % %
% % % % % %             imwrite(uint16(XX1),png_filename,'PNG');
% % % % % %             count = count + 1
% % % % % %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% % % % % %
% % % % % %     else
% % % % % %         if  ~isdir(fullfilename_read)
% % % % % %
% % % % % %         end
% % % % % %     end
% % % % % %
% % % % % %   end
% % % % % %   %%
% % % % % %   %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % %     file_names = dir(dirname_forpres); %returns the list of files in the specified directory
% % % % % %     sza = size(file_names);
% % % % % %     count2 = 0;
% % % % % %     lenf = sza(1);
% % % % % %     warning off;
% % % % % %
% % % % % % % % %      for k = 3:lenf
% % % % % % % % %          count2 = count2 + 1
% % % % % % % % %         filename_read = [dirname_toread,'\',file_names(k).name];
% % % % % % % % %         info_dicom = dicominfo(filename_read);
% % % % % % % % %         info_dicom_vect(count2) = info_dicom;
% % % % % % % % %      end
% % % % % % % % %
% % % % % % % % %      szdc = size(info_dicom_vect);
% % % % % % % % %
% % % % % %   for k = 3:lenf
% % % % % %
% % % % % %     filename_read = file_names(k).name;
% % % % % %     fullfilename_read = [dirname_forpres,'\',filename_read];
% % % % % %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% % % % % %     name2 = [pathstr,'\',name];
% % % % % %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% % % % % %
% % % % % %         info_dicom = dicominfo(fullfilename_read);
% % % % % % % % %         inf = info_dicom.ImageComments
% % % % % % % % %         if exist('inf')
% % % % % % % % %             comments = info_dicom.ImageComments;
% % % % % % % % %             index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
% % % % % % % % %             index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
% % % % % % % % %             index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
% % % % % % % % %             if ~isempty(comments)
% % % % % % % % %                 filename_read = [comments, '.', num2str(num)];
% % % % % % % % %             end
% % % % % % % % %         end
% % % % % % %%%%        creation names for saving mat and png files
% % % % % %            mode = info_dicom.ExposureControlMode;
% % % % % %            thickness = info_dicom.BodyPartThickness;
% % % % % %            paddle = uint8(info_dicom.Private_0019_1026);
% % % % % %            kvp = info_dicom.KVP;
% % % % % %            view = info_dicom.ViewPosition;
% % % % % %            mas = info_dicom.ExposureInuAs/1000;
% % % % % %
% % % % % %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% % % % % %                   file_short = 'LECC';
% % % % % %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% % % % % %                   file_short = 'HECC';
% % % % % %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% % % % % %                   file_short = 'LEML';
% % % % % %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% % % % % %                   file_short = 'HEML';
% % % % % %            elseif strfind(mode, 'MANUAL')
% % % % % %               if kvp==25
% % % % % %                   file_short = 'DC';
% % % % % %               elseif (kvp == 39 & paddle(1:4) == uint8([50;52;99;109]))
% % % % % %                   file_short = 'CPHE';
% % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([50;52;99;109]))
% % % % % %                   file_short = ['CPLE',num2str(kvp)];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % %                    file_short = 'FFHE';
% % % % % %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% % % % % %                    file_short = ['FFLE',num2str(kvp)];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness > 30)
% % % % % %                   file_short = ['H4cm'];
% % % % % %               elseif (kvp== 39 & paddle(1:4) == uint8([55;46;53;99]) & thickness < 30)
% % % % % %                   file_short = ['H0cm'];
% % % % % %               end
% % % % % %            end
% % % % % %
% % % % % %             mat_filename=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];
% % % % % %             png_filename=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];
% % % % % %             save(mat_filename, 'info_dicom');
% % % % % %             XX = dicomread(info_dicom);
% % % % % %
% % % % % %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% % % % % %             clear XX;
% % % % % %
% % % % % %             imwrite(uint16(XX1),png_filename,'PNG');
% % % % % %             count2 = count2 + 1
% % % % % %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% % % % % %
% % % % % %     else
% % % % % %         if  ~isdir(fullfilename_read)
% % % % % %
% % % % % %         end
% % % % % %     end
% % % % % %
% % % % % % end
% % % % % %
% % % % % %
% % % % % %
% % % % % %
% % % % % %
% % % % % % end
% % % % % %
% % % % % % function [info_dicom] = search_heimage(time,infodicom_set)
% % % % % %
% % % % % %
% % % % % % end
% % % % % %
% % % % % %
% % % % % %
% % % % % %
