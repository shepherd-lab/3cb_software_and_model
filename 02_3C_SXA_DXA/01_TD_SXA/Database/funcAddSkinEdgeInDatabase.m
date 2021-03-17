function key=funcAddSkinEdgeInDatabase(Database,ManualEdge);
%author Lionel HERVE
%creation date 5-22-03
%modification for mxDatabase 3-25-03

key=funcFindNextAvailableKey(Database,'manualedge');
for index=1:size(ManualEdge,1)
  exdata(index,1:4)={key,index,ManualEdge(index,1),ManualEdge(index,2)};      
end
mxDatabase(Database.Name,'BULKIN manualEdge',exdata);
