%% Delete an entrie
%author Lionel HERVE
%creation date 5-10-03
function funcDeleteAnEntrie(Database,line)

button = questdlg('Delete an entrie is definitive. Even undo function won''t work. Do you want to continue?',...
'Continue Operation','Yes','No','No');
if strcmp(button,'Yes')
    key=cell2mat(Database.content(line,1));
    keyname=funcFindKeyName(Database,Database.Table);
    %execute SQL command
    mxDatabase(Database.Name,['delete from ',Database.Table,' where ',keyname,'=',num2str(key)]);
end

