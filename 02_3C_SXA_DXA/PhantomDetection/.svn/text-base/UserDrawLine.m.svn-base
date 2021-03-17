%Lionel HERVE
%4-28-04
%ask the user to draw line.
%return the position

function position=UserDrawLine(RequestedAction,direction)
global f0 Image position MyLine localScopeDirection
switch RequestedAction
    case 'ROOT'
        localScopeDirection=direction;
        MyLine=plot(0,0,'b','erasemode','xor');
        position=200;
        DrawLine(direction,position);
        set(f0.handle,'WindowButtonMotionFcn','UserDrawLine(''MOTION'',''nothing'');');
        waitforbuttonpress;
        UserDrawLine('END','nothing');
    case 'MOTION'        
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        if strcmp(localScopeDirection,'horizontal')
            position=CurrentPoint(1,2);
            if position<1
                position=1;
            end
            if position>size(Image.image,1)
                position=size(Image.image,1);
            end
        else 
            position=CurrentPoint(1,1);
            if position<1
                position=1;
            end
            if position>size(Image.image,2)
                position=size(Image.image,2)
            end
        end
        DrawLine(localScopeDirection,position);
    case 'END'                
         set(f0.handle,'WindowButtonMotionFcn','');
end

function DrawLine(direction,position)
global Image MyLine
if strcmp(direction,'horizontal')
    set(MyLine,'xdata',[0,size(Image.image,2)],'ydata',[position position]);
else 
    set(MyLine,'ydata',[0,size(Image.image,1)],'xdata',[position position]);
end
