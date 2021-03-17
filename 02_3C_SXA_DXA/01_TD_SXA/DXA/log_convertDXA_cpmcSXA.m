function I = log_convertDXA_cpmcSXA(image,mAs, kVp, Alfilter)  % to open 25kVp images
global Image flag

flag.SXAphantomDisplay = false;    % true for displaying RIOs  

szz=size(image);
if szz(2) > 1350 %%% to open large paddle images
  
      %%% select ref ROI and calculate its mean value:
       Xmin=900;Xmax=1050;Ymin=1750;Ymax=1825;
       rectangle('Position',[Xmin,Ymin,Xmax-Xmin,Ymax-Ymin],'Facecolor','y');
    if  kVp <= 38
        %%%%%% LE SXA phantom parameter calculation  %%%%%%%%%%%%%%
        Image.image = log_convert(image);            % conversion into attenuation scale for the SXA phantom detection
        Image.OriginalImage = Image.image;           % assigning for for the SXA phantom detection
        ReinitImage(Image.image,'OPTIMIZEHIST');     % to display image temporary
        PhantomDetection;                            % SXA phantom detection and RIO displaying
        SXARefLE = SXAReference_calculation(image)   % SXA phantom parameter calculation
        
        %%% select ref ROI and calculate its mean value:
      
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
%         MEANref= 6874;       
        %%% dark current image (no paddle dependent)
 
%         DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p31al2_cal091107\png_files\p31al2_lead100.raw.png';
%         DCLE= imread(DC_filename);
%         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
%         ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
%         signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        MEANDCLE=45;
        
        I = -log((image-MEANDCLE)/(MEANref-MEANDCLE)*mAs/50);%+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image
        I=I* 10000+6000;
    end

    if  kVp == 39
        
        %%% HE SXA phantom parameter
        SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization
                
        %%% Flat field file: 4 cm 50/50
        FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p92al2_testCPMC110607\png_files\p92al2_4cm5050HE.160raw.png';
        I0HE= imread(FF_filename);
        
        %%% select ref ROI and calculate its mean value:

        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal); % in the image
%         MEANref=1415;
        ROIrefI0=I0HE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0); % in the 4 cm 50/50
        
        %%% dark current image (no paddle dependent)
        %DC_filename = 'A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead280.58raw.png';
        %DC_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead280.58raw.png';
%         DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p31al2_cal091107\png_files\p31al2_lead280.raw.png';
%         DCHE= imread(DC_filename);
%         XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
%         ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
%         signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        MEANDCHE=45;

         I = -log((image-MEANDCHE)/(MEANref-MEANDCHE)*mAs/50)+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE)*mAs/50);% intensity/I_0 corrected image
        I=I* 10000+0;
    end




else % for small paddle images

    if  kVp <= 38
                  
         %%%%%% LE SXA phantom parameter calculation  %%%%%%%%%%%%%%
        Image.image = log_convert(image);            % conversion into attenuation scale for the SXA phantom detection
        Image.OriginalImage = Image.image;           % assigning for for the SXA phantom detection
        ReinitImage(Image.image,'OPTIMIZEHIST');     % to display image temporary
        PhantomDetection;                            % SXA phantom 3D reconstruction, parameter calculation and RIO displaying
        SXARefLE = SXAReference_calculation(image)   % SXA phantom parameter calculation for DXA LE image normalization
        
        FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airLEA.57raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airLE.753raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\41.226raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airLE.40raw.png';
        I0LE= imread(FF_filename);
        I0LE= I0LE(193:1855,385:1663); % crop image for small paddle images

        %%% select ref ROI and calculate its mean value (in small paddle):
        Xmin=50;Xmax=200;Ymin=1525;Ymax=1600;
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
        ROIrefI0=I0LE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);
        %%% dark current image (no paddle dependent)
        DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead100.54raw.png';
        DCLE= imread(DC_filename);
        XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
        signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        MEANDCLE=nanmean(signalDCLE);

        I = -log((image-MEANDCLE)/(MEANref-MEANDCLE))+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image
        I=I* 10000;
    end

    if  kVp == 39
        
         %%% HE SXA phantom parameter
        SXARefHE = SXAReference_calculation(image); % SXA phantom parameter calculation for DXA HE image normalization
        
        %         FF_filename = 'O:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airHE3mm.63raw.png';
        FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airHE3mm.63raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airHE6mm.758raw.png';
        %      FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\29.195raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airHE6mm.54raw.png';
        I0HE= imread(FF_filename);
        I0HE= I0HE(193:1855,385:1663);

        %%% select ref ROI and calculate its mean value (in small paddle):
        Xmin=50;Xmax=200;Ymin=1525;Ymax=1600;
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
        ROIrefI0=I0HE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);
        %%% dark current image (no paddle dependent)
        DC_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead280.58raw.png';
        DCHE= imread(DC_filename);
        XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        MEANDCHE=nanmean(signalDCHE);

        I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE)); % intensity/I_0 corrected image
        I=I* 10000;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
