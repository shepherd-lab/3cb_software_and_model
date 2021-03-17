%DeactivateContour
%Lionel HERVE
%9-19-03

function deactivatecontour
global FreeForm

%deactivate the contours
    for index=1:FreeForm.FreeFormnumber
        if FreeForm.FreeFormCluster(index).valid
            set(FreeForm.FreeFormCluster(index).patch,'ButtonDownFcn','');
        end;
    end