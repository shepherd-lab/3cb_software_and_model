function CheckGen3

% Added this function to prevent duplicate results in KtableGen3 and
% MachineParametersCorrection tables
% Written by Amir Pasha M
% 02202014

global Info Database 
try
    KtableGen3=mxDatabase(Database.Name,['select * from kTableGen3 where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by commonanalysis_id DESC']);
    KtableGen = KtableGen3(1,:);
    KtableGen33=cell2mat(KtableGen(1));
    CheckVersionGen3=cell2mat(KtableGen3(7));
    

    if strfind(CheckVersionGen3,Info.Version)
        
        if KtableGen33 ~=0
            Info.CheckKtableGen3=true;
        else
              Info.CheckKtableGen3=false;
        end;
        
    else
        if ~strcmpi(CheckVersionGen3(1:10),'Version7.1')
            
             Info.CheckKtableGen3=false;
             
        else
            Info.CheckKtableGen3=true;
        
        end;
    end;
    
catch
    Info.CheckKtableGen3=false;
    
end

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

