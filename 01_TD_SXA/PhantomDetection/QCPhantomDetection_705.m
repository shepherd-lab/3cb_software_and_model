% Phantom Manual

% draw two box (one for 100%fat, one for 100%lean)
% 
% Lionel HERVE 2/03
% modification
% 10-29-03 automatic detection 
function QCPhantomDetection(Gen3Pos)
global f0 ctrl Analysis Info figuretodraw Image Phantom ReportText Error  PhantomDetectionFailure Correction DEBUG Database
figure(f0.handle);   
Analysis.DensityPercentageAngle = [];
 Phantom = [];
 %Phantom.second_phantom = true;  %for down right corner    
 Error.PhantomDetection=false;
 Error.StepPhantomFailure=false;
 Error.StepPhantomBBsFailure=false;
 Error.StepPhantomPosition=false;
 Error.StepPhantomReconstruction=false;
  [v,d] = version;
  k = strfind(v, 'R2007a');
  if ~isempty(k)
      if isempty(getNumberOfComputationalThreads)
            fprintf('Multithreaded computation is disabled in your MATLAB session.\n');
            fprintf('Use Preferences to enable.\n');
            return
      end
      num = getNumberOfComputationalThreads;
      setNumberOfComputationalThreads(num);
  end 
%{
 if Info.DigitizerId == 3
            Analysis.Filmresolution  = 0.15;
 else
            Analysis.Filmresolution = 0.169;
 end
%}
 %try
    if Info.DigitizerId >= 4
        type = phantom_typedigital();
    else
        type = 'WEDGE';%phantom_type(Image.OriginalImage); 
    end
     % type = 'WEDGE';
     %type = 'STEP';
     if strcmp(type,'NO') | strcmp(type,'BAD') 
         Error.StepPhantomFailure = true
        stop;
     elseif strcmp(type, 'STEP')
       % Message('Step phantom');
        Analysis.Step = 1;
        if Info.DigitizerId >= 4
             % Analysis.PhantomID = 8; %commented for phantom calibration
            % stop;
              if ~get(ctrl.CheckManualPhantom,'value') % manual 
                  Z2phantom_manual();
              else
                  QCZ2phantom_automatic(Gen3Pos);
              end
        end
           
          
      end
          Info.PhantomComputed=true;
          Info.StepPhantomComputed=true;
          set(ctrl.text_zone,'String','Now, you can compute the breast density'); 
          %set(ctrl.text_zone,'String','Breast density = 93%'); 
          %  draweverything;
          FuncActivateDeactivateButton;
          Error.PhantomDetection=false;
          Error.StepPhantomFailure=false;
          Error.StepPhantomBBsFailure=false;
          Error.StepPhantomPosition=false;
          Error.StepPhantomReconstruction=false;
   
