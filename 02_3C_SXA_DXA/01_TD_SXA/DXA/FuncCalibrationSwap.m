% CalibrationSwap
% select the good calibration of DXA
% creation date 8-25-03
% author: Lionel HERVE

function funcCalibrationSwap
global Info;
global ctrl
global Analysis;
global Result;

switch Info.DXACalibration
    case 'PA'
        Info.DXACalibration='lateral';
        set(ctrl.DXA.CalibrationLateral,'checked','on');
        set(ctrl.DXA.CalibrationPA,'checked','off');
    case 'lateral'
        Info.DXACalibration='PA';    
        set(ctrl.DXA.CalibrationPA,'checked','on');    
        set(ctrl.DXA.CalibrationLateral,'checked','off');    
end
