function png_projectionscreation()
global ctrl
    
%     parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\BR3D_40cm']; 
    parentdir =  uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\BR3D_40cm')
    index = findstr(parentdir,'\');
    ind_last = index(end);
    dir_short = parentdir(ind_last+1:end);
    dirname_toread = parentdir;       
    dirname_towritepngcut = '\png_files';
    dirname_towritematcut = '\mat_files';
       
    mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
    mkdir(parentdir,dirname_towritematcut);
     
    dirname_towritepng = [dirname_toread,'\png_files\'];
    dirname_towritemat = [dirname_toread,'\mat_files\'];
    
    file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;  
   
    
    
    for k = 3:lenf        
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,'\',filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read); %,versn
        name2 = [pathstr,'\',name];
        if length(ext) > 4
            ext = [];
        end
        kvp = [];
        if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
                
             info_dicom = dicominfo(fullfilename_read);
%             pivot_str='dd-mmm-yyyy HH:MM:SS';
%             mode = info_dicom.ExposureControlMode;
%             thickness = info_dicom.BodyPartThickness;
%             paddle = uint8(info_dicom.Private_0019_1026);
             kvp = info_dicom.KVP;
%             view = info_dicom.ViewPosition;
%             
%             if isfield(info_dicom,'ExposureInuAs')
%                 mas = info_dicom.ExposureInuAs/1000;
%             else
%                 mas = info_dicom.ExposureinuAs/1000;
%             end
%             
%             comments = info_dicom.ImageComments;
%             force = info_dicom.CompressionForce;
%             %time =  str2num(info_dicom.AcquisitionTime);
%             time_acq =info_dicom.AcquisitionTime;
%             date_acq =info_dicom.AcquisitionDate;
%             time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
%             date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
%             date_vect = [date_arr,time_arr];
%             time = datenum(date_vect);
            if kvp == 49        
                file_short = [dir_short,name(end)];
            else
                file_short = [dir_short,name(end)];
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
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
         else
            if  ~isdir(fullfilename_read)
                
            end
        end
end   

  
