function EraseOldFile
global Database

content=mxDatabase(Database.Name,'select FileID,FileDate,filename from FileOnInternalDrive order by FileID');
ID=cell2mat(content(:,1));
dateStr=cell2mat(content(:,2));
dateStr=[dateStr(:,5:6),'-'*ones(size(dateStr,1),1),dateStr(:,7:8),'-'*ones(size(dateStr,1),1),dateStr(:,1:4)];
today=datenum(date);
filename=content(:,3);

for index=1:size(ID,1)
    if (today-datenum(dateStr(index,:)))>7
        ['erase old file: ID=',num2str(ID(index)) ,' Date=', dateStr(index,:)]
        delete(['d:\DicomImages\',deblank(cell2mat(filename(index,:)))]);
        mxDatabase(Database.Name,['delete from FileOnInternalDrive where FileID=',num2str(ID(index))]);
    else 
        break;
    end
end

