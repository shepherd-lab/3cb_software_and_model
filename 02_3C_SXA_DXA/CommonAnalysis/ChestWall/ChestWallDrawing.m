% Breast Wall drawing
% Lionel HERVE
% 11-8-04

function ChestwallDrawing(RequestedAction,select)
global f0 ChestWallData Image ctrl Info ROI xy

switch RequestedAction
    case 'ROOT'
        ChestWallData.Valid=0;
        set(f0.handle,'WindowButtonDownFcn','');
        ChestWallDrawing('DeactivateFigureReaction',0);
        DeactivateContour;
        FreezeButtons(ctrl,f0,Info);
        figure(f0.handle);
        axes(f0.axisHandle);
        ChestWallData.DrawingInProgress=1;
        ChestWallData.NumberPoints=0;
        ChestWallData.Points=[];

        % Initially, the list of points is empty.

        Message('Press LEFT button to ADD a new point and RIGHT button to FINISH');
        ok=true;
        hold on;

        while ok
            k = waitforbuttonpress;
            point1 = get(f0.axisHandle,'CurrentPoint');
            if ~strcmp(get(f0.handle,'SelectionType'),'alt')
                if (flipdim(point1(1,1:2),2)<size(Image.image))&(point1(1,1:2)>0)
                    ChestWallData.NumberPoints=ChestWallData.NumberPoints+1;
                    ChestWallData.Points(ChestWallData.NumberPoints,:)=point1(1,1:2);
                    ChestWallData.handle(ChestWallData.NumberPoints)=plot(point1(1,1),point1(1,2),'EraseMode','xor','linestyle','none','marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','markersize',10);
                end
            else
                ChestWallData.DrawingInProgress=2;
                ok=false;
                Message('Drag the point and press RIGHT when finished');
                ChestWallDrawing('SetBehavior',0);
                ChestWallDrawing('DrawInterpolation',0);
            end
        end
    case 'Redraw'  
        DeactivateContour;
        ChestWallData.NumberPoints=size(ChestWallData.Points,1);   %redefine ManualEdge.NumberPoints since it could be reach from a database call
        for index=1:ChestWallData.NumberPoints
            ChestWallData.handle(index)=plot(ChestWallData.Points(index,1),ChestWallData.Points(index,2),'EraseMode','xor','linestyle','none','marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','markersize',10);
        end
        if ChestWallData.DrawingInProgress==2      %when the points can be moved
            ChestWallDrawing('SetBehavior',0);      %set some behavior
            ChestWallDrawing('DrawInterpolation',0);
        end
    case 'SetBehavior' 
        set(f0.handle,'WindowButtonDownFcn','ChestWallDrawing(''ButtonDownSkinModif'',0)');
        for index=1:ChestWallData.NumberPoints
            set(ChestWallData.handle(index),'ButtonDownFcn',['ChestWallDrawing(''SetIndividualBehavior'',',num2str(index),')']);
        end
        ChestWallData.Handle=plot([0],[0],'erasemode','xor','HitTest','off');
    case 'ButtonDownSkinModif'  %set the right button to end the drawing
        if strcmp(get(f0.handle,'SelectionType'),'alt')
            ChestWallDrawing('DeactivateFigureReaction',0);
            ChestWallDrawing('EndManualDrawing',0);
        end
    case 'DrawInterpolation' 
        %compel first and last point to be on the edge of the ROI
        set(ChestWallData.handle(1),'xdata',ROI.xmin);ChestWallData.Points(1,1)=ROI.xmin;
        set(ChestWallData.handle(ChestWallData.NumberPoints),'xdata',ROI.xmin);ChestWallData.Points(ChestWallData.NumberPoints,1)=ROI.xmin;
        ChestWallData.Curve=funcComputeInterpolationCurve(ChestWallData);
        set(ChestWallData.Handle,'xdata',ChestWallData.Curve(:,1),'ydata',ChestWallData.Curve(:,2))
    case 'SetIndividualBehavior' %2
        set(f0.handle,'WindowButtonUpFcn','ChestWallDrawing(''DeactivateFigureReaction'',0)');
        set(f0.handle,'WindowButtonMotionFcn',['ChestWallDrawing(''SetIndividualMoveBehavior'',',num2str(select),')']);
    case 'SetIndividualMoveBehavior'
        point1 = get(f0.axisHandle,'CurrentPoint');
        ChestWallData.Points(select,:)=point1(1,1:2);
        set(ChestWallData.handle(select),'xdata',point1(1,1),'ydata',point1(1,2));
        ChestWallDrawing('DrawInterpolation',0);
    case 'DeactivateFigureReaction'  %4
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
    case 'MODIF'
        ChestWallData.Valid=0;
        freezebuttons(ctrl,f0,Info);
        draweverything;
        %Go in the manual Skin Detection;
        ChestWallData.DrawingInProgress=2;
        ChestWallDrawing('Redraw');
        
    case  'EndManualDrawing'  %1
        ChestWallData.DrawingInProgress=0;
        set(f0.handle,'WindowButtonDownFcn','');          
        ChestWallData.Points=round(ChestWallData.Points);
        ChestWallData.Curve=funcComputeInterpolationCurve(ChestWallData);
        ChestWallData.Curve=[round(ChestWallData.Curve(:,1)-ROI.xmin+1) round(ChestWallData.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
        ChestWallData.Curve(1,1)=1;   %put the first and the last point to the edge of the ROI region
        ChestWallData.Curve(size(ChestWallData.Curve,1),1)=1;
        [ChestWallData.Curve(:,1),ChestWallData.Curve(:,2)]=funcclipping(ChestWallData.Curve(:,1),ChestWallData.Curve(:,2),ROI.rows,ROI.columns);       %clip to the ROI
        
        ChestWallData.pixels=polyarea(ChestWallData.Curve(:,1),ChestWallData.Curve(:,2));
        ChestWallData.Valid=1;
        draweverything;
        funcActivateDeactivateButton;
        Message('Ok');
end