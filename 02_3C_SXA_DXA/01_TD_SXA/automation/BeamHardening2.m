%Lionel HERVE
%4-29-04
%retrieve all the SXA analysis and compute the size of the file

global Database Info Image Analysis ctrl

content={};
columntitle={'Acquisition_id' 'FileSize'};

IDList=mxDatabase(Database.Name,'select sxaanalysis_id,acquisition.acquisition_id,filename from sxaanalysis,acquisition,commonanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id')
for index=1:size(IDList)
    s = dir(cell2mat(IDList(index,3)));
    content(index,2)={s.bytes};
    content(index,1)={cell2mat(IDList(index,2))};
end
CopyResultsToExcel(content,columntitle);