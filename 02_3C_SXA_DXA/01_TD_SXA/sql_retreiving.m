function p = sql_retreiving() 
p=mxDatabase('mammo_CPMC','select acquisition.acquisition_id, sxaanalysis.version, sxaanalysis.sxaresult from sxaanalysis,commonanalysis, acquisition where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id ');
%and sxaanalysis.version="Version 6.2"