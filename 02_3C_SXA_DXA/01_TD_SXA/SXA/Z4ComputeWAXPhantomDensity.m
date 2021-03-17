function  Analysis = Z4ComputeWaxPhantomDensity(ROI,Image,Analysis,index)
         
        global Info bb Analysis params roi_values Error h_slope Z4coef_tableSmall  MachineParams thickness_ROI  Database phleanref_vect%ROI
               
       % temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
       %thickness of the phantom % 107083 6.039	7.006	7.973
       
       if index == 1 || index == 4 || index == 7
           thickness = 6;
       elseif index == 2 || index == 5 || index == 8
            thickness = 4;
           %thickness = 6.039;
           %thickness = 7.006;
           %thickness = 7.973;
           %thickness = 5.946; 
           %thickness = 4.979; 
% % %            thickness = 4.012; 
           %thickness = 2.994; 
           %thickness = 2.027; 
           %thickness = 0.967; 
           %thickness = 3.961; 
           %Analysis.thicknessDSP7  = 4.012;   
       elseif index == 3 || index == 6 || index == 9
           thickness = 2;
       end
      
       Z4coef_table = Z4coef_tableSmall;
       
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
       
    if Info.DigitizerId>=4
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
    r  = roi_valuescorr'    
    mAs = Info.mAs;
    kVp = Info.kVp;
    %thickness = Analysis.ph_thickness; % for breast
    
    Y_angle = 0;
    X_angle = 0;
    %params(4) - Info.bucky_distance;%;1.7; %1.38-0.05
     
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
    Analysis.fresult = fresult;
    Analysis.ydata_ph80 = ydata_ph80;
    Analysis.xdata = xdata;
    Vph80 = ph80_a2 * xdata.^2 + ph80_a1 * xdata + ph_offset;
    for i = 1: length_80ref
       [km, klean] = coeff_extraction(xdata(i),klean_vect, km_vect, h_corrvect);
       Vph80_fitvect(i) = ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i) + ph_offset;
       ref80corr_vect(i,1) = klean * ydata_ph80(i);
       fatref_vectDSP7(i) = klean*(Vph80_fitvect(i) + (1/km-1)*(ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i)));
       fatref_vect(i) = fatref_vectDSP7(i) - (ref80corr_vect(i) - fatref_vectDSP7(i))*30/80;
       fatref_vect(i) = fatref_vectDSP7(i);
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
    %{
     h_slope = figure;
     plot(xdata, ydata_ph100, 'bo',xdata, ydata_fat,'b*'); hold on;
     legend('fibroglandular reference','fat reference',2); 
     plot( xdata,yc_ph100fit,'-r', xdata,yc_fatfit,'-m'); 
     grid on; 
     
     set(gca, 'Xlim',[1.8 7]);
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
    
    %Lean_ref_init = ph_slope80 * thickness + ph_offset;
       
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
   
    thickness_ROI = thickness*ones(size(temproi)); %ROI.image
        
    Lean_ref_ROI = ph80_a2corr * thickness_ROI.^2 + ph80_a1corr * thickness_ROI + ph_offsetcorr;
    Fat_ref_ROI = ph_a2fat * thickness_ROI.^2 +  ph_a1fat * thickness_ROI + ph_offsetfat; 
    
    crisco_ref = -30; %-32.5;
    
    %crisco_coef = ((80 - crisco_ref)/(100 - crisco_ref))*100/80; 
    
    crisco_coef = 1;
    DensityImage =(temproi-Fat_ref_ROI)./(Lean_ref_ROI - Fat_ref_ROI)*80*crisco_coef; 
  
    %Analysis.DensityImage=DensityImage;
   Analysis.DensityPercentage=nansum(nansum(DensityImage.*thickness_ROI))/sum(sum(thickness_ROI));
    
   % Analysis.DensityPercentage=mean(mean(DensityImage));
       
    density = Analysis.DensityPercentage
    anal = Analysis;
 