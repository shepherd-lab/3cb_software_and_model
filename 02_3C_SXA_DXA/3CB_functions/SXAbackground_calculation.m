function  sxa_bkgr = SXAbackground_calculation()
    global bb Analysis   
   
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
        
%       Analysis.roi_valuescorr = Analysis.roi_values - Analysis.Ibkg;
        roi_valuescorr = Analysis.roi_values;
        roi_data = [ phantom_thickness',roi_valuescorr'];
       
    roidata_corr = roi_data;
    roi_sorted = sortrows(roidata_corr,1);
    hleanref_vect = roi_sorted(:,1);    %thickness of SXA steps
    phleanref_vect = roi_sorted(:,2);   %density of SXA steps
   
    xdata = hleanref_vect(1:6);          %thickness of SXA steps
    ydata_ph80 = phleanref_vect(1:6);  
      
    fresult3 = fit(xdata,ydata_ph80,'poly2')    %fit for lean curve
    ph80_a2corr = fresult3.p1;
    ph80_a1corr = fresult3.p2;
    ph_offsetcorr = fresult3.p3;
    sxa_bkgr = ph_offsetcorr
     xdata_fit = [0;xdata];
     ydata_fit = ph80_a2corr * xdata_fit.^2 + ph80_a1corr * xdata_fit + ph_offsetcorr;
%        figure; plot(xdata, ydata_ph80, 'bo',xdata_fit, ydata_fit,'-r'); grid on;
%        a = 1;
     
    


