%          File:    ExtractSignal
%
%   Description:    this file extract a line of the image. Result store in
%   signal.   then type save('c:\p43lh1-flatfield','signal','-ascii');
%                   
%   Author: Lionel Herve 3-03
%   Revision History:
% 5-15-03: put ExtractSignal and EndExtractSignalTogether

function ExtractSignal(RequestedAction)
global flag ctrl f0 xy handle Image

switch RequestedAction
    case 'BeginLine'
        xy=[];
        figure(f0.handle);
        axes(f0.axisHandle);
        set(ctrl.text_zone,'String','Drag a line to extract');
        handle.line=plot([0 0],[0 0]);
        
        k = waitforbuttonpress;
    
        point1 = get(f0.axisHandle,'CurrentPoint'); xy(1,:)=point1(1,1:2);xy(2,:)=point1(1,1:2);
        handle.line=plot(xy(:,1),xy(:,2),'EraseMode','xor','linewidth',3,'color','blue');
        set(f0.handle,'WindowButtonUpFcn','ExtractSignal(''EndLine'');');
        set(f0.handle,'WindowButtonMotionFcn','ExtractSignal(''MoveLine'')');
    case 'EndLine'
        flag.action=0;
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
        set(handle.line,'XData',0,'YData',0);
        [xy(1,1),xy(1,2)]=funcclipping(xy(1,1),xy(1,2),size(Image.image,1),size(Image.image,2)); %correct if the operator ask for point outside the image
        [xy(2,1),xy(2,2)]=funcclipping(xy(2,1),xy(2,2),size(Image.image,1),size(Image.image,2));
        plot(xy(:,1),xy(:,2),'b');
    
        signal=improfile(Image.image,xy(:,1),xy(:,2));
        if flag.ShowMaterial
            signal=signal;%-50;
        end
%         signal_sm = smooth(signal, 71);
        signal_smooth = signal;
        ss = size(signal_smooth);
        s = size(signal);
        %signal(:,2) = signal_smooth;
        figure; plot(signal_smooth); % plot(signal_smooth);
        signal=signal'; %for external use
        set(ctrl.text_zone,'String','Ok');
    case 'MoveLine'
        point1=get(f0.axisHandle,'CurrentPoint');xy(2,:)=point1(1,1:2);set(handle.line,'XData',xy(:,1),'YData',xy(:,2));drawnow;
end

