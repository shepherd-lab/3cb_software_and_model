function CheckSXAAnalysis
% Lionel HERVE
% 12-21-04
% allow the SXA operator to check if he already reviewed a scan by checking
% the number of SXA analyses already performed on a particuliar image

AcqID=inputdlg('Acquisition ID?','SXA Analysis checker')

if size(AcqID)>0
    AcqID=cell2mat(AcqID);
    funcShowSQLinTable(['select * from commonanalysis,sxaanalysis,correction,othersxainfo where correction.flatfieldcorrection_id=sxaanalysis.flatfieldcorrection_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and othersxainfo.sxaanalysis_id=sxaanalysis.sxaanalysis_id and acquisition_id=',AcqID]);
end
    