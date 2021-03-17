function dicom_3C_CDupload()
 global ctrl
 
 output_dir = 'C:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CB_pres';
  for i=[1:200]
    patient_name = ['3C01',num2str(i,'%03.0f')];
    parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01',num2str(i,'%03.0f')];
  
   dirname_toreadpres = [parentdir,'\ForPresentation'];
    
   %%%%%%%%%%%%%%%%%%% For Presentation%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file_names = dir(dirname_toreadpres); %returns the list of files in the specified directory
    sza = size(file_names);
    count = 0;
   
    lenf = sza(1);
    warning off;   
  
  for k = 3:lenf
    
        filename_readPres = file_names(k).name;
        fullfilename_readPres = [dirname_toreadpres,'\',filename_readPres];
        [pathstr,name,ext] = fileparts(fullfilename_readPres);     %,versn
        name2Pres = [pathstr,'\',name];
        if ~isdir(name2Pres)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
        
        info_dicom = dicominfo(fullfilename_readPres);
%%%%        creation names for saving mat and png files
           mode = info_dicom.ExposureControlMode;
%            thickness = info_dicom.BodyPartThickness;
%            paddle = uint8(info_dicom.Private_0019_1026);
           kvp = info_dicom.KVP;
           view = info_dicom.ViewPosition;
%            if isfield(info_dicom,'ExposureInuAs')
%                 mas = info_dicom.ExposureInuAs/1000;
%            else
%                mas = info_dicom.ExposureinuAs/1000;
%             end
%           % mas = info_dicom.ExposureInuAs/1000;
%            comments = info_dicom.ImageComments;
%            force = info_dicom.CompressionForce;
%           %time = info_dicom.AcquisitionTime;
%             time_acq =info_dicom.AcquisitionTime;
%            date_acq =info_dicom.AcquisitionDate;
%            time_arr =[str2num(time_acq(1:2)),str2num(time_acq(3:4)),str2num(time_acq(5:6))];
%            date_arr =[str2num(date_acq(1:4)),str2num(date_acq(5:6)),str2num(date_acq(7:8))];
%            date_vect = [date_arr,time_arr];
%            time = datenum(date_vect);
          

            file_short2 = [];
            if (strfind(view, 'CC') & strfind(mode, 'AUTO_FILTER')) & kvp < 38 
                file_short2 = [patient_name,'_CC.dcm'];
            elseif (strfind(view, 'ML') & strfind(mode, 'AUTO_FILTER')) & kvp < 38 
                file_short2 = [patient_name,'_ML.dcm'];
            else
                 file_short2 = [];
             end
             
            if ~isempty(file_short2)
                
                copyfile(fullfilename_readPres,output_dir);
                in_fname = [output_dir,'\',filename_readPres];
                out_fname = [output_dir,'\',file_short2];
                movefile(in_fname,out_fname);
               count = count + 1
            end
            
            
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
        
    else
        if  ~isdir(fullfilename_readPres)
           
        end
    end
   
  end
  end
  
   

