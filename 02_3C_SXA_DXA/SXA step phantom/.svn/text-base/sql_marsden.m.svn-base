function sxa_list = sql_marsden()
acq_list = load('P:\Temp\good films\marsden_left.txt');
%sxalist = zeros(
for i = 1:length(acq_list)
    sxalist = mxDatabase('mammo_Marsden',['SELECT ALL acquisition.acquisition_id,acquisition.view_id,acquisition.mAs,acquisition.kVp,acquisition.Thickness,acquisition.Force,commonanalysis.commonanalysis_id,SXAStepAnalysis.SXAStepResult,SXAStepAnalysis.angle_rx,SXAStepAnalysis.angle_ry,SXAStepAnalysis.coord_tz,SXAStepAnalysis.error_3Dreconstruction,SXAStepAnalysis.total_fatmass,SXAStepAnalysis.total_leanmass,SXAStepAnalysis.breast_volume FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxastepanalysis.commonanalysis_id  AND acquisition.acquisition_id =',num2str(acq_list(i))]);  %,num2str(acq_list(i))
    sxa_list(i,:) = sxalist(end,:);
end
