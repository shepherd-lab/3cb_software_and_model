%%% add an entrie to table pet in Database toto

function [key,error]=funcaddinDatabase(Database,table,field);

%find the number of column in the table
[a,ColumName]=mxDatabase(Database.Name,['select * from ',table],1);
tablesize=size(ColumName,2);

key=funcFindNextAvailableKey(Database,table);
values=['''',num2str(key),''''];
for index=1:size(field,2)
    values=[values,',''',cell2mat(field(index)),''''];
end
v  = values
%add some empty field if it lacks some element in field
for index=size(field,2)+2:tablesize
    values=[values,','''''];
end

try 
    mxDatabase(Database.Name,['insert into ',table,' values(',values,');']);
    error=false;

catch
    error=true;
    'ERROR IN FUNCADDINDATABASE'
    foe=lasterror;foe.message
end
