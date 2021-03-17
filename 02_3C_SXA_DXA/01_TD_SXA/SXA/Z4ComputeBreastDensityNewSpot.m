function  Z4ComputeBreastDensityNew(Innerline,ROI, Image)
    global Info bb Analysis Database params roi_values Error h_slope  ROI MachineParams thickness_ROI thickness_mapproj  thickness_mapreal breast_Maskcorr flag
    global Z4coef_tableBig Z4coef_tableSmall Z4coef_tableGE Result BreastMask MaskROIproj SXAAnalysis Outline
    global thickness_mapprojCrop DensityImageSkin DensityImage  SXAreport
     Error.DENSITY=false;
     Error.SuperLeanWarning=false;
     %Add two fields to Error, by Song, 03/11/11
     Error.SXAroiFitFailure = false;           %error when no best fit found
     Error.SXAroiFitWarning = false;    %warning when <= 5 ROI used
     %end of change
     Analysis.TotalFatMass = [];
     Analysis.TotalLeanMass = [];
     Analysis.DensityPercentageCut = [];
     Analysis.DensityPercentage = [];
     Analysis.DensityPercentageNoCorr = [];
     Analysis.BreastVolume = [];
     Analysis.BreastArea = [];
     Error.SuperLeanWarning=false;
     SXAAnalysis = [];
     resolution = Analysis.Filmresolution/10;
     %max_thickness = max(max(thickness_mapreal));
     crop_coef = 2.3;
     MaskROIproj = [];

     dynamic=65536;
     Analysis.Run_number = 13;   % 15 - cohort for UVM  % 3 - v7.1, pre GENII Lookup table = DSP7 table, thickness correction - DSP7 table, v6.5  
                              % 4 - v7.1, pre GENII Lookup table = DSP7,  5
                              % - same as 4; 6 - after correction of  thickness
                              % table, thickness correction - DSP7 table,
                              % v6.5, fixed thckness in Machine_Parameters
                              % 7 - DSP7 and DSP7 corrected
    % MachineParams.comId= 1;  % for temporay test of GEN 3 calibration
     MachineParams.comId= [];
    % try
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
        
       %for DXA and 
     if Info.Database == false
         Analysis.RefFat = 0;
         Analysis.RefGland = 80;
     end  
     
      if (Info.DigitizerId >=5 | Info.centerlistactivated == 46) & ~(Info.centerlistactivated >= 21 & Info.centerlistactivated <= 26)  %Info.centerlistactivated == 55 | Info.centerlistactivated == 56  | Info.centerlistactivated == 53  %strcmp(Analysis.film_identifier(1:3),'mar')                     
          Analysis.Ibkg = extract_Ibkg(Database.Name, Info.acqDate, Info.kVp, ...
                                Info.centerlistactivated, MachineParams.padSize);
      else
% % %             if Analysis.Ibkg<0             %Am 02282014
% % %              
% % %              Analysis.Ibkg = -2000;
% % %              
% % %          else
             Analysis.Ibkg =0;
% % %          end
      end 
    
     
     if Info.DigitizerId>=4
        index_out = find(Analysis.roi_values == -1);
        Analysis.roi_values(index_out) = [];
        phantom_thickness(index_out) = [];
        Analysis.roi_valuescorr = Analysis.roi_values - Analysis.Ibkg;
        roi_valuescorr = Analysis.roi_valuescorr;
    else
        [roi_valuescorr,roi_centroids] = riovalues_calculation(Image.image);
        index_out = find(roi_valuescorr == -1);
        roi_valuescorr(index_out) = [];
        phantom_thickness(index_out) = [];
        Analysis.roi_valuescorr = roi_valuescorr;
     end

     if Info.kVp > 38 
        % if ismember(kVpLE,Info)
          try
             mAs = Info.mAsLE;
             kVp = Info.kVpLE;
          catch
              errmsg = lasterr
              Error.DENSITY = true;
              Analysis.Step = 6;
              Message(errmsg);
          end
     else     
         mAs = Info.mAs;
         kVp = Info.kVp;
         technique = Info.technique;
     end
    
    thickness = Analysis.ph_thickness;
    %params(4) - Info.bucky_distance;%;1.7; %1.38-0.05
    
    % thickness = 4;
     
     floor_thick = floor(thickness);
% % %      if flag.small_paddle == true
% % %          MachineParams.padSize = 'Small';
% % %      else
% % %          MachineParams.padSize = 'Large';
% % %      end
% % %      Z4coef_table2 = readKvalues(Database.Name, Info.acqDate, Info.kVp, ...
% % %                                 Info.centerlistactivated, MachineParams.padSize);
          

     if 1 %Info.date_acquisition_num >= Info.date_GEN3_num
           
          Z4coef_table = extract_Kvalues(Database.Name, Info.acqDate, Info.kVp, ...
                                    Info.centerlistactivated, MachineParams.padSize);

          if Info.DigitizerId >=5 %Info.centerlistactivated == 55 | Info.centerlistactivated == 56  | Info.centerlistactivated == 53  %strcmp(Analysis.film_identifier(1:3),'mar')                     
              Z4coef_table = Z4coef_table(1:end-4,:);
          end% for GE  machines     
         MachineParams.comId= 1;
      
     else
        MachineParams.comId= 0;
        Analysis.GEN3diffdays = [];
        if  Info.DigitizerId==4
             if flag.small_paddle ==  false
                  switch kVp
                      case  24
                          Z4coef_table = Z4coef_tableBig.kVp24;

                      case 25
                          Z4coef_table = Z4coef_tableBig.kVp25;

                      case 26
                          Z4coef_table = Z4coef_tableBig.kVp26;

                      case 27
                          Z4coef_table = Z4coef_tableBig.kVp27;

                      case 28
                         Z4coef_table = Z4coef_tableBig.kVp28;

                      case 29
                         Z4coef_table = Z4coef_tableBig.kVp29;

                      case 30
                          Z4coef_table = Z4coef_tableBig.kVp30;

                      case 31
                         Z4coef_table = Z4coef_tableBig.kVp31;

                      case 32
                          Z4coef_table = Z4coef_tableBig.kVp32;

                      case 33
                         Z4coef_table = Z4coef_tableBig.kVp33;
                      case 34
                         Z4coef_table = Z4coef_tableBig.kVp34;   

                      otherwise
                            ;
                  end    
             else
                  Z4coef_table = Z4coef_tableSmall; 
             end
         elseif Info.DigitizerId >=5 & Info.DigitizerId<=7
              if  technique == 1
                   switch kVp
                       case  27
                           Z4coef_table = Z4coef_tableGE.MoMokVp27;
                       case  28
                           Z4coef_table = Z4coef_tableGE.MoMokVp28;
                       otherwise
                           if kVp < 27
                               Z4coef_table = Z4coef_tableGE.MoMokVp27;
                           else
                               Z4coef_table = Z4coef_tableGE.MoMokVp28;
                           end                          
                   end

              elseif technique == 2
                   switch kVp
                       case  27
                           Z4coef_table = Z4coef_tableGE.MoRhkVp27;
                       case  28
                           Z4coef_table = Z4coef_tableGE.MoRhkVp28;
                       case  29
                           Z4coef_table = Z4coef_tableGE.MoRhkVp29;
                       otherwise
                           if kVp < 27
                               Z4coef_table = Z4coef_tableGE.MoRhkVp27;
                           else
                               Z4coef_table = Z4coef_tableGE.MoRhkVp29;
                           end
                   end
              elseif technique == 3
                   switch kVp
                       case  28
                           Z4coef_table = Z4coef_tableGE.RhRhkVp28;
                       case  29
                           Z4coef_table = Z4coef_tableGE.RhRhkVp29;
                       case  30
                           Z4coef_table = Z4coef_tableGE.RhRhkVp30;
                       case  31
                           Z4coef_table = Z4coef_tableGE.RhRhkVp31;
                       case  32
                           Z4coef_table = Z4coef_tableGE.RhRhkVp32;
                       otherwise
                           if kVp < 28
                               Z4coef_table = Z4coef_tableGE.RhRhkVp28;
                           else
                               Z4coef_table = Z4coef_tableGE.RhRhkVp32;
                           end
                   end
              else
                  Z4coef_table = Z4coef_tableGE.MoMokVp27;
              end

        end 

     end
         h_corrvect = Z4coef_table(:,1);
         klean_vect = Z4coef_table(:,2);
         km_vect = Z4coef_table(:,3);
   
% % %      JW commented out 8/16/2011. v7c5 considers which SXA ROIs appropriate to use
% % %      if ((kVp == 24) | (kVp == 25))
% % %          index_80ref = find(roi_valuescorr<56000);
% % %          length_80ref = length(index_80ref);
% % %      else
         length_80ref = length(roi_valuescorr);
% % %      end
        
     
      
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

% Commented out by Song, 02-07-11
%      prop_h = (thickness - h_corrvect(h_index)) ./ (h_corrvect(h_index+1)-h_corrvect(h_index));
%      klean = klean_vect(h_index) + prop_h* (klean_vect(h_index+1)-klean_vect(h_index));
%      km = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));
     
     %{ 
     Y_angle = (Analysis.ry + MachineParams.ry_correction)* 0.9 ;
     Y_angle = Analysis.ry - 0.054;%-0.5; % - 0.054; %+ 0.25 - 0.2;%-0.4;% + 0.3;
     % wrong X_angle = -Analysis.rx + MachineParams.rx_correction/1.2; % ??? for   % sign of angle 
     X_angle = Analysis.rx + MachineParams.rx_correction/1.2; % ??? for sign of angle
     X_angle = Analysis.rx;%-0.5; % - 0.1336;
     Analysis.Y_angle = Y_angle;% X_angle = 0;
     %}
     if flag.small_paddle ==  true  %small paddle
         X_angle = Analysis.rx - MachineParams.rx_correction;
         Y_angle = Analysis.ry - MachineParams.ry_correction;
     else
         X_angle = Analysis.rx - MachineParams.rx_correction;
         Y_angle = Analysis.ry - MachineParams.ry_correction;

     end
     Analysis.X_angle_orig = X_angle;
     Analysis.Y_angle_orig = Y_angle;
% %      Analysis.Y_angle = Y_angle;
     
    roi_data = [ phantom_thickness',roi_valuescorr'];
    %roidata_corr = roi_data(index,:); % for analog films
        
    roidata_corr = roi_data;
    roi_sorted = sortrows(roidata_corr,1);
    hleanref_vect = roi_sorted(:,1);    %thickness of SXA steps
    phleanref_vect = roi_sorted(:,2);   %density of SXA steps
   
    xdata = hleanref_vect(1:length_80ref);          %thickness of SXA steps
    ydata_ph80 = phleanref_vect(1:length_80ref);    %density of SXA steps
  
    %% 3 times comment if there is a problem with SXA phantom fit
        %Updated by Song, 03/11/11
    %Statment
%     fresult = fit(xdata,ydata_ph80,'poly2')
    %was replaced by
    [roiFitCoef, roiChiSqr, roiUsed] = SXAroiBestFit(xdata, ydata_ph80);
    %which finds the best SXA roi fit, return the best-fit params, roi used
    %and error
    if isnan(roiFitCoef)
        Error.DENSITY = true;
        Error.SXAroiFitFailure = true;
        error('No best-fit line was found on SXA ROI values!');
    end
    if ( roiUsed(end) - roiUsed(1) < 5 )  %less than or equal to 5 roi used
        Error.SXAroiFitWarning = true;
    end
    Analysis.SXAroiFit = roiFitCoef;
    Analysis.SXAroiChiSqr = roiChiSqr;
    Analysis.SXAroiUsed = roiUsed;
    %consequently, the following assignment statements changed
%     ph80_a2 = fresult.p1;
%     ph80_a1 = fresult.p2;
%     ph_offset = fresult.p3;
    ph80_a2 = roiFitCoef(1);
    ph80_a1 = roiFitCoef(2);
    ph_offset = roiFitCoef(3);
    
    %end of change
    %%
    %%%%% restore temporary if you have problems with SXA phantom fit
% % %     fresult = fit(xdata,ydata_ph80,'poly2')
% % %      ph80_a2 = fresult.p1;
% % %      ph80_a1 = fresult.p2;
% % %      ph_offset = fresult.p3;
    %%%
    
%%    
    
    %yc = ph_a2 * xdata.^2 + ph_a2 * xdata + ph_offset;

% Commented out by Song 08-03-10, because it's never used
%     Vph80 = ph80_a2 * xdata.^2 + ph80_a1 * xdata + ph_offset;
%Initialization
Vph80_fitvect = zeros(length_80ref, 1);
ref80corr_vect = zeros(length_80ref, 1);
fatref_vect = zeros(length_80ref, 1);
    for i = 1: length_80ref
       [km, klean] = coeff_extraction(xdata(i),klean_vect, km_vect, h_corrvect);
       Vph80_fitvect(i) = ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i) + ph_offset;

% Changed by Song 08-03-10, to use fitted SXA value for lean curve
%        ref80corr_vect(i,1) = klean * ydata_ph80(i);
       ref80corr_vect(i) = klean * Vph80_fitvect(i);
        
% Changed by Song 09-13-10, separate two calibration methods
% if DSP, keep Serghei's code
% if GEN 3, use code from v7.0.C3, no fat reference conversion
       if MachineParams.comId <= 0  %DSP calibration
            fatref_vectDSP7(i) = klean*(Vph80_fitvect(i) + (1/km-1)*(ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i)));
            fatref_vect(i) = fatref_vectDSP7(i)- (ref80corr_vect(i) - fatref_vectDSP7(i))*30/80; %32.5
       else
            fatref_vect(i) = klean*(Vph80_fitvect(i) + (1/km-1)*(ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i)));
       end
       
% % %        %%% new GEN3 calibration
% % %     fatref_vect(i) = klean*(Vph80_fitvect(i) + (1/km-1)*(ph80_a2 * xdata(i).^2 + ph80_a1 * xdata(i)));
       
    end

 
    
% Commented by Song 08-03-10 because Vph80_fitvect is changed to a colume
% vector
%     Vph80_fitvect  =  Vph80_fitvect';
    
    fresult3 = polyfit(xdata,ref80corr_vect,2)    %fit for lean curve
    ph80_a2corr = fresult3(1);
    ph80_a1corr = fresult3(2);
    ph_offsetcorr = fresult3(3);
    Vph80corr_fitvect = ph80_a2corr * xdata.^2 + ph80_a1corr * xdata + ph_offsetcorr;
    
% Commented by Song 08-03-10 because this statement does not assign new values to xdata     
%     xdata = hleanref_vect(1:length_80ref);  %fit for fat curve
% Changed by Song 08-03-10 because fatref_vect is changed to a colume vect
%     ydata_fat = fatref_vect';
    ydata_fat = fatref_vect;
    fresult2 = polyfit(xdata,ydata_fat,2)
    ph_a2fat = fresult2(1);
    ph_a1fat = fresult2(2);
    ph_offsetfat = fresult2(3);
    yc_fatfit = ph_a2fat * xdata.^2 + ph_a1fat * xdata + ph_offsetfat;
    
    fres_lin = polyfit(xdata,ydata_fat,1)
    ph_afat_lin = fres_lin(1);
    ph_bfat_lin = fres_lin(2);
    yc_fatfit_lin = ph_afat_lin * xdata + ph_bfat_lin ;
    Analysis.ph_afat_lin = ph_afat_lin;
    Analysis.ph_bfat_lin =  ph_bfat_lin;
    
    ydata_ph100 = (ref80corr_vect-ydata_fat)*0.25 + ref80corr_vect;
    yc_ph100fit = (Vph80corr_fitvect-yc_fatfit)*0.25 + Vph80corr_fitvect;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
     h_slope = figure('Tag','Slope');
     set(h_slope,'Visible', 'On');
     
     plot(xdata, ydata_ph100, 'ko',xdata, ydata_fat,'k*', 'LineWidth',2); hold on;
     legend('fibroglandular reference','fat reference',2); 
     plot( xdata,yc_ph100fit,'-k', xdata,yc_fatfit,'-k','LineWidth',2); hold on;
     grid on; 
     
     set(gca, 'Xlim',[1 7]);hold on;
     %}
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1)-Analysis.Ibkg;
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
    szmaskroi = size(MaskROI);
    
    for x=1:I-1
        MaskROI(y1(x):y2(x),x)=1;
    end
% % %     figure; imagesc(MaskROI); colormap(gray);
    MaskROI = MaskROI(:,1:szmaskroi(2));
    fat = Analysis.Fat_ref;
   % f = fat
   % temproi1 =(temproi-Analysis.Fat_ref)/(Analysis.Lean_ref-Analysis.Fat_ref)*80;
   % Analysis.ImageFatLean = (temproi1>0).*temproi1;
    
    %%%%%%%%%%%%%%% density with angle correction
 
   
  % thickness_ROI = zeros(size(ROI.image));
   
   
   ph_dist = 570*(66.3-MachineParams.bucky_distance-3.6)/66.3;
   deltaH = ph_dist*Analysis.Filmresolution*0.1*tan(Analysis.Y_angle*pi/180);
   deltaH2 = 570*Analysis.Filmresolution*0.1*tan(Analysis.Y_angle*pi/180);
   th = 6.14 + deltaH - 2.65;
   th2 = 6.14 + deltaH2 - 2.65;
  
   %X_angle  =0;
   %Y_angle = 0;
  % thickness_ROI = thickness_ROIcreation(X_angle,Y_angle); %-2.67; %- MachineParams.bucky_distance + deltaH;;
   %figure; imagesc(thickness_ROI); colormap(gray);
   mn_thickness = mean(mean(thickness_ROI));
   %a  =1;
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
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TILT calibration  %%%%%%%%%%%%%%%%%%%%
    %{
    thickness_mapprojIm = projection_conversionTILT();
    thickness_mapproj = thickness_mapprojIm(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    % only for y_angle = 0 - no angle
    thickness_mapproj(1:end,1:end)  = mean(mean(thickness_mapprojIm(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmax-11:ROI.xmax-1)));
     %figure; imagesc(thickness_mapproj);colormap(gray);
    mn_thickproj = mean(mean(thickness_mapproj))
    %}
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    Lean_ref_ROI = ph80_a2corr * thickness_mapproj.^2 + ph80_a1corr * thickness_mapproj + ph_offsetcorr;
    Fat_ref_ROI = ph_a2fat * thickness_mapproj.^2 +  ph_a1fat * thickness_mapproj + ph_offsetfat; 
    Lean_ref_ROI100 = (Lean_ref_ROI-Fat_ref_ROI)*0.25 + Lean_ref_ROI;
%     figure; imagesc(thickness_mapproj); colormap(gray);
    %figure; imagesc(Lean_ref_ROI); colormap(gray);
    %figure; imagesc(Lean_ref_ROI100); colormap(gray);
    %figure; imagesc(Fat_ref_ROI); colormap(gray);
   %Lean_ref_ROI = deltaH_ROI*ph_slope80 + Analysis.Lean_ref;  %linear case
   %Fat_ref_ROI =  ph_slope80*thickness_ROI/km + ph_offset; % linear case

%Changed by Song 09-13-10, crisco_coef is related to the conversion 
%from DSP7 scale to crisco reference (Song Note 1, p.38)
%For the case of GEN 3 calibration, crisco_coef = 1

if MachineParams.comId > 0 %GEN 3 calibration
   crisco_coef = 1;
else
   crisco_ref = -30;  %32.5;
   crisco_coef = ((80 - crisco_ref)/(100 - crisco_ref))*100/80;
end
   %crisco_coef  = 1;
   DensityImage = (temproi-Fat_ref_ROI)./(Lean_ref_ROI - Fat_ref_ROI)*80*crisco_coef;
%Added by Song 08-16-10, density conversion from wax-water reference to
%crisco reference (crisco_fat = -30% of DSP7)
%Then changed by Song 09-13-10, this conversion only applies to GEN3 calib
if MachineParams.comId > 0
    DensityImage = refConvert(DensityImage);
end
%end of change
   %%% changed to remove negatives and very high densities from -20 to 0
   %%% and from 200 to 110
   
   DensityImage = funcclim(DensityImage,0,120); %for run 15  %%commented
   %%Temprorary 09/05/2014 by Pasha 

  
   %fatedge_index = find(temproi<= Analysis.Phantomfatlevel);
   %temproi1 =(temproi-Analysis.Fat_ref)./(Analysis.Lean_ref - Analysis.Fat_ref)*80; 
   %DensityImage = (temproi1>0).*temproi1; 
   
    %figure;
    %imagesc(DensityImage); colormap(gray);
    
    %DensityImage(find(DensityImage<= 0)) = 0;
    %DensityImage(fatedge_index) = 0;
    %figure;
    %imagesc(DensityImage); colormap(gray);
    
% Inserted by Song 08-11-10, use a look-up table to correct densities
% Changed by Song 09-13-10, density corretion only applies to GEN3 calib
    DensityImageBFCorr = DensityImage;
if MachineParams.comId > 0
    DensityImage = densCorr(DensityImage, thickness_mapproj, Database.Name, Analysis.GEN3commanal_id); %It was MachineParams.comId
else
     ATable = extract_A2A1A0_values(Database.Name, Info.acqDate, Info.kVp,Info.centerlistactivated, MachineParams.padSize);
     A2 = ATable(1);  A1 = ATable(2); A0 = ATable(3);
     DensityImage = A2*DensityImage.^2 + A1*DensityImage + A0;
end
    
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
    %DensityImage = temproi1;
    
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
    %Xcoord = 1:ROI.columns;   
    Analysis.Xcoord = 1:ROI.columns;
    %figure;
    %imagesc(temproi); colormap(gray);
    mn = mean(mean(thickness_ROI));
    %figure; imagesc(thickness_ROI); colormap(gray);
    
    MaskROIproj = thickness_mapproj>mn/crop_coef; %2.3
    
%     if Info.view_id == 4 | Info.view_id == 5
%     
%     Image.Mask_MLO=Image.Mask_MLO(ROI.row_start:ROI.row_end, ROI.column_start:ROI.column_end);
%     Mask_MLO=Image.Mask_MLO;
%     BreastMask=BreastMask.*Mask_MLO;
%     DensityImageMask=DensityImageMask.*Mask_MLO;
%     
% end
    
    %figure; imagesc((~MaskROIproj) & MaskROI); colormap(gray);title('Cropped area'); % draw the cropped area.
    
    %MaskROIproj = MaskROI;
    
   % MaskROIproj2 = thickness_mapproj>mn/1.5;
    temproi_proj = temproi.*MaskROIproj;
    thickness_mapprojCrop = thickness_mapproj.*MaskROIproj;
    %index_proj = find(MaskROIproj == 1);
   % figure; imagesc(thickness_mapproj); colormap(gray);
    
   % bin_h = 0:0.1:8;
    %figure; hist( temproi_proj,bin_v);
   
   % figure; imagesc(temproi_proj);
   %
    bin_v = 0:500:60000;
    bin_h = 0:0.1:8;
    [X,Y] = meshgrid(bin_h, bin_v);
    max_thick = max(max(thickness_mapprojCrop));
    max_roi = max(max(temproi_proj));
    min_roi = min(min(temproi_proj));
    temproi_projnorm = temproi_proj;% .*thickness_mapprojCrop/max_thick;
    Z = zeros(length(bin_v),length(bin_h));
    for i = 1:length(bin_v)
        index_v = find(temproi_projnorm>(i-1)*500 & temproi_proj<i*500);
        thickness_bin = thickness_mapprojCrop(index_v);
        if isempty(thickness_bin)
            colv = zeros(length(bin_h),1);
        else
            colv = histc(thickness_bin,bin_h);
        end
        Z(i,:) = colv';
    end
    
     mZ = max(max(Z));
    Z_mask = Z>mZ/256;
    %figure; imagesc(Z_mask); colormap(gray);
    Z(Z<mZ/256) = mZ / 255;
    indexZ = find(Z);
    %}
    
   %figure(h_slope); hold on;
    %plot(X(indexZ),Z(indexZ), '.r'); hold on;
    % figure; hist(thickness_mapprojCrop(index_proj),bin_h);
   % figure; hist(temproi_proj(index_proj),bin_v);
    %Z = repmat(z_vh,1,length(bin_v))';
    %index_projZ = find(MaskROIproj.*Z_mask == 1);
    %figure(h_slope); hold on;
    %
   % plot(thickness_mapprojCrop(index_proj),temproi_proj(index_proj), '.r'); hold on; %.*thickness_mapprojCrop(index_proj)/max_thick
    %thick4fat = thickness_mapprojCrop(index_proj);
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
    %contour(X,Y,Z,256); hold on;%surf(X,Y,Z);
    
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
    %thickness_mapprojCrop(thickness_mapprojCrop>0.6)) ;
    % bw = Zs1>0.3*max(max(Zs1));
    %MaskROIproj(indexes) = 1;
    %DensityImage(DensityImage>100) = 100;
    
    %DensityImage(DensityImage<0) = 0;
    %DensityImage(~MaskROIproj) = -20;
    
    %Analysis.DensityImage=MaskROIproj.*DensityImage;
    
    %figure; imagesc(Analysis.DensityImage); colormap(gray);
    
 % Analysis.ThicknessImage=MaskROI.*thickness_ROI;%*10; %in mm scale
   Analysis.SXAThicknessImageTotal=thickness_mapproj; %MaskROIproj.*
   
   y_index = find(MaskROIproj(:,2) == 1);
   upper_y = min(y_index);
   low_y = max(y_index);
   y_length = low_y - upper_y;
   x1up = 1;
   y1up = upper_y;
   x2up = 1;
   y2up = upper_y + round(y_length/14); 
   x3up = round(y_length/14 * tan(60 * pi / 180));
   y3up = y1up;
   CornerMask_upper =  1 - roipoly(ROI.image, [x1up x2up x3up],[y1up y2up y3up]);
   
   x1low = 1;
   y1low = low_y;
   x2low = 1;
   y2low = low_y - round(y_length/14); 
   x3low = round(y_length/14 * tan(60 * pi / 180));
   y3low = y1low;
   CornerMask_low =  1 - roipoly(ROI.image, [x1low x2low x3low],[y1low y2low y3low]);
   CornerMask = CornerMask_upper & CornerMask_low;
% % %   figure; imagesc(CornerMask); colormap(gray);
   corner_area = bwarea((~CornerMask)&MaskROIproj);
% % %   figure; imagesc((~CornerMask)&MaskROIproj); colormap(gray);
   breast_area = bwarea(MaskROIproj);
% % %    figure; imagesc(breast_area); colormap(gray);
   
   Hskin = 0.14; %thickness of skin in cm
   %G = %G – (100 -%G)*2*Hskin/Hbreast  
   %DensityImage = (DensityImage>-10&DensityImage<120).*DensityImage;
   
   DensityImageSkin = DensityImage - 2*(100 - DensityImage)*Hskin./(thickness_mapproj+0.01);
   
   Analysis.SXADensityImageHomo=MaskROIproj.*DensityImageSkin; 
   DensityImageSkin = funcclim(DensityImageSkin,0,100); %for run 15  %%commented
   %%Temprorary 09/05/2014 by Pasha ; 
   
   
   DensityImageSkinBFCorr = DensityImageBFCorr - 2*(100 - DensityImageBFCorr)*Hskin./(thickness_mapproj+0.01);
   Analysis.SXADensityImageCrop=MaskROIproj.*DensityImageSkin; %
   
   %MaskROIprojTotal = 1 - (thickness_mapproj == 0);
      
   Analysis.SXADensityImageTotal=DensityImageSkin.*BreastMask; % added .*MaskROIprojTotal on 04.24.08; %
   % se3 = strel('disk', 5);
   % MaskROIproj = imerode(MaskROIproj, se3);
  
   %Analysis.BreastAreaCrop = sum(sum(MaskROIproj * (Analysis.Filmresolution*0.1)^2));%*0.965; % in cm2
   
    if Info.centerlistactivated == 46
             Analysis.Filmresolution = 0.131; % added for UK Selenia 12.10.12
    end
   
   
   %figure;imagesc(MaskROIprojTotal); colormap(gray);
   area_total = bwarea(BreastMask);
   area_proj = bwarea(MaskROIproj);
   area_breast = bwarea(BreastMask);
   area_MaskROI = bwarea(MaskROI);
% % %    figure;imagesc(BreastMask); colormap(gray);
% % %    figure;imagesc(DensityImageSkinCrop.*MaskROIproj); colormap(gray);
% % %    figure;imagesc(DensityImage.*MaskROIproj); colormap(gray);
   Analysis.BreastVolume = sum(sum( thickness_mapprojCrop.*MaskROIproj*(Analysis.Filmresolution*0.1)^2))/ 1.0742*0.85; %Analysis.ThicknessImage 
% % %    figure; imagesc(~breast_Maskcorr); colormap(gray);
% % %    figure; imagesc(thickness_mapreal); colormap(gray);
   
   SXAAnalysis.SXABreastAreaPixelsCrop = bwarea(MaskROIproj);
   SXAAnalysis.SXABreastAreaCrop = bwarea(MaskROIproj) * (Analysis.Filmresolution*0.1)^2;
   SXAAnalysis.SXABreastAreaPixelsTotal = bwarea(BreastMask);
   SXAAnalysis.SXABreastAreaTotal = bwarea(BreastMask) * (Analysis.Filmresolution*0.1)^2;
   
   SXAAnalysis.SXABreastVolumeReal = sum(sum( thickness_mapreal.*(~breast_Maskcorr)*(Analysis.Filmresolution*0.1)^2));
   SXAAnalysis.SXABreastVolumeProj = sum(sum( thickness_mapproj.*(BreastMask)*(Analysis.Filmresolution*0.1)^2));
   SXAAnalysis.SXABreastVolumeProjCrop = sum(sum( thickness_mapproj.*(MaskROIproj)*(Analysis.Filmresolution*0.1)^2));
   
   if corner_area < breast_area/10
       Analysis.DensityPercentageNoCorr=nonan_sum(nonan_sum(DensityImage.*MaskROIproj.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop));
       MaskROIprojCorner = MaskROIproj&CornerMask;
       Analysis.DensityPercentageCut=nonan_sum(nonan_sum(DensityImage.*MaskROIprojCorner.*thickness_mapprojCrop))/sum(sum(MaskROIprojCorner.*thickness_mapprojCrop));
       Analysis.DensityPercentage=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIprojCorner.*thickness_mapprojCrop))/sum(sum(MaskROIprojCorner.*thickness_mapprojCrop));
       Analysis.DensityPercentageTotal=nonan_sum(nonan_sum(DensityImageSkin.*BreastMask.*thickness_mapproj))/sum(sum(BreastMask.*thickness_mapproj));
       Analysis.DensityPercentageBFCorr=nonan_sum(nonan_sum(DensityImageSkinBFCorr.*MaskROIprojCorner.*thickness_mapprojCrop))/sum(sum(MaskROIprojCorner.*thickness_mapprojCrop));
   else
       Analysis.DensityPercentageNoCorr=nonan_sum(nonan_sum(DensityImage.*MaskROIproj.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop));
       Analysis.DensityPercentage=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop));
       Analysis.DensityPercentageTotal=nonan_sum(nonan_sum(DensityImageSkin.*BreastMask.*thickness_mapproj))/sum(sum(BreastMask.*thickness_mapproj));
       Analysis.DensityPercentageCut = Analysis.DensityPercentageNoCorr;
       Analysis.DensityPercentageBFCorr=nonan_sum(nonan_sum(DensityImageSkinBFCorr.*MaskROIproj.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop));
   end
   Analysis.DensityImagev8 = DensityImageSkin.*thickness_mapproj;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calculate Fractal Diemnsion density%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

if Info.Analysistype == 5 ;
    if Info.FD_Density==true;
        
% % %         funcThresholdContour;
% % %         draweverything;
        Fractional_Dimension_Density;
    end
end

%*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;Calculate Fractal Diemnsion density End%*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;   

   
   
   Analysis.SXAthickness_mapproj = thickness_mapproj;
   SXAAnalysis.SXADensityPercentageCrop = Analysis.DensityPercentage;
   SXAAnalysis.SXADensityPercentageTotal = Analysis.DensityPercentageTotal;
   Analysis.BreastAreaCut =  bwarea(MaskROIproj);
   %im_implant = (DensityImageSkinCrop.*MaskROIproj)>120;Analysis.DensityImageCrop
   im_implant = (DensityImageSkin.*MaskROIproj)>120;
   %figure; imagesc(DensityImageSkinCrop.*MaskROIproj); colormap(gray);
  % figure; imagesc(im_implant); colormap(gray);
   implant_mask = bwarea(im_implant);
   
   if implant_mask/Analysis.BreastAreaCut > 0.1
       Error.SuperLeanWarning=true;
   end
   %Analysis.DensitySkinCorrected=nonan_sum(nonan_sum(DensityImageSkinCrop.*MaskROIproj.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop));
   %Analysis.DensityPercentage =  Analysis.DensitySkinCorrected;       
   % figure; imagesc(MaskROIproj); colormap(gray);
   
   %figure; imagesc(Analysis.ThicknessImage); colormap(gray);
   %*10;
   index_proj = find(MaskROIproj == 1);
   %plot(thickness_mapprojCrop(index_proj),temproi_proj(index_proj), '.r'); hold on; 
    h_slope = figure('Tag','Slope');
    if SXAreport == true
        set(h_slope,'Visible', 'On'); 
    else
        set(h_slope,'Visible', 'Off'); 
    end
   contourf(X,Y/10000,Z,16);
   h2 = [1,1,1;0.984126984000000,0.984126984000000,0.984126984000000;0.968253968000000,0.968253968000000,0.968253968000000;0.952380952000000,0.952380952000000,0.952380952000000;0.936507937000000,0.936507937000000,0.936507937000000;0.920634921000000,0.920634921000000,0.920634921000000;0.904761905000000,0.904761905000000,0.904761905000000;0.888888889000000,0.888888889000000,0.888888889000000;0.873015873000000,0.873015873000000,0.873015873000000;0.857142857000000,0.857142857000000,0.857142857000000;0.841269841000000,0.841269841000000,0.841269841000000;0.825396825000000,0.825396825000000,0.825396825000000;0.809523810000000,0.809523810000000,0.809523810000000;0.793650794000000,0.793650794000000,0.793650794000000;0.777777778000000,0.777777778000000,0.777777778000000;0.761904762000000,0.761904762000000,0.761904762000000;0.746031746000000,0.746031746000000,0.746031746000000;0.730158730000000,0.730158730000000,0.730158730000000;0.714285714000000,0.714285714000000,0.714285714000000;0.698412698000000,0.698412698000000,0.698412698000000;0.682539683000000,0.682539683000000,0.682539683000000;0.666666667000000,0.666666667000000,0.666666667000000;0.650793651000000,0.650793651000000,0.650793651000000;0.634920635000000,0.634920635000000,0.634920635000000;0.619047619000000,0.619047619000000,0.619047619000000;0.603174603000000,0.603174603000000,0.603174603000000;0.587301587000000,0.587301587000000,0.587301587000000;0.571428571000000,0.571428571000000,0.571428571000000;0.555555556000000,0.555555556000000,0.555555556000000;0.539682540000000,0.539682540000000,0.539682540000000;0.523809524000000,0.523809524000000,0.523809524000000;0.507936508000000,0.507936508000000,0.507936508000000;0.492063492000000,0.492063492000000,0.492063492000000;0.476190476000000,0.476190476000000,0.476190476000000;0.460317460000000,0.460317460000000,0.460317460000000;0.444444444000000,0.444444444000000,0.444444444000000;0.428571429000000,0.428571429000000,0.428571429000000;0.412698413000000,0.412698413000000,0.412698413000000;0.396825397000000,0.396825397000000,0.396825397000000;0.380952381000000,0.380952381000000,0.380952381000000;0.365079365000000,0.365079365000000,0.365079365000000;0.349206349000000,0.349206349000000,0.349206349000000;0.333333333000000,0.333333333000000,0.333333333000000;0.317460317000000,0.317460317000000,0.317460317000000;0.301587302000000,0.301587302000000,0.301587302000000;0.285714286000000,0.285714286000000,0.285714286000000;0.269841270000000,0.269841270000000,0.269841270000000;0.253968254000000,0.253968254000000,0.253968254000000;0.238095238000000,0.238095238000000,0.238095238000000;0.222222222000000,0.222222222000000,0.222222222000000;0.206349206000000,0.206349206000000,0.206349206000000;0.190476190000000,0.190476190000000,0.190476190000000;0.174603175000000,0.174603175000000,0.174603175000000;0.158730159000000,0.158730159000000,0.158730159000000;0.142857143000000,0.142857143000000,0.142857143000000;0.126984127000000,0.126984127000000,0.126984127000000;0.111111111000000,0.111111111000000,0.111111111000000;0.0952380950000000,0.0952380950000000,0.0952380950000000;0.0793650790000000,0.0793650790000000,0.0793650790000000;0.0634920630000000,0.0634920630000000,0.0634920630000000;0.0476190480000000,0.0476190480000000,0.0476190480000000;0.0317460320000000,0.0317460320000000,0.0317460320000000;0.0158730160000000,0.0158730160000000,0.0158730160000000;0,0,0;];
   colormap(h2); hold on;
  
     
     plot(xdata, ydata_ph100/10000, 'ko',xdata, ydata_fat/10000,'k*', 'LineWidth',2); hold on;
     legend('pixel frequency contours','fibroglandular reference','fat reference','Position', 'best'); 
     plot( xdata,yc_ph100fit/10000,'-k', xdata,yc_fatfit/10000,'-k','LineWidth',2); hold on;
     grid on; 
     
     set(gca, 'Xlim',[1 8]);hold on;
   %surf(X,Y,Z);
    %Analysis.DensityPercentage=nonan_sum(nonan_sum(DensityImage.*MaskROI))/sum(sum(MaskROI));
    rho_fat = 0.9196;  %g/ml - density of fat 
    rho_lean = 1.1;    %g/ml - density of lean
    Analysis.TotalLeanMass = SXAAnalysis.SXABreastVolumeReal*Analysis.DensityPercentage/100*rho_lean; %in g/cm^3
    Analysis.TotalFatMass = SXAAnalysis.SXABreastVolumeReal*(100 -Analysis.DensityPercentage)/100*rho_fat; %in g/cm^3
    density = Analysis.DensityPercentage;
    density_all = Analysis.DensityPercentageCut;
%     anal = Analysis %commented out by Song, used nowhere
    if isnan(Analysis.DensityPercentage)
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
        SXAAnalysis.SXABreastVolumeReal=-1;
    else 
        Error.DENSITY=false;
    end
   
%     d = density;  %commented out by Song, used nowhere
%     d2 = density_all;     %used no where
    FuncActivateDeactivateButton;
%      catch
%          errmsg = lasterr
%          Error.DENSITY = true;
%         Analysis.Step = 6;
%      end
     format short g;
%      sxa_analysis = SXAAnalysis   %commented out by Song, used nowhere
%     a =1;     %used nowhere
    %{
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
   %}
    
%%
function densImgOut = densCorr(densImgIn, thickMap, dbName, calibComId)

pCols = 7:11;
SQLstatement = ['SELECT * ', ...
                'FROM DensityFitParams ', ...
                'WHERE commonanalysis_id = ', num2str(calibComId)];
entryRead = mxDatabase(dbName, SQLstatement);
p = cell2mat(entryRead(pCols));

[m n] = size(densImgIn);
densImgOut = zeros(m, n);
for i = 1:m
    for j = 1:n
        x = thickMap(i, j);
        y = densImgIn(i, j);
        if (y < 120 && y > -20)
            densImgOut(i, j) = p(1) + p(2)*y +p(3)*y^2 + p(4)*x*y + p(5)*x*y^2; 
        else
            densImgOut(i, j) = y;
        end
    end
end

%%
%%
function imgOut = refConvert(imgIn)

%For details, see Song Note 1, p41
d1 = 30.43;
d2 = 79.26;
d3 = -30;

imgTemp = (imgIn - d1)./(d2 - d1).*80;
imgOut = (imgTemp - d3)./(100 - d3).*100;
%%
%%
function kTable = extract_Kvalues(dbName, imgAcqDate, imgVolt, machID, padSize)
global Info Analysis flag




SQLstatement = ['SELECT TOP 1 * FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'' ) AND (date_acquisition =',...
               ' (SELECT MAX(date_acquisition)  FROM kTableGen3 ',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version8.0%'') ',...
               ' AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112)))) ',...
               ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];         
                              
               
               
               
              % AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112))'];

% % % SQLstatement = [' SELECT * FROM kTableGen3 ', ...
% % %                 'WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'' AND CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),', imgAcqDate,', 112) AND (date_acquisition =',...
% % %                 ' (SELECT MAX(date_acquisition)  FROM dbo.kTableGen3 ',...
% % %                 ' WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'' AND CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),', imgAcqDate,', 112))) AND ',... 
% % %                 ' (commonanalysis_id = (SELECT MAX(commonanalysis_id) FROM dbo.kTableGen3 ',...
% % %                 ' WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'' AND CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),', imgAcqDate,', 112)))'];
kentryRead = mxDatabase(dbName, SQLstatement);

%%%added by AM 03102014

Ktable_1 = mxDatabase(dbName,['select * from kTableGen3 where (machine_id= ',num2str(Info.centerlistactivated),') ',...
    ' AND (QCWAX_status LIKE ''%True%'') ',...
    'order by date_acquisition']);

sz_corr_K = size(Ktable_1);

for i = 1:sz_corr_K(1)
    Machine_id_Ktable(i) = Ktable_1{i,1};
    acquisition_id(i)=Ktable_1{i,2};
    date_acquisition_num_Ktable(i) = datenum(Ktable_1{i,4}, 'yyyymmdd');
    paddle_size(i)= cellstr(Ktable_1{i,5});
    
end
    
small_index = find(strncmp(paddle_size, 'Small', 5));
big_index = find(strncmp(paddle_size, 'Large', 5));
date_acquisition_num = datenum(Info.date_acq, 'yyyymmdd');
Test1=datestr(date_acquisition_num);


if flag.small_paddle
    start_date_num_small = date_acquisition_num_Ktable(small_index); %paddle_type==1
    acquisition_id_small=acquisition_id(small_index)
% % %     Test2=datestr(start_date_num_small);
    
    dates_max = max(start_date_num_small(start_date_num_small <= date_acquisition_num ));
    
    Test3=datestr(dates_max);
    if  ~isempty(start_date_num_small)
        if isempty(dates_max)
            dates_max = min(start_date_num_small);
        end
    end
    
    index_date = find(start_date_num_small == dates_max);
    acquisition_id_K = num2str(acquisition_id_small(index_date));
  
else
    start_date_num_big = date_acquisition_num_Ktable(big_index );
    acquisition_id_big=acquisition_id(big_index);
% % %     Test2=datestr(start_date_num_big);
    
    dates_max = max(start_date_num_big(start_date_num_big <= date_acquisition_num ));
    if  ~isempty(start_date_num_big)
        if isempty(dates_max)
            dates_max = min(start_date_num_big);
        end
    end
    index_date = find(start_date_num_big == dates_max);
    %index_date = 110;
    acquisition_id_K=num2str(acquisition_id_big(index_date))
end

 
s2 = regexp(acquisition_id_K, '  ', 'split');
acquisition_id_K=cell2mat(s2(:,1));

SQLstatement = ['SELECT TOP 1 *  FROM kTableGen3',...
    ' WHERE (acquisition_id lIKE ''',acquisition_id_K, '''',')',...
    ' AND (QCWAX_status LIKE ''%True%'') ',...
    ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...

kentry_Alt = mxDatabase(dbName, SQLstatement);
Alt_kdate_num = datenum(kentry_Alt(4), 'yyyymmdd');                


SQLstatement = ['SELECT MAX(date_acquisition), MIN(date_acquisition) FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' OR version LIKE ''%Version8.0%'') AND (QCWAX_status LIKE ''%True%'')' ];
            
mm_kdate = mxDatabase(dbName, SQLstatement);
min_kdate_char = char(mm_kdate(2));
max_kdate_num = datenum(mm_kdate(1), 'yyyymmdd');
min_kdate_num = datenum(mm_kdate(2), 'yyyymmdd');
imgAcqDate_num = datenum(imgAcqDate, 'yyyymmdd');


SQLstatement = ['SELECT TOP 1 *  FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1% '' OR version LIKE ''%Version8.0%'')',...
               ' AND date_acquisition LIKE ''',min_kdate_char(1:8),'''',...
               ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...
kentry_min = mxDatabase(dbName, SQLstatement);
           
if ~isempty(kentryRead)
    acq_kdate = kentryRead{1,4};
    acq_kdate_num = datenum(acq_kdate, 'yyyymmdd');
    diff_date = imgAcqDate_num - acq_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

elseif ~isempty(kentry_Alt)
    
    kentryRead = kentry_Alt;
    diff_date = date_acquisition_num - Alt_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};
    
else
  
    kentryRead = kentry_min;
    diff_date = imgAcqDate_num - min_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

end

Analysis.calib_diffdays = diff_date;

%%%end  by Am 03102014

kStartCol = 9;               
    kList = [];        
 %kentryRead = mxDatabase(dbName, SQLstatement);

% % Kvalues_table =  mxDatabase(Database.Name,['select * from kTableGen3 where machine_id=',num2str(Info.centerlistactivated)]);
% % sz_ktable = size(kentryRead, 1);
% % kacq_date_num = zeros(sz_ktable,1);
% % % count = 1;
% % % inside = 0;
% % % for i = 1:sz_ktable
% % %     if i == 1
% % %         kacq_date_num(i,1:2) = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}];
% % %     elseif (datenum( kentryRead{i,4}, 'yyyymmdd') == datenum( kentryRead{i-1,4}, 'yyyymmdd'))
% % %         if  kentryRead{i,3} > kentryRead{i-1,3}
% % %             current_read = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}]; %kacq_date_num(i,1:2)
% % %         else
% % %             current_read = [datenum( kentryRead{i-1,4}, 'yyyymmdd'), kentryRead{i-1,3}];
% % %         end
% % %         inside = 1;
% % %     elseif inside == 0 
% % %         count = count + 1;
% % %         kacq_date_num(count,1:2) = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}];
% % %     else
% % %         inside = 0;
% % %         count = count + 1;
% % %         kacq_date_num(count,1:2) = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}];
% % %     end
% % %         
% % % % % %     fg = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}];
% % % % % %    
% % % % % %    % if (fg(i,1) == fg1(1) $ fg(i,2) > fg1(1)
% % % % % %    
% % % % % %     kacq_date_num(i,1:2) = [datenum( kentryRead{i,4}, 'yyyymmdd'), kentryRead{i,3}];
% % %     
% % %     
% % % %     end_date_num(i) = datenum( machine_correction{i,5}, 'yyyymmdd');
% % % %     paddle_type(i)  =  machine_correction{i,3};
% % % %     error_thickDB(i) = machine_correction{i,2};
% % % %     tz_angleDB(i) = machine_correction{i,6};
% % % %     error_3DreconDB(i) = machine_correction{i,7};
% % % end
% % % c_date=mxDatabase(dbName,['select  date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
% % % date_acq = c_date{1,1};
% % % date_acq_num = datenum(date_acq, 'yyyymmdd');
% % % 
% % % index_date =  max(find(kacq_date_num(:,1) < date_acq_num) );

 if ~isempty(kentryRead)
      kList = cell2mat(kentryRead(1, kStartCol:end-1));
    else
      kList = cell2mat(kentryRead(1, kStartCol:end-1));
 end

numVal = round(length(kList)/3);

kTable = zeros(numVal, 3);
for i = 1:numVal
    kTable(i, :) = kList(3*i-2:3*i);
end
    
a  = 1;


% % % if size(entryRead, 1) > 1   %large paddle has multiple k-values depending on kVp
% % %     voltList = cell2mat(entryRead(:, kVpCol));
% % %     idx = find(voltList == imgVolt);
% % %     if ~isempty(idx) 
% % %         kList = cell2mat(entryRead(idx, kStartCol:end));
% % %     end
% % % else    %this is the case of small paddle
% % %     kList = cell2mat(entryRead(:, kStartCol:end));
% % % end
%%

function Ibkg = extract_Ibkg(dbName, imgAcqDate, imgVolt, machID, padSize)
global Info Analysis

 
SQLstatement = ['SELECT TOP 1 * FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'') AND (date_acquisition =',...
               ' (SELECT MAX(date_acquisition)  FROM kTableGen3 ',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'') ',...
               ' AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112)))) ',...
               ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];         
                              
               
kentryRead = mxDatabase(dbName, SQLstatement);

SQLstatement = ['SELECT MAX(date_acquisition), MIN(date_acquisition) FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'') AND (QCWAX_status LIKE ''%True%'') '];
            
mm_kdate = mxDatabase(dbName, SQLstatement);
min_kdate_char = char(mm_kdate(2));
max_kdate_num = datenum(mm_kdate(1), 'yyyymmdd');
min_kdate_num = datenum(mm_kdate(2), 'yyyymmdd');
imgAcqDate_num = datenum(imgAcqDate, 'yyyymmdd');

SQLstatement = ['SELECT TOP 1 *  FROM kTableGen3',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'')',...
               ' AND date_acquisition LIKE ''',min_kdate_char(1:8),'''',...
               ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...
kentry_min = mxDatabase(dbName, SQLstatement);
           
if ~isempty(kentryRead)
    acq_kdate = kentryRead{1,4};
    acq_kdate_num = datenum(acq_kdate, 'yyyymmdd');
    diff_date = imgAcqDate_num - acq_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

else
    kentryRead = kentry_min;
    diff_date = imgAcqDate_num - min_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

end
%Analysis.GEN3diffdays = diff_date;

% % % SQLstatement = [' SELECT MAX(date_acquisition) FROM kTableGen3 ', ...
% % %                 'WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'''];
% % % max_kdate =  mxDatabase(dbName, SQLstatement);
% % % max_kdate_num = datenum( max_kdate, 'yyyymmdd');
kStartCol = 8; 
Ibkg = cell2mat(kentryRead(1, kStartCol));


%%

function ATable = extract_A2A1A0_values(dbName, imgAcqDate, imgVolt, machID, padSize)
global Info Analysis
% 
try
SQLstatement = ['SELECT TOP 1 * FROM DensityDSP7Corr',...
               ' WHERE (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'') AND (date_acquisition =',...
               ' (SELECT MAX(date_acquisition)  FROM DensityDSP7Corr',...
               ' WHERE (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'') ',...
               ' AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112)))) ',...
               ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];         
              % ' WHERE (paddle_size lIKE ''', padSize, '''',')',...     ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
kentryRead = mxDatabase(dbName, SQLstatement);

SQLstatement = ['SELECT MAX(date_acquisition), MIN(date_acquisition) FROM DensityDSP7Corr',...
               ' WHERE (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'')  AND (QCWAX_status LIKE ''%True%'') '];
                %  ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
mm_kdate = mxDatabase(dbName, SQLstatement);
min_kdate_char = char(mm_kdate(2));
max_kdate_num = datenum(mm_kdate(1), 'yyyymmdd');
min_kdate_num = datenum(mm_kdate(2), 'yyyymmdd');
imgAcqDate_num = datenum(imgAcqDate, 'yyyymmdd');

SQLstatement = ['SELECT TOP 1 *  FROM DensityDSP7Corr',...
               ' WHERE (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'' or version LIKE ''%Version8.0%'')',...
               ' AND date_acquisition LIKE ''',min_kdate_char(1:8),'''',...
                ' AND (QCWAX_status LIKE ''%True%'') ',...
               ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...
kentry_min = mxDatabase(dbName, SQLstatement);
           
if ~isempty(kentryRead)
    acq_DSP7date = kentryRead{1,4};
    acq_DSP7date_num = datenum(acq_DSP7date, 'yyyymmdd');
    diff_date = imgAcqDate_num - acq_DSP7date_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

else
    kentryRead = kentry_min;
    diff_date = imgAcqDate_num - min_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

end
Analysis.calib_diffdays = diff_date;

% % % SQLstatement = [' SELECT MAX(date_acquisition) FROM kTableGen3 ', ...
% % %                 'WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'''];
% % % max_kdate =  mxDatabase(dbName, SQLstatement);
% % % max_kdate_num = datenum( max_kdate, 'yyyymmdd');

kStartCol = 9;               
    kList = [];        


 if ~isempty(kentryRead)
      kList = cell2mat(kentryRead(1, kStartCol:end));
    else
      kList = cell2mat(kentryRead(1, kStartCol:end));
 end

numVal = round(length(kList)/3);

ATable = zeros(numVal, 3);
for i = 1:numVal
    ATable(i, :) = kList(3*i-2:3*i);
end

catch
    ATable = [0,1,0];
    Analysis.calib_diffdays = -10000;
end


function Fractional_Dimension_Density()
global Info Analysis Image Outline BreastMask thickness_mapproj MaskROIproj thickness_mapprojCrop DensityImageSkin FD ROI BW duration
global Threshold temproi breast_Maskcorr SXAAnalysis  thickness_mapreal 
tic

% Written by Amir Pasha M
%Date: 05012014

Analysis.VolumeMD = [];
Analysis.VolumeMD_Real = [];
Analysis.DensityPercentageMD=[];
Analysis.OLV=[];
Analysis.OLP=[];
Analysis.DiffPixel=[];
Analysis.hd=[];
FD.OLP_OLV_HD=[];
I1=[];
I2=[];
I3=[];
I4=[];
ccc=[];
ddd=[];
Analysis.VolumeFractal=[];
Overlaping_Volume=[];
Analysis.DensityPercentageFractal=[];
Analysis.VolumeFractal_Real=[];
Analysis.FDOptimalPercentage=[];
Analysis.DiffSXA=[];
FD.Density_Results=[];
FD.OLP_OLV_HD=[];
Analysis.DensityPercentage_realSXA=[];


% I1=BW;

%%%% fractal threshold brast density
dynamic=65536;
%   FractalCurrentImage=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj.*thickness_mapprojCrop;
UnderSamplingFactor=1;
BreastFraction=1;

CurrentImage_notexcuded=Image.OriginalImage(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax);
CurrentImage=excludePCmuscle(CurrentImage_notexcuded);
clear CurrentImage_notexcuded;
%Erase ouside of the skin edge
midpoint=ceil(length(Outline.x)/2);
for index=1:midpoint
    CurrentImage(1:ceil(BreastFraction*(Outline.y(index)-Analysis.midpoint)+Analysis.midpoint),ceil(BreastFraction*Outline.x(index)))=0;
    CurrentImage(ceil(BreastFraction*(Outline.y(length(Outline.y)-index)-Analysis.midpoint)+Analysis.midpoint):end,ceil(BreastFraction*Outline.x(index)))=0;
end
CurrentImage(:,ceil(BreastFraction*midpoint):end)=0;

CurrentImage=UnderSamplingN(CurrentImage,UnderSamplingFactor);

BreastMaskUndersample = ~(CurrentImage==0);

bins=[0:1000]*(dynamic-Analysis.BackGroundThreshold)/1000;
FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
Histc = histc(FlatImage,bins);
clear FlatImage; % save memmory
Histc(1)=0;   %erase background from calculation
Histp=cumsum(Histc);
Histp=Histp/Histp(end);
FractalCurrentImage=CurrentImage;
%figure;plot(Histp);
%fractal analysis
%FractalCurrentImage=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);


%% Remve Muscle for all CC view 
[iy ix]=size(BreastMask);
cx=2;cy=iy/2+100;r=300;
X0=10;
Y0=20;
a=50; %  define how big width is 
b=iy/4;  
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
Muscle_mask=((x-X0)/a).^2+((y-Y0)/b).^2<=1;
% figure;imagesc(Muscle_mask); colormap(bone) 
% figure;imagesc(temproi); colormap(gray) 


% % % %% Find classification in Breast based on their appearances
% % % Rmin = 5;
% % % Rmax = 65;
% % % 
% % % % % % Image.OrginalWithoutPhantom = zeros(size(Image.image));
% % % % % % Image.OrginalWithoutPhantom(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = temproi;
% % % try
% % %     [centersBright, radiiBright, metricBright] = imfindcircles(temproi,[Rmin Rmax], ...
% % %         'ObjectPolarity','bright','Sensitivity',0.85,'EdgeThreshold',0.1);
% % %     
% % %     k=1;
% % %     
% % %     if ~size(centersBright)==0
% % %         Info.classification=true;
% % %         p = zeros(size(BreastMask));
% % %         Add= im2bw(p);
% % % %         figure;imagesc(temproi);colormap(gray)
% % %         hBright=viscircles(centersBright, radiiBright,'LineStyle','--');
% % %         for k = 1:length(metricBright)
% % %             [iy ix]=size(BreastMask);
% % %             cx=centersBright(k,1);
% % %             cy=centersBright(k,2);
% % %             r=radiiBright(k);
% % %             [x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
% % %             classification=((x.^2+y.^2)<=r^2);
% % %             Add= im2bw(Add);
% % %             Add = imadd(classification, Add);
% % %             %      figure;imagesc(Add);colormap(gray)
% % %         end
% % %         
% % %         classification_Maks=Add;
% % %         clear Add;
% % %         
% % %         ccc = bwconncomp(classification_Maks);
% % %         stats_classification = regionprops(ccc ,temproi,'Eccentricity','Area','BoundingBox','Perimeter','Orientation',...
% % %             'Centroid','EquivDiameter',...
% % %             'MaxIntensity','MinIntensity','MeanIntensity','PixelValues');
% % %         E = [stats_classification.Area];
% % %         [~,biggest] = max(E);
% % %         stats_classification_biggest=stats_classification(biggest);
% % %         
% % %         %     classification_Maks(labelmatrix(ccc)~=biggest) = 0;
% % %         
% % %         Analysis.Classification.PixelValues = [stats_classification_biggest.PixelValues];
% % %         Analysis.Classification.MinIntensity = [stats_classification_biggest.MinIntensity];
% % %         Analysis.Classification.MaxIntensity= [stats_classification_biggest.MaxIntensity];
% % %         Analysis.Classification.MeanIntensity= [stats_classification_biggest.MeanIntensity];
% % %         Analysis.Classification.Perimeter= [stats_classification_biggest.Perimeter];
% % %         Analysis.Classification.Area = [stats_classification_biggest.Area];
% % %         Analysis.Classification.EquivDiameter = [stats_classification_biggest.EquivDiameter];
% % %         Analysis.Classification.CentroidX = [stats_classification_biggest.Centroid(1)];
% % %         Analysis.Classification.CentroidY = [stats_classification_biggest.Centroid(2)];
% % %         Analysis.Classification.Orientation = [stats_classification_biggest.Orientation];
% % %         Analysis.Classification.Eccentricity = [stats_classification_biggest.Eccentricity];
% % %         
% % %         FD.Classification=[Analysis.Classification.MinIntensity,Analysis.Classification.MaxIntensity,Analysis.Classification.MeanIntensity,Analysis.Classification.Perimeter,...
% % %             Analysis.Classification.Area,Analysis.Classification.EquivDiameter,Analysis.Classification.CentroidX,Analysis.Classification.CentroidY,Analysis.Classification.Orientation,Analysis.Classification.Eccentricity ];
% % %         
% % % % % %         ddd = bwconncomp(BW);
% % % % % %         
% % % % % %         Density_Mask=BW.*(~classification_Maks); % Remove Classification from density
% % %         
% % %     else
% % %         Info.classification=false;
% % %         Density_Mask=BW;
% % %         
% % %     end;
% % % catch
% % %     lasterr
% % % end

% Maks=MaskROIproj.*(~Muscle_mask).*Density_Mask;

%Volume of Mammographic Density for BO

% % % Analysis.VolumeMD = thickness_mapproj.*(BreastMask).*BW; % Image 
% % % % Analysis.VolumeMD_Real = sum(sum( thickness_mapproj.*(BreastMask).*BW *(Analysis.Filmresolution*0.1)^2));
% % % Analysis.VolumeMD_Real = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*BW*(Analysis.Filmresolution*0.1)^2));

% % % mask_BW=BW.*(~Muscle_mask);
% % % Density_in_BW=MaskROIproj.*( mask_BW);
% % % MaskBreast =MaskROIproj.*(~Muscle_mask);
% % % Density_out_BW=abs(MaskBreast- Density_in_BW);  % Calculate the density out
% % % Analysis.DensityPercentage_BWOut=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*Density_out_BW.*(~Muscle_mask)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*Density_out_BW.*(~Muscle_mask)));
% % % 
% % % if Info.classification==true;
% % %     
% % %     if ddd.NumObjects==ccc.NumObjects 
% % %         
% % %         Analysis.DensityPercentageMD=0;  % to prevent Inf results for density
% % %     else
% % %         
% % %         Analysis.DensityPercentageMD=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*Density_Mask))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*Density_Mask));
% % %     end;
% % % else
% % %     Analysis.DensityPercentageMD=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*Density_Mask))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*Density_Mask));
% % % end

j=1;
FractalThreshold=zeros(25);
fractal_mask_1=zeros(size(BreastMask));
for  FractalThreshold=[0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.87 0.89 0.91 0.93 0.95 0.97 0.99]
    %         indexFractalThreshold=1:20
    %         FractalThreshold=0.05*(indexFractalThreshold-1);
    
    [~,thresholdindex]=max(Histp>FractalThreshold);
    threshold=bins(thresholdindex);
    image = (FractalCurrentImage>threshold);
    % %  figure;imagesc(image);colormap(gray);
    fractal_mask=image;
    indexFractalThreshold=j;
    fractal_mask_1(:,:,indexFractalThreshold) = image;
    % %          figure;imshow(fractal_mask_1(:,:,indexindexFractalThreshold));
    clear image;
    
    % % %         if Info.classification==true;
    % % %
    % % %             I1=BW.*(~Muscle_mask).*(~classification_Maks);
    % % %             I2=fractal_mask.*(~Muscle_mask).*(~classification_Maks);
    % % %             Density_in=MaskROIproj.*(I2);
    % % %             MaskBreast =MaskROIproj.*(~Muscle_mask).*(~classification_Maks);
    % % %
    % % %         else
    % % %             I1=BW.*(~Muscle_mask);
    I2=fractal_mask.*(~Muscle_mask);
    Density_in=MaskROIproj.*I2;
    MaskBreast =MaskROIproj.*(~Muscle_mask);
    % % %         end
    
    Density_out=abs(MaskBreast-Density_in);
    %          figure;imagesc(Density_out);colormap(gray);
         
% % %         a= size(I2);
% % %         b=size(thickness_mapprojCrop);
% % %         % check to make sure that they have the same column
% % %         if ~(a(2)==b(2))
% % %             % %         if ~(I2(2)==thickness_mapprojCrop(2))
% % %             nrows = max(size(I2,1), size(thickness_mapprojCrop,1));
% % %             ncols = max(size(I2,2), size(thickness_mapprojCrop,2));
% % %             nchannels = size(I2,3);
% % %             
% % %             extendedI2 = [ I2, zeros(size(I2,1), ncols-size(I2,2), nchannels); ...
% % %                 zeros(nrows-size(I2,1), ncols, nchannels)];
% % %             
% % %             extendedthickness_mapprojCrop = [ thickness_mapprojCrop, zeros(size(thickness_mapprojCrop,1), ncols-size(thickness_mapprojCrop,2), nchannels); ...
% % %                 zeros(nrows-size(thickness_mapprojCrop,1), ncols, nchannels)];
% % %             
% % %             extendedDensityImageSkin = [ DensityImageSkin, zeros(size(DensityImageSkin,1), ncols-size(DensityImageSkin,2), nchannels); ...
% % %                 zeros(nrows-size(DensityImageSkin,1), ncols, nchannels)];
% % %             
% % %             extendedMaskROIproj = [ MaskROIproj, zeros(size(MaskROIproj,1), ncols-size(MaskROIproj,2), nchannels); ...
% % %                 zeros(nrows-size(MaskROIproj,1), ncols, nchannels)];
% % %             
% % %             extendedBreastMask = [ BreastMask, zeros(size(BreastMask,1), ncols-size(BreastMask,2), nchannels); ...
% % %                 zeros(nrows-size(BreastMask,1), ncols, nchannels)];
% % %             
% % %             extendedthickness_mapproj = [ thickness_mapproj, zeros(size(thickness_mapproj,1), ncols-size(thickness_mapproj,2), nchannels); ...
% % %                 zeros(nrows-size(thickness_mapproj,1), ncols, nchannels)];
% % %             
% % %             extendedI1 = [ I1, zeros(size(I1,1), ncols-size(I1,2), nchannels); ...
% % %                 zeros(nrows-size(I1,1), ncols, nchannels)];
% % %             
% % %             I2=extendedI2;
% % %             thickness_mapprojCrop=extendedthickness_mapprojCrop;
% % %             DensityImageSkin=extendedDensityImageSkin;
% % %             MaskROIproj=extendedMaskROIproj;
% % %             BreastMask=extendedBreastMask;
% % %             thickness_mapproj=extendedthickness_mapproj ;
% % %             I1=extendedI1;
% % %             
% % %         end
        
%         II=MaskROIproj.*fractal_mask.*(~Muscle_mask).*(~classification_Maks);
%          figure;imagesc(II);colormap(gray);

%% FD<<<=============Calculate Density and Dense Volume (in and out density) with Muscle Removal===========>>>FD


Analysis.SXADensityPercentage_FD_in(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*Density_in))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*Density_in));
Analysis.SXADensityPercentage_FD_out(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(Density_out)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(Density_out)));
Analysis.DenseVolume_FD_in(indexFractalThreshold) = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*Density_in *(Analysis.Filmresolution*0.1)^2)); %Dense volume for inside of glandular
Analysis.DenseVolume_FD_out(indexFractalThreshold)= sum(sum( thickness_mapreal.*(~breast_Maskcorr).*Density_out*(Analysis.Filmresolution*0.1)^2)); % Dense volume for out side of glandular

%% FD<<<=============End of Calculate Density and Dense Volume (in and out density) with Muscle Removal===========>>>FD

% % % 
% % %         Analysis.DensityPercentageFractal(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*I2))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*I2));
% % %         
% % %         Analysis.DensityPercentageFractalOut(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(Density_out)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(Density_out)));
% % %         
% % %         
% % %         Analysis.WithMuscle(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*fractal_mask))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*fractal_mask));
% % %         
% % %         Analysis.VolumeFractal_Real(indexFractalThreshold) = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*I2 *(Analysis.Filmresolution*0.1)^2)); %Dense volume for inside of glandular
% % % 
% % %         Analysis.VolumeFractal_Real_out(indexFractalThreshold) = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*(Density_out) *(Analysis.Filmresolution*0.1)^2)); % Dense volume for out side of glandular 
% % %         
     
        %         figure;imagesc(I2);colormap(gray);
        
%         [Analysis.OLP(indexFractalThreshold), Analysis.DiffPixel(indexFractalThreshold) ] = CheckOverlapingPixel(I1,I2);
        
        
% %         Analysis.hd(indexFractalThreshold) = HausdorffDist(I1,I2,1);  % Commented temoproray for High computation Time. 05/27/2014
         
%         Analysis.hd=zeros(1,25);  % Temorary zero

        
% % %         Analysis.VolumeFractal = thickness_mapproj.*(BreastMask).*I2;
        
        %         Test=sum(sum((thickness_mapproj.*(BreastMask).*BW *(Analysis.Filmresolution*0.1)^2)&(thickness_mapproj.*(BreastMask).*I2 *(Analysis.Filmresolution*0.1)^2)))
        
% % %         Overlaping_Volume=Analysis.VolumeFractal&Analysis.VolumeMD;
% % %         Overlaping_Volume_Image  = Overlaping_Volume.*Analysis.VolumeMD;
% % %         Overlaping_Volume_N=sum(sum(Overlaping_Volume_Image));
% % %         
% % %         % % %         ddd=find(Analysis.VolumeMD>0);
% % %         % % %         Analysis.VolumeMD(ddd)=1;
% % %         I3= sum(sum(Analysis.VolumeMD ));
% % %         
% % %         % % %         ccc=find(Analysis.VolumeFractal>0);
% % %         % % %         Analysis.VolumeFractal(ccc)=1;
% % %         I4= sum(sum(Analysis.VolumeFractal));
% % %         % overlaping Volume
% % %         Analysis.OLV(indexFractalThreshold)=(Overlaping_Volume_N/((I3+I4)/2))*100;
        
% %         try
% %         
% %         C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % %         figure;imshow(C);
% %         FD_Filename=(indexFractalThreshold*5)-5;
% %         
% %         fname = [num2str(FD_Filename) '.png' ];
% %         imwrite(C,[thumbdir filesep fname]);
% %         j=j+1;
% %         catch 
% %             j=j+1;
% %         end
        
clear fractal_mask  % save memmory

j=j+1;
     
    end

% % % duration=toc;
% % % 
% % % try
% % % [~,Max_OLV_ind]=max(Analysis.OLV(:));
% % % Max_OLV=(Max_OLV_ind*5)-5;
% % % if Max_OLV_ind>18
% % %     Max_OLV=(Max_OLV_ind*2)+49;
% % % end
% % %     
% % % FD.Max=['FD' num2str(Max_OLV)]; 
% % % 
% % % FD.Maximum=max(max(Analysis.OLV(:)));
% % % FD.Minimum=min(min(Analysis.OLV(:)));
% % % 
% % % indexFractalThreshold=Max_OLV_ind;
% % % fractal_mask_Max=fractal_mask_1(:,:,indexFractalThreshold);
% % % % figure(999);imshow(fractal_mask_Max);
% % % 
% % % % [maxtab, mintab]=peakdet(Analysis.OLV,0.01);  % find maxima and minima between MD and FD density
% % % 
% % % % % FD.Maxima=maxtab;
% % % % % FD.Minima=mintab;
% % % FD.Maxima=0;  %Temproray zero
% % % FD.Minima=0;   %Temproray zero
% % % if isempty(FD.Maxima) && isempty(FD.Minima)
% % %     FD.Maxima=0;
% % %     FD.Minima=0;
% % % elseif  isempty(FD.Maxima)
% % %     FD.Maxima=0
% % % elseif  isempty( FD.Minima)
% % %     FD.Minima=0;
% % % end
% % % 
% % % try
% % % f=figure;hold on; plot(Analysis.OLV, 'r--');
% % % plot(mintab(:,1), mintab(:,2), 'g*');
% % % plot(maxtab(:,1), maxtab(:,2), 'b*');
% % % saveas(f, [thumbdir filesep 'plot.png']);
% % % catch err
% % % 
% % % end

% % % catch err
%     rethrow(err);
% % % end

% % % delete(f);


     
% % % Analysis.DensityPercentageFractal(find(isnan(Analysis.DensityPercentageFractal)))=0;
% % % Analysis.DensityPercentageFractalOut(find(isnan(Analysis.DensityPercentageFractalOut)))=0;
% % % Analysis.VolumeFractal_Real(find(isnan(Analysis.VolumeFractal_Real)))=0;
% % % Analysis.VolumeFractal_Real_out(find(isnan(Analysis.VolumeFractal_Real_out)))=0;
% % % 
% % % if Info.classification==true;  % Optimal SXA or MAxima FD SXA
% % %     
% % %     Analysis.DensityPercentage_realSXA=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max.*(~Muscle_mask).*(~classification_Maks)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max.*(~Muscle_mask).*(~classification_Maks)));
% % % else
% % %     Analysis.DensityPercentage_realSXA=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max.*(~Muscle_mask)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max.*(~Muscle_mask)));
% % %     
% % % % % % end

% % % if Info.classification==true;
% % %         
% % %     fractal_mask_Max=fractal_mask_Max.*(~Muscle_mask).*(~classification_Maks);
% % %     Density_in_Max=MaskROIproj.*(fractal_mask_Max);
% % %     MaskBreast =MaskROIproj.*(~Muscle_mask).*(~classification_Maks);
% % %     Density_out_Max=abs(MaskBreast-Density_in_Max);
% % %     Analysis.DensityPercentage_FDMaxOut=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*Density_out_Max.*(~Muscle_mask).*(~classification_Maks)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*Density_out_Max.*(~Muscle_mask).*(~classification_Maks)));
% % % else
% % %     
% % %     fractal_mask_Max=fractal_mask_Max.*(~Muscle_mask);
% % %     Density_in_Max=MaskROIproj.*(fractal_mask_Max);
% % %     MaskBreast =MaskROIproj.*(~Muscle_mask);
% % %     Density_out_Max=abs(MaskBreast-Density_in_Max);
% % %     Analysis.DensityPercentage_FDMaxOut=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*Density_out_Max.*(~Muscle_mask)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*Density_out_Max.*(~Muscle_mask)));
% % % end
% % % 
% % % 
% % % Analysis.VolumeFractal_Max= sum(sum( thickness_mapreal.*(~breast_Maskcorr).*fractal_mask_Max *(Analysis.Filmresolution*0.1)^2));
% % % 
% % % Analysis.FDOptimalPercentage=sum(sum(fractal_mask_Max)/Analysis.ValidBreastSurface)*100;
% % % 
% % % Analysis.MDArea_Percentage=sum(sum(I1)/Analysis.ValidBreastSurface)*100;
% % % 
% % % Analysis.DiffSXA=Analysis.DensityPercentageMD-Analysis.DensityPercentage_realSXA;
% % % FD.OLP_OLV_HD=[Analysis.OLP,Analysis.OLV,Analysis.hd];

 FD.Density_Results=[Analysis.SXADensityPercentage_FD_in,Analysis.SXADensityPercentage_FD_out,Analysis.DenseVolume_FD_in,Analysis.DenseVolume_FD_out];





% % /
% function Fractional_Dimension_Density()
% global Info Analysis Image Outline BreastMask thickness_mapproj MaskROIproj thickness_mapprojCrop DensityImageSkin FD ROI  thickness_mapreal breast_Maskcorr
% 
% 
% 
% % I1=BW;
% 
% 
% %%%% fractal threshold brast density
% dynamic=65536;
% %  FractalCurrentImage=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj.*thickness_mapprojCrop;
% UnderSamplingFactor=1;
% BreastFraction=1;
% 
% CurrentImage_notexcuded=Image.OriginalImage(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax);
% CurrentImage=excludePCmuscle(CurrentImage_notexcuded);
% clear CurrentImage_notexcuded;
% %Erase ouside of the skin edge
% midpoint=ceil(length(Outline.x)/2);
% for index=1:midpoint
%     CurrentImage(1:ceil(BreastFraction*(Outline.y(index)-Analysis.midpoint)+Analysis.midpoint),ceil(BreastFraction*Outline.x(index)))=0;
%     CurrentImage(ceil(BreastFraction*(Outline.y(length(Outline.y)-index)-Analysis.midpoint)+Analysis.midpoint):end,ceil(BreastFraction*Outline.x(index)))=0;
% end
% CurrentImage(:,ceil(BreastFraction*midpoint):end)=0;
% 
% CurrentImage=UnderSamplingN(CurrentImage,UnderSamplingFactor);
% 
% BreastMaskUndersample = ~(CurrentImage==0);
% 
% bins=[0:1000]*(dynamic-Analysis.BackGroundThreshold)/1000;
% FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
% Histc = histc(FlatImage,bins);
% clear FlatImage; % save memmory
% Histc(1)=0;   %erase background from calculation
% Histp=cumsum(Histc);
% Histp=Histp/Histp(end);
% FractalCurrentImage=CurrentImage;
% %figure;plot(Histp);
% %fractal analysis
% %FractalCurrentImage=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% 
% % % % % Create an unique folder for each image 
% % % % % % % archiveDir = fileparts(which('Z4ComputeBreastDensityNew'));
% % % % archiveDir='\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\SXAVersion8.0\Images_Results';
% % % % thumbdir = [archiveDir filesep 'FD_Results' ];
% % % % if ~exist(thumbdir,'dir')
% % % %     mkdir(thumbdir);
% % % % end
% % % % 
% % % % thumbdir = [thumbdir filesep num2str(Info.AcquisitionKey) ];
% % % % 
% % % % if ~exist(thumbdir,'dir')
% % % %     mkdir(thumbdir);
% % % % end
% 
% indexFractalThreshold=zeros(20);
% 
% for indexFractalThreshold=1:20
%     FractalThreshold=0.05*(indexFractalThreshold-1);
%     [maxi,thresholdindex]=max(Histp>FractalThreshold);
%     threshold=bins(thresholdindex);
%     image = (FractalCurrentImage>threshold);
%     % %  figure;imagesc(image);colormap(gray);
%     fractal_mask = image;
%     fractal_mask_1(:,:,indexFractalThreshold) = image;
%     clear image;
%     
%     
%    
% Density_in_BW=MaskROIproj.*( fractal_mask);
% MaskBreast =MaskROIproj;
% Density_out_BW=abs(MaskBreast- Density_in_BW);  % Calculate the density out
% 
% 
%     
%     Analysis.DensityPercentageFractal(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*fractal_mask))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*fractal_mask));
%     %                 plot((ROI.xmin+Threshold.boundary(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary(:,1)-1)/Undersamplingfactor,'.r', 'LineWidth', 0.5,'markersize',0.5);
%     % % %              [ x_mask,y_mask ] = boundary_xy( fractal_mask );
%     % % %              [x_mask_xcorr,y_mask_ycorr] = SkinDetection_correctedv2(x_mask,y_mask);
%     % % %              mask_realvolume = polyarea(x_mask_xcorr,y_mask_ycorr);
%     % % %               figure;imagesc(mask_realvolume);colormap(gray);
%     Analysis.VolumeFractal(indexFractalThreshold) = sum(sum( thickness_mapproj.*(BreastMask).*fractal_mask *(Analysis.Filmresolution*0.1)^2));
% 
%     
% %             Analysis.DensityPercentageFractal(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*I2))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*I2));
%         
%         Analysis.DensityPercentageFractalOut(indexFractalThreshold)=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(Density_out_BW)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(Density_out_BW)));
%         
% 
% %         Analysis.VolumeFractal_Real(indexFractalThreshold) = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*I2 *(Analysis.Filmresolution*0.1)^2)); %Dense volume for inside of glandular
% 
%         Analysis.VolumeFractal_Real_out(indexFractalThreshold) = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*(Density_out_BW) *(Analysis.Filmresolution*0.1)^2)); % Dense volume for out side of glandular 
%         
%     
% 
%     
% end
% 
% if Analysis.DensityPercentage<25
%     Max_OLV_ind=19;
% elseif 25<=Analysis.DensityPercentage &&  Analysis.DensityPercentage<50
%     Max_OLV_ind=14;
% elseif 50<=Analysis.DensityPercentage &&  Analysis.DensityPercentage<75
%     Max_OLV_ind=10;
% else
%     Max_OLV_ind=5;
% end
% 
% 
% indexFractalThreshold=Max_OLV_ind;
% fractal_mask_Max=fractal_mask_1(:,:,indexFractalThreshold);
% 
% Analysis.DensityPercentage_realSXA=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*fractal_mask_Max));
% 
% 
% 
% 
% clear fractal_mask;
% FD.Density_Results=[Analysis.DensityPercentageFractal,Analysis.DensityPercentageFractalOut,Analysis.VolumeFractal,Analysis.VolumeFractal_Real_out];
% 

function [ OverlapingPixel, DiffPixel ] = CheckOverlapingPixel(I1,I2)

global Image Info

if size(I1)~=size(I2)

nrows = max(size(I1,1), size(I2,1));
ncols = max(size(I1,2), size(I2,2));
nchannels = size(I1,3);

extendedI1 = [ I1, zeros(size(I1,1), ncols-size(I1,2), nchannels); ...
  zeros(nrows-size(I1,1), ncols, nchannels)];

extendedI2 = [ I2, zeros(size(I2,1), ncols-size(I2,2), nchannels); ...
  zeros(nrows-size(I2,1), ncols, nchannels)];

I1=extendedI1;
I2=extendedI2;

end

Overlaping=I1&I2;
% % % figure;imshow(Overlaping);
NOverlaping= nnz(Overlaping);
I3=nnz(I1);
I4=nnz(I2);
Diff=abs(I3-I4);

PercentageOverlapingRef=(NOverlaping/((I3+I4)/2))*100;
% % PercentageOverlapingRef=(NOverlaping/I3)*100;  % how many percentage is overlaping with Refernce

DiffRefrence=I3-NOverlaping; % Diff from Reference image
% % PercentageDiffRef=(DiffRefrence/I3)*100; %how many percentage is Diff ref
PercentageDiffRef=(abs(I3-I4)/((I3+I4)/2))*100;

PercentageOverlapingTarget=(NOverlaping/I4)*100;
DiffTarget=I4-NOverlaping; % Diff from Target image
PercentageDiffTarget=(DiffTarget/I4)*100; %how many percentage is Diff
C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure;imshow(C);


OverlapingPixel=PercentageOverlapingRef;
DiffPixel=PercentageDiffRef;






% corrMat = reshape(cell2mat(entryRead(6:end)), 3, 9)';
% 
% densMat = [corrMat(:, 1:2), round(corrMat(:, 2)+corrMat(:, 3))];
% params0 = [0.1 0.4 0.02 -0.05 0.0005 -0.0001];
% params = mySurfFit(densMat, params0);
% 
% x = zeros(3, 3);
% y = zeros(3, 3);
% z = zeros(3, 3);
% 
% for i = 1:3
%     for j = 1:3
%         x(i, j) = densMat(3*(i-1)+j, 1);
%         y(i, j) = densMat(3*(i-1)+j, 2);
%         z(i, j) = applyCorr(x(i, j), y(i, j), params);
%     end
% end
% 
% densImgOut = applyCorr(thickMap, densImgIn, params);
% 
% % [m n] = size(densImgIn);
% % densImgOut = zeros(m, n);
% % for i = 1:m
% %     for j = 1:n
% %         densCorr = applyCorr(thickMap(i, j), densImgIn(i, j), params);
% %         densImgOut(i, j) = densImgIn(i, j) + densCorr;
% %     end
% % end
% 
% % x = zeros(3, 3);
% % y = zeros(3, 3);
% % z = zeros(3, 3);
% % 
% % for i = 1:3
% %     for j = 1:3
% %         x(i, j) = corrMat(3*(i-1)+j, 1);
% %         y(i, j) = corrMat(3*(i-1)+j, 2);
% %         z(i, j) = corrMat(3*(i-1)+j, 3);
% %     end
% % end
% 
% % [m n] = size(densImgIn);
% % densImgOut = zeros(m, n);
% % for i = 1:m
% %     for j = 1:n
% %         dens = densImgIn(i, j);
% %         if (dens ~= 200 && dens ~= -10)
% %             densCorr = griddata(x, y, z, thickMap(i, j), dens);
% %             densImgOut(i, j) = dens + densCorr;
% %         else
% %             densImgOut(i, j) = dens;
% %         end
% %     end
% % end
% 
% %%
% function params = mySurfFit(data, params0)
% 
% sumSqr = @(p) calcSumSqr(data, p);
% 
% options = optimset('MaxFunEvals', 1e+6, 'TolFun', 1e-12);
% params = fminsearch(sumSqr, params0, options);
% 
% %%
% function chiSqr = calcSumSqr(data, p)
% 
% x = data(:, 1);
% y = data(:, 2);
% z = data(:, 3);
% 
% zFit = applyCorr(x, y, p);
% chiSqr = sum((z - zFit).^2);
% 
% %%
% function densOut = applyCorr(thick, density, p)
% 
% x = thick;
% y = density;
% densOut = p(1) + p(2)*y + p(3)*y.^2 + p(4)*x.*y + p(5)*x.*y.^2 + p(6)*y.^3;

