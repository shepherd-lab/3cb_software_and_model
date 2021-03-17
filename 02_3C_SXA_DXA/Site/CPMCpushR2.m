%CPMC push R2
%Lionel HERVE
%8-30-04
global Database

[SFMRList]=FuncSelectInTable('fileoninternaldrive','What do you want to push',1,'Cancel');
SFMRList=cell2mat(SFMRList);
if size(SFMRList,1)>0
    for index=1:size(SFMRList,1)
        sfmrCode=cell2mat(mxDatabase(Database.Name,['select sfmrbarcode from  fileoninternaldrive where FileID=',num2str(SFMRList(index))]));
        mxDatabase(Database.Name,['update fileoninternaldrive set status=''ToBePushed'' where sfmrbarcode=''',sfmrCode,'''']);
    end
end
