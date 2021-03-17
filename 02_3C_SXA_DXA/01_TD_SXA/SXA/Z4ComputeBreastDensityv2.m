function  Z4ComputeBreastDensityv2(Innerline,ROI, Image)
    global Info bb Analysis params roi_values Error h_slope Z4coef_table ROI MachineParams thickness_ROI thickness_mapproj
    Error.DENSITY=false;
    
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
       
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
    kVp = Info.kVp;
    thickness = Analysis.ph_thickness;
    %params(4) - Info.bucky_distance;%;1.7; %1.38-0.05
    
    % thickness = 4;
     
     floor_thick = floor(thickness);
    
     h_corrvect = Z4coef_table(:,1);
     klean_vect = Z4coef_table(:,2);
     km_vect = Z4coef_table(:,3);
     
     length_80ref = length(roi_valuescorr);
          
      if floor_thick == 0 %& thickness(1) < 1
         floor_hcorr = h_corrvect(1);
      else
         floor_hcorr = floor_thick; 
      end
     
     %%%%%%%%%%%%%%%%%  floor variant  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % hklean_index = find(hklean_vect==floor_hklean);
    
     h_index = max(find(h_corrvect < thickness));
     if  h_index == length(h_corrvect)
         h_index = h_index -1;
     end
          
     prop_h = (thickness - h_corrvect(h_index)) ./ (h_corrvect(h_index+1)-h_corrvect(h_index));
     klean = klean_vect(h_index) + prop_h* (klean_vect(h_index+1)-klean_vect(h_index));
     km = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));
     
      
     Y_angle = (Analysis.ry + MachineParams.ry_correction)* 0.9 ;
     Y_angle = Analysis.ry-0.5;
   % wrong X_angle = -Analysis.rx + MachineParams.rx_correction/1.2; % ??? for   % sign of angle 
     %X_angle = Analysis.rx - MachineParams.rx_correction/1.2; % ??? for sign of angle
     X_angle = Analysis.rx; 
     % X_angle = 0;
     % Y_angle = Analysis.ry + 0.7;
     %Y_angle = 0;
     Analysis.Y_angle = Y_angle ;% X_angle = 0;
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
    phleanref_vect = roi_sorted(:,2);
   
    xdata = hleanref_vect(1:length_80ref);
    ydata_ph80 = phleanref_vect(1:length_80ref);
    fresult = fit(xdata,ydata_ph80,'poly2')
    ph80_a2 = fresult.p1;
    ph80_a1 = fresult.p2;
    ph_offset = fresult.p3;
    %yc = ph_a2 * xdata.^2 + ph_a2 * xdata + ph_offset;
    
    Vph80 = ph80_a2 * xdata.^2 + ph80_a1 * xdata + ph_offset;
    for i = 1: length_80ref
       [km, klean] = coeff_extraction(xdata(i),klean_vect, km_vect, h_corrvect);
       Vph80_fitvect(i) = ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i) + ph_offset;
       ref80corr_vect(i,1) = klean * ydata_ph80(i);
       fatref_vectDSP7(i) = klean*(Vph80_fitvect(i) + (1/km-1)*(ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i)));
       fatref_vect(i) = fatref_vectDSP7(i) - (ref80corr_vect(i) - fatref_vectDSP7(i))*32.5/80;
    end
    
    Vph80_fitvect  =  Vph80_fitvect';
    
    fresult3 = fit(xdata,ref80corr_vect,'poly2')
    ph80_a2corr = fresult3.p1;
    ph80_a1corr = fresult3.p2;
    ph_offsetcorr = fresult3.p3;
    Vph80corr_fitvect = ph80_a2corr * xdata.^2 + ph80_a1corr * xdata + ph_offsetcorr;
    
     
    xdata = hleanref_vect(1:length_80ref);
    ydata_fat = fatref_vect';
    fresult2 = fit(xdata,ydata_fat,'poly2')
    ph_a2fat = fresult2.p1;
    ph_a1fat = fresult2.p2;
    ph_offsetfat = fresult2.p3;
    yc_fatfit = ph_a2fat * xdata.^2 + ph_a1fat * xdata + ph_offsetfat;
    
    fres_lin = fit(xdata,ydata_fat,'poly1')
    ph_afat_lin = fres_lin.p1;
    ph_bfat_lin = fres_lin.p2;
    yc_fatfit_lin = ph_afat_lin * xdata + ph_bfat_lin ;
    Analysis.ph_afat_lin = ph_afat_lin;
    Analysis.ph_bfat_lin =  ph_bfat_lin;
    
    ydata_ph100 = (ref80corr_vect-ydata_fat)*0.25 + ref80corr_vect;
    yc_ph100fit = (Vph80corr_fitvect-yc_fatfit)*0.25 + Vph80corr_fitvect;
     h_slope = figure;
     plot(xdata, ydata_ph100, 'bo',xdata, ydata_fat,'b*'); hold on;
     legend('fibroglandular reference','fat reference',2); 
     plot( xdata,yc_ph100fit,'-r', xdata,yc_fatfit,'-m'); 
     grid on; 
     
     set(gca, 'Xlim',[1.2 7]);
    %}
     hleanref_index = find(floor(hleanref_vect(:,1))==floor_hcorr);
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
     Lean_ref_init = phleanref_vect(index_max-1) + prop_hleanref* (phleanref_vect(index_max)-phleanref_vect(index_max-1));
       
    [km_thick, klean_thick] = coeff_extraction(thickness,klean_vect, km_vect, h_corrvect); %for one thickness
    Analysis.Lean_ref = Lean_ref_init*klean_thick;
    Vph80_thick = ph80_a2 * thickness.^2 + ph80_a1 * thickness + ph_offset;
    Analysis.Fat_ref = klean_thick*(Vph80_thick + (1/km_thick-1)*(ph80_a2 * thickness.^2 + ph80_a1 * thickness));
    %Analysis.Fat_ref = ph_slope80*thickness/km + ph_offset;
    Analysis.Phantomleanlevel = Analysis.Lean_ref;
    Analysis.Phantomfatlevel = Analysis.Fat_ref;
    Analysis.ph2 = ph80_a2;
    Analysis.ph1 = ph80_a1;
    Analysis.ph_offset = ph_offset;
    Analysis.km = km_thick;
    Analysis.klean = klean_thick;
        
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
   tx = Analysis.params(5);    %/0.014); % 
   ty = Analysis.params(6);    %/0.014);
   tz = Analysis.params(4);    %/0.014);
   %resolution = 0.014; %in cm 
   resolution = Analysis.Filmresolution*0.1; %0.014; %in cm
   size_ROI = size(temproi);
   x_ROI = size_ROI(2)
   y_ROI = size_ROI(1)
   Xcoord = 1:x_ROI;
   X_position = Analysis.params(5);
   Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
   %YXcoord_ROI = thickness;
   YXcoord_ROI = Xcoord_ROI;
   x_linspace = 1:x_ROI;
   y_linspace = ((1:y_ROI)')*resolution;  
   
   % calculation of the plane parameters 
   x_lnsparce = 1:3:x_ROI;
   y_lnsparce = ((1:3:y_ROI)')*resolution;  %cm
   leny = length(y_lnsparce);
   lenx = length(x_linspace);
   X = repmat(x_linspace', leny,1);
   Y = ones(lenx,1);
   for i = 2:leny
       Y = [Y;i*ones(lenx,1)];
   end    
   Z = ones(lenx*leny, 1)*tz;
   one_colm = ones(lenx*leny,1);
   XYZ_matrix = [[X,Y]*resolution, Z,one_colm];    % in cm
   mmax1 = max(XYZ_matrix);
   mmin1 = min(XYZ_matrix);
   Tx1 = makehgtform('translate',[-tx -ty -tz]);
   Tx2 = makehgtform('translate',[tx ty tz]);
   %Y_angle = 0;
   Ry = makehgtform('yrotate',Y_angle*pi/180); 
   Rx = makehgtform('xrotate',X_angle*pi/180);           
   XYZ_trans = Tx2*Ry*Rx*Tx1*XYZ_matrix';
   mmax2 = max(XYZ_trans');
   mmin2 = min(XYZ_trans');
   %xROI_trans = round(XYZ_trans(1:x_ROI,1));
   plane_coef = plane_fittting(XYZ_trans'); %*resolution
   
   thickness_ROI = zeros(size(ROI.image));
   
   for i = 1:x_ROI
       middle = round(y_ROI/2);  
       thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
       if X_angle > 0
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
       else
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
       end
   end
   
    thickness_ROI = thickness_ROIcreation(X_angle,Y_angle) - MachineParams.bucky_distance;
   % thickness_ROI = thickness_ROIcreation(X_angle,Y_angle);
    %mmax = max(max(thickness_ROI))
    %mmin = min(min(thickness_ROI))
    %th = thickness
   %%%%%%%%%%%%%%%% for low part of breast 
      %thickness_ROI = thickness + (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(Y_angle*pi/180);
      
   figure; imagesc(thickness_ROI); colormap(gray);
   
   %figure; bar(histc(thickness_ROI));
   %deltaH_ROI =  (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(Y_angle*pi/180);
   %[km_ROI,klean_ROI] = coeffROI_extraction(thickness_ROI,klean_vect, km_vect, h_corrvect); %for all ROI thicknesses
   %Vph80_ROI = ph80_a2 .* thickness_ROI.^2 + ph80_a1 .*thickness_ROI + ph_offset;
   
   %Lean_ref_ROI = klean_ROI .* Vph80_ROI;
   %Fat_ref_ROI = klean_ROI*(Vph80_ROI + (1./km_ROI-1)* (Vph80_ROI - ph_offset));    %(ph80_a2 * thickness.^2 + ph80_a1 * thickness));
   
    %Vph80corr_fitvect = ph80_a2corr * xdata.^2 + ph80_a1corr * xdata + ph_offsetcorr;
    %yc_fatfit = ph_a2fat * xdata.^2 + ph_a1fat * xdata + ph_offsetfat;
    
    Lean_ref_ROI = ph80_a2corr * thickness_ROI.^2 + ph80_a1corr * thickness_ROI + ph_offsetcorr;
    Fat_ref_ROI = ph_a2fat * thickness_ROI.^2 +  ph_a1fat * thickness_ROI + ph_offsetfat; 
    
   %Lean_ref_ROI = deltaH_ROI*ph_slope80 + Analysis.Lean_ref;  %linear case
   %Fat_ref_ROI =  ph_slope80*thickness_ROI/km + ph_offset; % linear case
    crisco_ref = -32.5;
    crisco_coef = ((80 - crisco_ref)/(100 - crisco_ref))*100/80;     
   
   temproi1 =(temproi-Fat_ref_ROI)./(Lean_ref_ROI - Fat_ref_ROI)*80*crisco_coef; 
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
    yc = floor((ROI.ymax - ROI.ymin) / 2) ;%+ ROI.ymin);
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
    %{
    inner_MaskROI = zeros(size(ROI.image));
    inner_MaskROI(fatedge_index) = 0;
    inner_MaskROI = inner_MaskROI.*MaskROI;
    figure;
    imagesc(inner_MaskROI); colormap(gray);
     figure;
    imagesc(MaskROI); colormap(gray);
    edgeMaskROI =  MaskROI-inner_MaskROI;
    figure;
    imagesc(edgeMaskROI); colormap(gray);
    %}
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
   
    temproi(fatedge_index) =  Fat_ref_ROI(fatedge_index);
    %temproi = MaskROI.temproi;
    index_breast = find(MaskROI == 1);
   % breast_pixels = temproi(index_breast);
     figure(h_slope); hold on;
     plot(thickness_ROI(index_breast),temproi(index_breast), '.r'); hold off;
    %figure;
    %imagesc(Analysis.ImageFatLean); colormap(gray);
    
   %  figure;
   % imagesc(Analysis.ImageFatLean.*MaskROI); colormap(gray);
   
     %figure;
    %imagesc(MaskROI); colormap(gray);
    
    %MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    Analysis.DensityImage=MaskROI.*DensityImage;
    Analysis.ThicknessImage=MaskROI.*thickness_ROI;%*10; %in mm scale
    Analysis.DensityPercentage=nansum(nansum(DensityImage.*MaskROI.*thickness_ROI))/sum(sum(MaskROI.*thickness_ROI));
    Analysis.BreastArea = sum(sum(MaskROI * (Analysis.Filmresolution*0.1)^2))*0.965; % in cm2
    Analysis.BreastVolume = sum(sum(Analysis.ThicknessImage.*MaskROI*(Analysis.Filmresolution*0.1)^2))/ 1.0742*0.85;
    
    %Analysis.DensityPercentage=nansum(nansum(DensityImage.*MaskROI))/sum(sum(MaskROI));
    rho_fat = 0.9196;  %g/ml - density of fat 
    rho_lean = 1.1;    %g/ml - density of lean
    Analysis.TotalLeanMass = Analysis.BreastVolume*Analysis.DensityPercentage/100*rho_lean; %in g/cm^3
    Analysis.TotalFatMass = Analysis.BreastVolume*(100 -Analysis.DensityPercentage)/100*rho_fat; %in g/cm^3
    density = Analysis.DensityPercentage
    anal = Analysis
    if isnan(Analysis.DensityPercentage)
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
    else 
        Error.DENSITY=false;
    end