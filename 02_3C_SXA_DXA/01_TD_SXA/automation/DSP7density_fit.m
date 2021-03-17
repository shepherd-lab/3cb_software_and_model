function DSP7density_fit( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global Analysis
  %Analysis.roi_DSP7densities = [17.5975,41.0736,53.2476,57.6039,66.7387,74.4445,102.1917]';
  Analysis.DSP7references = [23.08,46.15,57.69,61.54,69.23,76.92,100.00]';
  ydata = [23.08,46.15,57.69,61.54,69.23,76.92,100.00]';
  roi_DSP7densities = Analysis.density_DSP7;
  fresult3 = fit(roi_DSP7densities,ydata,'poly2')    %fit for lean curve
    Analysis.A2 = fresult3.p1;
    Analysis.A1 = fresult3.p2;
    Analysis.A0 = fresult3.p3;
    %%% test of correction
    ydata_fit = Analysis.A2*roi_DSP7densities.^2 + Analysis.A1*roi_DSP7densities + Analysis.A0;
    figure; plot(roi_DSP7densities, ydata,'ko',roi_DSP7densities,ydata_fit, 'b-', 'LineWidth',2);
    diff_v = (ydata_fit - ydata);
    diff2_v = (ydata - roi_DSP7densities);
    diff = mean(abs(ydata_fit - ydata));
    diff2 = mean(abs(ydata - roi_DSP7densities));
    a  =1;
end
