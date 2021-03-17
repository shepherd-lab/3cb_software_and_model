% Density Computation
% compute the image density from the ImageFatLean
% Lionel HERVE 2/03
% revision history
%    3-03: Flat field correction in the computations
%    5-20-03: use functions
function computedensity
global Analysis ctrl ROI Image Info Outline Correction Database

rb = ROI;
rc = Outline;

%if Correction.Type==1
%    message('!!!Invalid correction!!!!')
%    beep;
%    return;
%end

    Analysis.Step=8;
    set(ctrl.text_zone,'String','Working hard...');     
    xm = strmatch('mammo_Marsden', Database.Name, 'exact');
          
    
    if get(ctrl.CheckBreast,'Value')
        if uint8(Analysis.PhantomID) == 7
           if xm > 0  
             UKComputeBreastDensity(Outline,ROI, Image);  
           else    
             funcComputeStepBreastDensity(Outline,ROI, Image);
           end 
        elseif uint8(Analysis.PhantomID) == 8
            funcComputeStepBDDigital(Outline,ROI, Image);
        elseif uint8(Analysis.PhantomID) == 9
            Z4ComputeBreastDensity(Outline,ROI, Image);    
        else
            Analysis=funcComputeBreastDensity(ROI,Image,Analysis,Outline,Info);
        end
        set(ctrl.text_zone,'String',strcat('Area surface:',num2str(Analysis.Surface),'pixels - Image Density :',num2str(Analysis.DensityPercentageSkin),'%'));
    else
        Analysis=funcComputePhantomDensity(ROI,Image,Analysis);
        set(ctrl.text_zone,'String',strcat('Area surface:',num2str(ROI.rows*ROI.columns),'pixels - Image Density :',num2str(Analysis.DensityPercentage),'%'));
    end
    %for temporary
%FuncActivateDeactivateButton;
%draweverything;

