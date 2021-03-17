function [sxa_listold, sxa_listnew] = sql_zerodensity()
acq_list = load('P:\Temp\good films\Z4_zerolistnew.txt');
%sxalist = zeros(
for i = 1:length(acq_list)
    sxalist = mxDatabase('mammo_CPMC',['SELECT ALL acquisition.acquisition_id,acquisition.view_id,acquisition.mAs,acquisition.kVp,acquisition.Thickness,acquisition.Force,commonanalysis.commonanalysis_id,SXAStepAnalysis.SXAStepResult,SXAStepAnalysis.angle_rx,SXAStepAnalysis.angle_ry,SXAStepAnalysis.coord_tz,SXAStepAnalysis.error_3Dreconstruction,SXAStepAnalysis.total_fatmass,SXAStepAnalysis.total_leanmass,SXAStepAnalysis.breast_volume,SXAStepAnalysis.flatfieldcorrection_id FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxastepanalysis.commonanalysis_id  AND acquisition.acquisition_id =',num2str(acq_list(i))]);  %,num2str(acq_list(i))
    sxa_listold(i,:) = sxalist(end-1,:);
     sxa_listnew(i,:) = sxalist(end,:);
     a =2;
end
