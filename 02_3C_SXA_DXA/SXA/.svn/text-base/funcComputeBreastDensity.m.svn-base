%Creation date 5-20-03
%author Lionel HERVE
% 2-17-04: work with Info.UseRoughness
% 4-28-04: take into account phantom reference values

function Analysis=funcComputeBreastDensity(ROI,Image,Analysis,Innerline,Info);
global ReportText Error Phantom

Error.SuperLeanWarning=false;

%Phantom.AngleHoriz = 0.7;
%Phantom.AngleCorr =  Phantom.AngleHoriz;
Phantom.AngleCorr =  0.0;              %Phantom.AngleHoriz;
Phantom.Angle = Phantom.AngleHoriz;
temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
Analysis.Phantomfatlevel=ValidMean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2)));
Analysis.OriginalPhantomfatlevel=ValidMean(Image.OriginalImage(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2)));
Analysis.OriginalPhantomleanlevel=ValidMean(Image.OriginalImage(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2)));
LeanPixels=Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2));
Analysis.Phantomleanlevel=ValidMean(LeanPixels);
an1 = Analysis
if sum(sum(isnan(LeanPixels)))>length(LeanPixels)/3
    Analysis.Phantomleanlevel=1.3*Analysis.Phantomfatlevel;
    ReportText = [ReportText , ' Lean wedge saturated use 1.3 x Fat wedge @'];
    Error.SATURATION=1;
end


%draw an image betwen 100% lean and 100%fat
Analysis.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
Analysis.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%

Analysis.ImageFatLean=(temproi-Analysis.Ref0)/(Analysis.Ref100-Analysis.Ref0);
an3 = Analysis
% Hfatcorr = 4.4
% Hleancorr = 3.4

 meanroi = mean(mean(temproi))
% Analysis.ImageFatLean1 = ((temproi - Fatref_corr) / (Leanref_corr - Fatref_corr)) * 80;


if Info.SXAGreaterValueForbidden
    ImageSuperLean=Analysis.ImageFatLean>1;
    Analysis.ImageFatLean=Analysis.ImageFatLean-ImageSuperLean.*Analysis.ImageFatLean+ImageSuperLean;
end
if Info.SXAnegativeValueForbidden
    ImageSuperFat=Analysis.ImageFatLean<0;
    Analysis.ImageFatLean=Analysis.ImageFatLean-ImageSuperFat.*Analysis.ImageFatLean;
end

%Analysis.DensityPercentage=nansum(nansum(Analysis.ImageFatLean.*MaskValidBreast))/sum(sum(MaskValidBreast))*100;

%an4 = Analysis
%compute sum of the value of the fatlean image in the innerregion
[C,I]=max(Innerline.x);
Npoint=size(Innerline.x,2);
innerline1_x=Innerline.x(1:I-1);
innerline1_y=Innerline.y(1:I-1);
innerline2_x=Innerline.x(Npoint:-1:Npoint-I+2);
innerline2_y=Innerline.y(Npoint:-1:Npoint-I+2);

ImageDensity=0;
y1=min(innerline2_y,innerline1_y);
y2=max(innerline2_y,innerline1_y);

MaskROI=zeros(size(ROI.image));
for x=1:I-1
    MaskROI(y1(x):y2(x),x)=1;
end

if Info.UseSuperFatLeanImage
    MaskValidBreast=MaskROI.*(Analysis.ImageFatLean>0).*(1-isnan(Analysis.ImageFatLean));   %use SuperFat info
    %figure('Name', 'MaskValidBreast');
    %imagesc(MaskValidBreast); colormap(gray);
    Analysis.DensityPercentage=nansum(nansum(Analysis.ImageFatLean.*MaskValidBreast))/sum(sum(MaskValidBreast))*100;
    if sum(sum((Analysis.ImageFatLean>1)))>Analysis.Surface/20
        Error.SuperLeanWarning=true;
    end
else
    MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    Analysis.DensityPercentage=nansum(nansum(Analysis.ImageFatLean.*MaskROI))/sum(sum(MaskROI))*100;
end
   
  %Phantom.Angle = -3.1;%-2.3
  %Analysis.Height1 = 40;
  
   an2 = Analysis
   size_ROI = size(temproi)
   x_ROI = size_ROI(2)
   y_ROI = size_ROI(1)
   Xcoord = 1:x_ROI;
   slope_roi =  repmat(Xcoord, y_ROI,1);
   szlope = size(slope_roi)
   Analysis.coordXFatcenter =  mean(Analysis.PhantomFatx);
   coor = Analysis.coordXFatcenter;
   pa = Phantom.Angle
   anfle = tan(Phantom.Angle * 6.28 /360)
   
  % Hleancorr = 43 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360) + 1  %43
   x = Phantom.AngleHoriz
   Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomD1 * Analysis.Filmresolution + 33.5
   %2800 (Hfatcorr +
  % height3 = Analysis.PhantomFatRefHeight
   Hfat_ROI  = (Analysis.coordXFatcenter-slope_roi)*(1 - Analysis.PhantomFatRefHeight/600) * tan(-Phantom.AngleCorr *1.1 * 6.28 /360) * Analysis.Filmresolution;
  hf = Hfat_ROI(1:100,1:100);
   %Hleancorr = 0;
   %Hfat_ROI = 0;
   
   min_hfat = min(min(Hfat_ROI))
   max_hfat = max(max(Hfat_ROI))
   szfatROI = size(Hfat_ROI)
   maskfull = x_ROI * y_ROI
   Fatref_corr = Analysis.Phantomfatlevel + Hfat_ROI  * 2000;%1860;%2100;%1800
   min_fatref = min(min(Fatref_corr))
   max_fatref = max(max(Fatref_corr))
   
 %  Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 2860; %3000 %2860     % for cpmc,  3000 for mtzion 100%
   
   if Analysis.PhantomID == 3
       Hleancorr = 39 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360); %+ 1 
       Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 3000;
   elseif Analysis.PhantomID == 5
       Hleancorr = 20 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360);  %43
       Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 2860;
   else
       Hleancorr = 43 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360) + 1  %43
       Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 2860;
  
   end
   min_leanref = min(min(Leanref_corr))
   max_leanref = max(max(Leanref_corr))
   temproi1 = ((temproi - Fatref_corr) ./ (Leanref_corr - Fatref_corr)) * ( Analysis.RefGland - Analysis.RefFat) + Analysis.RefFat;
   ag = Analysis.RefGland - Analysis.RefFat
   af = Analysis.RefFat
  
   %figure('Name', 'temproi');
   % imagesc(temproi); colormap(gray); colorbar
    
   %  figure('Name', 'MaskValidBreast');
   % imagesc(MaskValidBreast); colormap(gray); colorbar
    
    % figure('Name', 'Image');
    %imagesc(temproi.*MaskValidBreast); colormap(gray); colorbar
  
  
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
  
   max_temproi = max(max(temproi.*MaskValidBreast))
   min_temproi = min(min(temproi.*MaskValidBreast))
   masknum = sum(sum(MaskValidBreast))
   maskperc = masknum / maskfull
   tempr = nansum(nansum(temproi.*MaskValidBreast))/masknum
   
   temproi2 = (temproi1>0).*temproi1;
   chest_mask = excludeSXAmuscle(temproi);
   MaskValidBreast = chest_mask .* MaskValidBreast;
   %figure;
   %imagesc(MaskValidBreast); colormap(gray);
   clear temproi1
   sum_mask = sum(sum(MaskValidBreast))
   densitypercentage1  =nansum(nansum(temproi2.*MaskValidBreast))/sum(sum(MaskValidBreast)) %Analysis.ImageFatLean1
    size_temproi1 = size(temproi2)
   Analysis.DensityPercentageAngle = densitypercentage1
   % an5 = Analysis

   if isnan(Analysis.DensityPercentage)
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
   else 
        Error.DENSITY=false;
   end
