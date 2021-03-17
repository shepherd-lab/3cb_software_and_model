function key=find_nextKey(database_name,table);


[a,names]=mxDatabase(database_name,['select * from ',table],1);
content=mxDatabase(database_name,['select ',cell2mat(names(1)),' from ',table,' order by ',cell2mat(names(1)),' DESC;'],1);

if size(content,1)==0  %when the table is empty
    key=1;
else
    key=cell2mat(content)+1;
end



