%Lionel HERVE
%5-25-04
%retrieve all the SXA analysis
function DSPphantom()

global Database Info Image Analysis ctrl Threshold

acquisitionkeyList=textread('P:\Temp\good films\qc_dsp.txt','%u'); 

%SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
for index=1:size(SXAIDList)
    index
    Info.AcquisitionKey=acquisitionkeyList(index);
   
end
