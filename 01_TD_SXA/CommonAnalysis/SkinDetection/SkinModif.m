%modif skin edge detection
%Lionel HERVE 
%creation date 10-2-03
%called when the button Modif of the GUI is pressed
%compute the control points of the skin edge

function skinmodif
global flag ManualEdge ROI Analysis Info ctrl f0 Outline;

Freezebuttons(ctrl,f0,Info);

if strcmp(flag.EdgeMode,'Auto')
    flag.EdgeMode='Manual';
    anglelist=round((atan((Outline.y-Analysis.midpoint)./Outline.x)*2/pi+1)*10+1);
    
    %parameter = angle
    ManualEdge.Points=[];
   
    ManualEdge.Points(anglelist,1)=ROI.xmin+Outline.x;ManualEdge.Points(1,1)=ROI.xmin+Outline.x(1);
    ManualEdge.Points(anglelist,2)=ROI.ymin+Outline.y;ManualEdge.Points(1,2)=ROI.ymin+Outline.y(1);
    ManualEdge.NumberPoints=size(anglelist,2);
    
    for index=2:size(ManualEdge.Points,1)  %correct if their exist some holes
        if ManualEdge.Points(index,1)==0
            ManualEdge.Points(index,1)=ManualEdge.Points(index-1,1);
            ManualEdge.Points(index,2)=ManualEdge.Points(index-1,2);
        end
    end
end
%Go in the manual Skin Detection;
ManualEdge.DrawingInProgress=2;
skindetectionv2('Redraw');

%clear index;clear anglelist;