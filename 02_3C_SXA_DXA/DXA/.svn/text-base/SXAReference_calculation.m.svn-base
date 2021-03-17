function SXARef = SXAReference_calculation(image)
    global Info bb Analysis roi_values Image roi_centroids
  
    %{
     Error.DENSITY=false;
     Error.SuperLeanWarning=false;
     Analysis.TotalFatMass = [];
     Analysis.TotalLeanMass = [];
     Analysis.DensityPercentageCut = [];
     Analysis.DensityPercentage = [];
     Analysis.DensityPercentageNoCorr = [];
     Analysis.BreastVolume = [];
     Analysis.BreastArea = [];
     Error.Error.SuperLeanWarning=false;
     %}
          
        phantom_thickness(1) = bb.bb1(1).z; 
        phantom_thickness(2) = bb.bb2(1).z;
        phantom_thickness(3) = bb.bb3(1).z;
        phantom_thickness(4) = bb.bb4(1).z;
        phantom_thickness(5) = bb.bb5(1).z;
        phantom_thickness(6) = bb.bb6(1).z;
        phantom_thickness(7) = bb.bb7(1).z;
        phantom_thickness(8) = bb.bb8(1).z;
        phantom_thickness(9) = bb.bb9(1).z;
              

        [roi_valuescorr,roi_centroids] = riovalues_calculation(Image.image);
        [roi_valuesCounts,roi_centroids] = riovalues_calculation(image);
        index_out = find(roi_valuescorr == -1);
        roi_valuescorr(index_out) = [];
        phantom_thickness(index_out) = [];
        roi_valuesCounts(index_out) = [];
        roi_centroids(:,index_out) = []
        Analysis.roi_valuescorr = roi_valuescorr;
     
    roi_data = [phantom_thickness',roi_valuescorr',roi_valuesCounts',roi_centroids];
    length_80ref = length(roi_valuescorr);
   
        
    roidata_corr = roi_data;
    roi_sorted = sortrows(roidata_corr,1);
    hleanref_vect = roi_sorted(:,1);
    phleanref_vect = roi_sorted(:,2);
    phleanref_vectCounts = roi_sorted(:,3);
    phleanref_centroids = roi_sorted(:,4:5);
    index_center = find(hleanref_vect == 4.7);
    ref_value = phleanref_vectCounts(index_center);
    ref_centroid = phleanref_centroids(index_center,:);
    index_linear = find(hleanref_vect > 1.1 & hleanref_vect < 7); %step between 2.5 and 4.8 cm (3,4,5,6)
    ref_values = phleanref_vectCounts(index_linear);
    ref_centroids = phleanref_centroids(index_linear,:);
    xdata1 = hleanref_vect(index_linear);
    ydata1 = phleanref_vect(index_linear);
    
    xdata2 = hleanref_vect(1:length_80ref);
    ydata2 = phleanref_vect(1:length_80ref);
        
    fresult1 = fit(xdata1,ydata1,'poly1'); % linear fit y = a1*x + b1
    a1 = fresult1.p1;
    b1 = fresult1.p2;
    ref_slope = a1;
    ref_thickness = Analysis.ph_thickness;
    SXARef.ref_slope = ref_slope;
    SXARef.ref_value = ref_value;
    SXARef.ref_centroid = ref_centroid;
    SXARef.ref_thickness = ref_thickness;
    SXARef.ref_values = ref_values;
    SXARef.ref_centroids = ref_centroids;
    a = 1;
    
    %%%%%% UNCOMMENT  to view  fitting results if necessary
    %figure; plot(xdata1, ydata1, 'ro',xdata1, a1*xdata1+b1,'k-', 'LineWidth',2);grid on;
     
    %%%%%%% in case if quadratic fit is needed    %%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %{
    fresult2 = fit(xdata2,ydata2,'poly2')   %%quadratic fit y = a2*x^2 + b2*x + c2
    a2 = fresult2.p1;
    b2 = fresult2.p2;
    c2 = fresult2.p3;
    %}
   
    
    