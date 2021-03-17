function I = log_convertDXA_cpmcDXAsm(image,mAs, kVp, Alfilter)  % to open 25kVp images
global Image flag

flag.SXAphantomDisplay = false;    % true for displaying RIOs

FF_filenameHE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\QC_Water021408\png_files\sm_HEFF_39-200.46raw_flipped.png';
FF_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\QC_Water021408\png_files\sm_LEFF_32-100.48raw_flipped.png';

% p123al2 240
%DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p121al2_test011008\png_files\p121al2_lead25_100.51raw
%FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p123al2_011208CPMC\png_files\p123al2_5050_39_40.100raw.png';
%DC_filenameHE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p121al2_test011008\png_files\p121al2_lead39_240.55raw.png';
% 
% % p127al2 
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p127al2_011508CPMC\png_files\p127al2_5050_39_40.206raw.png';
% MEANDCLE=38;
% MEANDCHE=44;
  
% % p133al2 
% FF_filenameHE = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_5050_39_40_2.37raw.png';
% MEANDCLE=38;
% MEANDCHE=44;
% % DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p123al2_011208CPMC\png_files\p123al2_lead32_115.83raw.png';
% % DC_filenameHE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_lead39_40.40raw.png';
% % DC_filenameLE='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p133al2_012208CPMC\png_files\p133al2_lead39_40.40raw.png';

% flip FF_filenameHE
I0HE= imread(FF_filenameHE);
I0LE= imread(FF_filenameLE);
%I0HE=flipdim(I0HE,1); %vertical flip

voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,3276];%40868.8 33974.3 3276 2000
mmax = max_counts(find(voltages == kVp));

szz=size(image);

Xmin=1234;Xmax=1384;Ymin=1717;Ymax=1792; %%% select ref ROI
XminSP=50;XmaxSP=200;YminSP=1525;YmaxSP=1600;

% CstLE=98000;
% CstHE=71000;
CstLE=0;
CstHE=0;%-20000;

if szz(2) > 1350 %%% to open LARGE PADDLE images
    Xmin=1234;Xmax=1384;Ymin=1717;Ymax=1792;
    rectangle('Position',[Xmin,Ymin,Xmax-Xmin,Ymax-Ymin],'Facecolor','y');

    if  kVp <= 38 % open LE image
        %%%%%% LE SXA phantom parameter calculation  %%%%%%%%%%%%%%
%         Image.image = log_convert(image);            % conversion into attenuation scale for the SXA phantom detection
%         Image.OriginalImage = Image.image;           % assigning for for the SXA phantom detection
%         ReinitImage(Image.image,'OPTIMIZEHIST');     % to display image temporary
%         PhantomDetection;                            % SXA phantom detection and RIO displaying
%         SXARefLE = SXAReference_calculation(image)   % SXA phantom parameter calculation

        %%% calculate ref ROI mean value
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);

        %%% dark current image (no paddle dependent)
%             DCLE= imread(DC_filenameLE);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        MEANDCLE=45;

%         I = -log((image-MEANDCLE)/(MEANref-MEANDCLE));%+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image
     %I = -log((image-MEANDCLE)/mmax*100/mAs); % without flat field
     % for 32 kVp Mo/Rh with flat field
    I = -log(image-MEANDCLE)+log((double(I0LE)-MEANDCLE)*mmax/(1433-MEANDCLE)/100*mAs); 
   % I = -log((image-double(DCLE))/mmax*100/mAs);
        I=I* 10000+CstLE;
    end

    if  kVp == 39

        %%% HE SXA phantom parameter
%         SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization

        %%% Flat field file: 4 cm 50/50
%         I0HE= imread(FF_filenameHE);

        %%% select ref ROI and calculate its mean value:
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal); % in the image

        ROIrefI0=I0HE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0); % in the 4 cm 50/50

        %%% dark current image (no paddle dependent)
%              DCHE= imread(DC_filenameHE);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        MEANDCHE=47;

%         I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE));% intensity/I_0 corrected image
        I = -log(image-MEANDCHE)+log((double(I0HE)-MEANDCHE)*mmax/(1827-MEANDCHE)/100*mAs); %370 1827
        %I = -log((image-MEANDCHE)/mmax*100/mAs); 
        I=I* 10000+CstHE;
    end


else % to open SMALL PADDLE images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SMALL PADDLE images %%%%%%%%%%%%%%%%%%%%%
     %                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
     %                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    XminSP=850;XmaxSP=1000;YminSP=1525;YmaxSP=1600;
    rectangle('Position',[XminSP,YminSP,XmaxSP-XminSP,YmaxSP-YminSP],'Facecolor','g');

    if  kVp <= 38

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
        MEANDCLE=45;
        
%         I = -log((image-MEANDCLE)/(MEANref-MEANDCLE)); % intensity/I_0 corrected image
%          I = -log(image-MEANDCLE);
          I = -log((image-MEANDCLE)/mmax*100/mAs);
%           I = -log((image-double(DCLE))/mmax*100/mAs);
        I=I* 10000+CstLE;
    end

    if  kVp == 39

        %%% HE SXA phantom parameter
%         SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization

        %%% Flat field file: 4 cm 50/50
        I0HE= imread(FF_filenameHE);
        I0HE= I0HE(193:1855,1:1279); % crop image for small paddle images

        %%% select ref ROI and calculate its mean value (in small paddle):
        ROIref=image(YminSP:YmaxSP,XminSP:XmaxSP);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
        ROIrefI0=I0HE(YminSP:YmaxSP,XminSP:XmaxSP);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);
        
       %%% dark current image (no paddle dependent)
%                 DCHE= imread(DC_filenameHE);
%                 DCHE= DCHE(193:1855,1:1279);
        %         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        %         ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        %         signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        MEANDCHE=47;

%         I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE)); % intensity/I_0 corrected image
        I = -log(image-MEANDCHE)+log((double(I0HE)-MEANDCHE)*mmax/(1827-MEANDCHE)/100*mAs); %370
%         I = -log(image-double(DCHE))+log((double(I0HE)-double(DCHE))*mmax/(370-MEANDCHE)/100*mAs);
        I=I* 10000+CstHE;
    end

end