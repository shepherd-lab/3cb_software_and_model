function key=funcFindNextAvailableKey(Database,table);
             

[a,names]=mxDatabase(Database.Name,['select * from ',table],1);
content=mxDatabase(Database.Name,['select ',cell2mat(names(1)),' from ',table,' order by ',cell2mat(names(1)),' DESC;'],1);

if size(content,1)==0  %when the table is empty
    key=1;
else
    key=cell2mat(content)+1;
end



