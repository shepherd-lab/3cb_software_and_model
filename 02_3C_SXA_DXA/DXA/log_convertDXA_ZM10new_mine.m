function I = log_convertDXA_cpmcDXA(image,mAs, kVp, Alfilter)
global Image flag SXARefLE SXARefHE file

flag.SXAphantomDisplay = true;    % true for displaying RIOs

% % p123al2 240
% DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p121al2_test011008\png_files\p121al2_lead25_100.51raw.png';
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p123al2_011208CPMC\png_files\p123al2_5050_39_40.100raw.png';
% DC_filenameHE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p121al2_test011008\png_files\p121al2_lead39_240.55raw.png';
% MEANDCLE=45;
% MEANDCHE=47;
%
% % p127al2
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p127al2_011508CPMC\png_files\p127al2_5050_39_40.206raw.png';
% MEANDCLE=38;
% MEANDCHE=44;

% % p133al2
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_5050_39_40_2.37raw.png';
% MEANDCLE=38;
% MEANDCHE=44;
% FF_filenameLE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p92al2_testCPMC110607\png_files\p92al2_4cm5050LE.157raw.png';
% % DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p123al2_011208CPMC\png_files\p123al2_lead32_115.83raw.png';
% DC_filenameHE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_lead39_40.40raw.png';
% DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_lead39_40.40raw.png';

% % p149al2 WHC
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p149al2_test013108\png_files\p149al2_4cm5050_HE39_40.269raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p154al2
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p154al2_020508CPMC\png_files\p154al2_4cm5050_39_40.179raw.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p160al2 021208
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p160al2_021208CPMC\png_files\p160al2_4cm5050_39_40.327raw.png';
% MEANDCLE=42;
% MEANDCHE=42;


% % % p167al2 TT005 WHC
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\TT005\TT005_calibration_p167al2\png_files\p167al2_4cm5050_HE39_240.26raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % p169al2 080226
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p169al2_022608CPMC\png_files\p169al2_4cm5050_39_40.574raw.png';
% MEANDCLE=30;
% MEANDCHE=30;

% % serghei QCWater
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\QC_Water021408\png_files\sm_HEFF_39-200.46raw_flipped.png';
% FF_filenameLE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\QC_Water021408\png_files\sm_LEFF_32-100.48raw_flipped.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p184al2 080311
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p184al2_031108CPMC\png_files\p184al2_4cm5050_39_40.305raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % p186al2 080318 room 6
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p186al2_031808CPMC\png_files\p186al2_4cm5050_39_40.243raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % p190al2 WHC TT006
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\TT006\TT006R_calibration_p190al2\png_files\p190al2_4cm5050_HE39_200.raw.png';
% MEANDCLE=36;
% MEANDCHE=36;


% % % p192al2 080311 room 6
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p192al2_20080325CPMC\png_files\p192al2_4cm5050_39_40.47raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p191al2 WHC 080327
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p191al2_test032708\png_files\p191al2_4cm5050_39_40.raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p3al3 080401 room 6
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p3al3_20080401CPMC\png_files\p3al3_4cm5050_39_40.298raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p10al3 WHC ATTENTION ERROR !!!!!!!!!!!!!
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p10al3_20080408CPMC\png_files\p10al3_4cm5050_39_40.raw.png';
% MEANDCLE=36;
% MEANDCHE=36;

% % % p10al3 080408 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p10al3_20080408CPMC\png_files\p10al3_4cm5050_39_40.raw.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p13al3 080415 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p13al3_20080415CPMC\png_files\p13al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p18al3 080422 room 4
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p18al3_20080422CPMC\png_files\p18al3_4cm5050_39_40_average.png';
% MEANDCLE=44;
% MEANDCHE=44;

% % % p24al3 080429 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p24al3_20080429CPMC\png_files\p24al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p30al3 080506 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p30al3_20080506CPMC\png_files\p30al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p38al3 080520 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p38al3_20080527CPMC\png_files\p38al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p45al3 080603 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p45al3_20080603CPMC\png_files\p45al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% % % p48al3 080610 room 8
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p48al3_20080610CPMC\png_files\p48al3_4cm5050_39_40_average.png';
% MEANDCLE=40;
% MEANDCHE=40;

% %p80al3 082608 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20080826_bis_gelo_1rstSet\png_files\P80AL3_4CM5050_39_200_average.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % % p85al3 092508 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20080925\png_files\p86al3_4cm5050_39_200_average.raw.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % % p91al3 102108 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20081021\png_files\p91al3_4cm5050_39_200_average.raw.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % % p94al3 110408 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20081104\png_files\p94al3_4cm5050_39_200_average.raw.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % % p98al3 20081203 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20081203_Delrin2ndSet\png_files\p98al3_4cm5050_39_200_average.raw.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % % p100al3 20081211 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20081211_Delrin3rdSet\png_files\p100al3_4cm5050_39_200_average.raw.png';
% MEANDCLE=20;
% MEANDCHE=20;

% % p104al3 20090122 ZM10 Delrin4thSet
%FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20090122_Delrin4thSet\png_files\p104al3_4cm5050_39_200_average.raw.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\E3C11112222\png_files\3c_3cbreast_39200HEFFacryl.raw.png';
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\E3C11112222\png_files\3c_3cbreast_39200HEFFacryl.raw.png';
FF_filenameHE ='\\researchstg\\aaData\Breast Studies\3C_data\3C_02_002\png_files\1.2.840.113681.2225183346.1518.3557132950.255_0009_000074_13797035610028_anraw.png';
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\E3C01001_092313\png_files\3C_20130906_HEFF.raw.png';
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01011\png_files\FFHEraw.png';                 
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02013\png_files\FFHEraw.png';  
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01006\png_files\FFHEraw.png';    
FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01008\png_files\FFHEraw.png';  


[pathstr,name,ext] = fileparts(file.fname);
FF_filenameHE = [pathstr,'\FFHEraw.png'];  
aa =  dir(FF_filenameHE);
if isempty(aa)
% %      [fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\png_files\*.*', 'Please select HEFF file.');
% %      FF_filenameHE = [pathName,fileName];;% % % thickfile_name = [pathName,fileName];
% %      FF_filenameHE = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Water_Oil_E1111110788\png_files\CP_FF3924cm_200.raw32.png';
% %      FF_filenameHE = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Tissue_Homogenization\png_files\FlatField_39kVp_200mAs_Rh.raw47.png'
% %          FF_filenameHE = '\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Phantom_test_materials\Stearic Acid\E11111108062014\all_files\3cb_sa_FF_39kvp_100mas_Al_Rh__raw3.png';
         FF_filenameHE = '\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Phantom_test_materials\E00000009162014\all_files\fifty_4cm_RCC_39kVp_99mAs_Rh_raw46.png';
         FF_filenameHE = '\\researchstg\aaData\Breast Studies\3C_data\CalibrationFiles\20120301\png_files\20120229_AL5_4CM5050_39_200_01.S35I41raw.png';
end

%FF_filenameHE = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Tissue_Homogenization\png_files_all\FlatField_39kVp_200mAs_Rh.raw47.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01002\png_files\FFHEraw.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02016\png_files\FFHEraw.png'; 

%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Training\png_files\3C_20130831_HEFF.raw.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C11112223\ForProcessing\png_files\3C_FFHE_Rh39100.212_0008_000063_13789284660098raw.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C11112222\ForProcessing\png_files\3C_FFHEAg39100.13_0011_000008_1378922836004braw.png';
%FF_filenameHE ='\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C11112222\ForProcessing\png_files\3C_HEFFRh39100.12_0010_000007_13789228420051raw.png';
LE_corr =-3700;   % -1500
LE_corr = 0;

% % % if kVp == 33
% % %     HE_corr = 0;
% % % else
% % %     HE_corr = 5000;
% % % end
% % % if ~isempty(strfind(pathstr,'UCSF')) | ~isempty(strfind(pathstr,'Homo'))
% % %     HE_corr = 0;
% % % else
% % %     HE_corr = 5000; %for Moffit
% % % end

if ~isempty(strfind(pathstr,'Moffitt'))
   HE_corr = 5000;
else
    HE_corr = 0;  %for Moffit
end

LEcorr_SXA = 0;%-1000 for n=10;
HEcorr_SXA = 0;%167 for n=10;

% % % LEcorr_SXA = -1977%-1000 for n=10;
% % % HEcorr_SXA = 220%167 for n=10;
LEcorr_SXA = -1997 %-1000 for n=8; breast difference
HEcorr_SXA = -187 %167 for n=8;

  LEcorr_SXA = -1997+965 +338 - 2700%+ 600% + 400 %  2743%27=+3283 %- 2738 %+ 1143%CP29
  HEcorr_SXA = -187 + 1653 -300 + 406 +380 -2339 %+38% + 400  % 515;%27= +1422%+ 1676 %  + 1420%CP29;

% % LEcorr_SXA = -1997 + 1667%-1000 for n=8; breast difference
% % HEcorr_SXA = -187 + 1588%167 for n=8;

% % % LEcorr_SXA = -1997+1872;%-1000 for n=8; breast difference
% % % HEcorr_SXA = -187-280%167 for n=8
% % % LEcorr_SXA = -(1997-2980)%-1000 for n=8; breast difference brest = 1980   CP=3980
% % % HEcorr_SXA = -(187-1500)%167 for n=8 bresat=1400   CP=1580



MEANDCLE=50;
MEANDCHE=50;

% % % p107al3 20090213 ZM10
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\20090213\png_files\p107al3_4cm5050_39_200_average.png';
% MEANDCLE=20;
% MEANDCHE=20;

% flip FF_filenameHE
% I0LE= imread(FF_filenameLE);
I0HE= imread(FF_filenameHE);
% I0HE=flipdim(I0HE,1); %vertical flip for CPMC
I0HE=flipdim(I0HE,2);I0HE=flipdim(I0HE,1); %both flips for MtZion

% voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
% max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65,...
%     20879.08, 3276];%33974.3 3276

voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34,39]; % ZM10 33 added
max_counts = [6621.2, 7994.7, 9485.5, 11256.26667, 13120.83333, 15094.4, 17223.33333, 19470.25, 18208.33333, 20082,22500, 3440];

mmax = max_counts(find(voltages == kVp));
%mmax = 20000; commented SM 1/9/14
szz=size(image);

Xmin=1234;Xmax=1384;Ymin=1717;Ymax=1792; %%% select ref ROI
XminSP=50;XmaxSP=200;YminSP=1525;YmaxSP=1600;

XminI0LP=100;XmaxI0LP=500;YminI0LP=800;YmaxI0LP=1200; %%% select ref ROI for I0
XminI0SP=100;XmaxI0SP=500;YminI0SP=630;YmaxI0SP=1030;

CstLE=0;
CstHE=0;

if szz(2) > 1350 %%% to open LARGE PADDLE images
    Xmin=1234;Xmax=1384;Ymin=1717;Ymax=1792;
    rectangle('Position',[Xmin,Ymin,Xmax-Xmin,Ymax-Ymin],'Facecolor','y');

    if  kVp <= 38 % open LE image

        %         %%%%% LE SXA phantom parameter calculation  %%%%%%%%%%%%%%
        %         Image.image = log_convert(image);            % conversion into attenuation scale for the SXA phantom detection
        %         Image.OriginalImage = Image.image;           % assigning for for the SXA phantom detection
        %         ReinitImage(Image.image,'OPTIMIZEHIST');     % to display image temporary
        %         PhantomDetection;                            % SXA phantom detection and RIO displaying
        % %         SXARefLE = SXAReference_calculation(image)   % SXA phantom parameter calculation

        %%% calculate ref ROI mean value
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);

        %          ROIrefI0=I0LE(YminI0LP:YmaxI0LP,XminI0LP:XmaxI0LP);
        %         signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        %         MEANrefI0=nanmean(signalI0); % in the 4 cm 50/50

        %%% dark current image (no paddle dependent)
        %             DCLE= imread(DC_filenameLE);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        %         MEANDCLE=45;

        %         I = -log((image-MEANDCLE)/(MEANref-MEANDCLE));%+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image

        %%%%%%%%% removing negative values %%%%%%%%%%%%% 
        current_image = (image-MEANDCLE)/mmax*100/mAs;
        index_neg = find(current_image<=0);
        current_image(index_neg) = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        I = -log(current_image); %no LE FF
%           I = -log(image-MEANDCLE)+log((double(I0LE)-MEANDCLE)*mmax/(MEANrefI0-MEANDCLE)/100*mAs); % LEFF
        %   I = -log((image-double(DCLE))/mmax*100/mAs);
        I=I* 10000+CstLE + LE_corr  + LEcorr_SXA; %   % -1500 is LE correction

        %          SXARefLE = SXAReference_calculation(I);

    end

    if  kVp == 39  %Large paddle

        %%% HE SXA phantom parameter
        %         SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization

        %%% Flat field file: 4 cm 50/50
        %         I0HE= imread(FF_filenameHE);

        %%% select ref ROI and calculate its mean value:
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal); % in the image

        ROIrefI0=I0HE(YminI0LP:YmaxI0LP,XminI0LP:XmaxI0LP);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0); % in the 4 cm 50/50

        %%% dark current image (no paddle dependent)
        %              DCHE= imread(DC_filenameHE);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        %         MEANDCHE=47;

        %         I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE));% intensity/I_0 corrected image
        %         I = -log(image-MEANDCHE)+log((double(I0HE)-MEANDCHE)*mmax/(370-MEANDCHE)/100*mAs);

        %%%%%%%%% removing negative values %%%%%%%%%%%%%
        current_image1 = image-MEANDCHE;
        %current_image2 = (double(I0HE)-MEANDCHE)*mmax/(MEANrefI0-MEANDCHE)/100*mAs; commented for temporary
        current_image2 = (double(I0HE)-MEANDCHE)*mmax/(MEANrefI0-MEANDCHE)/100*mAs;
        index_neg1 = find(current_image1<=0);
        current_image1(index_neg1) = 1;
        index_neg2 = find(current_image2<=0);
        current_image2(index_neg2) = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % I = -log(current_image1)+log(current_image2);
         I = -log(current_image1./current_image2);
        % I = -log(image-MEANDCHE)+log((double(I0HE)-MEANDCHE)*mmax/(MEANrefI0-MEANDCHE)/100*mAs);
        I=I* 10000+CstHE +HE_corr  + HEcorr_SXA; 
        
        %%%%%%%%%%%%% version from Fred %%%%%%%%%%%%%%%%
% % %         current_image = median(median(FLATFIELD))*(image-IODARK)./FLATFIELD;
% % %         current_image = current_image/mmax*100/mAs;
% % %         %%%%%%%%% removing negative values %%%%%%%%%%%%%
% % %         index_neg = find(current_image<=0);
% % %         current_image(index_neg) = 1;
% % %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %         I = -log(current_image);
% % %         I=I* 10000;
        

        %% HE SXA phantom parameter
        %         SXARefHE = SXAReference_calculation(I); % SXA phantom HE attenuation calculation

    end

else % to open SMALL PADDLE images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SMALL PADDLE images %%%%%%%%%%%%%%%%%%%%%
    %                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
    %                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    XminSP=850;XmaxSP=1000;YminSP=1525;YmaxSP=1600;
    rectangle('Position',[XminSP,YminSP,XmaxSP-XminSP,YmaxSP-YminSP],'Facecolor','g');

    if  kVp <= 38  %small paddle

        %%%%%% LE SXA phantom parameter calculation  %%%%%%%%%%%%%%
        %         Image.image = log_convert(image);            % conversion into attenuation scale for the SXA phantom detection
        %         Image.OriginalImage = Image.image;           % assigning for for the SXA phantom detection
        %         ReinitImage(Image.image,'OPTIMIZEHIST');     % to display image temporary
        %         PhantomDetection;                            % SXA phantom 3D reconstruction, parameter calculation and RIO displaying
        %         SXARefLE = SXAReference_calculation(image)   % SXA phantom parameter calculation for DXA LE image normalization

        %%% select ref ROI and calculate its mean value (in small paddle):

        ROIref=image(YminSP:YmaxSP,XminSP:XmaxSP);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);

        %%% dark current image (no paddle dependent)
        %                 DCLE= imread(DC_filenameLE);
        %                 DCLE= DCLE(193:1855,1:1279);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        %         MEANDCLE=45;

        %%%%%%%%% removing negative values %%%%%%%%%%%%%
        current_image = (image-MEANDCLE)/mmax*100/mAs;
        index_neg = find(current_image<=0);
        current_image(index_neg) = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %         I = -log((image-MEANDCLE)/(MEANref-MEANDCLE)); % intensity/I_0 corrected image
        %          I = -log(image-MEANDCLE);
        I = -log(current_image);
        %           I = -log((image-double(DCLE))/mmax*100/mAs);
      
        I=I* 10000+CstLE + LE_corr  + LEcorr_SXA; % LE_corr+ -1500 is LE correction
       
    end

    if  kVp == 39   % small paddle

        %%% HE SXA phantom parameter
        %         SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization

        %%% Flat field file: 4 cm 50/50
%         I0HE= imread(FF_filenameHE);
      I0HE= I0HE(193:1855,1:1279); % crop image for small paddle images

        %%% select ref ROI and calculate its mean value (in small paddle):
        ROIref=image(YminSP:YmaxSP,XminSP:XmaxSP);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);

        ROIrefI0=I0HE(YminI0SP:YmaxI0SP,XminI0LP:XmaxI0SP);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);

        %%% dark current image (no paddle dependent)
        %                 DCHE= imread(DC_filenameHE);
        %                 DCHE= DCHE(193:1855,1:1279);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        %         MEANDCHE=47;

         %%%%%%%%% removing negative values %%%%%%%%%%%%%
        current_image1 = image-MEANDCHE;
        current_image2 = (double(I0HE)-MEANDCHE)*mmax/(MEANrefI0-MEANDCHE)/100*mAs;
        index_neg1 = find(current_image1<=0);
        current_image1(index_neg1) = 1;
        index_neg2 = find(current_image2<=0);
        current_image2(index_neg2) = 1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         I = -log(current_image1./current_image2);
        %I = -log(current_image1)+log(current_image2);
        
        %         I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE)); % intensity/I_0 corrected image
%         I = -log(image-MEANDCHE)+log((double(I0HE)-MEANDCHE)*mmax/(MEANrefI0-MEANDCHE)/100*mAs);
        %         I = -log(image-double(DCHE))+log((double(I0HE)-double(DCHE))*mmax/(370-MEANDCHE)/100*mAs);

        I=I* 10000+CstHE  +HEcorr_SXA +HE_corr;
    end

end