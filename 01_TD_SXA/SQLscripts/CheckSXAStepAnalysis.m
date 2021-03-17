function CheckSXAAnalysis
% Lionel HERVE
% 12-21-04
% allow the SXA operator to check if he already reviewed a scan by checking
% the number of SXA analyses already performed on a particuliar image

AcqID=inputdlg('Acquisition ID?','SXA Step Analysis checker')

if size(AcqID)>0
    AcqID=cell2mat(AcqID);
    %funcShowSQLinTable(['select * from commonanalysis,sxastepanalysis,correction,othersxastepinfo where correction.flatfieldcorrection_id=sxastepanalysis.flatfieldcorrection_id and sxastepanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and othersxastepinfo.sxastepanalysis_id=sxastepanalysis.sxastepanalysis_id and commonanalysis.acquisition_id=',AcqID]);
    funcShowSQLinTable(['select * from commonanalysis,sxastepanalysis where sxastepanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=',AcqID, 'order by sxastepanalysis.sxastepanalysis_id' ]);
    % funcShowSQLinTable(['select * from acquisition,commonanalysis,sxastepanalysis,othersxastepinfo  where acquisition.acquisition_id=commonanalysis.acquisition_id and commonanalysis.commonanalysis_id=sxastepanalysis.commonanalysis_id and othersxastepinfo.sxastepanalysis_id=sxastepanalysis.sxastepanalysis_id ]);
end
    