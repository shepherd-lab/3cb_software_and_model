function funcDelete(Database,Table,keys);
    keyname=funcFindKeyName(Database,Table);
    
    if size(keys,2)~=0
        for index=1:size(keys,1)
            SQLstatement=['delete from ',Table,' where ',keyname,'=',num2str(keys(index))];
            mxDatabase(Database.Name,SQLstatement);
        end
    end