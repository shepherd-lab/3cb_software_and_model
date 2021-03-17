function  funcComputeStepBDDigital(Innerline,ROI, Image)
    global Info bb Analysis params roi_values Error h_slope coef_tables ROI
    Error.DENSITY=false;
    
    if Info.centerlistactivated == 4
        phantom_thickness(1) = 1.2319; 
        phantom_thickness(2) = 3.2639;
        phantom_thickness(3) = 5.6134;
        phantom_thickness(4) = 2.67716;
        phantom_thickness(5) = 4.7244;
        phantom_thickness(6) = 7.06374;
        phantom_thickness(7) = 1.95834;
        phantom_thickness(8) = 4.0005;
        phantom_thickness(9) = 6.3373;
    elseif Info.centerlistactivated == 8
        phantom_thickness(1) = 1.2192; 
        phantom_thickness(2) = 3.41122; 
        phantom_thickness(3) = 5.53466; 
        phantom_thickness(4) = 2.66192;
        phantom_thickness(5) = 4.8514; 
        phantom_thickness(6) = 6.97738;
        phantom_thickness(7) = 1.95834;
        phantom_thickness(8) = 4.11988; 
        phantom_thickness(9) = 6.24078;  
    elseif Info.centerlistactivated == 9
        phantom_thickness(1) = 1.19126; 
        phantom_thickness(2) = 3.2639; 
        phantom_thickness(3) = 5.64642; 
        phantom_thickness(4) = 2.68224;
        phantom_thickness(5) = 4.70154;  
        phantom_thickness(6) = 7.06374;
        phantom_thickness(7) = 2.00406;
        phantom_thickness(8) = 3.99034;
        phantom_thickness(9) = 6.35508;  
    else
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
    end
    
      %{
       phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z; 
      %}  
        
     %{ 
     Info.DigitizerId=4;
     Info.mAs = 120;
     Info.kVp = 32;
     %}
     if Info.DigitizerId==4
        index_out = find(Analysis.roi_values == -1);
        Analysis.roi_values(index_out) = [];
        phantom_thickness(index_out) = [];
        Analysis.roi_valuescorr = Analysis.roi_values;
        roi_valuescorr = Analysis.roi_valuescorr;
    else
        [roi_valuescorr,roi_centroids] = riovalues_calculation(Image.image);
        index_out = find(roi_valuescorr == -1);
        roi_valuescorr(index_out) = [];
        phantom_thickness(index_out) = [];
        Analysis.roi_valuescorr = roi_valuescorr;
    end
        
    mAs = Info.mAs;
    kVp = Info.kVp
    %technique = Info.technique;
    thickness = params(4) - 1.7; %1.38-0.05
    %thickness = 8;
    %round_thick = round(params(4) - 1.6);
    %thickness = 6.001;
    %%%% only for open 
    %{
    thickness = 6.001;
    Analysis.RefFat = 0;
    Analysis.RefGland = 80;
    %}
    %%%%%%%%%%%%%%%%%%%%%
      switch Info.kVp
          case  24
              klean_table = coef_tables.klean24;
              kmless3cm_table = coef_tables.km24less3cm;
              kmmore3cm_table = coef_tables.km24more3cm;
          case 25
              klean_table = coef_tables.klean25;
              kmless3cm_table = coef_tables.km25less3cm;
              kmmore3cm_table = coef_tables.km25more3cm;  
          case 26
              klean_table = coef_tables.klean26;
              kmless3cm_table = coef_tables.km26less3cm;
              kmmore3cm_table = coef_tables.km26more3cm;
          case 27
              klean_table = coef_tables.klean27;
              kmless3cm_table = coef_tables.km27less3cm;
              kmmore3cm_table = coef_tables.km27more3cm;   
          case 28
              klean_table = coef_tables.klean28;
              kmless3cm_table = coef_tables.km28less3cm;
              kmmore3cm_table = coef_tables.km28more3cm;       
          case 29
              klean_table = coef_tables.klean29;
              kmless3cm_table = coef_tables.km29less3cm;
              kmmore3cm_table = coef_tables.km29more3cm;         
          case 30
              klean_table = coef_tables.klean30;
              kmless3cm_table = coef_tables.km30less3cm;
              kmmore3cm_table = coef_tables.km30more3cm;     
          case 31
              klean_table = coef_tables.klean31;
              kmless3cm_table = coef_tables.km31less3cm;
              kmmore3cm_table = coef_tables.km31more3cm;     
          case 32
              klean_table = coef_tables.klean32;
              kmless3cm_table = coef_tables.km32less3cm;
              kmmore3cm_table = coef_tables.km32more3cm;         
          case 33
              klean_table = coef_tables.klean33;
              kmless3cm_table = coef_tables.km33less3cm;
              kmmore3cm_table = coef_tables.km33more3cm;       
          otherwise
                ;
       end    
     hklean_vect = klean_table(2:end,1); 
     hkmless3cm_vect = kmless3cm_table(2:end,1); 
     hkmmore3cm_vect = kmmore3cm_table(2:end,1);
     mAs_vect = klean_table(1,2:end); 
     floor_thick = floor(thickness);
    
     if thickness < 3
        %floor_hkm = floor(hkmless3cm_vect);
        %{
        if floor_thick == 0 %& thickness(1) < 1
            floor_hkm = hkmless3cm_vect(1);
        else
            floor_hkm = floor_thick;
        end
        %}
        hkm_vect = hkmless3cm_vect;
        km_table = kmless3cm_table;
        length_80ref = 5;
     else
        %floor_hkm = floor(hkmmore3cm_vect);
        %{
        if floor_thick == 0 %& thickness(1) < 1
            floor_hkm = hkmmore3cm_vect(1);
        else
            floor_hkm = floor_thick;
        end
        %}
        hkm_vect = hkmmore3cm_vect;
        km_table = kmmore3cm_table;
        length_80ref = length(roi_valuescorr);
     end
     
      if floor_thick == 0 %& thickness(1) < 1
         floor_hklean = hklean_vect(1);
      else
         floor_hklean = floor_thick; 
      end
     
     if floor_thick == 0 %& thickness(1) < 1
         floor_hkm = hkm_vect(1);
     else
          floor_hkm = floor_thick;
     end
    
     if mAs <=  mAs_vect(2)
         mAs_floor =  mAs_vect(1);
     elseif mAs >=  mAs_vect(2) & mAs <  mAs_vect(3)
         mAs_floor =  mAs_vect(2);
     else
         mAs_floor = mAs_vect(3);
     end
     
     mAs_index = find(mAs_vect==mAs_floor);
     if mAs_index == length(mAs_vect)
         mAs_index = mAs_index - 1;
     end
     
     prop_mAs = (mAs - mAs_vect(mAs_index)) / (mAs_vect(mAs_index+1)-mAs_vect(mAs_index));
     
     klean_array = klean_table(2:end,mAs_index+1) + prop_mAs* (klean_table(2:end,mAs_index+2)-klean_table(2:end,mAs_index+1));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% proportional variant
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    index_max = min(find(hleanref_vect> thickness)); 
     if isempty(index_max)  
        index_max = length(hleanref_vect);
     end
     if index_max == 1
         index_max = 2;
     end
     prop_hleanref = (thickness - hleanref_vect(index_max-1)) ./ (hleanref_vect(index_max)-hleanref_vect(index_max-1));
     Lean_ref_init = leanref_vect(index_max-1) + prop_hleanref* (leanref_vect(index_max)-leanref_vect(index_max-1));
     %}
     
     
     
     %%%%%%%%%%%%%%%%%  floor variant  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % hklean_index = find(hklean_vect==floor_hklean);
     hklean_index = max(find(hklean_vect < thickness));
     if mAs_index == length(mAs_vect)
         hklean_index = hklean_index - 1;
     end
     
     if  hklean_index == length(hklean_vect)
         hklean_index = hklean_index -1;
     end
         
     
     prop_hklean = (thickness - hklean_vect(hklean_index)) ./ (hklean_vect(hklean_index+1)-hklean_vect(hklean_index));
     klean = klean_array(hklean_index) + prop_hklean* (klean_array(hklean_index+1)-klean_array(hklean_index));
     
     km_array = km_table(2:end,mAs_index+1) + prop_mAs* (km_table(2:end,mAs_index+2)-km_table(2:end,mAs_index+1));
     
     hkm_index = max(find(hkm_vect<thickness));
     %hklean_index = max(find(hklean_vect < thickness));
     if mAs_index == length(mAs_vect)
         hkm_index = hkm_index - 1;
     end
     if  hkm_index == length(hkm_vect)
         hkm_index = hkm_index -1;
     end
     prop_hkm = (thickness - hkm_vect(hkm_index)) ./ (hkm_vect(hkm_index+1)-hkm_vect(hkm_index));
     km = km_array(hkm_index) + prop_hkm* (km_array(hkm_index+1)-km_array(hkm_index));
    %%%%%%%%%%%%%%%%%%%%%%%%%%% end floor variant %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    %}
 
    X_angle = -Analysis.ry/1.2 ;
                     % X_angle = 0;
    %k_angle = cos(15*pi/180)/cos((14.5 + X_angle)*pi/180);
                     %k_angle = 1;
   % phantom_thickness = phantom_thickness;%*k_angle;
   
    %1.2319	1.95834	2.67716	3.2639	4.0005	4.7244	5.6134	6.3373	7.06374

    %roi_data = [roi_values; phantom_thickness];
   %%% %index = find(roi_values(1,:)>10000&roi_values(1,:)<61000);  %for analog films 
    %roi_data = roi_temp(roi_values(1,:)>10000&roi_values(1,:)<61000),:);
    
    roi_data = [ phantom_thickness',roi_valuescorr'];
    %roidata_corr = roi_data(index,:); % for analog films
        
    roidata_corr = roi_data;
    roi_sorted = sortrows(roidata_corr,1);
    hleanref_vect = roi_sorted(:,1);
    leanref_vect = roi_sorted(:,2);
   
    xdata = hleanref_vect(1:length_80ref);
    ydata = leanref_vect(1:length_80ref);
    fresult = fit(xdata,ydata,'poly1')
    ph_slope80 = fresult.p1;
    ph_offset = fresult.p2;
    yc = ph_slope80 * xdata + ph_offset;
    
   
     km_fat = [1.5 1.46 1.42 1.4 1.37 1.34   1.32 1.29 1.3]';
     fatref_vect =  ph_slope80.*xdata./km_fat + ph_offset;
     ydata_fat = fatref_vect;
     fresult_fat = fit(xdata,ydata_fat,'poly1')
     ph_slope80_fat = fresult_fat.p1;
     ph_offset_fat = fresult_fat.p2;
     yc_fat = ph_slope80_fat * xdata + ph_offset_fat;
     
     ydata_100 = (ydata-ydata_fat)*0.25 + ydata; %/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%
      fresult_100 = fit(xdata,ydata_100,'poly1')
    ph_slope80_100 = fresult_100.p1;
    ph_offset_100 = fresult_100.p2;
    yc_100 = ph_slope80_100 * xdata + ph_offset_100; 
     
     h_slope = figure;
     plot(xdata(2:end), ydata_100(2:end), 'bo',xdata(2:end), ydata_fat(2:end),'b*'); hold on;
     legend('fibroglandular reference','fat reference',2); 
     plot( xdata(2:end),yc_100(2:end),'-r', xdata(2:end),yc_fat(2:end),'-m'); 
     grid on; 
     
     set(gca, 'Xlim',[1.8 7]);
    %}
     hleanref_index = find(floor(hleanref_vect(:,1))==floor_hklean);
     ln1 = length(hleanref_vect);
     if hleanref_index == ln1
         hleanref_index = hleanref_index - 1;
     end
     %}
     index_max = min(find(hleanref_vect> thickness)); 
     if isempty(index_max)  
        index_max = length(hleanref_vect);
     end
     if index_max == 1
         index_max = 2;
     end
     prop_hleanref = (thickness - hleanref_vect(index_max-1)) ./ (hleanref_vect(index_max)-hleanref_vect(index_max-1));
     Lean_ref_init = leanref_vect(index_max-1) + prop_hleanref* (leanref_vect(index_max)-leanref_vect(index_max-1));
    
    
    %Lean_ref_init = ph_slope80 * thickness + ph_offset;
    
    Analysis.Lean_ref = Lean_ref_init*klean;
    Analysis.Fat_ref = ph_slope80*thickness/km + ph_offset;
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
    
    fat = Analysis.Fat_ref;
    f = fat
   % temproi1 =(temproi-Analysis.Fat_ref)/(Analysis.Lean_ref-Analysis.Fat_ref)*80;
   % Analysis.ImageFatLean = (temproi1>0).*temproi1;
    
    %%%%%%%%%%%%%%% density with angle correction
   size_ROI = size(temproi)
   x_ROI = size_ROI(2)
   y_ROI = size_ROI(1)
   Xcoord = 1:x_ROI;
   X_position = params(5);
   Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
   thickness_ROI = thickness + (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(X_angle*pi/180);
   deltaH_ROI =  (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(X_angle*pi/180);
   Lean_ref_ROI = deltaH_ROI*ph_slope80 + Analysis.Lean_ref; 
   Fat_ref_ROI =  ph_slope80*thickness_ROI/km + ph_offset;
   temproi1 =(temproi-Fat_ref_ROI)./(Lean_ref_ROI - Fat_ref_ROI)*80; 
   %fatedge_index = find(temproi<= Analysis.Phantomfatlevel);
   %temproi1 =(temproi-Analysis.Fat_ref)./(Analysis.Lean_ref - Analysis.Fat_ref)*80; 
   %DensityImage = (temproi1>0).*temproi1; 
   
    %figure;
    %imagesc(DensityImage); colormap(gray);
    
    %DensityImage(find(DensityImage<= 0)) = 0;
    %DensityImage(fatedge_index) = 0;
    %figure;
    %imagesc(DensityImage); colormap(gray);
    
    %horizontal profile
    yc = floor((ROI.ymax - ROI.ymin) / 2 + ROI.ymin);
    Lean_ref_profile = Lean_ref_ROI(yc,:).*MaskROI(yc,:);
    Fat_ref_profile = Fat_ref_ROI(yc,:).*MaskROI(yc,:);
    lean0_index = find(Lean_ref_profile == 0); 
    fat0_index = find(Fat_ref_profile == 0);
    Lean_ref_profile(lean0_index) = Analysis.BackGroundThreshold;
    Fat_ref_profile(fat0_index) = Analysis.BackGroundThreshold;
    Analysis.Fat_ref_profile = Fat_ref_profile;
    Analysis.Lean_ref_profile = Lean_ref_profile;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% correction for angle
    fatedge_index = find(temproi<=Fat_ref_ROI); 
    DensityImage = temproi1;
    DensityImage(fatedge_index) = 0;
    %vertical profile
    xc = floor(0.37*(ROI.xmax - ROI.xmin));
    Leanref_profile_horiz = Lean_ref_ROI(:,xc).*MaskROI(:,xc);
    Fatref_profile_horiz = Fat_ref_ROI(:,xc).*MaskROI(:,xc);
    lean0_index = find(Leanref_profile_horiz == 0); 
    fat0_index = find(Fatref_profile_horiz == 0);
    Leanref_profile_horiz(lean0_index) = Analysis.BackGroundThreshold;
    Fatref_profile_horiz(fat0_index) = Analysis.BackGroundThreshold;
    Analysis.Fatref_profile_horiz = Fatref_profile_horiz;
    Analysis.Leanref_profile_horiz = Leanref_profile_horiz;
        
    Analysis.Xcoord = Xcoord;
    %figure;
    %imagesc(temproi); colormap(gray);
    
    %figure;
    %imagesc(Analysis.ImageFatLean); colormap(gray);
    
   %  figure;
   % imagesc(Analysis.ImageFatLean.*MaskROI); colormap(gray);
   
     %figure;
    %imagesc(MaskROI); colormap(gray);
    
    %MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    Analysis.DensityImage=MaskROI.*DensityImage;
    Analysis.ThicknessImage=MaskROI.*thickness_ROI;
    Analysis.DensityPercentage=nansum(nansum(DensityImage.*MaskROI.*thickness_ROI))/sum(sum(MaskROI.*thickness_ROI));
    
    %Analysis.DensityPercentage=nansum(nansum(DensityImage.*MaskROI))/sum(sum(MaskROI));
   
    density = Analysis.DensityPercentage
    anal = Analysis
    if isnan(Analysis.DensityPercentage)
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
    else 
        Error.DENSITY=false;
    end