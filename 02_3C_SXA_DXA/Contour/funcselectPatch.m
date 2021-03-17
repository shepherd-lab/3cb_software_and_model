%funcSelectPatch
%author lionel HERVE
%Select a patch, deselect the other
%creation date 4-4-03
%5-14-03 transform to a function
function FreeForm=funcselectPatch(FreeForm,selectindex);

FreeForm.FreeFormSelect=selectindex;
plot(FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).face(1,1),FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).face(1,2),'--rs','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5);


