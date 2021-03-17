%add new data from CPMC
global Database 
load('D:\DicomImageBlinded\DatabaseBackUp');
content=AcquisitionTable;
content2=mxDatabase('mammo_CPMC','select acquisition_id from acquisition');

for iRecord=size(content,1):-1:1
    %check if the record is new
        
    [maxi,index2]=max(cell2mat(content2(:,1))==cell2mat(content(iRecord,1)));
    
    if maxi==0
        values='';
        [num2str(cell2mat(content(iRecord,1))),' added']
        for iField=1:size(content,2)
            values=[values,'''',num2str(cell2mat(content(iRecord,iField))),''','];
        end
        values(end)=[];
        mxDatabase('mammo_CPMC',['insert acquisition values(',values,')']);
        
        mxDatabase(Database.Name,['insert into reposition values(''',num2str(cell2mat(content(iRecord,1))),''',''-'')']);  %%add the reposition path
    else
        break
    end
end