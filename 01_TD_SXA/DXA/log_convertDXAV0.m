function I = log_convertDXA(image,mAs, kVp, Alfilter)
global Result

% %%% new normalization
%   voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
%   max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,33974.3];%40868.8 33974.3  2000 3276
%   for 39kVp open -  33974.3, for 3mm Al - 3276, 
%   for 6mm Al: I changed the last value: 1255 counts
%     max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,1255];
% 
%   mmax = max_counts(find(voltages == kVp)); %9074.182 for 26 kVp
%   rect = [385,193,1279,1662];
%   I = -log(image*100/(mmax*mAs))* 10000;
%   {
%    H = fspecial('disk',5);
%    LE1 = imfilter(I,H,'replicate');
%    I = funcGradientGauss(LE1,5);
%    }
% {
%    if  kVp == 39
%       FF_filename = 'D:\temp\FlatField_Selenia\FFNorm_6mmAl28Aug.png';
%       FF_filename = 'P:\aaSTUDIES\Breast Studies\DXA_breast\Source Data\FlatField_Selenia\FFNorm_6mmAl28Aug.png';
%       6mm Al - FFNorm_6mmAl28Aug.png
%       3mm Al - FFNorm_3mmAl28Aug.png
%       open - FFNorm_open28Aug.png
%       FFNorm = imread(FF_filename);
%       FFNorm = imcrop(FFNorm,rect);
%       I = I + double(FFNorm);
%     end
%   }
% tttttttttttttttttttttttt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if  kVp == 25
    FF_filename = 'Z:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airLEA.57raw.png';
%     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airLE.753raw.png';
%     FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\41.226raw.png';
%     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airLE.40raw.png';
    I0LE= imread(FF_filename);
    
    %%% select ref ROI and calculate its mean value:
    Xmin=1450;Xmax=1600;Ymin=50;Ymax=125;
% Xmin=1448;Xmax=1577;Ymin=56;Ymax=109;
    ROIref=image(Ymin:Ymax,Xmin:Xmax);
    signal=reshape(ROIref,1,prod(size(ROIref)));
    MEANref=nanmean(signal);
    ROIrefI0=I0LE(Ymin:Ymax,Xmin:Xmax);
    signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
    MEANrefI0=nanmean(signalI0);
    %%% dark current image
    DC_filename='U:\alaidevant\Selenia_images\p170al1_ghosting\png_files\p170al1_lead100.54raw.png';
    DCLE= imread(DC_filename);
    XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
    ROIDCLE=DCLE(YminDC:YmaxDC,XminDC:XmaxDC);
    signalDCLE=reshape(ROIDCLE,1,prod(size(ROIDCLE)));
    MEANDCLE=nanmean(signalDCLE);
    
%     I = -log(image)+log(double(I0LE)-62);
    I = -log((image-MEANDCLE)/(MEANref-MEANDCLE))+log((double(I0LE)-MEANDCLE)/(MEANrefI0-MEANDCLE)); % intensity/I_0 corrected image 
    I=I* 10000;
end

if  kVp == 39
    FF_filename = 'Z:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\airscan\p144al1_airHE3mm.63raw.png';
%     FF_filename = 'U:\alaidevant\Selenia_images\p112al1_cal051707\png_files\p112al1_airHE6mm.758raw.png';
%      FF_filename = 'U:\alaidevant\Selenia_images\p89al1_TT001L\calibrations\png_files\29.195raw.png';
%     FF_filename = 'U:\alaidevant\Selenia_images\p124al1_052307\png_files\p126al1_airHE6mm.54raw.png';
     I0LE= imread(FF_filename);
     
      %%% select ref ROI and calculate its mean value:
%       Xmin=1450;Xmax=1600;Ymin=50;Ymax=125;
      Xmin=1115;Xmax=1230;Ymin=81;Ymax=202; %%% small paddle
      % Xmin=1448;Xmax=1577;Ymin=56;Ymax=109;
      ROIref=image(Ymin:Ymax,Xmin:Xmax);
      signal=reshape(ROIref,1,prod(size(ROIref)));
      MEANref=nanmean(signal);
      ROIrefI0=I0LE(Ymin:Ymax,Xmin:Xmax);
      signalI0=reshape(ROIrefI0,1,prod(size(ROIrefI0)));
      MEANrefI0=nanmean(signalI0);
      %%% dark current image
      DC_filename='U:\alaidevant\Selenia_images\p170al1_ghosting\png_files\p170al1_lead280.58raw.png';
      DCHE= imread(DC_filename);
     XminDC=500;XmaxDC=1640;YminDC=355;YmaxDC=1680;
    ROIDCHE=DCHE(YminDC:YmaxDC,XminDC:XmaxDC);
    signalDCHE=reshape(ROIDCHE,1,prod(size(ROIDCHE)));
    MEANDCHE=nanmean(signalDCHE);
    
%        I = -log(image)+log(double(I0LE)/7-62);
    I = -log((image-MEANDCHE)/(MEANref-MEANDCHE))+log((double(I0LE)-MEANDCHE)/(MEANrefI0-MEANDCHE)); % intensity/I_0 corrected image 
    I=I* 10000;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555