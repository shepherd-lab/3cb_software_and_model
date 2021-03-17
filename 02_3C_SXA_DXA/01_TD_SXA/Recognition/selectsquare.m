function [x,y]=selectsquare(argx,argy,RequestedAction)
global dummyuicontrol2 localdx localdy TAG CurrentX CurrentY CurrentMask

switch RequestedAction
    case 'ROOT'
        set(gcf,'doublebuffer','on','renderer','zbuffer');   
        CurrentX=1;
        CurrentY=1;
        localdx=argx;
        localdy=argy;
        set(gcf,'WindowButtonMotionFcn','selectsquare(0,0,''MOVE'')');
        set(gcf,'WindowButtonDownFcn','selectsquare(0,0,''END'')');
        selectsquare(0,0,'HIGHLIGHT');
        
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);

        x=CurrentX;
        y=CurrentY;
        
    case 'MOVE'        
        selectsquare(0,0,'DEHIGHLIGHT');
        selectsquare(0,0,'READPOSITION');
        selectsquare(0,0,'HIGHLIGHT');
        selectsquare(0,0,'COMPUTECORRELATION');
    case 'DEHIGHLIGHT'
        TAG(CurrentY:CurrentY+localdy,CurrentX:CurrentX+localdx)=TAG(CurrentY:CurrentY+localdy,CurrentX:CurrentX+localdx)-CurrentMask;
    case 'HIGHLIGHT'
        TAG(CurrentY:CurrentY+localdy,CurrentX:CurrentX+localdx)=TAG(CurrentY:CurrentY+localdy,CurrentX:CurrentX+localdx)+CurrentMask;
        imagesc(TAG);
    case 'READPOSITION'
        point1 = round(get(gca,'CurrentPoint'));        
        if (point1(1,1)>0)&&(point1(1,1)+localdx<size(TAG,2))&&(point1(1,2)>0)&&(point1(1,2)+localdy<size(TAG,1))
            CurrentX=point1(1,1);CurrentY=point1(1,2);
        end
    case 'END'
        set(gcf,'WindowButtonMotionFcn','');
        set(gcf,'WindowButtonDownFcn','');
        set(dummyuicontrol2,'value',true);
end
