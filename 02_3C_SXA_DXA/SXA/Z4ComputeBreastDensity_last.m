function  Z4ComputeBreastDensity(Innerline,ROI, Image)
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
   


      Y_angle = Analysis.ry - 0.054;%-0.5; % - 0.054; %+ 0.25 - 0.2;%-0.4;% + 0.3;
      
   % wrong X_angle = -Analysis.rx + MachineParams.rx_correction/1.2; % ??? for   % sign of angle 
     X_angle = Analysis.rx + MachineParams.rx_correction/1.2; % ??? for sign of angle
     X_angle = Analysis.rx;%-0.5; % - 0.1336;

     %X_angle = Analysis.rx; 
      X_angle = 0;
     % Y_angle = Analysis.ry + 0.7;
     %Y_angle = 0;
     Analysis.Y_angle = Y_angle;% X_angle = 0;
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
       fatref_vect(i) = fatref_vectDSP7(i);%- (ref80corr_vect(i) - fatref_vectDSP7(i))*30/80; %32.5
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
     plot(xdata, ydata_ph100, 'ko',xdata, ydata_fat,'k*', 'LineWidth',2); hold on;
     legend('fibroglandular reference','fat reference',2); 
     plot( xdata,yc_ph100fit,'-k', xdata,yc_fatfit,'-k','LineWidth',2); 
     grid on; 
     
     set(gca, 'Xlim',[1 8]);
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
    
    
    %Image.image(:,1) = Image.OriginalImage(:,1);
    temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    % bin_v = 0:500:60000; 
    %figure; hist( temproi,bin_v);
    %figure; imagesc(Image.image); colormap(gray);
     %figure; hist( Image.image,bin_v);
     
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
    %figure; imagesc(MaskROI); colormap(gray);
    fat = Analysis.Fat_ref;
    f = fat
   % temproi1 =(temproi-Analysis.Fat_ref)/(Analysis.Lean_ref-Analysis.Fat_ref)*80;
   % Analysis.ImageFatLean = (temproi1>0).*temproi1;
    
    %%%%%%%%%%%%%%% density with angle correction
   tx = Analysis.params(5);    %/0.014); % 
   ty = Analysis.params(6);    %/0.014);
   tz = Analysis.params(4);    %/0.014);
   resolution = 0.014; %in cm 
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
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(-y_linspace(middle+1:end)) + plane_coef(3); %y_ROI*resolution
       else
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
       end
   end
   
   %{
   X_angle  =0;
   Y_angle = 0;
   Analysis.ry = Y_angle;
   %}
   ph_dist = 570*(66.3-MachineParams.bucky_distance-3.6)/66.3;
   deltaH = ph_dist*0.014*tan(Y_angle*pi/180);
   deltaH2 = 570*0.014*tan(Y_angle*pi/180);
   th = 6.14 + deltaH - 2.65;
   th2 = 6.14 + deltaH2 - 2.65;
  
   %X_angle  =0;
   %Y_angle = 0;
   thickness_ROI = thickness_ROIcreation(X_angle,Y_angle); %-2.67; %- MachineParams.bucky_distance + deltaH;;
   %figure; imagesc(thickness_ROI); colormap(gray);
   mn_thickness = mean(mean(thickness_ROI));
   a  =1;
   %+ 0.06;
   
   %  figure; imagesc(thickness_ROI); colormap(gray);
    % thickness_ROI = thickness_ROIcreation(X_angle,Y_angle);
    %mmax = max(max(thickness_ROI))
    %mmin = min(min(thickness_ROI))
    %th = thickness
   %%%%%%%%%%%%%%%% for low part of breast 
      %thickness_ROI = thickness + (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(Y_angle*pi/180);
      
   %figure; imagesc(thickness_ROI); colormap(gray);
  
   %figure; imagesc(thickness_mapproj); colormap(gray);
  
   %figure; imagesc(MaskROI); colormap(gray);
   %figure; bar(histc(thickness_ROI));
   %deltaH_ROI =  (X_position-Xcoord_ROI*Analysis.Filmresolution*0.1)* tan(Y_angle*pi/180);
   %[km_ROI,klean_ROI] = coeffROI_extraction(thickness_ROI,klean_vect, km_vect, h_corrvect); %for all ROI thicknesses
   %Vph80_ROI = ph80_a2 .* thickness_ROI.^2 + ph80_a1 .*thickness_ROI + ph_offset;
   
   %Lean_ref_ROI = klean_ROI .* Vph80_ROI;
   %Fat_ref_ROI = klean_ROI*(Vph80_ROI + (1./km_ROI-1)* (Vph80_ROI - ph_offset));    %(ph80_a2 * thickness.^2 + ph80_a1 * thickness));
   
    %Vph80corr_fitvect = ph80_a2corr * xdata.^2 + ph80_a1corr * xdata + ph_offsetcorr;
    %yc_fatfit = ph_a2fat * xdata.^2 + ph_a1fat * xdata + ph_offsetfat;
    
   % thickness_mapproj = thickness_ROI - MachineParams.bucky_distance - 0.8; %- 0.4;%  ;% - 0.35;% + deltaH; - 1.19;% 
    
    thickness_mapprojIm = projection_conversionTILT();
    
    thickness_mapproj = thickness_mapprojIm(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
   % figure; imagesc(thickness_mapproj);colormap(gray);
   
   % only for y_angle = 0 - no angle
   thickness_mapproj(1:end,1:end)  = mean(mean(thickness_mapprojIm(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmax-11:ROI.xmax-1)));
  
   %figure; imagesc(thickness_mapproj);colormap(gray);
    mn_thickproj = mean(mean(thickness_mapproj))
    
    Lean_ref_ROI = ph80_a2corr * thickness_mapproj.^2 + ph80_a1corr * thickness_mapproj + ph_offsetcorr;
    Fat_ref_ROI = ph_a2fat * thickness_mapproj.^2 +  ph_a1fat * thickness_mapproj + ph_offsetfat; 
    Lean_ref_ROI100 = (Lean_ref_ROI-Fat_ref_ROI)*0.25 + Lean_ref_ROI;
    
   % figure; imagesc(Lean_ref_ROI); colormap(gray);
    %figure; imagesc(Lean_ref_ROI100); colormap(gray);
    %figure; imagesc(Fat_ref_ROI); colormap(gray);
   %Lean_ref_ROI = deltaH_ROI*ph_slope80 + Analysis.Lean_ref;  %linear case
   %Fat_ref_ROI =  ph_slope80*thickness_ROI/km + ph_offset; % linear case
    crisco_ref = -30;  %32.5;
   % crisco_coef = ((80 - crisco_ref)/(100 - crisco_ref))*100/80;     
   crisco_coef  = 1;
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
    Lean_ref_profile = Lean_ref_ROI100(yc,:).*MaskROI(yc,:);
    Fat_ref_profile = Fat_ref_ROI(yc,:).*MaskROI(yc,:);
    %Fat_ref_profile2 = Fat_ref_profile;
    lean0_index = find(Lean_ref_profile == 0); 
    fat0_index = find(Fat_ref_profile == 0);
    Lean_ref_profile(lean0_index) = Analysis.BackGroundThreshold;
    Fat_ref_profile(fat0_index) = Analysis.BackGroundThreshold;
    Analysis.Fat_ref_profile = Fat_ref_profile;
    Analysis.Lean_ref_profile = Lean_ref_profile;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% correction for angle
    fatedge_index = find(temproi<=Fat_ref_ROI); 
    
    %save('fat_ref_profile2.mat','Fat_ref_profile2');
    
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
    
   % DensityImage(fatedge_index) = 0;
    
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
    mn = mean(mean(thickness_ROI))
    MaskROIproj = thickness_mapproj>mn/2;
    
    MaskROIproj = MaskROI;
   % MaskROIproj2 = thickness_mapproj>mn/1.5;
    temproi_proj = temproi.*MaskROIproj;
    thickness_mapproj = thickness_mapproj.*MaskROIproj;
    index_proj = find(MaskROIproj == 1);
   % figure; imagesc(thickness_mapproj); colormap(gray);
    
   % bin_h = 0:0.1:8;
    %figure; hist( temproi_proj,bin_v);
   
   % figure; imagesc(temproi_proj);
   %{
    bin_v = 0:500:60000;
    bin_h = 0:0.1:8;
    [X,Y] = meshgrid(bin_h, bin_v);
    max_thick = max(max(thickness_mapproj));
    max_roi = max(max(temproi_proj));
    min_roi = min(min(temproi_proj));
    temproi_projnorm = temproi_proj;% .*thickness_mapproj/max_thick;
    Z = zeros(length(bin_v),length(bin_h));
    for i = 1:length(bin_v)
        index_v = find(temproi_projnorm>(i-1)*500 & temproi_proj<i*500);
        thickness_bin = thickness_mapproj(index_v);
        if isempty(thickness_bin)
            colv = zeros(length(bin_h),1);
        else
            colv = histc(thickness_bin,bin_h);
        end
        Z(i,:) = colv';
    end
    %}
     mZ = max(max(Z));
    Z_mask = Z>mZ/256;
    %figure; imagesc(Z_mask); colormap(gray);
    Z(Z<mZ/256) = mZ / 255;
    indexZ = find(Z);
    %}
    
    figure(h_slope); hold on;
    %plot(X(indexZ),Z(indexZ), '.r'); hold on;
    % figure; hist(thickness_mapproj(index_proj),bin_h);
   % figure; hist(temproi_proj(index_proj),bin_v);
    %Z = repmat(z_vh,1,length(bin_v))';
    %index_projZ = find(MaskROIproj.*Z_mask == 1);
    figure(h_slope); hold on;
    %
    plot(thickness_mapproj(index_proj),temproi_proj(index_proj), '.r'); hold on; %.*thickness_mapproj(index_proj)/max_thick
    %thick4fat = thickness_mapproj(index_proj);
    %roi4fat = temproi_proj(index_proj);
    %save('roi_thick4fat.mat','thick4fat','roi4fat');
    %}
    %k6 = 3100;
    %{
    load('roi_thick2fat.mat'); plot(thick2fat,roi2fat, '.r'); hold on; 
    load('roi_thick250.mat'); plot(thick250,roi250, '.r'); hold on; 
    load('roi_thick2lean.mat'); plot(thick2lean,roi2lean, '.r'); hold on; 
    
    load('roi_thick4fat.mat'); plot(thick4fat,roi4fat, '.r'); hold on;
    load('roi_thick450.mat'); plot(thick450,roi450, '.r'); hold on;
    load('roi_thick4lean.mat'); plot(thick4lean,roi4lean, '.r'); hold on;
    
    load('roi_thick6fat.mat'); plot(thick6fat,roi6fat+k6, '.r'); hold on;
    load('roi_thick650.mat'); plot(thick650,roi650+k6, '.r'); hold on;
    load('roi_thick6lean.mat'); plot(thick6lean,roi6lean+k6, '.r'); hold on;
    %}
     contour(X,Y,Z,250); %surf(X,Y,Z);
    
    temproi(fatedge_index) =  Fat_ref_ROI(fatedge_index);
    %temproi = MaskROI.temproi;
    index_breast = find(MaskROI == 1);
    
   % breast_pixels = temproi(index_breast);
    % figure(h_slope); hold on;
    % plot(thickness_ROI(index_breast),temproi(index_breast), '.r'); hold off;
    
     
     %figure;
    %imagesc(Analysis.ImageFatLean); colormap(gray);
    
   %  figure;
   % imagesc(Analysis.ImageFatLean.*MaskROI); colormap(gray);
   
     %figure;
    %imagesc(MaskROI); colormap(gray);
    
    %MaskROI=MaskROI.*(1-isnan(Analysis.ImageFatLean));
    %MaskROIproj=zeros(size(ROI.image));
  
    percent = bwarea(~MaskROIproj&MaskROI)*0.3/bwarea(MaskROIproj)*100;
  %  figure; imagesc(~MaskROIproj&MaskROI); colormap(gray);
    
    %figure; imagesc(
    %thickness_mapproj(thickness_mapproj>0.6)) ;
    % bw = Zs1>0.3*max(max(Zs1));
    %MaskROIproj(indexes) = 1;
    %DensityImage(DensityImage>100) = 100;
    
    %DensityImage(DensityImage<0) = 0;
    %DensityImage(~MaskROIproj) = -20;
    
    Analysis.DensityImage=MaskROIproj.*DensityImage;
    
    %figure; imagesc(DensityImage); colormap(gray);
    
 % Analysis.ThicknessImage=MaskROI.*thickness_ROI;%*10; %in mm scale
   Analysis.ThicknessImage=MaskROIproj.*thickness_mapproj;
   %*10;
   Analysis.DensityPercentage=nansum(nansum(DensityImage.*MaskROIproj.*thickness_mapproj))/sum(sum(MaskROIproj.*thickness_mapproj));
    Analysis.BreastArea = sum(sum(MaskROIproj * (Analysis.Filmresolution*0.1)^2))*0.965; % in cm2
    Analysis.BreastVolume = sum(sum( thickness_mapproj.*MaskROIproj*(Analysis.Filmresolution*0.1)^2))/ 1.0742*0.85; %Analysis.ThicknessImage
    
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