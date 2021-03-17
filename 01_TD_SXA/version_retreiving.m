function p = version_retreiving(acq_id) 
%acqid_str =    num2str(acq_id);

%Info.AcquisitionKey = acq_id;
%if phantomID == 7
   p=mxDatabase('mammo_CPMC',['select commonanalysis.version from commonanalysis, acquisition where commonanalysis.acquisition_id=acquisition.acquisition_id and acquisition.acquisition_id=',num2str(acq_id)]);
%else
%   p=mxDatabase('mammo_CPMC',['select sxaanalysis.version from sxaanalysis,commonanalysis, acquisition where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and acquisition.acquisition_id=',num2str(acq_id)]);
%end
%and sxaanalysis.version="Version 6.2" ['select * from acquisition where
%acquisition_id=',num2str(Info.AcquisitionKey)]);
%(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);