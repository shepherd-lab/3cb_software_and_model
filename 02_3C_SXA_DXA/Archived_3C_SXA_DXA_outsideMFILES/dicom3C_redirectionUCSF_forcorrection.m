function dicom_3C_CDupload()
 global ctrl
  parentdir = uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\');
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

% % %            if strcmp(info_dicom.AcquisitionDate,'20130807')
% % %                folder = 'UCSF\3C01001';
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130812')
% % %                folder = 'UCSF\3C01002';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130813')
% % %                folder = 'UCSF\3C01003';
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130819')
% % %                folder = 'UCSF\3C01004';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130905')
% % %                folder = 'UCSF\3C01005';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130906')
% % %                folder = 'UCSF\3C01006';    
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130910') & str2num(info_dicom.AcquisitionTime) < 132000
% % %                folder = 'UCSF\3C01007';
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130910') & str2num(info_dicom.AcquisitionTime) > 132000
% % %                folder = 'UCSF\3C01008';
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130923')
% % %                folder = 'UCSF\3C01009';       
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130926')
% % %                folder = 'UCSF\3C01010';      
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20130930')
% % %                folder = 'UCSF\3C01011';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131021')
% % %                folder = 'UCSF\3C01012';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131030')
% % %                folder = 'UCSF\3C01013';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131031')
% % %                folder = 'UCSF\3C01014';  
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131121')               
% % %                folder = 'UCSF\3C01015'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131203')               
% % %                folder = 'UCSF\3C01016'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131204')
% % %                folder = 'UCSF\3C01017';     
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131209')
% % %                folder = 'UCSF\3C01018'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131210')
% % %                folder = 'UCSF\3C01019'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131219')
% % %                folder = 'UCSF\3C01020'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20131227')
% % %                folder = 'UCSF\3C01021'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140107')
% % %                folder = 'UCSF\3C01022'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140109')
% % %                folder = 'UCSF\3C01023'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140117')
% % %                folder = 'UCSF\3C01024'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140127') & str2num(info_dicom.AcquisitionTime) < 112000
% % %                folder = 'UCSF\3C01025'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140127')
% % %                folder = 'UCSF\3C01026'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140203')
% % %                folder = 'UCSF\3C01027'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140204')
% % %                folder = 'UCSF\3C01028'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140213')
% % %                folder = 'UCSF\3C01029'; 
% % %            elseif strcmp(info_dicom.AcquisitionDate,'20140218')
% % %                folder = 'UCSF\3C01030';             
% % %            else
               
% %            if strcmp(info_dicom.AcquisitionDate,'20140311')
% %                folder = 'UCSF\3C01031';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140318') & str2num(info_dicom.AcquisitionTime) < 135000
% %                folder = 'UCSF\3C01032';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140318')  & str2num(info_dicom.AcquisitionTime) >= 135000
% %                folder = 'UCSF\3C01033';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140326')
% %                folder = 'UCSF\3C01034';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140409')
% %                folder = 'UCSF\3C01035';
% %            else
           if strcmp(info_dicom.AcquisitionDate,'20140414')
               folder = 'UCSF\3C01036';
           elseif strcmp(info_dicom.AcquisitionDate,'20140415')
               folder = 'UCSF\3C01037';
           elseif strcmp(info_dicom.AcquisitionDate,'20140417')
               folder = 'UCSF\3C01038';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140422')
% %                folder = 'UCSF\3C01039';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140428')
% %                folder = 'UCSF\3C01040';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140505')
% %                folder = 'UCSF\3C01041';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140508')
% %                folder = 'UCSF\3C01042';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140512')
% %                folder = 'UCSF\3C01043';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140514')
% %                folder = 'UCSF\3C01044';
           elseif strcmp(info_dicom.AcquisitionDate,'20140515')
               folder = 'UCSF\3C01045';
           elseif strcmp(info_dicom.AcquisitionDate,'20140519')
               folder = 'UCSF\3C01046';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140520')
% %                folder = 'UCSF\3C01047';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140527')
% %                folder = 'UCSF\3C01048';
           elseif strcmp(info_dicom.AcquisitionDate,'20140605')
               folder = 'UCSF\3C01049';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140612')
% %                folder = 'UCSF\3C01050';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140618') & str2num(info_dicom.AcquisitionTime) < 137000
% %                folder = 'UCSF\3C01051';
           elseif ((strcmp(info_dicom.AcquisitionDate,'20140618') & str2num(info_dicom.AcquisitionTime) >= 137000) | strcmp(info_dicom.AcquisitionDate,'20140620'))
               folder = 'UCSF\3C01052';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140623')
% %                folder = 'UCSF\3C01053';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140624')
% %                folder = 'UCSF\3C01054';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140709')
% %                folder = 'UCSF\3C01055';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140715')
% %                folder = 'UCSF\3C01056';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140721')
% %                folder = 'UCSF\3C01057';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140731')
% %                folder = 'UCSF\3C01058';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140805')
% %                folder = 'UCSF\3C01059';
% %            elseif strcmp(info_dicom.AcquisitionDate,'20140807')
% %                folder = 'UCSF\3C01060';    
           
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
            catch
                count2 = count2 + 1
               continue;                
            end
             
      count = count + 1
                
       end      
       
%%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag_proc = 0;  
if flag_proc 
   file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;   
        
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
    if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
       
              
         try    
            info_dicom = dicominfo(fullfilename_read);
         catch
               continue;
         end
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
           paddle = uint8(info_dicom.Private_0019_1026);
           kvp = info_dicom.KVP;
           view = info_dicom.ViewPosition;
           if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
           else
               mas = info_dicom.ExposureinuAs/1000;
           end
           %mas = info_dicom.ExposureInuAs/1000;
           
           comments = info_dicom.ImageComments;
           force = info_dicom.CompressionForce;
                   
           if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')
                  file_short = 'LECC';
           elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & strfind(mode, 'MANUAL')
                  file_short = 'HECC';
           elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')
                  file_short = 'LEML';
           elseif  strfind(view, 'ML') & strfind(mode, 'MANUAL') & kvp == 39
                  file_short = 'HEML';       
           elseif strfind(mode, 'MANUAL')      
              if kvp==25  
                  file_short = 'DC';
              elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
                  file_short = 'CPHE';
              elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]) & force ~= 0)                                          )
                  file_short = ['CPLE',num2str(kvp)];
                  
                  
              elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
                   file_short = 'FFHE';
              elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
                   file_short = ['FFLE',num2str(kvp)]; 
              elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
                  file_short = ['GEN3',num2str(kvp)];    
              
              end
           end
                 
            mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
            png_filename=[dirname_towritepng, file_short(1:end), 'raw.png' ];
            save(mat_filename, 'info_dicom');
            XX = dicomread(info_dicom);
           
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
            clear XX;
           
            imwrite(uint16(XX1),png_filename,'PNG');
            count = count + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
        
    else
        if  ~isdir(fullfilename_read)
           
        end
    end
   
  end
       
end    
   %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_names = dir(dirname_forpres); %returns the list of files in the specified directory
    sza = size(file_names);
    count2 = 0;
    lenf = sza(1);
    warning off;   
  
  for k = 3:lenf
    
    filename_read = file_names(k).name;
    fullfilename_read = [dirname_forpres,'\',filename_read];
    [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
    name2 = [pathstr,'\',name];
    if ~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
        try
        info_dicom = dicominfo(fullfilename_read);
         catch
               continue;
         end
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
           paddle = uint8(info_dicom.Private_0019_1026);
           kvp = info_dicom.KVP;
           view = info_dicom.ViewPosition;
           if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
           else
               mas = info_dicom.ExposureinuAs/1000;
           end
           %mas = info_dicom.ExposureInuAs/1000;
           comments = info_dicom.ImageComments;
           force = info_dicom.CompressionForce;
          
           if strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER') & (kvp ~= 39)
                  file_short = 'LECC';
           elseif  strfind(view, 'CC') & (kvp == 39 & (mas>53 & mas<57)) & (strfind(mode, 'MANUAL') | strfind(mode, 'AUTO_FILTER'))
                  file_short = 'HECC';
           elseif strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER') & (kvp ~= 39)
                  file_short = 'LEML';
           elseif  strfind(view, 'ML')  & kvp == 39 & ( strfind(mode, 'MANUAL') | strfind(mode, 'AUTO_FILTER'))
                  file_short = 'HEML';       
           elseif strfind(mode, 'MANUAL')      
              if kvp==25  
                  file_short = 'DC';
              elseif (kvp == 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109])) )
                  file_short = 'CPHE';
              elseif (kvp~= 39 & (paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]) & force ~= 0)                                          )
                  file_short = ['CPLE',num2str(kvp)];
              elseif (kvp== 39 & paddle(1:4) == uint8([78;111;110;101]))
                   file_short = 'FFHE';
              elseif (kvp~= 39 & paddle(1:4) == uint8([78;111;110;101]))
                   file_short = ['FFLE',num2str(kvp)]; 
              elseif (kvp~= 39 & ((paddle(1:4) == uint8([50;52;99;109]) | paddle(1:4) == uint8([49;56;99;109]))) & force == 0 )  %(thickness > 88 & thickness < 92)
                  file_short = ['GEN3',num2str(kvp)];    
              
              end
           end
           
                 
            mat_filename=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];
            png_filename=[dirname_towritepngPres, file_short(1:end), 'Pres.png' ];
            save(mat_filename, 'info_dicom');
            XX = dicomread(info_dicom);
           
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
            clear XX;
           
            imwrite(uint16(XX1),png_filename,'PNG');
            count2 = count2 + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
        
    else
        if  ~isdir(fullfilename_read)
           
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
