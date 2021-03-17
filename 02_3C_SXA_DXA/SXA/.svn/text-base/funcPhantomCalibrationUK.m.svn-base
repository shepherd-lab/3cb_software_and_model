function  funcPhantomCalibrationUK()
    global Info bb Analysis params roi_values Error h_slope Image
    [roi_valuescorr,roi_centroids] = riovalues_calculation(Image.image);
    Analysis.roi_valuescorr = roi_valuescorr;
        
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
    roidata_corr = sortrows(roidata_corr,1)
    xdata = roidata_corr(:,1);
    ydata = roidata_corr(:,2);
   % xdata = (1.2:0.7:6.8)';
    fresult = fit(xdata,ydata,'poly2');
    ph_data = [ydata;fresult.p1;fresult.p2;fresult.p3]
    figure;
    plot(xdata,ydata, 'bo', xdata, fresult.p1.*xdata.^2+fresult.p2.*xdata.^1+fresult.p3, '-r');
    %{
    fresult = fit(xdata,ydata,'poly1')
    ph_slope80 = fresult.p1;
    ph_offset = fresult.p2;
    yc = ph_slope80 * xdata + ph_offset;
    h_slope = figure;
    plot(xdata, ydata, 'bo', xdata,yc,'-r'); 
    %}
    