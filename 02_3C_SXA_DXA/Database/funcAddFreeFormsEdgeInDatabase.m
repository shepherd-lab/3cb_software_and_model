function freeformskey=funcAddFreeFormsEdgeInDatabase(Database,FreeForm);
%author Lionel HERVE
%creation date 5-27-03
%modification for mxDatabase

freeformskey=funcFindNextAvailableKey(Database,'freeforms');
indexFreeForm=1;
for index=1:FreeForm.FreeFormnumber
     if FreeForm.FreeFormCluster(index).valid
         %% to optimize
        for indexpoint=1:size(FreeForm.FreeFormCluster(index).face,1)
          exdata(indexpoint,1:5)={freeformskey,indexFreeForm,indexpoint,FreeForm.FreeFormCluster(index).face(indexpoint,1),FreeForm.FreeFormCluster(index).face(indexpoint,2)};      
        end
        indexFreeForm=indexFreeForm+1;   
        mxDatabase(Database.Name,'BULKIN freeforms',exdata);
        clear exdata;
    end
end
if FreeForm.FreeFormnumber==0
    mxDatabase(Database.Name,'insert into freeforms values(''',num2str(freeformskey),''',''0'',''0'',''0'',''0'')');
end



