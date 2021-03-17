function I = log_convertSXA(image,mAs, kVp,proj_num)
global Info 


% use mAs and kVp from Dicom table if mAs or kVp=0
if (Info.mAs==0)||(Info.kVp==0)
    
    try
        
        Dicom=mxDatabase(Database.Name,['select  FileSize,	KVP, ExposureInuAs, ...'
            'ExposureTime, DetectorTemperature  from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
        
        Info.kvpDicom=cell2mat(Dicom(2));
        Info.mAsDicom=(round(cell2mat(Dicom(3))))/1000;
        
        Info.mAs=Info.mAsDicom;
        Info.kVp=Info.kvpDicom;
    catch err
        Info.kVp= 28
        Info.mAs = 100;
    end
    
end

voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34,39, 49]; % ZM10 33 added
max_counts = [6621.2, 7994.7, 9485.5, 11256.26667, 13120.83333, 15094.4, 17223.33333, 19470.25, 18208.33333, 20082,22500, 3440 6880];
                         
  kVp=Info.kVp
  voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34,35, 39, 49];
%  kVp=32;
  max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,33974.3,3440,6880 ];%40868.8 33974.3 3276 2000 33974.3
  mmax = max_counts(find(voltages == kVp)); %9074.182 for 26 kVp
  %mmax = 50000;
  %mAs = 100;
 % H = fspecial('disk',5);
 % I = imfilter(image,H,'replicate');
%  FF_name = ['\\researchstg\aadata\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\FF_images\FFLE31kVp_',proj_num,'.png'];
  FF_name = ['\\researchstg\aadata\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\CP_31kVp\FFLE\png_files\FFLE31kVp_',proj_num,'.png'];
  FF_image = double(imread(FF_name));
%  image =  image*100/(mmax*mAs);
   image = image./FF_image; % flat fielding
   
%  image=funcclim(image,1,65536);
 min_image = min(min(image));
 max_image = max(max(image));
 I = -log(image)* 10000  + 4000; % - 14300; % 3950;


 
  %{
   H = fspecial('disk',5);
   I = imfilter(I,H,'replicate');
   I = funcGradientGauss(I,5);
  %}