function [a_offset,b_slope] = grayscale_correction( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global Analysis
  xdata = [0 30 45 50 60 70 100];
  roi_DSP7values = Analysis.roi_DSP7values;
   fresult3 = fit(xdata,,'poly1')    %fit for lean curve
    b_slope = fresult3.p1;
    a_offset = fresult3.p2;
    ydata_fit = b_slope*xdata + a_offset;
   figure; plot(xdata, roi_DSP7values, 'ko',xdata, ,'k*', 'LineWidth',2);


end

