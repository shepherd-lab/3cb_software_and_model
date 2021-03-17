function RepositionImage(AcquisitionList,MaxNumber)
global Database

if ~exist('MaxNumber') 
    MaxNumber=1000;
end

%reuse the code from preparecds
MediaSize=4300; %MB
CurrentMediaSize=0;
CurrentMedia=0;
CurrentList=[];
[DVDName,DirectoryName]=CreateNewDVDDirectory;

Message('Preparing DVDs...');
for indexAcq=1:size(AcquisitionList,1)
    [num2str(indexAcq),'/',num2str(size(AcquisitionList,1)),' CurrentSize:',num2str(CurrentMediaSize/2^20),' acquisition:', num2str(AcquisitionList(indexAcq))]
    %check if the file has been repositioned
    repositionLocation=cell2mat(mxDatabase(Database.Name,['select location from reposition where acquisition_id=',num2str(AcquisitionList(indexAcq))]));  
    if strcmp(deblank(repositionLocation),'-')         %skip already repositoned images
        %copy the file, check the size of the diskimage
        CurrentList=[CurrentList; indexAcq];
        Filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionList(indexAcq))])));
        DIRQUERY=dir(Filename);
        CurrentMediaSize=CurrentMediaSize+DIRQUERY(1).bytes;
        copyfile(Filename,[DirectoryName,'\',funcEndFileName(Filename)]);
    end
    if (CurrentMediaSize>MediaSize*2^20)||(indexAcq==size(AcquisitionList,1))
        Message('Removing the files from server');
        for index2=1:size(CurrentList,1)
            mxDatabase(Database.Name,['update reposition set location=''',DVDName,''' where acquisition_id=',num2str(AcquisitionList(CurrentList(index2)))]);
            Filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionList(CurrentList(index2)))])));
            try
                delete(Filename);
            end
        end
        %% update reposition table
        Message(['Directory ',DirectoryName,' full...']);
        CurrentMedia=CurrentMedia+1;
        if CurrentMedia>=MaxNumber
            break;
        end
        [DVDName,DirectoryName]=CreateNewDVDDirectory;
        CurrentList=[];
        CurrentMediaSize=0;
    end
end
Message('Done...Go and check in D:\temp\');


function [DVDName,DirectoryName]=CreateNewDVDDirectory
global Database
% find the last DVD name and add 1 to it
CurrentDirectoryNames=mxDatabase(Database.Name,'select distinct location from reposition');
temp=cell2mat(CurrentDirectoryNames);
indexes=str2num(temp(:,4:end));
if size(indexes,1)>0 %there is a risk no DVD where already done
    NewIndex=max(indexes)+1;
else 
    NewIndex=1;
end
DVDName=['DVD',num2str(NewIndex)];
DirectoryName=['D:\temp\',DVDName];
mkdir(DirectoryName);





