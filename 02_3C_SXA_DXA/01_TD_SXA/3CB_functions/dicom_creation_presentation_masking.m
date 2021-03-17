function dicom_3C_CDupload()
 global ctrl
  for i=[1:1]
     dirname_toread  = '\\researchstg\aaData\Breast Studies\3C_data\ConvertIntoPresentation\DICOM_forpresentation';
        
    dirname_towritepng = [dirname_toread,'\png_files\'];
    dirname_towritemat = [dirname_toread,'\mat_files\'];        
   
%     dirnamepng_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
%     dirnamemat_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\mat_files\';   
       
    
filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionKey)])));
PatientID=cell2mat(mxDatabase(Database.Name,['select patient_ID from acquisition where acquisition_id=',num2str(AcquisitionKey)]));
StudyID=cell2mat(mxDatabase(Database.Name,['select study_ID from acquisition where acquisition_id=',num2str(AcquisitionKey)]));
View=cell2mat(mxDatabase(Database.Name,['select view_description from acquisition,mammo_view where mammo_view.mammoview_id=acquisition.view_id and acquisition_id=',num2str(AcquisitionKey)]));

dicomwrite(uint16(Image.image), [filename(1:end-4),'.dcm'], 'PatientID',PatientID,'StudyID',StudyID,'PatientOrientation',View);


    %%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;   
        count3 = 0;
 
  for k = 3:lenf
    
    filename_read = file_names(k).name;
    fullfilename_readPres = [ dirname_toread,'\',filename_read];
    [pathstr,name,ext] = fileparts(fullfilename_readPres);     %,versn
    name2Pres = [pathstr,'\',name];
    if ~isdir(name2Pres)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
        
        info_dicom = dicominfo(fullfilename_readPres);
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
%            paddle = uint8(info_dicom.Private_0019_1026);
           kvp = info_dicom.KVP;
           view = info_dicom.ViewPosition;
           if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
           else
               mas = info_dicom.ExposureinuAs/1000;
            end
          % mas = info_dicom.ExposureInuAs/1000;
           comments = info_dicom.ImageComments;
           force = info_dicom.CompressionForce;
          %time = info_dicom.AcquisitionTime;
           time_acq =info_dicom.AcquisitionTime;
           date_acq =info_dicom.AcquisitionDate;
           time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
           date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
           date_vect = [date_arr,time_arr];
           time = datenum(date_vect);
           age = str2num(info_dicom.PatientAge(1:3));
          

    count3 = count3 + 1
    name
   files_missing{count3,1} = name;
   
   
end
        
            mat_filename=[dirname_towritemat, patient_id, '.mat' ];
            png_filename=[dirname_towritepng, patient_id, '.png' ];
            mat_filenameorig=[dirname_towritemat, patient_id, '_orig.mat' ];
            png_filenameorig=[dirname_towritepng, patient_id, '_orig.png' ]
            
            save(mat_filename, 'info_dicom');
            save(mat_filenameorig, 'info_dicom');
            
            XX = dicomread(info_dicom);
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
                       
            imwrite(uint16(XX1),png_filename,'PNG');                   
            imwrite(uint16(XX),png_filenameorig,'PNG'); 
            clear XX;
            clear XX1;
            count = count + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
        
    else
     nn =  name2Pres 
    end
   
  end
  a = 1;
  end
  
   

