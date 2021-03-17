function p = version_retreiving(acq_id) 
acqid_str =    num2str(acq_id;
p=mxDatabase('mammo_CPMC','select sxaanalysis.version from sxaanalysis,commonanalysis, acquisition where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and acquisition.acquisition_id=acq_id');
%and sxaanalysis.version="Version 6.2"