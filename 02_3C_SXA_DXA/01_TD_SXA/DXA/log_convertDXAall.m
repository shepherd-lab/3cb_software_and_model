function I = log_convertDXA(image,mAs, kVp, Alfilter)
global Result

szz=size(image);
if szz(2) > 1350 %%% to open large paddle images


    if  kVp == 25
        % FF_filename = 'A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airLEA.57raw.png';
%         FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airLEA.57raw.png';
        FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\TT004\CD2_wholeB_FlatF\png_files\p22al2_100FLE100Av.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airLE.753raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\41.226raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airLE.40raw.png';
        I0LE= imread(FF_filename);
        
        %%% select ref ROI and calculate its mean value:
        %     Xmin=50;Xmax=200;Ymin=1525;Ymax=1600;
        Xmin=434;Xmax=584;Ymin=1717;Ymax=1792;   %%% same ROI ref as in small paddle
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
        ROIrefI0=I0LE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);
        %%% dark current image (no paddle dependent)
        % DC_filename='A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead100.54raw.png';
        %         DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast
        %         Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead100.54raw.png';
        DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p31al2_cal091107\png_files\p31al2_lead100.raw.png';
        DCLE= imread(DC_filename);
        XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
        signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
        MEANDCLE=nanmean(signalDCLE);

        I = -log((image-MEANDCLE)/(MEANref-MEANDCLE))+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image
        I=I* 10000;
    end

    if  kVp == 39
        % FF_filename = 'A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airHE3mm.63raw.png';
%         FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airHE3mm.63raw.png';
        FF_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\TT004\CD2_wholeB_FlatF\png_files\p22al2_100FHE280Av.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airHE6mm.758raw.png';
        %      FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\29.195raw.png';
        %     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airHE6mm.54raw.png';
        I0HE= imread(FF_filename);
        
        %%% select ref ROI and calculate its mean value (in small paddle):
        %     Xmin=50;Xmax=200;Ymin=1525;Ymax=1600;
        Xmin=434;Xmax=584;Ymin=1717;Ymax=1792;   %%% same ROI ref as in small paddle
        ROIref=image(Ymin:Ymax,Xmin:Xmax);
        signal=reshape(ROIref,1,prod(size(ROIref)));
        MEANref=nanmean(signal);
        ROIrefI0=I0HE(Ymin:Ymax,Xmin:Xmax);
        signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
        MEANrefI0=nanmean(signalI0);
        %%% dark current image (no paddle dependent)
        %DC_filename = 'A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead280.58raw.png';
        %DC_filename = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\dark_current\p170al1_lead280.58raw.png';
        DC_filename='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\p31al2_cal091107\png_files\p31al2_lead280.raw.png';
        DCHE= imread(DC_filename);
        XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
        ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
        signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
        MEANDCHE=nanmean(signalDCHE);

        I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0HE)-MEANDCHE)/(MEANrefI0-MEANDCHE)); % intensity/I_0 corrected image
        I=I* 10000;
    end




else % for small paddle images

    if  kVp == 25
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
