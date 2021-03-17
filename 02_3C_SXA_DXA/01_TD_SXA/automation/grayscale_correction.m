function [ROI_values_corr] = grayscale_correction(ROI_values, a_offset, b_slope);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     global MachineParams
     A_const =  MachineParams.a_init;
     B_const =  MachineParams.b_init;
     ROI_values_corr = ROI_values*B_const/b_slope - a_offset*B_const/b_slope + A_const;
     
end

