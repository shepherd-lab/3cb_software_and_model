%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function AutomaticPCAnalysisROI(CancerRegionData)
global Info Database ctrl StructuralAnalysis

SaveBool=false;
SaveCommonAnalysis=false;
StructuralAnalysis = [];
%try 
%     Message('Retrieve or compute common analysis...');
%     %% try to see if a commonanalysis has already been done
%     commonanalysisID=max(cell2mat(mxDatabase(Database.Name,['select commonanalysis_id from commonanalysis where acquisition_id=' num2str(Info.AcquisitionKey)])));
%     if size(commonanalysisID,1)==0
% %%ROI
%        CallBack=get(ctrl.ROI,'callback');
%        eval(CallBack);
%        draweverything;
% 
% %% Skin detection
%         CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
%         eval(CallBack);
%         SaveCommonAnalysis=true;
%     else
%        Info.CommonAnalysisKey= commonanalysisID;
%        RetrieveInDatabase('COMMONANALYSIS');
%        draweverything;
%     end
    
%% Automatic BDPC analysis
    Message('Computing parenchymal parameters...');
    
    ReturnResults = StructuralAnalysisComputationROI(CancerRegionData);
    SaveBool=true;
% catch
%     lasterr
% end

if (SaveBool==true)
    if SaveCommonAnalysis
        SaveInDatabase('COMMONANALYSIS');
    end
    SaveInDatabase('STRUCTURALANALYSIS');
end

%% Go to next patient
% save if the analysis was ok otherwise choose nextpatient
nextpatient(3);
