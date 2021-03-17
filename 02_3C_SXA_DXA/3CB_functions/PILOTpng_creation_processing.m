function dicom_3C_CDupload()
 global ctrl
  for i=[1:1]
     dirname_toread  = '\\researchstg\aaData\Breast Studies\3C_data\ConvertIntoPresentation\DICOM_forprocessing\rest_dicoms';
        
%     dirname_towritepng = [dirname_toread,'\png_files\'];
%     dirname_towritemat = [dirname_toread,'\mat_files\'];        
   
     dirname_towritepng = '\\researchstg\aaData\Breast Studies\3C_data\ConvertIntoPresentation\DICOM_forprocessing\png_files\';
    dirname_towritemat = '\\researchstg\aaData\Breast Studies\3C_data\ConvertIntoPresentation\DICOM_forprocessing\mat_files\'; 
    
%     dirnamepng_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
%     dirnamemat_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\mat_files\';   
       
    
    %%%%%%%%%% For Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;   
        count3 = 0;
        count4 = 0;
  for k = 3:lenf
    try
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
%            thickness = info_dicom.BodyPartThickness;
%            paddle = uint8(info_dicom.Private_0019_1026);
           kvp = info_dicom.KVP;
           view = info_dicom.ViewPosition;
           if isfield(info_dicom,'ExposureInuAs')
                mas = info_dicom.ExposureInuAs/1000;
           else
               mas = info_dicom.ExposureinuAs/1000;
            end
          % mas = info_dicom.ExposureInuAs/1000;
%            comments = info_dicom.ImageComments;
%            force = info_dicom.CompressionForce;
          %time = info_dicom.AcquisitionTime;
%            time_acq =info_dicom.AcquisitionTime;
    if    isfield(info_dicom,'AcquisitionDate')
          date_acq =info_dicom.AcquisitionDate;
    else          
             date_acq = 'NO';
    end    
%            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
%            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
%            date_vect = [date_arr,time_arr];
%            time = datenum(date_vect);
    if    isfield(info_dicom,'PatientAge')
         age = str2num(info_dicom.PatientAge(1:3));
    else          
            age = '000Y';
    end   
           
          

file_short = [];
if strfind(view, 'CC') & kvp == 25 & mas == 81.9
    patient_id = '3CB011_CC';
elseif strfind(view, 'ML') & kvp == 24 & mas == 71.8   
    patient_id = '3CB011_ML' ; 
elseif strfind(view, 'CC') & kvp == 25 & mas == 90.6
    patient_id = '3CB015_CC';
elseif strfind(view, 'ML') & kvp == 25 & mas == 84.3   
    patient_id = '3CB015_ML'; 
elseif strfind(view, 'CC') & kvp == 25 & mas == 90.6
    patient_id = '3CB015_CC';
elseif strfind(view, 'ML') & kvp == 25 & mas == 84.3   
    patient_id = '3CB015_ML';    
elseif strfind(view, 'CC') & kvp == 25 & mas == 110.2
    patient_id = '3CB022_CC';
elseif strfind(view, 'ML') & kvp == 25 & mas == 95.4  
    patient_id = '3CB022_ML';   
elseif strfind(view, 'CC') & kvp == 25 & mas == 101.4
    patient_id = '3CB031_CC';
elseif strfind(view, 'ML') & kvp == 25 & mas == 94.4  
    patient_id = '3CB031_ML';     
elseif strfind(view, 'CC') & kvp == 25 & mas == 72.6
    patient_id = '3CB037_CC';
elseif strfind(view, 'ML') & kvp == 25 & mas == 89.7  
    patient_id = '3CB037_ML';     
elseif strfind(view, 'CC') & kvp == 26 & mas == 81.7
    patient_id = '3CB025_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 75.2  
    patient_id = '3CB025_ML'; 
elseif strfind(view, 'CC') & kvp == 26 & mas == 125.8
    patient_id = '3CB047_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 94.9  
    patient_id = '3CB047_ML'; 
elseif strfind(view, 'CC') & kvp == 27 & mas == 129.3
    patient_id = '3CB027_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 139.5  
    patient_id = '3CB027_ML'; 
elseif strfind(view, 'CC') & kvp == 27 & mas == 89.9
    patient_id = '3CB032_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 83.2  
    patient_id = '3CB032_ML';     
elseif strfind(view, 'CC') & kvp == 27 & mas == 75.3
    patient_id = '3CB042_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 96.7  
    patient_id = '3CB042_ML';     
elseif strfind(view, 'CC') & kvp == 27 & mas == 89.8
    patient_id = '3CB050_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 100.8  
    patient_id = '3CB050_ML';  
elseif strfind(view, 'CC') & kvp == 28 & mas == 76.9
    patient_id = '3CB016_CC';
elseif strfind(view, 'ML') & kvp == 27 & mas == 80  
    patient_id = '3CB016_ML';      
elseif strfind(view, 'CC') & kvp == 28 & mas == 78.5
    patient_id = '3CB035_CC';
elseif strfind(view, 'ML') & kvp == 28 & mas == 98.7  
    patient_id = '3CB035_ML';     
elseif strfind(view, 'CC') & kvp == 29 & mas == 134
    patient_id = '3CB018_CC';
elseif strfind(view, 'ML') & kvp == 28 & mas == 115.5  
    patient_id = '3CB018_ML';     
elseif strfind(view, 'CC') & kvp == 29 & mas == 86.1
    patient_id = '3CB029_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 76.9  
    patient_id = '3CB029_ML';       
elseif strfind(view, 'CC') & kvp == 29 & mas == 76.1
    patient_id = '3CB033_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 75.2 
    patient_id = '3CB033_ML';    
elseif strfind(view, 'CC') & kvp == 29 & mas == 83.2
    patient_id = '3CB036_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 88.9 
    patient_id = '3CB036_ML';      
elseif strfind(view, 'CC') & kvp == 29 & mas == 54.2
    patient_id = '3CB041_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 65.1 
    patient_id = '3CB041_ML';      
elseif strfind(view, 'CC') & kvp == 30 & mas == 75.1
    patient_id = '3CB014_CC';
elseif strfind(view, 'ML') & kvp == 29 & mas == 75.9 
    patient_id = '3CB014_ML';  
elseif strfind(view, 'CC') & kvp == 30 & mas == 69.1
    patient_id = '3CB021_CC';
elseif strfind(view, 'ML') & kvp == 29 & mas == 81.1 
    patient_id = '3CB021_ML';    
elseif strfind(view, 'CC') & kvp == 30 & mas == 69.9
    patient_id = '3CB038_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 88 
    patient_id = '3CB038_ML';   
elseif strfind(view, 'CC') & kvp == 30 & mas == 59
    patient_id = '3CB044_CC';
elseif strfind(view, 'ML') & kvp == 29 & mas == 58.1 
    patient_id = '3CB044_ML';       
elseif strfind(view, 'CC') & kvp == 30 & mas == 72.9
    patient_id = '3CB045_CC';
elseif strfind(view, 'ML') & kvp == 29 & mas == 78 
    patient_id = '3CB045_ML';    
elseif strfind(view, 'CC') & kvp == 30 & mas == 53.2
    patient_id = '3CB046_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 55 
    patient_id = '3CB046_ML';     
elseif strfind(view, 'CC') & kvp == 30 & mas == 64
    patient_id = '3CB048_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 91.9 
    patient_id = '3CB048_ML';    
elseif strfind(view, 'CC') & kvp == 31 & mas == 60.7
    patient_id = '3CB012_CC';
elseif strfind(view, 'ML') & kvp == 31 & mas == 65.7 
    patient_id = '3CB012_ML';        
elseif strfind(view, 'CC') & kvp == 31 & mas == 143.4
    patient_id = '3CB019_CC';
elseif strfind(view, 'ML') & kvp == 30 & mas == 96.8 
    patient_id = '3CB019_ML';       
elseif strfind(view, 'CC') & kvp == 31 & mas == 56
    patient_id = '3CB023_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 134.9 
    patient_id = '3CB023_ML';      
elseif strfind(view, 'CC') & kvp == 31 & mas == 101.7
    patient_id = '3CB026_CC';
elseif strfind(view, 'ML') & kvp == 31 & mas == 98.5 
    patient_id = '3CB026_ML';   
elseif strfind(view, 'CC') & kvp == 32 & mas == 62.7
    patient_id = '3CB010_CC';
elseif strfind(view, 'ML') & kvp == 33 & mas == 82.9 
    patient_id = '3CB010_ML';       
elseif strfind(view, 'CC') & kvp == 32 & mas == 80
    patient_id = '3CB013_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 109 
    patient_id = '3CB013_ML';      
elseif strfind(view, 'CC') & kvp == 32 & mas == 98
    patient_id = '3CB017_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 114.8 
    patient_id = '3CB017_ML';       
elseif strfind(view, 'CC') & kvp == 32 & mas == 100.8
    patient_id = '3CB020_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 133.9 
    patient_id = '3CB020_ML';   
elseif strfind(view, 'CC') & kvp == 32 & mas == 115
    patient_id = '3CB024_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 114.9 
    patient_id = '3CB024_ML';  
elseif strfind(view, 'CC') & kvp == 32 & mas == 72.3
    patient_id = '3CB028_CC';
elseif strfind(view, 'ML') & kvp == 31 & mas == 91.9 
    patient_id = '3CB028_ML';      
elseif strfind(view, 'CC') & kvp == 32 & mas == 122.7
    patient_id = '3CB030_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 100.8 
    patient_id = '3CB030_ML';     
elseif strfind(view, 'CC') & kvp == 32 & mas == 128.2  & age == 47
    patient_id = '3CB034_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 128   & age == 47
    patient_id = '3CB034_ML'; 
elseif strfind(view, 'CC') & kvp == 32 & mas == 84.9
    patient_id = '3CB039_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 78 
    patient_id = '3CB039_ML'; 
elseif strfind(view, 'CC') & kvp == 32 & mas == 113.9
    patient_id = '3CB040_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 119.4 
    patient_id = '3CB040_ML';         
elseif strfind(view, 'CC') & kvp == 32 & mas == 78.9
    patient_id = '3CB043_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 115  & age == 64
    patient_id = '3CB043_ML';         
elseif strfind(view, 'CC') & kvp == 32 & mas == 127.6
    patient_id = '3CB049_CC';
elseif strfind(view, 'ML') & kvp == 32 & mas == 115 & age == 44  % add
    patient_id = '3CB049_ML';            
elseif strfind(view, 'CC') & kvp == 25 & age == 68
    patient_id = '3CB009_CC';
elseif strfind(view, 'ML') & kvp == 24 & age == 68
    patient_id = '3CB009_ML';    
elseif strfind(view, 'CC') & kvp == 26 & age == 49
    patient_id = '3CB007_CC';
elseif strfind(view, 'ML') & kvp == 25 & age == 49
    patient_id = '3CB007_ML';  
elseif strfind(view, 'CC') & kvp == 28 & age == 80
    patient_id = '3CB005_CC';
elseif strfind(view, 'ML') & kvp == 28 & age == 80
    patient_id = '3CB005_ML';   
elseif strfind(view, 'CC') & kvp == 28 & age == 60
    patient_id = '3CB008_CC';
elseif strfind(view, 'ML') & kvp == 29 & age == 60
    patient_id = '3CB008_ML';       
elseif strfind(view, 'CC') & kvp == 29 & age == 57
    patient_id = '3CB006_CC';
elseif strfind(view, 'ML') & kvp == 28 & age == 57
    patient_id = '3CB006_ML';      
elseif strfind(view, 'CC') & strfind(date_acq, '20100127') & age == 59
    patient_id = '3CB001_CC';
elseif strfind(view, 'ML') & strfind(date_acq, '20100127') & age == 59
    patient_id = '3CB001_ML';   
elseif strfind(view, 'CC') & strfind(date_acq, '20100127')  & age == 43
    patient_id = '3CB002_CC';
elseif strfind(view, 'ML') & strfind(date_acq, '20100127') & age == 43
    patient_id = '3CB002_ML';     
elseif strfind(view, 'CC') & strfind(date_acq, '20100114')  & age == 71
    patient_id = '3CB003_CC';
elseif strfind(view, 'ML') & strfind(date_acq, '20100114') & age == 71
    patient_id = '3CB003_ML';    
elseif strfind(view, 'CC') & strfind(date_acq, '20100210')  & age == 44
    patient_id = '3CB004_CC';
elseif strfind(view, 'ML') & strfind(date_acq, '20100210') & age == 44
    patient_id = '3CB004_ML'; 
else
    patient_id = ['UNKNOWN',name];
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
    catch
        count4 = count4 + 1
         files_missing_catch{count4,1} = name;
    end
   
  end
  a = 1;
  end
  
   

