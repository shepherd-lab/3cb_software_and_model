function  CheckMachineParameterCorr
% Added this function to prevent duplicate results in MachineParametersCorrection table
% Written by Amir Pasha M
% 03122014

global Info Database 
try
    MachineParametersCorrection=mxDatabase(Database.Name,['select Top 1* from MachineParametersCorrection_New where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by commonanalysis_id DESC']);
    
    MachineParametersCorrection_Machine=num2str(MachineParametersCorrection{1,4});
    MachineParametersCorrection_Paddle=num2str(MachineParametersCorrection{1,6});
    MachineParametersCorrection_date=MachineParametersCorrection{1,7};
    CheckVersionMachinePara_version=MachineParametersCorrection{1,8};
    
    
    if strfind(CheckVersionMachinePara_version,Info.Version)
        
        if strfind(MachineParametersCorrection_Machine,Info.machine_id)
            Info.MachineParametersCorrection=true;
        else
            Info.MachineParametersCorrection=false;
        end;
        
    else
        if ~strcmpi(CheckVersionMachinePara_version(1:10),'Version7.1')
            
            Info.MachineParametersCorrection=false;
            
        else
            Info.MachineParametersCorrection=true;
            
        end;
    end;
    
catch
    Info.MachineParametersCorrection=false;
    
end

end

