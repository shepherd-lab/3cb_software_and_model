%FuncDeleteFreeForm
%delete the highlighted freeform
%creation date 4-7-2003
%author Lionel HERVE
%revision history

function FreeForm=FuncDeleteFreeForm(FreeForm);
if (FreeForm.FreeFormSelect>0)
        delete(FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).patch);
        FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).valid=false;
end
