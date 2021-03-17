%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function AutomaticQCWAXAnalysis

global   Info  Analysis Error  QCAnalysisData figuretodraw flag ROI Image ctrl MachineParams Database SXAreport
global refDSPtoWAX   version versionGen3

Error.DENSITY=false;
SaveBool= true;
Info.ReportCreated = false;
Error.SkinEdgeFailed = false;
flag.EdgeMode='Auto';
Analysis.tz_angle = 28;
Analysis.error_3Drecon=0.006;
% calibration set validation_mode = false, for validation set
% validation_mode = true (next two lines)
VALIDATION_MODE=false; % if it is false Transfer to Ktable
VALIDATION_MODE_MachineParameterCorr=false;  % if it is false Transfer to MachineParameterCorrection Table
set(ctrl.CheckBreast,'value',false);
kGE = 0.71;
Analysis.Ibkg = 0;

try
    
    if Info.DigitizerId == 5 | Info.DigitizerId == 6 | Info.DigitizerId == 7
        crop_coef = kGE;
    else
        crop_coef = 1;
    end
    
    
    %% Automatic ROI and Skin detection
    
    set(ctrl.Cor,'value',false);
    % % %      Added by Am 02202014
    multiWaitbar( 'Automatic Gen3 Analysis Progress',  1/3, 'Color', [0.2 0.9 0.3] );
    if VALIDATION_MODE == false && VALIDATION_MODE_MachineParameterCorr==false
        CheckGen3;
        
       % temp comment sypks lambertthing 07012019
        if Info.CheckKtableGen3==true && Info.MachineParametersCorrection==true
            Message('It seems there is result with the same Verion in Database');
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end;
    end;
    
    
    a = ROI
    try
        % temp workaround 07112019 sypks: account for modification to
        % QCwax_bbs_position_digital for tomo images
        if Analysis.film_identifier == 'trace1'
            QCwax_bbs_position_digital_GETOMO;
        else
            QCwax_bbs_position_digital;
        end
    catch
        ;
    end
    
    % temp workaround 07112019 sypks: account for modification to QCPhantom
    %Detection for tomo images
    
    if Analysis.film_identifier == 'trace1'
        QCPhantomDetection_GETOMO;
    else
        %      multiWaitbar( 'Automatic Gen3 Analysis Progress',  2/3, 'Color', [0.2 0.9 0.3] )
        QCPhantomDetection;         %07022019 sypks another error with VA images
    end
    
    %Calculate k table
    draweverything;
    
    
    SaveInDatabase('COMMONANALYSIS');
    if ~VALIDATION_MODE % Am 02282014
        roi_QCWAX;
        saveGen3CalibParams(Analysis, Info, MachineParams, Database.Name); %included back into program 06122018 sypks
        
    else
        
        
        % multiWaitbar( 'Automatic Gen3 Analysis Progress',  3/3, 'Color', [0.2 0.9 0.3] );
        
        % % % if VALIDATION_MODE_MachineParameterCorr==false
        % % %     roi_QCWAX;
        % % %     DensityFitParams(Analysis, Info, MachineParams, Database.Name);;
        % % % end
        
        roi_QCWAX_validation;
    end
    Info.CommonAnalysisKey
    if  VALIDATION_MODE_MachineParameterCorr==false
        CheckMachineParameterCorr;
        if Info.MachineParametersCorrection==true
            Message('It seems there is result with the same Verion in Database');
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        else
            try
                
                SaveInDatabase('MachineParametersCorrection_new')
            catch
                errmsg = lasterr
            end;
        end;
    end;
    
    %%% end of adding by AM
    
    % try
    if SXAreport == true
        %%%%%%% temp set sypks 06082018
        %%%%%%% Analysis.Step = 7;
        %%%%%%% temp set sypks 06082018
        CreateReport('ADDCOMMONGEN3');
        figure(figuretodraw);
        % pause(1);
        %
        set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
        for index=1:QCAnalysisData.Draw.Compartments
            set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
        end
        %}
    end
    % catch
    % end
    
    
    %% Report creation
    
    if SaveBool
        %% Add QA codes
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            try
                SaveInDatabase('QACODES');
            catch
                errmsg = lasterr
                nextpatient(0);
                multiWaitbar( 'CloseAll' );
                return;
            end
        end
        
    end
    
    
    %% Go to next patient
    % save if the analysis was ok otherwise choose nextpatient
    
    if (Error.DENSITY &(SaveBool)) %
        nextpatient(0);
    else
        nextpatient(1); %0 is for temporary
    end
    
catch
    errmsg = lasterr
    nextpatient(0);
    multiWaitbar( 'CloseAll' );
    return;
end

end

