global Database

AcquisitionList=[3483:4000]';

for indexAcq=1:size(AcquisitionList,1)
    Filename=deblank(cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(AcquisitionList(indexAcq))])));
    DIRQUERY=dir(['d:\temp\dvd3\',funcEndFileName(Filename)])
    if size(DIRQUERY,1)
        %delete(['d:\temp\dvd3\',funcEndFileName(Filename)])
    end
end        
