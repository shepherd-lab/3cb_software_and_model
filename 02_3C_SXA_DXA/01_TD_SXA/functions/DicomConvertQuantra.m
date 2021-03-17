function pull_samples_featureslist_andCreateDICOMs

Database.Name='mammo_CPMC';

film_identifier=lower('CPMC');
dvd_str = findstr('dvd',film_identifier);
count = 1;
% [FileName,PathName] = uigetfile('\\researchstg\aaStudies\Breast Studies\Subtypes - Vachon\Quantra\*.txt');
[FileName,PathName] = uigetfile('\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Auto Dense Study\Reading List\Acq list Test\*.txt');
acqs_filename = [PathName,FileName];
acq_list = textread(acqs_filename,'%u');

%acqs_filename = ['temp.txt'];
%acq_list = textread(acqs_filename,'%u');

%destination='D:\sample_featureslist';
%dirname_towrite = 'F:\SFMR_cohort_study\';
% dirname_towrite = '\\researchstg\aaData\Quantra_Mayo\';
%dirname_towrite = 'D:\sample_featurelist_DICOMs\';

dirname_towrite ='\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Auto Dense Study\Reading List\Acq list Test\';

date_driveI = datenum('20081231', 'yyyymmdd');
date_driveK = datenum('20090930', 'yyyymmdd');

str = computer;
i=1
[ret, comp_name] = system('hostname');
%dos 'C:\dcmtk-3.6.0-win32-i386\bin\storescp.exe -v -od "D:\Hologic Cenova output" -aet "KPServer" 6100')

while i<=length(acq_list);
    try
        % %         acq_id = acq_list(i);
        % %         b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
        % %         fname=strcat(cell2mat(b(17)),'');   %erase extra ' '
        % %         %Info.fname = fname;
        % %         %fname(1:2) = [];
        % %         %fname_init = fname;
        % %         index_slash = find(fname=='\');
        % %         fname = fname(index_slash(end)+1: end);
        % %         fname_short = fname;
        % %         str = computer;
        % %         patient_id=cell2mat(b(3));
        % %         Analysis.patient_id = patient_id;
        % %         Info.machine_id=num2str(b{1,7});
        % %
        % %         %digitizer
        % %         SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
        % %         a=mxDatabase(Database.Name,SQLstatement);
        % %         Info.DigitizerId=cell2mat(a(1));
        % %         Info.DigitizerDescription=cell2mat(a(2));
        % %         Info.study_id = lower(b(2));
        % %         date_driveI = datenum('20081231', 'yyyymmdd');
        % %         date_driveKM = datenum('20090930', 'yyyymmdd');
        % %         date_driveK = datenum('20110630', 'yyyymmdd');
        % %         date_driveN = datenum('20120601', 'yyyymmdd');
        % %         date_driveNK=datenum('20120501', 'yyyymmdd'); % Modified by Amir 04032013
        % %         if ~isempty(cell2mat(b(2)))
        % %             study_id = lower(b(2));
        % %             study_id = study_id{1};
        % %         else
        % %             study_id = 'none';
        % %         end
        % %         %%%%%%%%%%%%%%%%%% Error: It was before declaration of digitizer
        % %         %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %         if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
        % %             crop_coef = kGE;
        % %         else
        % %             crop_coef = 1;
        % %         end
        % %
        % %         if ~isempty(cell2mat(b(5)))
        % %             film_identifier = lower(b(5));
        % %             film_identifier = film_identifier{1};
        % %             try
        % %                 if film_identifier=='                    '
        % %                     film_identifier = lower(b(2));
        % %                     film_identifier = film_identifier{1};
        % %                 end
        % %             end
        % %         else
        % %             film_identifier = 'none';
        % %         end
        % %         Analysis.film_identifier = film_identifier;
        % %         [ret, comp_name] = system('hostname');
        % %         image_columns = [];
        % %         image_size = [];
        % %         if Info.DigitizerId >= 4  & Info.DigitizerId <= 7 %| Info.DigitizerId == 11 %digitalInfo.DigitizerId >= 4 %digital
        % %             dvd_str = findstr('dvd',film_identifier);
        % %             %date_acq = b{1,6}; %5/1/09: JW replaced with study_date from DICOMinfo table
        % %
        % %             if ~strcmp(Database.Name,'mammo')
        % %                 c=mxDatabase(Database.Name,['select * from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
        % %                 %image_columns =mxDatabase(Database.Name,['select columns from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
        % %
        % %                 if ~isempty(c)
        % %                      date_acq = c{1,204};
        % %                      image_columns = cell2mat(c(29))/2;
        % %                       if image_columns > 1350*crop_coef
        % %                          flag.small_paddle = false;
        % %                         else
        % %                             flag.small_paddle = true;
        % %                         end
        % %                 else
        % %                      cacq =mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
        % %                      date_acq = cacq{1,6};
        % %                      image_size = cacq{1,20};
        % %                       if image_size > 3288177
        % %                     flag.small_paddle = false;
        % %                 else
        % %                     flag.small_paddle = true;
        % %                  end
        % %                 end
        % %               Info.date_acq = date_acq;
        % %
        % %                 folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
        % %             end
        % %
        % %             fg = strcmp(film_identifier(1:3),'non')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        acq_id = acq_list(i);
        c=mxDatabase(Database.Name,['select * from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(acq_id),')']);
        date_acq = c{1,204};
        folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
        
        date_acq_num = datenum(date_acq, 'yyyymmdd');
        
        b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(acq_id)]);
        Study_id= cell2mat(b(2))
        patient_id=cell2mat(b(3))
        
        
        
        if ~isempty(cell2mat(b(5)))
            film_identifier = lower(b(5));
            film_identifier = film_identifier{1};
            try
                if film_identifier=='                    '
                    film_identifier = lower(b(2));
                    film_identifier = film_identifier{1};
                end
            end
        else
            film_identifier = cell2mat(b(2));
        end
        
        
        date_driveKM = datenum('20090930', 'yyyymmdd');
        date_driveK = datenum('20110630', 'yyyymmdd');
        
        date_driveMGH=datenum('20120501', 'yyyymmdd');
        date_driveMGH1=datenum('20130501', 'yyyymmdd');
        date_driveN = datenum('20120601', 'yyyymmdd');
        date_driveUVM=datenum('20120901', 'yyyymmdd');
        date_driveUVM1=datenum('20130401', 'yyyymmdd');
        date_driveCP=datenum('20130631', 'yyyymmdd');
        date_driveUCSF=datenum('20130901', 'yyyymmdd');
        
        dvd_str = findstr('dvd',film_identifier);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:4),'cpuc') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not') | strcmp(film_identifier(1:3),'non')| strcmp(film_identifier(1),'0') | strcmp(film_identifier(1),'1')) %for CPMC
            date_acq_num = datenum(date_acq, 'yyyymmdd');
            %date_driveI = datenum('20081231', 'yyyymmdd');
            %date_driveK = datenum('20110630', 'yyyymmdd');
            
            if date_acq_num > date_driveN
                start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC';
            elseif date_acq_num > date_driveK
                start_dir = '\\researchstg\aaDATA5\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA5\Breast Studies\CPMC';
            elseif date_acq_num > date_driveI
                start_dir = '\\researchstg\aaDATA4\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA4\Breast Studies\CPMC';
            else
                start_dir = '\\researchstg\aaDATA2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA2\Breast Studies\CPMC';
                
            end
        elseif strcmp(film_identifier(1:3),'mgh') % for MGH
            date_acq_num = datenum(date_acq, 'yyyymmdd');
            %                 if date_acq_num > date_driveNK % added by Amir 04032013
            %                     start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Added by Amir 04032013
            %                     startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH'; %Added by Amir 04032013
            %                 elseif date_acq_num > date_driveKM % (else added to if)Updated by Amir 04032013
            if date_acq_num > date_driveKM
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'K:\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA5\Breast Studies\MGH';
                else
                    start_dir = '\\researchstg\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA5\Breast Studies\MGH';
                end
            else
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = '\\researchstg\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = 'L:\aaDATA6\Breast Studies\MGH';
                else
                    start_dir = '\\researchstg\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA6\Breast Studies\MGH';
                end
            end
        elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
            if strcmp(comp_name(1:4),'Ming')
                start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
            else
                start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
            end
            folder = [];
        elseif strcmp(film_identifier(1:3),'ucs')  %for UCSF
            if strcmp(patient_id(1:4),'3C01')
                start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\',patient_id(1:7),'\png_files'];
                startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
                folder = [];
            elseif  ~isempty(strfind(film_identifier,'ucsf_03-12-2014'))
                start_dir = ['\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\png_files'];
                startdir_report = '\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\';
                folder = [];
                
            else
                start_dir = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr';
                
            end
        elseif strcmp(film_identifier(1:3),'mof')  %for UCSF
            start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\',patient_id(1:7),'\png_files'];
            startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
            folder = [];
            
        elseif  ~isempty(strfind(film_identifier,'nc'))%strcmp(film_identifier(1:2),'nc')  %for NC
            if strcmp(comp_name(1:4),'Ming')
                start_dir = '\\researchstg\aaData5\Breast Studies\NC\DicomImagesBlinded(digi)'; % (aaData4 changed to aaData5) updated by Amir 04032013
                startdir_report = 'K:\aaData5\Breast Studies\NC';%(aaData4 changed to aaData5)updated by Amir 04032013
            else
                start_dir = '\\researchstg\aaDATA5\Breast Studies\NC\DicomImagesBlinded(digi)';%(aaData4 changed to aaData5) updated by Amir 04032013
                startdir_report = '\\researchstg\aaDATA5\Breast Studies\NC';%(aaData3 changed to aaData5) updated by Amir 04032013
            end
            folder = [];
            %Case added for Avon, by Song, 1/24/11
        elseif strcmpi(film_identifier(1:3), 'avo')     %for Avon
            if strcmp(comp_name(1:4),'Ming')
                start_dir = '\\researchstg\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                startdir_report = 'D:\aaData\Breast Studies\Shanghai';
            else
                start_dir = '\\researchstg\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaData\Breast Studies\Shanghai';
            end
            folder = [];
            %End of change by Song, 1/24/11
            %Case for Marsden images acquired separately for Volpara, JW 11/7/12
        elseif strcmpi(film_identifier(1:18), 'marsden_11-07-2012')
            if strcmp(comp_name(1:4),'Ming')
                start_dir = '\\researchstg\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                startdir_report = 'K:\aaData5\Breast Studies\Marsden';
            else
                start_dir = '\\researchstg\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaData5\Breast Studies\Marsden';
            end
            folder = [];
            %End change by JW 11/7/12
            %Case added for Marsden, by Song, 1/26/11
        elseif strcmpi(film_identifier(1:3), 'mar')     %for Marsden
            if strcmp(comp_name(1:4),'Ming')
                start_dir = '\\researchstg\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaData3\Breast Studies\Marsden';
            else
                start_dir = '\\researchstg\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                startdir_report = '\\researchstg\aaData3\Breast Studies\Marsden';
            end
            folder = [];
            %End of change by Song, 1/26/11
            %startdir_wfolder = [start_dir,'\',folder];
            %%% JW added 9/3/09 for Bayer GE 2000D images %%%
        elseif strcmp(film_identifier(1:3),'p01')||strcmp(film_identifier(1:3),'po1')||strcmp(film_identifier(1:3),'PO1')
            if strcmp(comp_name(1:4),'Ming')
                %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                start_dir = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\P01';
            else
                if strcmp(b(16),'01-Feb-2010         ')
                    start_dir = '\\researchstg.radiology.ucsf.edu\working_directory\projects-snap\aaSTUDIES\Breast Studies\TLSTY_P01_invivo\Source Data\Mammograms\second batch\DicomImagesBlinded';
                    startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                else
                    start_dir = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                    startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                end
            end
            folder = [];
        elseif strcmp(film_identifier(1:2),'3c')
            if strcmp(comp_name(1:4),'Ming')
                %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                start_dir = '\\researchstg\aaDATA\Breast Studies\3C_data';
                startdir_report = '\\researchstg\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
            else
                start_dir = '\\researchstg\aaDATA\Breast Studies\3C_data';
                startdir_report = '\\researchstg\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
            end
            
            folder = [];
            tempfname=strcat(cell2mat(b(17)),'');   %erase extra ' '
            index_slash = find(tempfname=='\');
            folder = tempfname(index_slash(end-2)+1: index_slash(end));
            
        elseif ~isempty(strfind(study_id,'bayer'))
            if strcmp(comp_name(1:4),'Ming')
                if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                    start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                    startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                else
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
                    start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                    startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                end
            else
                if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                    start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                    startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                else
                    start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                    startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                end
            end
            folder = [];
            %%%end JW added 9/3/09 %%%
        end
        
        
        
        %         elseif Info.DigitizerId == 1
        %             if ~isempty(strfind(lower(study_id),lower('mayo'))) %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
        %                 start_dir = '\\digitizer1\d\DicomImages\Bo_files\Dicom\png_files';
        %                 startdir_report = start_dir;
        %                 folder = [];
        %             end
        %         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        startdir_wfolder = [start_dir,'\',folder];
        fname=strcat(cell2mat(b(23)),'');
        fname = [startdir_wfolder,fname];
        fmat = [fname(1:end-7),'.mat'];
        
        
        
        
        [pathstr,name,ext] = fileparts(fname);
        clear info_dicom_blinded;
        load(fmat);
        info_dicom_blinded.DeviceSerialNumber = 'H1KRHR8416ac98';
        info_dicom_blinded.PatientID = num2str(acq_id);
        info_dicom_blinded.PatientName.FamilyName = patient_id;
        info_dicom_blinded.StudyInstanceUID = [info_dicom_blinded.StudyInstanceUID, '.', num2str(i)];
        clear XX;
        XX = imread(fname);
        XX1=round(OverSamplingN(XX,2));
        
        fname_towrite=[dirname_towrite,name(1:end),'.dcm'];
        
        dicomwrite(XX1,fname_towrite,info_dicom_blinded,'CreateMode','copy');
        
        %note 'C:\Program Files\MATLAB\R2008a\toolbox\images\medformats\private\dicom_prep_ImagePixel.m',
        %which is eventually called by dicomwrite subfunctions, has been temporarily replaced with
        %Barry Ren's (Hologic) modified version to improve
        %compatability with Quantra.
        
        dos (['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe -aet pasha -aec R2SERVER_SCP 128.218.111.82 7100 ', fname_towrite],'-echo')
% % %         dos (['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe -aet NHANES-DXA -aec R2SERVER_SCP 128.218.111.82 7100 ', fname_towrite],'-echo')
        
        %[status, results] = dos('comp', '-echo');
% %         pause(60);
        %pause(10);
        
        i=i+1
        count = i;
        
    catch
        lasterr
        i=i+1;
        k = count
    end
end

