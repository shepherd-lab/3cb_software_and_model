function ProdigyDXAdensityComputation()
    global Image Result ROI xy PreciseOutline figuretodraw 
     pixel_area = 0.0063508; %cm^2  
    BW = roipoly(ROI.image,PreciseOutline.x',PreciseOutline.y');
     D = bwdist(~BW); 
    %imshow(I)
   %  figure;
   % imagesc(~BW); colormap(gray);hold on;
   % figure;
   % imagesc(D); colormap(gray);hold on;
    mc = max(max(D)) 
    [index_y,index_x] = find(D==mc);
    xc = mean(index_x)
    yc = mean(index_y)
    xi = PreciseOutline.x;
    yi = PreciseOutline.y;
    
    roi_immaterial2=Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    index_wrong = find(roi_immaterial2==Inf|roi_immaterial2==NaN);
    roi_immaterial2(index_wrong) = 0;
    index_wrong2 = find(roi_immaterial2==Inf|roi_immaterial2==NaN);
    roi_immaterial = funcclim(roi_immaterial2,-50,200);
    index_wrong3 = find(roi_immaterial==Inf|roi_immaterial==NaN);
    roi_HE = Image.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    %
    %xc = sum(xi)/ length(xi);
    %yc = sum(yi)/ length(yi);
    
    x25 = xc + (xi-xc)*0.25;
    y25 = yc + (yi-yc)*0.25;
    
    x50 = xc + (xi-xc)*0.50;
    y50 = yc + (yi-yc)*0.50;
    
    x75 = xc + (xi-xc)*0.75;
    y75 = yc + (yi-yc)*0.75;
    
    Result.xc = xc;
    Result.yc = yc;
    Result.x100 = xi;
    Result.y100 = yi;
    Result.x75 = x75;
    Result.y75 = y75;
    Result.x50 = x50;
    Result.y50 = y50;
    Result.x25 = x25;
    Result.y25 = y25;
       
    area100 = polyarea(PreciseOutline.x',PreciseOutline.y')*pixel_area;
    area75 = polyarea(x75', y75')*pixel_area;
    area50 = polyarea(x50', y50')*pixel_area;
    area25 = polyarea(x25', y25')*pixel_area;
    
    breast_Mask100 = roipoly(ROI.image,PreciseOutline.x',PreciseOutline.y');
    breast_Mask75 = roipoly(ROI.image,x75',y75');
    breast_Mask50 = roipoly(ROI.image,x50',y50');
    breast_Mask25 = roipoly(ROI.image,x25',y25');
    
    H = fspecial('disk',5);
    %temp_image = imfilter(Image.thickness,H,'replicate');
    %imthickness = funcGradientGauss(temp_image,3);
    roi_imthickness=Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    
    imthickness_masked100_2 = breast_Mask100 .* roi_imthickness;
    imthickness_masked100 = (imthickness_masked100_2>0).*imthickness_masked100_2;
   %  figure;
   % imagesc(imthickness_masked100_2); colormap(gray);
     nn2 = nansum(nansum(imthickness_masked100_2))
   % figure;
    %imagesc(imthickness_masked100); colormap(gray);
    nn = nansum(nansum(imthickness_masked100))
    
    imthickness_masked75 = breast_Mask75 .* roi_imthickness;
    imthickness_masked50 = breast_Mask50 .* roi_imthickness;
    imthickness_masked25 = breast_Mask25 .* roi_imthickness;
   % figure;
   % imagesc( breast_Mask100);colormap(gray);
     index_wrong4 = find(breast_Mask100==Inf|breast_Mask100==NaN);
   % figure;
   % imagesc(roi_immaterial);colormap(gray);
    
    immaterial_masked100 = roi_immaterial .* breast_Mask100;
    immaterial_masked75 = breast_Mask75 .* roi_immaterial;
    immaterial_masked50 = breast_Mask50 .* roi_immaterial;
    immaterial_masked25 = breast_Mask25 .* roi_immaterial;
    index_wrong5 = find(immaterial_masked100==Inf|immaterial_masked100==NaN);
   % figure;  h = axes; hold on;
    %imagesc(immaterial_masked100); colormap(gray);
    max_thick = max(max(imthickness_masked100))
    min_thick = min(min(imthickness_masked100))
    max_thick = max(max(imthickness_masked75))
    min_thick = min(min(imthickness_masked75))
    max_thick = max(max(imthickness_masked50))
    min_thick = min(min(imthickness_masked50))
    max_thick = max(max(imthickness_masked25))
    min_thick = min(min(imthickness_masked25))
    
    imthickness_norm = imthickness_masked100 / max_thick ;
    %figure;
    %imagesc(imthickness_norm); colormap(gray);
    
    
    volume100 = pixel_area * nansum(nansum(imthickness_masked100));
    volume75 = pixel_area * nansum(nansum(imthickness_masked75));
    volume50 = pixel_area * nansum(nansum(imthickness_masked50));
    volume25 = pixel_area * nansum(nansum(imthickness_masked25));
    %{
    density100 = nansum(nansum(immaterial_masked100 .* imthickness_norm))/area100;
    density75 = nansum(nansum(immaterial_masked75 .* imthickness_norm))/area75;
    density50 = nansum(nansum(immaterial_masked50 .* imthickness_norm))/area50;
    density25 = nansum(nansum(immaterial_masked25 .* imthickness_norm))/area25;
    %}
    density100 = nansum(nansum(immaterial_masked100 .* imthickness_masked100))/(nansum(nansum(imthickness_masked100)));
    density75 = nansum(nansum(immaterial_masked75 .* imthickness_masked75))/(nansum(nansum(imthickness_masked75)) );
    density50 = nansum(nansum(immaterial_masked50 .* imthickness_masked50))/(nansum(nansum(imthickness_masked50)));
    density25 = nansum(nansum(immaterial_masked25 .* imthickness_masked25))/(nansum(nansum(imthickness_masked25)) );
    
    
    %plot(h, xi,yi,'r-', xc, yc,'*k', x75,y75, 'b-',x25, y25, 'g-', x50, y50, 'm-' ); 
      
    volume = [volume100 volume75 volume50 volume25]'
    density = [density100 density75 density50 density25]'
   % density_2 = [density100_2 density75_2 density50_2 density25_2]'
    area = [area100 area75 area50 area25]'
    Result.DXAProdigyBreastCalculated = true;  
    ProdigyDensityData.Output = {Result.acqid_str,Result.filenameLE_str,Result.filenameHE_str,Result.date_str...
                                 volume100,density100,area100, volume25, density25,area25, volume50, density50,area50, volume75, density75, area75};
    
             %                      ProdigyDensityData.Output{1,10+index} = mean(mean(Image.material(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
          %  Prodigy9stepsQAData.Output{2,index} = mean(mean(Image.LE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax) - Result.LE0));  
           % Prodigy9stepsQAData.Output{3,index} = mean(mean(Image.HE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax) - Result.HE0));  
    
    Excel('INIT');
    Excel('TRANSFERT',ProdigyDensityData.Output);
 
    %{
    MaskROI=zeros(size(ROI.image));
    for x=1:I-1
        MaskROI(y1(x):y2(x),x)=1;
    end
    
    ROI.rows=ROI.ymax-ROI.ymin+1;
    ROI.columns=ROI.xmax-ROI.xmin+1;        
    ROI.image=tempimage(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    ROI.BackGround=Analysis.BackGround(ROI.ymin:ROI.ymin+size(ROI.image,1)-1,ROI.xmin:ROI.xmin+size(ROI.image,2)-1);
    MaskValidBreast=MaskROI.*(Analysis.ImageFatLean>0).*(1-isnan(Analysis.ImageFatLean));
    Analysis.DensityPercentage=nansum(nansum(Analysis.ImageFatLean.*MaskValidBreast))/sum(sum(MaskValidBreast))*100;
    MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    temproi2 = (temproi1>0).*temproi1;
     %}