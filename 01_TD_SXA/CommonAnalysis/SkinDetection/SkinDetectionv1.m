% skin detection
% 
% version 2g
% find a first rough skin detection with a min max metod
% then find a fitted ellise
%       merit function = distance to the outline curve
%       don't try to calculate analytic derivative = more changeable
% apply snake algorithm on this
%
%       Author Lionel HERVE 2/03
% 
%  revision history
%       19-2-03 don't try to calculate analytic derivative = more changeable
%       10-15-03 send the ROI.backGround as parameter of funcfindOutline

function skindetectionv1(RequestedAction)

warning off MATLAB:divideByZero
global Analysis flag ctrl Outline ROI SkinEdge f0 ManualEdge PreciseOutline

Analysis.Step=3;    

switch RequestedAction
    case 'SkinDetection'  %0
        if get(ctrl.CheckAutoSkin,'value')
            %find outline 
            [Outline.x,Outline.y]=funcfindOutline(1-ROI.BackGround);
            [PreciseOutline,Analysis.Surface,Analysis.midcurve_p,Analysis.midpoint]=funcFindStuffOnOutline(Outline);
            DrawEverything;
            FuncActivateDeactivateButton;    
            flag.EdgeMode='Auto';
        else
            figure(f0.handle);
            axes(f0.axisHandle);
            hold on
            % Initially, the list of points is empty.
            
            ManualEdge.NumberPoints = 1;
            ManualEdge.Points=[];
            set(ctrl.text_zone,'String','Press left button to begin the drawing, release to end');
            waitforbuttonpress;
        
            point1 = get(f0.axisHandle,'CurrentPoint'); ManualEdge.Points(ManualEdge.NumberPoints,:)=point1(1,1:2);
            SkinEdge.handle=plot(ManualEdge.Points(:,1),ManualEdge.Points(:,2),'EraseMode','xor','linewidth',3,'color','blue');
            set(f0.handle,'WindowButtonUpFcn','SkinDetectionV1(''EndManualDrawing'')');
            set(f0.handle,'WindowButtonMotionFcn','skindetectionv1(''AddPointInDrawing'')');
        end
    case  'EndManualDrawing'  %1   %end of the manual drawing
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
        SkinEdge.handle=plot([0],[0]); 
        ManualEdge.Points=round(ManualEdge.Points);
        [C,I]=max(ManualEdge.Points(:,1));
        xy=[];
        xy(:,1)=ManualEdge.Points(:,1)-ROI.xmin; %convert from image to ROI
        xy(:,2)=ManualEdge.Points(:,2)-ROI.ymin;
        xy(1,1)=1;   %put the first and the last point to the edge of the ROI region
        xy(size(ManualEdge.Points,1),1)=1;
        for index=1:size(xy,1)
            [xy(index,1),xy(index,2)]=funcclipping(xy(index,1),xy(index,2),ROI.rows,ROI.columns);
        end
        %modify the curve in order there just remain 2 point per abscisse
        Outline1=funcSemiEdgeComputation(xy);  %find the first part of the curve (increasing x)
        xy=flipdim(xy,1);
        Outline2=flipdim(funcSemiEdgeComputation(xy),1); %find the second part of the curve (decreasing x)
        I=size(Outline1,1);
        Outline.x=[Outline1(:,1)' Outline2(1,1)+1 Outline2(:,1)'];
        Outline.y=[Outline1(:,2)' round((Outline1(I,2)+Outline2(1,2))/2)+1  Outline2(:,2)'];
        [PreciseOutline,Analysis.Surface,Analysis.midcurve_p,Analysis.midpoint]=funcFindStuffOnOutline(Outline);
        DrawEverything;  
        FuncActivateDeactivateButton;    

    
        flag.EdgeMode='Manual';
    case 'AddPointInDrawing'
        ManualEdge.NumberPoints=ManualEdge.NumberPoints+1;
        point1=get(f0.axisHandle,'CurrentPoint');
        ManualEdge.Points(ManualEdge.NumberPoints,:)=point1(1,1:2);
        set(SkinEdge.handle,'XData',ManualEdge.Points(:,1),'YData',ManualEdge.Points(:,2));
        drawnow
end
set(ctrl.text_zone,'String','ok...');

