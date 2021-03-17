function [sxa_listout] = sql_sxacancers()
%acq_list = load('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\CPMC\step_phantom\Cancer cases\patient_ids_digcancers.txt');
%acq_list = textread('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\CPMC\step_phantom\Cancer cases\patient_ids_digcancers.txt','%s');
acq_list = load('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\CPMC\step_phantom\Cancer cases\acq_ids_filmcancers.txt','%s');
%sxalist = zeros(
%acq_list = cell2mat(acq_list);
%a = acq_list{1};
out_index = 0;
out = 1;
count = 1;
for i = 1:length(acq_list)
    %sxalist = mxDatabase('mammo_CPMC',['SELECT ALL acquisition.acquisition_id,acquisition.view_id,acquisition.mAs,acquisition.kVp,acquisition.Thickness,acquisition.Force,commonanalysis.commonanalysis_id,SXAStepAnalysis.SXAStepResult,SXAStepAnalysis.angle_rx,SXAStepAnalysis.angle_ry,SXAStepAnalysis.coord_tz,SXAStepAnalysis.error_3Dreconstruction,SXAStepAnalysis.total_fatmass,SXAStepAnalysis.total_leanmass,SXAStepAnalysis.breast_volume,SXAStepAnalysis.flatfieldcorrection_id FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxastepanalysis.commonanalysis_id  AND acquisition.patient_id =',num2str(acq_list(i))]);  %,num2str(acq_list(i))
    %SQLrequest = ['SELECT ALL acquisition_id,patient_id, view_id, machine_id  FROM acquisition WHERE  acquisition.patient_id = ','''',acq_list{i},''''];
    SQLrequest = ['SELECT ALL acquisition.acquisition_id,acquisition.view_id,acquisition.mAs,acquisition.kVp,acquisition.Thickness,commonanalysis.commonanalysis_id,SXAAnalysis.SXAResult FROM acquisition,commonanalysis,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND acquisition.acquisition_id =',num2str(acq_list(i))];
    sxalist = mxDatabase('mammo_CPMC',SQLrequest);  %,num2str(acq_list(i)) num2str(acq_list(i)
    % sxa_listold(i,:) = sxalist(end-1,:);
   % sz_new = size(sxalist(end,:));
      % out_index = out_index+1;
        
    
    if ~isempty(sxalist)
        sxa_listout(count,:) = sxalist(end,:);
        count = count +1;
    end
    %sz_out = size(sxa_listout);
    %out_index = sz_out(1);
    
end
a =2;