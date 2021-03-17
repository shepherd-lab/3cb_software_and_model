% skin detection
%   
%       Author Lionel HERVE 9-19-03
%   Rout the code to the good skin detection version
function skindetection(RequestedAction)
global flag ManualEdge Analysis

switch RequestedAction
    case 'FROMGUI'
        Analysis.Step=1.5;
        draweverything;
        Info.CommonAnalysisKey=0;
        ManualEdge.Method=2;
        SkinDetection('ROOT');
    case 'ROOT'
        if ManualEdge.Method==1
            SkinDetectionv1('EndManualDrawing');   %legacy of former versions
        else
            SkinDetectionv2('SkinDetection',0);
        end
    case 'FROMDATABASE'
        if ManualEdge.Method==1        
            if strcmp(flag.EdgeMode,'manual') 
                SkinDetectionv1('EndManualDrawing');   %legacy of former versions
            else
                SkinDetectionv1('SkinDetection');   %legacy of former versions
            end
        else
             if strcmp(flag.EdgeMode,'manual') 
                 ManualEdge.DrawingInProgress=2;
                 SkinDetectionv2('Redraw',0);
                 SkinDetectionv2('EndManualDrawing',0);
             else
                 SkinDetectionv2('SkinDetection',0);                 
             end
         end
end