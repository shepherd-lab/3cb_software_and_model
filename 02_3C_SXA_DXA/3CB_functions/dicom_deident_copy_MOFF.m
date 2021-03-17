function dicom_deident_copy_UCSF()
%% patient loop
for i=[2:203]
    %       for i=[164:164]
    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02',num2str(i,'%03.0f')];
    outputdir = '\\researchstg\aaData\Breast Studies\iCAD\DICOM_images\Moffitt\ForProcessing\';
    outputdir_pres = '\\researchstg\aaData\Breast Studies\iCAD\DICOM_images\Moffitt\ForPresentation\';
    dirname_toread = parentdir;
    index = strfind(parentdir, '\');
    patient_name = parentdir(index(end)+1:end);
    
    dirname_forprescut = '\ForPresentation';
    dirname_forpres = [dirname_toread,dirname_forprescut];
  
    dirname_towritepngcut = '\png_files';
    dirname_towritematcut = '\mat_files';
    dirname_forprescut = '\ForPresentation';
    dirname_forpres = [dirname_toread,dirname_forprescut];    
 
    dirname_towritepng = [dirname_toread,'\png_files\'];
    dirname_towritemat = [dirname_toread,'\mat_files\'];
    
    dirname_towritepngPres = [dirname_forpres,'\png_files\'];
    dirname_towritematPres = [dirname_forpres,'\mat_files\'];
    output_error = [];
    
    try
    
    %% for processing
    file_names = dir(dirname_toread); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;
   for k = 3:lenf        
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_toread,'\',filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
        name2 = [pathstr,'\',name];
        if length(ext) > 4
            ext = [];
        end
        
        if ~isdir(fullfilename_read) & isdicom(fullfilename_read)    %((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
           info_dicom = dicominfo(fullfilename_read);
           mode2 = info_dicom.ExposureControlMode;
           view = info_dicom.ViewPosition;
           %file_short = 'LECC';
%            if ~(~isempty(strfind(info_dicom.PatientID,'DE-IDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'DEIDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'3C11')))
%                dicom_3CBdeidentify(fullfilename_read);
% %                     mat_filenamePres=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];                       
% %                     save(mat_filenamePres, 'info_dicom');
%            end
            if (~isempty(strfind(view, 'CC')) & (~isempty(strfind(mode2, 'AUTO_FILTER')) | ~isempty(strfind(mode2, 'TEC')))) & info_dicom.KVP < 38 
                 fullfilename_write = [outputdir,patient_name,'_',view(1:2),'.dcm'];
                 copyfile(fullfilename_read,fullfilename_write,'f');
            elseif (~isempty(strfind(view, 'ML')) & (~isempty(strfind(mode2, 'AUTO_FILTER')) | ~isempty(strfind(mode2, 'TEC')))) & info_dicom.KVP < 38
                % file_short = 'LEML';                
                 fullfilename_write = [outputdir,patient_name,'_',view(1:2),'.dcm'];
                 copyfile(fullfilename_read,fullfilename_write,'f');
            end               
        end        
        
   end    
 
           
    %% for presentation
    file_names = dir(dirname_forpres); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
    lenf = sza(1);
    warning off;
    for k = 3:lenf        
        filename_read = file_names(k).name;
        fullfilename_read = [dirname_forpres,'\',filename_read];
        [pathstr,name,ext] = fileparts(fullfilename_read);     %,versn
        name2 = [pathstr,'\',name];
        if length(ext) > 4
            ext = [];
        end
        if ~isdir(fullfilename_read) & isdicom(fullfilename_read) %((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
           info_dicom = dicominfo(fullfilename_read);
           mode2 = info_dicom.ExposureControlMode;
           view = info_dicom.ViewPosition;
           %file_short = 'LECC';
%            if ~(~isempty(strfind(info_dicom.PatientID,'DE-IDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'DEIDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'3C11')))
%                dicom_3CBdeidentify(fullfilename_read);
% %                     mat_filenamePres=[dirname_towritematPres, file_short(1:end), 'Pres.mat' ];                       
% %                     save(mat_filenamePres, 'info_dicom');
%            end
             if (~isempty(strfind(view, 'CC')) & (~isempty(strfind(mode2, 'AUTO_FILTER')) | ~isempty(strfind(mode2, 'TEC')))) & info_dicom.KVP < 38 
                 fullfilename_write = [outputdir_pres,patient_name,'_',view(1:2),'.dcm'];
                 copyfile(fullfilename_read,fullfilename_write,'f');
            elseif (~isempty(strfind(view, 'ML')) & (~isempty(strfind(mode2, 'AUTO_FILTER')) | ~isempty(strfind(mode2, 'TEC')))) & info_dicom.KVP < 38
                % file_short = 'LEML';                
                 fullfilename_write = [outputdir_pres,patient_name,'_',view(1:2),'.dcm'];
                 copyfile(fullfilename_read,fullfilename_write,'f');
            end               
        end        
    end 
    catch
        pat_error = [patient_name,'_',view(1:2)];
        output_error = [output_error; pat_error]
    end
end   
a = 1;    
% if ((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
%            info_dicom = dicominfo(fullfilename_read);
%            mode2 = info_dicom.ExposureControlMode;
%            view = info_dicom.ViewPosition;        
%             if strfind(view, 'CC') & strfind(mode2, 'AUTO_FILTER')
%                  file_short = 'LECC';
%                  if ~(~isempty(strfind(info_dicom.PatientID,'DE-IDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'DEIDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'3C11')))
%                     dicom_3CBdeidentify(fullfilename_read); 
% %                     mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% %                     save(mat_filename, 'info_dicom');
% %                     copyfile(mat_filename,dirname_towritepng);
%                  end
%                  fullfilename_write = [outputdir,patient_name,'_',view(1:2),'.dcm'];
%                  copyfile(fullfilename_read,fullfilename_write,'f');
% %                  mat_filename1=[dirname_towritemat, file_short(1:end), '*raw.mat' ];
% %                  fn = dir(mat_filename1);
% %                  mat_filename = [dirname_towritemat,fn.name];
% %                  save(mat_filename, 'info_dicom');
% %                  copyfile(mat_filename,dirname_towritepng);
%     
%              elseif strfind(view, 'ML') & strfind(mode2, 'AUTO_FILTER')
%                  file_short = 'LEML';
%                  if ~(~isempty(strfind(info_dicom.PatientID,'DE-IDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'DEIDENTIFIED')) | ~isempty(strfind(info_dicom.PatientID,'3C11')))
%                     dicom_3CBdeidentify(fullfilename_read); 
% %                     mat_filename=[dirname_towritemat, file_short(1:end), 'raw.mat' ];
% %                     save(mat_filename, 'info_dicom');
% %                     copyfile(mat_filename,dirname_towritepng);
%                  end
%                  fullfilename_write = [outputdir,patient_name,'_',view(1:2),'.dcm'];
%                  copyfile(fullfilename_read,fullfilename_write,'f');
%             end               
%         end        
%     
    
  



