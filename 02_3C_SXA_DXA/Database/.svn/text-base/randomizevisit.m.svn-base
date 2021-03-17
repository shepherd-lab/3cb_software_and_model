function OutputList=randomizevisit(acquisitionkeyList)
global Database;

OutputList=acquisitionkeyList;

formerContent=[{0},{''},{0}];
for index=1:size(acquisitionkeyList,1)
    content=mxDatabase(Database.Name,['select acquisition_id, patient_id, view_id from acquisition where acquisition_id=',num2str(acquisitionkeyList(index))]);
    if (strcmp(formerContent{2},content{2}))&(formerContent{3}==content{3})
        if (rand(1)>0.5)
            OutputList=[OutputList(1:index-2);OutputList(index);OutputList(index-1);OutputList(index+1:end)];
        end
    end
    formerContent=content;
end



