%to be launched manually
% Lionel HERVE
% 12-10-04
% example of use : missingID=findmissingfiles(0,'GENERATE>',5914)

function findmissingfiles(List,option,argument)
global Database dummyuicontrol2 Info

missingID=[];

if ~exist('option')
    option='NULL'
end

if strcmp(option,'GENERATE>')
    List=cell2mat(mxDatabase(Database.Name,['select acquisition_id from acquisition where acquisition_id>',num2str(argument)]));
end

for index=1:size(List)
        filename=cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(List(index))]));
        [ending,beginning]=funcEndFileName(filename);
        ThumbnailFileName=[beginning,'thumb_',ending];
        if ~exist(ThumbnailFileName)
            try
                imagette=UnderSamplingN(imread(filename),10);
            catch
                missingID=[missingID;List(index)];
                ['missing : ', num2str(List(index))]
            end
        end
end

