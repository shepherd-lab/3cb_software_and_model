function  UKComputeStepBreastDensity(Innerline,ROI, Image)
    global Info bb Analysis  roi_values Error h_slope
    [roi_valuescorr,roi_centroids] = riovalues_calculation(Image.image);
    Analysis.roi_valuescorr = roi_valuescorr;
    mAs = Info.mAs;
    %kVp = Info.kVp
    technique = Info.technique;
    thickness = params(4) - 1.38-0.05;
    round_thick = round(params(4) - 1.38-0.05);
    if  technique == 1 %Mo/Mo strcmp(technique, 'Mo/Mo')
        switch round_thick
            case  3
                klean = 0.9466;
                km = 1.469;
            case  4
                klean = -1.518e-6*mAs^2 + 0.0006193*mAs + 0.9397;
                km = 1.5376;
            case  5
                klean = -2.4455e-6*mAs^2 + 0.001*mAs + 0.9795;
                km = 0.0001989*mAs + 1.531;
            case  6
                klean = 0.0008633*mAs + 1.086;
                km = 0.0003381*mAs + 1.532;
            case  7
                klean = 0.0008633*mAs + 1.086;
                km = 0.0003381*mAs + 1.532;   
            otherwise
                ;
        end
    elseif  technique == 2 % Mo/Rh strcmp(technique, 'Mo/Rh')
        switch round_thick
            case  5
                klean = 0.0003409*mAs + 0.9692;
                km = 1.577;
            case  6
                klean = 0.0007271*mAs + 1;
                km = 1.55573;
            case  7
                klean = 0.0005442*mAs + 1.159;
                km = 0.0001058*mAs + 1.52;
            case  8
                klean = 0.0005442*mAs + 1.159;
                km = 0.0001058*mAs + 1.52;
            otherwise
                ;
        end
    elseif  technique == 3 % Rh/Rh
        klean = 1.1692;
        km = 1.448;
    else
        %not known
    end
    
    phantom_thickness(1) = bb.bb1(1).z; %bb.bb1(1).z
    phantom_thickness(2) = bb.bb2(1).z;
    phantom_thickness(3) = bb.bb3(1).z;
    phantom_thickness(4) = bb.bb4(1).z;
    phantom_thickness(5) = bb.bb5(1).z;
    phantom_thickness(6) = bb.bb6(1).z;
    phantom_thickness(7) = bb.bb7(1).z;
    phantom_thickness(8) = bb.bb8(1).z;
    phantom_thickness(9) = bb.bb9(1).z;
    
    %roi_data = [roi_values; phantom_thickness];
    index = find(roi_values(1,:)>17000&roi_values(1,:)<61000);
    %roi_data = roi_temp(roi_values(1,:)>10000&roi_values(1,:)<61000),:);
    roi_data = [ phantom_thickness',roi_valuescorr'];
    roidata_corr = roi_data(index,:);
    xdata = roidata_corr(:,1);
    ydata = roidata_corr(:,2);
   
    
    %{
    fresult = fit(xdata,ydata,'poly1')
    ph_slope80 = fresult.p1;
    ph_offset = fresult.p2;
    yc = ph_slope80 * xdata + ph_offset;
    h_slope = figure;
    plot(xdata, ydata, 'bo', xdata,yc,'-r'); 
    Lean_ref_init = ph_slope80 * thickness + ph_offset;
    Analysis.Lean_ref = Lean_ref_init*klean;
    Analysis.Fat_ref = ph_slope80*klean*thickness/km + ph_offset;
    Analysis.Phantomleanlevel = Analysis.Lean_ref;
    Analysis.Phantomfatlevel = Analysis.Fat_ref;
    Analysis.ph_slope80 = ph_slope80;
    Analysis.ph_offset = ph_offset;
    Analysis.km = km;
    Analysis.klean = klean;
    Analysis.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    Analysis.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    
    temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    
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
    temproi1 =(temproi-Analysis.Fat_ref)/(Analysis.Lean_ref-Analysis.Fat_ref)*80;
    Analysis.ImageFatLean = (temproi1>0).*temproi1;
    
    %figure;
    %imagesc(temproi); colormap(gray);
    
    %figure;
    %imagesc(Analysis.ImageFatLean); colormap(gray);
    
   %  figure;
   % imagesc(Analysis.ImageFatLean.*MaskROI); colormap(gray);
   
     %figure;
    %imagesc(MaskROI); colormap(gray);
    
    %MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    Analysis.DensityPercentage=nansum(nansum(Analysis.ImageFatLean.*MaskROI))/sum(sum(MaskROI));
    density = Analysis.DensityPercentage
    anal = Analysis
    if isnan(Analysis.DensityPercentage)
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
    else 
        Error.DENSITY=false;
    end
    %}