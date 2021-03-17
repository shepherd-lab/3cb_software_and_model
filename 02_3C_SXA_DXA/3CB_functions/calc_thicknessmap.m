function  calc_thicknessmap(thick,xdir_angle)
global X_angle ROI ROI2  MachineParams Analysis Outline thickness_ROI Info thickness_mapproj  thickness_mapreal breast_Maskcorr PreciseOutline Error
global flag BreastMask

% %    Error.PeripheryCalculation = false;
% %  try
       
%    tic
    res = Analysis.Filmresolution/10;
    coef = 0.9;
     thick_wbacky = thick + 2.3;
    a = 1;
     
     thickness = 5;
     
     