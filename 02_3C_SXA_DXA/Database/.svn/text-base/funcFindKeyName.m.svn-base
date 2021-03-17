function keyname=funcFindKeyName(Database,Table)
%creation date 10-10-03
%Author Lionel HERVE

% retrieve name of the key column
[content,names]=mxDatabase(Database.Name,['select * from ',Table],1);
keyname=cell2mat(names(1));
