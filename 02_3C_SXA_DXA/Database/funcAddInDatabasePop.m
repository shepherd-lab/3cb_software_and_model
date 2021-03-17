%%% add an entrie to table pet in Database toto

function [key,error]=funcaddinDatabasepop(Database,table,field);

%find the number of column in the table
[a,ColumName]=mxDatabase(Database.Name,['select * from ',table],1);
tablesize=size(ColumName,2);

%key=funcFindNextAvailableKey(Database,table);
%values=['''',num2str(key),''''];
values = ['''',cell2mat(field(1)),''''];
for index=2:size(field,2)
    values=[values,',''',cell2mat(field(index)),''''];
end
v  = values
%add some empty field if it lacks some element in field
for index=size(field,2)+2:tablesize
    values=[values,','''''];
end

try 
    try 
        mxDatabase(Database.Name,['insert into ',table,' values(',values,');']);
    catch
        try
           mxDatabase(Database.Name,['insert into ',table,' values(',values,');']);
        catch
            try
                mxDatabase(Database.Name,['insert into ',table,' values(',values,');']);
            catch
                err = lasterror
            end
        end
    end
    %[a,names]=mxDatabase(Database.Name,['select * from ',table],1);
    %content=mxDatabase(Database.Name,['select ',cell2mat(names(1)),' from ',table,' where ',cell2mat(names(2)),' = ',cell2mat(field(1)), ' order by ',cell2mat(names(1)),' DESC;'],1);
    %key = cell2mat(content);
    key=funcFindNextAvailableKey(Database,table)-1;
    error=false;

catch
    error=true;
    'ERROR IN FUNCADDINDATABASE'
    foe=lasterror;foe.message
end
