function dicom_3C_redirectionUCSF(pat_min, pat_max)
 global ctrl
  parentdir = uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_DICOMs');
  dirname_toread = parentdir;
    dirname_towritepngcut = '\png_files';
    dirname_towritematcut = '\mat_files';
    dirname_forprescut = '\ForPresentation';
     
    srtlist = fuf (parentdir ,1,'detail');
   
    sza = size(srtlist);
     count = 0;
     count2 = 0;
      count1 = 0;
    lenf = sza(1);
    warning off;
     
    
       for k = 1:lenf
            filename_read =  char(srtlist(k));
            try
             info_dicom = dicominfo(filename_read);
             folder = [];


            filename_read
            k
           kstr = strfind(filename_read,'3C-02')
          
           if ~isempty(kstr)
               pat_id = str2num(filename_read(kstr+5:kstr+7))
           elseif ~isempty(kstr2)
               pat_id = str2num(filename_read(kstr2+9:kstr2+11))
           else
               pat_id = [];
           end
         if ~isempty(pat_id)  
           if (pat_id >=pat_min  & pat_id <=pat_max)
               if (~isempty(kstr) | ~isempty(kstr2)) 
                   if ~isempty(kstr)
                      folder = ['UCSF\3C01', filename_read(kstr+5:kstr+7)];
                   elseif ~isempty(kstr2)
                      folder = ['UCSF\3C01', filename_read(kstr2+9:kstr2+11)];
                   else
                       folder = [];
                   end;      
               else 
                   count1 = count1 + 1
                   continue;
               end
           
           
            dirname_toreadUCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages';
            dirname_patient = [dirname_toreadUCSF,'\',folder];
            dirname_forpres = [dirname_patient,dirname_forprescut];
  
            dirname_towritepng = [dirname_patient,'\png_files\'];
            dirname_towritemat = [dirname_patient,'\mat_files\'];

            dirname_towritepngPres = [dirname_forpres,'\png_files\'];
            dirname_towritematPres = [dirname_forpres,'\mat_files\'];
           
           
           
            if strcmp(info_dicom.PresentationIntentType, 'FOR PRESENTATION')
              copyfile([filename_read],dirname_forpres);  %,'_t1'
            elseif strcmp(info_dicom.PresentationIntentType, 'FOR PROCESSING')
              copyfile([filename_read],dirname_patient);  %,'_t1'
            end
           end
         end
            catch
                count2 = count2 + 1
               continue;                
            end
             
      count = count + 1
                
       end      
       
%%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % flag_proc = 0;  
% % if flag_proc 
% %    file_names = dir(dirname_toread); %returns the list of files in the specified directory
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
% %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %        
% %               
% %          try    
% %             info_dicom = dicominfo(fullfilename_read);
% %          catch
% %                continue;
% %          end
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
% %         
% %            mode = info_dicom.ExposureControlMode;
% %            thickness = info_dicom.BodyPartThickness;
% %            paddle = uint8(info_dicom.Private_0019_1026);
% %            kvp = info_dicom.KVP;
% %            view = info_dicom.ViewPosition;
% %            if isfield(info_dicom,'ExposureInuAs')
% %                 mas = info_dicom.ExposureInuAs/1000;
% %            else
% %                mas = info_dicom.ExposureinuAs/1000;
% %            end
% %            %mas = info_dicom.ExposureInuAs/1000;
% %            
% %            comments = info_dicom.ImageComments;
% %            force = info_dicom.CompressionForce;
% %                    
% %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
% %                   file_short = 'LECC';
% %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
% %                   file_short = 'HECC';
% %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
% %                   file_short = 'LEML';
% %            elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
% %                   file_short = 'HEML';       
% %            elseif strfind(mode, 'MANUAL')      
% %               if kvp==25  
% %                   file_short = 'DC';
% %               elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% %                   file_short = 'CPHE';
% %               elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]) & force ~= 0)                                          )
% %                   file_short = ['CPLE',num2str(kvp)];
% %                   
% %                   
% %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% %                    file_short = 'FFHE';
% %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% %                    file_short = ['FFLE',num2str(kvp)]; 
% %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
% %                   file_short = ['GEN3',num2str(kvp)];    
% %               
% %               end
% %            end
% %                  
% %             mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% %             png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
% %             save(mat_filename, 'info_dicom');
% %             XX = dicomread(info_dicom);
% %            
% %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% %             clear XX;
% %            
% %             imwrite(uint16(XX1),png_filename,'PNG');
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
% % end    
% %    %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     file_names = dir(dirname_forpres); %returns the list of files in the specified directory
% %     sza = size(file_names);
% %     count2 = 0;
% %     lenf = sza(1);
% %     warning off;   
% %   
% %   for k = 3:lenf
% %     
% %     filename_read = file_names(k).name;
% %     fullfilename_read = [dirname_forpres,'\',filename_read];
% %     [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
% %     name2 = [pathstr,'\',name];
% %     if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
% %         try
% %         info_dicom = dicominfo(fullfilename_read);
% %          catch
% %                continue;
% %          end
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
% %            end
% %            %mas = info_dicom.ExposureInuAs/1000;
% %            comments = info_dicom.ImageComments;
% %            force = info_dicom.CompressionForce;
% %           
% %            if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER') & (kvp ~= 39)
% %                   file_short = 'LECC';
% %            elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & (strfind(mode, 'MANUAL') | strfind(mode, 'AUTO_FILTER'))
% %                   file_short = 'HECC';
% %            elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER') & (kvp ~= 39)
% %                   file_short = 'LEML';
% %            elseif  strfind(view, 'ML')  & kvp == 39 & ( strfind(mode, 'MANUAL') | strfind(mode, 'AUTO_FILTER'))
% %                   file_short = 'HEML';       
% %            elseif strfind(mode, 'MANUAL')      
% %               if kvp==25  
% %                   file_short = 'DC';
% %               elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
% %                   file_short = 'CPHE';
% %               elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]) & force ~= 0)                                          )
% %                   file_short = ['CPLE',num2str(kvp)];
% %               elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
% %                    file_short = 'FFHE';
% %               elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
% %                    file_short = ['FFLE',num2str(kvp)]; 
% %               elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
% %                   file_short = ['GEN3',num2str(kvp)];    
% %               
% %               end
% %            end
% %            
% %                  
% %             mat_filename=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];
% %             png_filename=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];
% %             save(mat_filename, 'info_dicom');
% %             XX = dicomread(info_dicom);
% %            
% %             XX1=round(UnderSamplingN(XX,2)); % downsizing the image
% %             clear XX;
% %            
% %             imwrite(uint16(XX1),png_filename,'PNG');
% %             count2 = count2 + 1
% %             set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
% %         
% %     else
% %         if  ~isdir(fullfilename_read)
% %            
% %         end
% %     end
   
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
