%Lionel HERVE
%4-29-04
%retrieve all the SXA analysis and compute the thickness of the two wedges

global Database Info Image Analysis

content={};
columntitle={'Acquisition_id';'FileSize'};

IDList=mxDatabase(Database.Name,'select acquisition_id,filename from acquisition');
for index=1:size(IDList,1)
    s = dir(cell2mat(IDList(index,2)));
    content(index,2)={s.bytes};
    content(index,1)={cell2mat(IDList(index,1))};
    
    if cell2mat(content(index,2))>5000000
        funcaddinDatabase(Database,'QA_code_results',[{num2str(cell2mat(IDList(index)))},{'15'}]);
        '****************'
    end
    [num2str(index),'/',num2str(size(IDList,1))]
end
