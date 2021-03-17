function LittleRotation(RequestedAction)
%Lionel HERVE
%11-23-04

global f0 ctrl handle xy Image

if ~exist('RequestedAction')
   RequestedAction='BeginLine'; 
end

switch RequestedAction
   case 'BeginLine'
        xy=[];
        figure(f0.handle);
        axes(f0.axisHandle);
        Message('Drag a line to define the horizontal');
        handle.line=plot([0 0],[0 0]);
        k = waitforbuttonpress;
        point1 = get(f0.axisHandle,'CurrentPoint'); xy(1,:)=point1(1,1:2);xy(2,:)=point1(1,1:2);
        handle.line=plot(xy(:,1),xy(:,2),'EraseMode','xor','linewidth',3,'color','blue');
        set(f0.handle,'WindowButtonUpFcn','LittleRotation(''EndLine'');');
        set(f0.handle,'WindowButtonMotionFcn','LittleRotation(''MoveLine'')');
    case 'EndLine'
        flag.action=0;
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
        set(handle.line,'XData',0,'YData',0);
        [xy(1,1),xy(1,2)]=funcclipping(xy(1,1),xy(1,2),size(Image.image,1),size(Image.image,2)); %correct if the operator ask for point outside the image
        [xy(2,1),xy(2,2)]=funcclipping(xy(2,1),xy(2,2),size(Image.image,1),size(Image.image,2));
        plot(xy(:,1),xy(:,2),'b');
        
        angle=atan((xy(1,2)-xy(2,2))/(xy(1,1)-xy(2,1)))*180/pi;
        Message('Rotating...')
        tempImage=imrotate(Image.OriginalImage,angle);
        
        ReinitImage(tempImage);
        draweverything;
        
        Message('Ok');
        
    case 'MoveLine'
        point1=get(f0.axisHandle,'CurrentPoint');xy(2,:)=point1(1,1:2);set(handle.line,'XData',xy(:,1),'YData',xy(:,2));drawnow; 
end
