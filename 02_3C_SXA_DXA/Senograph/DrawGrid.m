%DrawGrid
%Lionel HERVE
%7-20-04

function CalibrationData=DrawGrid(ImLE,ImHE,RequestedAction)

global Gridhandler f0 OriginX OriginY

CalibrationData=[];
DeltaX=40;
SizeX=60;
DeltaY=50;
SizeY=160;

if ~exist('RequestedAction')
    RequestedAction='';
end

switch RequestedAction
    case ''
        for i=1:15
            Gridhandler(i)=funcbox(0,0,0,0,'b');
        end
        OriginX=1400;
        OriginY=800;
        DrawGrid(ImLE,ImHE,'DRAWGRID');
        set(gcf,'WindowButtonMotionFcn','global ImLE ImHE;DrawGrid(ImLE,ImHE,''MOTION'');');
        waitforbuttonpress;
        set(f0.handle,'WindowButtonMotionFcn','');
        CalibrationData=DrawGrid(ImLE,ImHE,'COMPUTATION');
        
    case 'MOTION'        
        RequestedAction='';
        CurrentPoint=get(gca,'CurrentPoint');
        OriginX=CurrentPoint(1,1);
        OriginY=CurrentPoint(1,2);
        DrawGrid(ImLE,ImHE,'DRAWGRID');
        drawnow;
                
        
    case 'DRAWGRID'
        RequestedAction='';
        for index1=1:5
            for index2=1:3
                X1=OriginX+(index1-1)*(SizeX+DeltaX);
                X2=X1+SizeX;
                Y1=OriginY+(index2-1)*(SizeY+DeltaY);
                Y2=Y1+SizeY;
                Gridhandler((index2-1)*5+index1)=funcbox(X1,Y1,X2,Y2,'r',1,Gridhandler((index2-1)*5+index1));
            end
        end

    case 'COMPUTATION'        
        RequestedAction='';
        CalibrationData=[];
        for index1=1:5
            for index2=1:3
                X1=round(OriginX+(index1-1)*(SizeX+DeltaX));
                X2=round(X1+SizeX);
                Y1=round(OriginY+(index2-1)*(SizeY+DeltaY));
                Y2=round(Y1+SizeY);
                CalibrationData=[CalibrationData; index1*2,(3-index2)*50,mean(mean(ImLE(Y1:Y2,X1:X2))),mean(mean(ImHE(Y1:Y2,X1:X2)))];
            end
        end
end