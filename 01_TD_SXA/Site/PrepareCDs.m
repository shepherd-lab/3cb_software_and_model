%PrepareCDs
function PrepareCDs(AcquisitionList)
global Database

%for database backup file
AcquisitionTable=mxDatabase(Database.Name,'select * from acquisition');

CDDirectoryName=CreateNewDirectory;
MediaSize=4000; %MB
CurrentMediaSize=0;
Message('Preparing CDs...');
for indexAcq=1:size(AcquisitionList)
    Filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionList(indexAcq))])));
    DIRQUERY=dir(Filename);
    CurrentMediaSize=CurrentMediaSize+DIRQUERY(1).bytes;
    copyfile(Filename,[CDDirectoryName,'\',funcEndFileName(Filename)]);
    if (CurrentMediaSize>MediaSize*2^20)
        Message(['Directory ',CDDirectoryName,' full...']);
        CurrentMediaSize=0;
        save([CDDirectoryName,'\','DatabaseBackUp'],'AcquisitionTable');
        CDDirectoryName=CreateNewDirectory;
    end
end
save([CDDirectoryName,'\','DatabaseBackUp'],'AcquisitionTable');
Message('Done...Go and check in C:\temp\');


function CDDirectoryName=CreateNewDirectory
s=dir ('c:\temp\BackUpCd*');
CDDirectoryName=['c:\temp\BackUpCd',num2str(size(s,1)+1)];
mkdir(CDDirectoryName);



