%funcErasefreeform
%author lionel HERVE
%Called when the left button is Erase all free forms is pushed
%action clear all the free forms
%date of creation: 4-7-2003
%revision 5-13-03: transformation into a function

function funcErasefreeforms
global FreeForm;

for index=1:FreeForm.FreeFormnumber
    FreeForm.FreeFormCluster(index).face=[];
    if FreeForm.FreeFormCluster(index).valid
        try
            delete(FreeForm.FreeFormCluster(index).patch);
        catch
        end
    end
end
FreeForm.FreeFormnumber=0;


