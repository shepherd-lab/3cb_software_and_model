% DXAroi
%author Lionel HERVE
%  date 8-22-03; draw an ellipse from the 4 user selected points

DXA.linewidth=2;

if flag.action==0
    draweverything;    
    figure(f0.handle);
    axes(f0.axisHandle);
    handle.ellipse=rectangle('position',[0 0 1 1],'Curvature',[1,1],'EraseMode','xor','linewidth',DXA.linewidth);
    
    set(ctrl.text_zone,'String','click left side');
    k = waitforbuttonpress;
    point1 = get(f0.axisHandle,'CurrentPoint'); DXA.xy(1,:)=point1(1,1:2);
    DXA.p(1)=plot([DXA.xy(1,1)],[DXA.xy(1,2)],'marker','x','MarkerSize',10,'EraseMode','xor');    
    
    set(ctrl.text_zone,'String','click right side');
    k = waitforbuttonpress;
    point1 = get(f0.axisHandle,'CurrentPoint'); DXA.xy(2,:)=point1(1,1:2);
    handle.line=plot([DXA.xy(1,1) DXA.xy(2,1)],[DXA.xy(1,2),DXA.xy(2,2)],'EraseMode','xor','linewidth',DXA.linewidth);    
    DXA.p(2)=plot([DXA.xy(2,1)],[DXA.xy(2,2)],'marker','x','MarkerSize',10,'EraseMode','xor');
    DXA.p(1)=plot([DXA.xy(1,1)],[DXA.xy(1,2)],'marker','x','MarkerSize',10,'EraseMode','xor');    
    DXA.p(1)=plot([DXA.xy(1,1)],[DXA.xy(1,2)],'marker','x','MarkerSize',10,'EraseMode','xor');        
    
    DXA.middle(1)=(DXA.xy(1,1)+DXA.xy(2,1))/2;
    
    DXA.xy(3,:)=[DXA.middle(1) 1];
    DXA.xy(4,:)=[DXA.middle(1) size(Image.LE,1)];
    handle.line2=plot([DXA.xy(3,1),DXA.xy(4,1)],[DXA.xy(3,2),DXA.xy(4,2)],'EraseMode','xor','linewidth',DXA.linewidth);
    
    set(ctrl.text_zone,'String','click upper side');
    k = waitforbuttonpress;
    point1 = get(f0.axisHandle,'CurrentPoint'); DXA.xy(3,:)=point1(1,1:2);
    DXA.p(3)=plot([DXA.middle(1)],[DXA.xy(3,2)],'marker','x','MarkerSize',10,'EraseMode','xor');
    set(handle.line2,'xdata',[DXA.middle(1),DXA.middle(1)],'ydata',[DXA.xy(3,2),DXA.xy(4,2)]);

    set(ctrl.text_zone,'String','click bottom side');
    k = waitforbuttonpress;
    point1 = get(f0.axisHandle,'CurrentPoint'); DXA.xy(4,:)=point1(1,1:2);
    DXA.p(4)=plot([DXA.middle(1)],[DXA.xy(4,2)],'marker','x','MarkerSize',10,'EraseMode','xor');
    
    set(handle.line2,'xdata',[DXA.middle(1),DXA.middle(1)],'ydata',[DXA.xy(3,2),DXA.xy(4,2)]);
    
    set(DXA.p(1),'ButtonDownFcn','flag.action=3;selectedpoint=1;DXAroi;')
    set(DXA.p(2),'ButtonDownFcn','flag.action=3;selectedpoint=2;DXAroi;')
    set(DXA.p(3),'ButtonDownFcn','flag.action=3;selectedpoint=3;DXAroi;')
    set(DXA.p(4),'ButtonDownFcn','flag.action=3;selectedpoint=4;DXAroi;')    
    flag.action=2;DXAroi; 
    
    clear point1;clear k;
elseif flag.action==1
    flag.action=0;
    set(f0.handle,'WindowButtonUpFcn','');
    set(f0.handle,'WindowButtonMotionFcn','');
    set(ctrl.text_zone,'String','Ok');
    clear point1;clear point2;
elseif flag.action==2 %draw the ellipse
    flag.action=0;    
    DXA.r=[DXA.xy(2,1)-DXA.xy(1,1),DXA.xy(4,2)-DXA.xy(3,2)];
    DXA.middle=[(DXA.xy(2,1)+DXA.xy(1,1))/2,(DXA.xy(4,2)+DXA.xy(3,2))/2];
    set(handle.ellipse,'position',[DXA.middle(1)-DXA.r(1)/4,DXA.middle(2)-DXA.r(2)/4,DXA.r(1)/2,DXA.r(2)/2]);
    set(DXA.p(1),'xdata',[DXA.xy(1,1)],'ydata',[DXA.xy(1,2)]);    
    set(DXA.p(2),'xdata',[DXA.xy(2,1)],'ydata',[DXA.xy(2,2)]);    
    set(DXA.p(3),'xdata',[DXA.middle(1)],'ydata',[DXA.xy(3,2)]);    
    set(DXA.p(4),'xdata',[DXA.middle(1)],'ydata',[DXA.xy(4,2)]);   
    set(handle.line2,'xdata',[DXA.middle(1),DXA.middle(1)],'ydata',[DXA.xy(3,2),DXA.xy(4,2)]);    
    set(handle.line,'xdata',[DXA.xy(1,1) DXA.xy(2,1)],'ydata',[DXA.xy(1,2),DXA.xy(2,2)]);    
elseif flag.action==3 %set move mode
    flag.action=0;        
    set(f0.handle,'WindowButtonUpFcn','flag.action=1;DXAroi;');
    set(f0.handle,'WindowButtonMotionFcn','point1=get(f0.axisHandle,''CurrentPoint'');DXA.xy(selectedpoint,:)=point1(1,1:2);flag.action=2;DXAroi');
end