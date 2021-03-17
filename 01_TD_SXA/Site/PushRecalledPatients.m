%PushRecalledPatients
%Lionel HERVE
%8-30-04

ScanToBePushed=mxDatabase(Database.Name,'select * from fileoninternaldrive where status=''ToBePushed'''); %FileID SFMR R2 status date filename
for index=1:size(ScanToBePushed,1)
    filename=deblank(cell2mat(ScanToBePushed(index,6)));
    clear Field;
    Field(1)=ScanToBePushed(index,2);
    Field(2)=ScanToBePushed(index,3);   
    Field(3)=ScanToBePushed(index,5);         
    Field(4)=ScanToBePushed(index,6);     
    [key,error]=funcaddinDatabase(Database,'fileonexternaldrive',Field);
    filename=deblank(cell2mat(Field(4)));
    movefile(['D:\dicomimages\',filename],'g:\Images');
    
    mxdatabase(Database.Name,['delete from fileoninternaldrive where filename=''',filename,'''']);
end