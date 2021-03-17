function  CorrectMachineParametersCorrection( )

% Caluculate Diff Error Thickness  
% Written by Amir P M
%03142014

global Analysis Info flag Database

if strfind(Info.Manufacturer,'HOLOGIC')
    if strfind(Info.machine_id,'20')  % Thickness 1 hasn't been captured after 20110919
        if isempty(Analysis.thicknessWax1) | Analysis.thicknessWax1==0
            if flag.small_paddle
                Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax2-5.8)*10;
            else
                Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
            end
        else
            Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
        end
    else
        Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
    end

elseif strfind(Info.Manufacturer,'LORAD')
    
    if strfind(Info.machine_id,'20')  % Thickness 1 hasn't been captured after 20110919
        if isempty(Analysis.thicknessWax1) | Analysis.thicknessWax1==0
            if flag.small_paddle
                Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax2-5.8)*10;
            else
                Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
            end
        else
            Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
        end
    else
        Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.26)*10;
    end
    
else
    
    Analysis.gen3thickness_diff_1sign=(Analysis.thicknessWax1-6.05)*10;  %GE
    
end

if flag.small_paddle==true
    
    Analysis.paddle_type=1;
    
else
    
    Analysis.paddle_type=0;
    
end;
try
Ktable_1 = mxDatabase(Database.Name,['select * from kTableGen3 where acquisition_id=',num2str(Info.AcquisitionKey),...
    'order by date_acquisition']);

QCWAX_status=Ktable_1(end);
QCWAX_status = strtrim(QCWAX_status);

if strcmpi(QCWAX_status,'True')
    
    Analysis.MachineParameter_status='True';
    
else
    
    Analysis.MachineParameter_status='False';
    
end

catch
     Analysis.MachineParameter_status='True';   
end
Analysis.tz_angle=28;
Analysis.error_3Drecon=0.006;
end

