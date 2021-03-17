%Creation date 5-20-03
%author Lionel HERVE

function Analysis=funcComputePhantomDensity(ROI,Image,Analysis);
        %rm = ROI.ymin
        %rrow = ROI.rows
        %rx = ROI.xmin
        %rcol = ROI.columns
        
        temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        
        Analysis.Phantomfatlevel=ValidMean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2)));
        LeanPixels=Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2));
        Analysis.Phantomleanlevel=ValidMean(LeanPixels);
 
        Analysis.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
        Analysis.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%    
  
        Analysis.ImageFatLean=(temproi-Analysis.Ref0)/(Analysis.Ref100-Analysis.Ref0);
        Analysis.DensityPercentage=mean(mean(Analysis.ImageFatLean))*100;
       % b = Analysis
        
         Hfatcorr = -0.135* Analysis.PhantomDistanceFatRef  + 6.98;
         Hleancorr =  43 * tan(-Analysis.AngleHoriz * 1.1 * 6.28 /360) + 1 ;
         Analysis.Hfatcorr = Hfatcorr;
         Analysis.Hleancorr = Hleancorr;
         
        Fatref_corr = Analysis.Phantomfatlevel + Hfatcorr * 2000;  %2100%1800 1860
        Leanref_corr = Analysis.Phantomleanlevel + (Hfatcorr + Hleancorr) * 2860;%3030%28002770
        meanroi = mean(mean(temproi))
        Analysis.DensityPercentage = ((meanroi - Fatref_corr) / (Leanref_corr - Fatref_corr)) * 80
        %Analysis.Phantomfatlevel = Fatref_corr;
        %Analysis.Phantomleanlevel = Leanref_corr;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  