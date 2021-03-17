function DicomConvert

% Written by Amir Pasha M
% 04/07/2014
 
% % %                                                      ___     _____
% % %                                                   0--,|    /OOOOOOO\
% % %                                                   <_/  /  /OOOOOOOOOOO\
% % %                                                      \  \/OOOOOOOOOOOOOOO\
% % %                                                       \ OOOOOOOOOOOOOOOOO|//
% % %                                                        \/\/\/\/\/\/\/\/\/
% % %                                                          //  /     \\  \
% % %                                                          ^^^^^       ^^^^^


Database.Name='mammo_CPMC';

film_identifier=lower('CPMC');
dvd_str = findstr('dvd',film_identifier);
count = 1;
  [FileName,PathName] = uigetfile('I:\Projects-Snap\Vopara\r\*.txt');
   acqs_filename = [PathName,FileName]; 
   acq_list = textread(acqs_filename,'%u');
 
%acqs_filename = ['temp.txt'];
%acq_list = textread(acqs_filename,'%u');
    
%destination='D:\sample_featureslist';
%dirname_towrite = 'F:\SFMR_cohort_study\';
dirname_towrite = '\\researchstg\Users\amahmoudzadeh\Cohort Study\UVM\Test\';
%dirname_towrite = 'D:\sample_featurelist_DICOMs\';

date_driveI = datenum('20081231', 'yyyymmdd');
date_driveK = datenum('20090930', 'yyyymmdd');
str = computer;
i=1
[ret, comp_name] = system('hostname');
%dos 'C:\dcmtk-3.6.0-win32-i386\bin\storescp.exe -v -od "D:\Hologic Cenova output" -aet "KPServer" 6100')

while i<=length(acq_list);
    try
        acq_id = acq_list(i);
        c=mxDatabase(Database.Name,['select * from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(acq_id),')']);
        date_acq = c{1,204};
        folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
        
        date_acq_num = datenum(date_acq, 'yyyymmdd');
        
        b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(acq_id)]);
        Study_id= cell2mat(b(2))
        patient_id=cell2mat(b(3))
        mAs=cell2mat(b(9))
        Kvp=cell2mat(b(10))

        
        
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
          % if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:4),'cpuc') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not') | strcmp(film_identifier(1:3),'non')| strcmp(film_identifier(1),'0') | strcmp(film_identifier(1),'1')) %for CPMC
             
            
          if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:4),'cpuc') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not') | strcmp(film_identifier(1:3),'non')| strcmp(film_identifier(1),'0') | strcmp(film_identifier(1),'1')) %for CPMC
              
              date_acq_num = datenum(date_acq, 'yyyymmdd');
              
              if date_acq_num>date_driveCP     %AM 10072013
                  start_dir = '\\researchstg\aaData\Breast Studies\Breast Studies\CPMC\DicomImageBlinded(digi)';
                  startdir_report = '\\researchstg\aaData\Breast Studies\Breast Studies\CPMC\';
              elseif date_acq_num >= date_driveN
                  start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                  startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC';
              elseif date_acq_num >= date_driveK
                  start_dir = '\\researchstg\aaDATA5\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                  startdir_report = '\\researchstg\aaDATA5\Breast Studies\CPMC';  % Am 04172013
              elseif date_acq_num >= date_driveI
                  start_dir = '\\researchstg\aaDATA4\Breast Studies\CPMC\DicomImagesBlinded(digi)';%  Am 04/17/2013
                  startdir_report = '\\researchstg\aaDATA4\Breast Studies\CPMC';
              else
                  start_dir = '\\researchstg\aaDATA2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                  startdir_report = '\\researchstg\aaDATA2\Breast Studies\CPMC';
                  
              end
              
              
              
                
            elseif strcmp(film_identifier(1:3),'mgh') || strcmp(film_identifier(1:3),'nov')% for MGH %added Novato 06062013
                
                if date_acq_num> date_driveMGH1
                    start_dir = '\\researchstg\aaData\Breast Studies\Breast Studies\MGH\DicomImageBlinded(digi)';
                    startdir_report = '\\researchstg\aaData\Breast Studies\Breast Studies\MGH\DicomImageBlinded(digi)';
                    
                elseif  date_acq_num> date_driveMGH
                    start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Added by Am 04032013
                    startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH'; %Added by Am 04032013
                    
                elseif  date_acq_num > date_driveKM
                    start_dir = '\\researchstg\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA5\Breast Studies\MGH';
                else
                    start_dir = '\\researchstg\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Am Changed ming to win 05/07/2013
                    startdir_report = '\\researchstg\aaDATA6\Breast Studies\MGH';
                    
                end
            elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
                
                if  date_acq_num>date_driveUVM1
                    start_dir = '\\researchstg\aaData\Breast Studies\Breast Studies\UVM\DicomImageBlinded(digi)';
                    startdir_report ='\\researchstg\aaData\Breast Studies\Breast Studies\UVM\DicomImageBlinded(digi)';
                    
                elseif  date_acq_num> date_driveUVM % || strcmpi(film_identifier(1:14),'UVM_09-10-2013') || strcmpi(film_identifier(1:14),'UVM_09-11-2013'));
                    start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\UVM_New\DicomImagesBlinded(digi)';
                    startdir_report ='\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\UVM_New\DicomImagesBlinded(digi)';
                    
                elseif (strcmpi(film_identifier(1:14), 'UVM_06-13-2013') || strcmpi(film_identifier(1:14), 'UVM_06_14_2013') || strcmpi(film_identifier(1:14), 'UVM_06-14-2013')  || strcmpi(film_identifier(1:14), 'UVM_06-15-2013') || strcmpi(film_identifier(1:14), 'UVM_06-16-2013') || strcmpi(film_identifier(1:14), 'UVM_06-17-2013'))
                    start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report ='\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    folder = [];
                else
                    start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
                    folder = [];
                end
                folder = [];
       
          elseif strcmp(film_identifier(1:3),'ucs')  %for UCSF
              
              if   date_acq_num>date_driveUCSF
                  
                  start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UCSF\DicomImagesBlinded(digi)';
                  startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UCSF\DicomImagesBlinded(digi)';
                  
              else
                  start_dir = '\\researchstg\aaData6\Breast Studies\UCSFMedCtr\DicomImagesBlinded(digi)';
                  startdir_report = '\\researchstg\aaData6\Breast Studies\UCSFMedCtr';
                  
              end
              
              
          elseif  ~isempty(strfind(film_identifier,'nc'))%strcmp(film_identifier(1:2),'nc')  %for NC
              if strcmp(comp_name(1:4),'Ming')
                  start_dir = 'U:\aaData5\Breast Studies\NC\DicomImagesBlinded(digi)'; % (aaData4 changed to aaData5) updated by Amir 04032013
                  startdir_report = 'U:\aaData5\Breast Studies\NC';%(aaData4 changed to aaData5)updated by Amir 04032013
              else
                  start_dir = '\\researchstg\aaDATA5\Breast Studies\NC\DicomImagesBlinded(digi)';%(aaData4 changed to aaData5) updated by Amir 04032013
                  startdir_report = '\\researchstg\aaDATA5\Breast Studies\NC';%(aaData3 changed to aaData5) updated by Amir 04032013
              end
              folder = [];
        
            elseif strcmpi(film_identifier(1:3), 'avo')     %for Avon
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'D:\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = 'D:\aaData\Breast Studies\Shanghai';
                else
                    start_dir = '\\ming\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming\aaData\Breast Studies\Shanghai';
                end
                folder = [];
                %End of change by Song, 1/24/11
                %Case for Marsden images acquired separately for Volpara, JW 11/7/12
            elseif strcmpi(film_identifier(1:18), 'marsden_11-07-2012')      
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'K:\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = 'K:\aaData5\Breast Studies\Marsden';
                else
                    start_dir = '\\ming\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming\aaData5\Breast Studies\Marsden';
                end
                folder = [];
                %End change by JW 11/7/12                
                %Case added for Marsden, by Song, 1/26/11
            elseif strcmpi(film_identifier(1:3), 'mar')     %for Marsden
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'H:\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = 'H:\aaData3\Breast Studies\Marsden';
                else
                    start_dir = '\\ming\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming\aaData3\Breast Studies\Marsden';
                end
                folder = [];
                %End of change by Song, 1/26/11
                %startdir_wfolder = [start_dir,'\',folder];
                %%% JW added 9/3/09 for Bayer GE 2000D images %%%
            elseif strcmp(film_identifier(1:3),'p01')||strcmp(film_identifier(1:3),'po1')||strcmp(film_identifier(1:3),'PO1')
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                    startdir_report = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                else
                    if strcmp(b(16),'01-Feb-2010         ')
                        start_dir = '\\ming.radiology.ucsf.edu\working_directory\projects-snap\aaSTUDIES\Breast Studies\TLSTY_P01_invivo\Source Data\Mammograms\second batch\DicomImagesBlinded';
                        startdir_report = '\\ming.radiology.ucsf.edu\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                    else
                        start_dir = '\\ming.radiology.ucsf.edu\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                        startdir_report = '\\ming.radiology.ucsf.edu\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                    end
                end
                folder = [];
            elseif strcmp(film_identifier(1:2),'3c')
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aaDATA\Breast Studies\3C_data';
                    startdir_report = 'D:\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
                else
                    start_dir = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\3C_data';
                    startdir_report = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
                end
                
                folder = [];
                tempfname=strcat(cell2mat(b(17)),'');   %erase extra ' '
                index_slash = find(tempfname=='\');
                folder = tempfname(index_slash(end-2)+1: index_slash(end));

            elseif ~isempty(strfind(study_id,'bayer'))
                if strcmp(comp_name(1:4),'Ming')
                    if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                else
                    if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                        start_dir = '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        start_dir = '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                end
                folder = [];
     
            end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        startdir_wfolder = [start_dir,'\',folder];
        fname=strcat(cell2mat(b(23)),'');
        fname = [startdir_wfolder,fname];
        fmat = [fname(1:end-7),'.mat'];

      


        [pathstr,name,ext] = fileparts(fname);
        clear info_dicom_blinded;
        load(fmat);
        info_dicom_blinded.DeviceSerialNumber = 'H1KRHR8416ac98';
        info_dicom_blinded.PatientID = patient_id ;
        info_dicom_blinded.acq_id = num2str(acq_id);
        uid = dicomuid
        info_dicom_blinded.SOPInstanceUID = uid;
% % %         info_dicom_blinded.ObjectType='ct image storage';
        info_dicom_blinded.StudyInstanceUID = [info_dicom_blinded.StudyInstanceUID, '.', num2str(i)];
        clear XX;

        XX = imread(fname);
        XX1=round(OverSamplingN(XX,2));
       
        

% % %          I = log_convertSXA(XX1,mAs, Kvp)
        
% % %         figure;imshow(XX1);
        
% % %         [XX2]=InvertIm(XX1);
% % %         figure;imshow(XX2)
        
        
        fname_towrite=[dirname_towrite,name(1:end),'.dcm'];
        
        
        dicomwrite(XX2,fname_towrite,info_dicom_blinded,'CreateMode','copy');
               
        %note 'C:\Program Files\MATLAB\R2008a\toolbox\images\medformats\private\dicom_prep_ImagePixel.m',
        %which is eventually called by dicomwrite subfunctions, has been temporarily replaced with
        %Barry Ren's (Hologic) modified version to improve
        %compatability with Quantra.

        %%   dos (['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe -aet KPServer -aec R2SERVER_SCP 128.218.111.23 7100 ', fname_towrite],'-echo')
        
% % %           dos (['C:\dcmtk-3.6.0-win32-i386\bin\storescu.exe -aet KPServer 7100', fname_towrite],'-echo')
% % %         [status, results] = dos('comp', '-echo');
        %pause(30);
        %pause(10);

        i=i+1
        count = i;
        
    catch
        lasterr
        i=i+1;
        k = count
    end
end


% % % % function I = log_convertSXA(XX1,mAs, kVp)
% % % % global Info 
% % % % 
% % % % % % % if (Info.mAs==0)||(Info.kVp==0)   %AM 11012013
% % % % % % %                              
% % % % % % %    Info.kVp= 28     
% % % % % % %    Info.mAs = 100;                      
% % % % % % %  end;
% % % % % % %                          
% % % % % % %   kVp=Info.kVp
% % % %   voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
% % % %  
% % % %   max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,33974.3];%40868.8 33974.3 3276 2000
% % % %   mmax = max_counts(find(voltages == kVp)); %9074.182 for 26 kVp
% % % %   %mmax = 50000;
% % % %   %mAs = 100;
% % % %  % H = fspecial('disk',5);
% % % %  % I = imfilter(image,H,'replicate');
% % % % % % %  image=funcclim(XX1,1,65536);
% % % % image=XX1;
% % % % % % %  image =  image*100/(mmax*mAs);
% % % % 
% % % %  I = -log(image)* 10000;
% % % %  
% % % %  function result=funcclim(XX1,limmin,limmax);
% % % % 
% % % % result=image;
% % % % maskminus=result<limmin;
% % % % maskplus=result>limmax;
% % % % result=result+(maskminus).*(limmin-result);
% % % % result=result+(maskplus).*(limmax-result);

function [invIm]=InvertIm(im, varargin)
% InvertIm generalized image inversion (grayscale reversal)
%    invIm=InvertIm(im) inverts an image array im in the sense of reversing
%    its grayscale (NOT matrix inversion).  InvertIm effects the inversion
%    by computing new image data rather than by reversing the colormap or
%    look-up-table (LUT), which is often, but not always, a better
%    approach.  im can be an array of any dimension composed of numeric or
%    binary elements (integers [uint8, int8, uint16, int16, etc.], floating
%    point [double or single], or logical).  The result invIm is the same
%    data class as im.
%    
%    For numeric arrays, the inverse is computed using 
%
%       invIm = (maxVal + minVal) - im
%
%    with appropriate treatment of the different data types.  For integer
%    arrays, minVal and maxVal are the minimum and maximum allowed
%    integers.  For floating point arrays, if the image data lie within the
%    range [0,1], the inversion is performed with default minVal and maxVal
%    of 0 and 1.  If the image data lie outside [0,1], then the minimum and
%    maxmimum values of the data are used for minVal and maxVal.
%
%    Invert(im, bitsStored) returns the inverse of the image im using a
%    maxVal of 2^bitsStored.  This option is convenient when inverting
%    images with a limited dynamic range, e.g., when you have a 16-bit
%    image that only uses the first 12 bits of data.  This option is only
%    applicable to integer data.
%
%    invIm=Invert(im, [], lowerLimit) returns the inverse of the image im
%    using a minVal of lowerLimit.  This option is useful, for example,
%    when inverting signed integer image data that is only positive.
%
%    invIm=Invert(im, [], [], upperLimit) returns the inverse of the image
%    im using a maxVal of upperLimit.
% 
%    All three optional arguments may be used together (e.g.,
%    invIm=Invert(im, bitsStored, lowerLimit, upperLimit)), but upperLimit
%    will supercede bitsStored.
%
%
%    Example:
%      im=imread('cameraman.tif');  % Brigg's field at MIT
%      fig=figure; colormap(gray)
%      subplot(2,2,1)
%      subimage(im)
%      axis off
%      subplot(2,2,2)
%      imhist(im)
%      ylabel('Number of Pixels')
%
%      invIm=InvertIm(im);
%      subplot(2,2,3)
%      subimage(invIm)
%      axis off
%      subplot(2,2,4)
%      imhist(invIm)
%      ylabel('Number of Pixels')
%
%
%    See also colormap

%    Written by Stead Kiger, Ph.D.
%               Department of Radiation Oncology
%               Beth Israel Deaconess Medical Center
%               Harvard Medical School
%               Boston, MA  02215
%
%    Last revised on April 11, 2007

% Initialize parameters
bitsStored=[];
lowerLimit=[];
upperLimit=[];

% Assign and check optional arguments for parameters
error(nargchk(1, 4, nargin, 'struct'))
% bitsStored
if nargin >= 2,
    bitsStored=varargin{1};
    if ~(isnumeric(bitsStored) || isempty(bitsStored)),
        error('Optional argument bitsStored must be either numeric or empty.')
    end
end

% lowerLimit
if nargin >= 3,
    lowerLimit=varargin{2};
    if ~(isnumeric(lowerLimit) || isempty(lowerLimit)),
        error('Optional argument lowerLimit must be either numeric or empty.')
    end
end

% upperLimit
if nargin == 4,
    upperLimit=varargin{3};
    if ~(isnumeric(upperLimit) || isempty(upperLimit)),
        error('Optional argument upperLimit must be either numeric or empty.')
    end
end

% Check that the image array is either numeric or logical
if ~(islogical(im) || isnumeric(im)),
    error('Input array must be logical or numeric, but is %s',class(im))
end


if islogical(im),
    % logical - just apply not
    invIm=~im;

else

    % determine the image class, i.e., data type; e.g., uint8, int16 etc.
    imClass=class(im);

    % create the function handle for casting the double precision image back
    % into its original class
    clsHdl=str2func(imClass);

    if isinteger(im),
        % get the minimum integer
        minVal=double(intmin(imClass));
        if ~isempty(lowerLimit),
            minVal=double(max(minVal, lowerLimit));
        end

        % get the maximum integer
        maxVal=double(intmax(imClass));
        if ~isempty(bitsStored),
            maxVal=double(min(maxVal, 2^bitsStored - 1));
        end
        if ~isempty(upperLimit),
            maxVal=min(maxVal, upperLimit);
        end

    elseif isfloat(im)
        imMin=min(im(:));
        imMax=max(im(:));
        if imMin >= 0 && imMax <= 1,
            % Intensity image or RGB
            minVal=0;
            maxVal=1;
        else
            minVal=imMin;
            maxVal=imMax;
        end

        if ~isempty(lowerLimit),
            minVal=lowerLimit;
        end
        if ~isempty(upperLimit),
            maxVal=upperLimit;
        end

    else
        error('Input array must be logical or numeric, but is %s',class(im))
    end

    % Compute the inverse and cast the array back into its original class
    invIm = feval(clsHdl, (maxVal + minVal) - double(im));

end
