% skin detection
%
%       Author Lionel HERVE 9-19-03
%   Rout the code to the good skin detection version
function chestwall(RequestedAction)
global flag ChestwallData Info 

switch RequestedAction
    case 'FROMGUI'
        draweverything;
        Info.CommonAnalysisKey=0;
        Chestwall('ROOT');
    case 'ROOT'
        ChestWallDrawing('ROOT',0);
    case 'FROMDATABASE'
        ChestWallData.DrawingInProgress=2;
        ChestWallDrawing('Redraw',0);
        ChestWallDrawing('EndManualDrawing',0);
end