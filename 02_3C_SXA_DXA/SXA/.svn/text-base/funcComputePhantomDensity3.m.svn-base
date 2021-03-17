%Creation date 5-20-03
%author Lionel HERVE

function Analysis=funcComputePhantomDensity3(ROI,Image,Analysis,Phantom)
        %rm = ROI.ymin
        %rrow = ROI.rows
        %rx = ROI.xmin
        %rcol = ROI.columns
        Phantom.AngleCorr =  0.0;   
        
        temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        
        Analysis.Phantomfatlevel=ValidMean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2)));
        LeanPixels=Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2));
        Analysis.Phantomleanlevel=ValidMean(LeanPixels);
        
        Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomD3 * Analysis.Filmresolution + 33.5
        Hleancorr = 43 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360) + 1  %43
        %Hfat_ROI = (Analysis.coordXFatcenter - slope_roi) * (1 - (Analysis.Height1+5)/600) * tan(-Phantom.Angle * 6.28 /360) * 0.15;
        %Hfatcorr = 40 - Analysis.PhantomFatRefHeight
        Hfatcorr = 18 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360) 
        Analysis.Phantomfatlevel = Analysis.Phantomfatlevel + Hfatcorr * 2000;
        Analysis.Phantomleanlevel = Analysis.Phantomleanlevel + (Hleancorr + Hfatcorr) * 2860;
        
        Analysis.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
        Analysis.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%    
  
        Analysis.ImageFatLean=(temproi-Analysis.Ref0)/(Analysis.Ref100-Analysis.Ref0);
        Analysis.DensityPercentage=mean(mean(Analysis.ImageFatLean))*100;
        c = Phantom
        b = Analysis
        %{
        Hfatcorr = 0.65
        Hleancorr = 1.375
        Fatref_corr = Analysis.Phantomfatlevel + Hfatcorr * 2100%1800
        Leanref_corr = Analysis.Phantomleanlevel + (Hfatcorr + Hleancorr) * 3030%2800
        meanroi = mean(mean(temproi))
        Analysis.DensityPercentageOne = ((meanroi - Fatref_corr) / (Leanref_corr - Fatref_corr)) * 80
        Analysis.Phantomfatlevel = Fatref_corr;
        Analysis.Phantomleanlevel = Leanref_corr;
        %}
     %{
       Phantom.Angle = -4.7;%-2.3
      Analysis.Height1 = 30;
  
   an2 = Analysis
   size_ROI = size(temproi)
   x_ROI = size_ROI(2)
   y_ROI = size_ROI(1)
   Xcoord = 1:x_ROI;
   slope_roi =  repmat(Xcoord, y_ROI,1);
   szlope = size(slope_roi)
   coor = Analysis.coordXFatcenter
   pa = Phantom.Angle
   anfle = tan(Phantom.Angle * 6.28 /360)
   
   Hleancorr = 43 * tan(-Phantom.Angle * 6.28 /360) + 1
   %2800 (Hfatcorr +
 
   Hfat_ROI = (Analysis.coordXFatcenter - slope_roi) * (1 - (Analysis.Height1+5)/600) * tan(-Phantom.Angle * 6.28 /360) * 0.15;
   min_hfat = min(min(Hfat_ROI))
   max_hfat = max(max(Hfat_ROI))
   szfatROI = size(Hfat_ROI)
   maskfull = x_ROI * y_ROI
   Fatref_corr = Analysis.Phantomfatlevel + Hfat_ROI  * 1860;%1800
   min_fatref = min(min(Fatref_corr))
   max_fatref = max(max(Fatref_corr))
   Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 2770;%3030;
   min_leanref = min(min(Leanref_corr))
   max_leanref = max(max(Leanref_corr))
   temproi1 = ((temproi - Fatref_corr) ./ (Leanref_corr - Fatref_corr)) * 80;
  
   %{ 
   figure('Name', 'Image');
    imagesc(temproi.*MaskValidBreast); colormap(gray); colorbar
   dens_distr =  temproi1.*MaskValidBreast;
   dens_distr1 = (dens_distr>0).*dens_distr;
    figure('Name', 'Density Distribution');
    imagesc(dens_distr); colormap(gray); colorbar;
    
    sz_dens = size(dens_distr1)
   x_dens = sz_dens(1)
   y_dens = sz_dens(2)
    X = 1:x_dens;
    Y = 1:y_dens;
   
    dens_distrN=undersamplingN(dens_distr1,10);
     [X,Y]=meshgrid(1:size(dens_distrN,2),1:size(dens_distrN,1));
       figure('Name', '3D Density Distribution');
    surf(X,Y,dens_distrN,'FaceColor','red','EdgeColor','none');
    camlight left; lighting phong
   %}
  
   %max_temproi = max(max(temproi.*MaskValidBreast))
   %min_temproi = min(min(temproi.*MaskValidBreast))
   %masknum = sum(sum(MaskValidBreast))
   %maskperc = masknum / maskfull
   %tempr = nansum(nansum(temproi.*MaskValidBreast))/masknum
   size_temproi1 = size(temproi1)
   densitypercentage1  =nansum(nansum(temproi1))/(size_temproi1(1)*size_temproi1(2)) %Analysis.ImageFatLean1
   size_temproi1 = size(temproi1)
   Analysis.DensityPercentage = densitypercentage1 ;
       %}