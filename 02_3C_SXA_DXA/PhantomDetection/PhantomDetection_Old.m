% Phantom Manual

% draw two box (one for 100%fat, one for 100%lean)
% 
% Lionel HERVE 2/03
% modification
% 10-29-03 automatic detection 
function phantomdetection
global f0 ctrl Analysis Info figuretodraw Image Phantom ReportText Error  PhantomDetectionFailure
figure(f0.handle);   
Analysis.DensityPercentageAngle = [];
Phantom=[];

try
    if ~get(ctrl.CheckManualPhantom,'value')
        set(ctrl.text_zone,'String','Drag a box on fat area');
        % example from MATLAB Functions: rbbox
        waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1_fat = round(min(point1,point2));             % calculate locations
        offset_fat = round(abs(point1-point2));         % and dimensions
        Analysis.coordXFatcenter =   p1_fat + offset_fat/2
        Analysis.PhantomFatx = [p1_fat(1) p1_fat(1)+offset_fat(1)];
        Analysis.PhantomFaty = [p1_fat(2) p1_fat(2)+offset_fat(2)];
       
        funcBox(Analysis.PhantomFatx(1),Analysis.PhantomFaty(1),Analysis.PhantomFatx(2),Analysis.PhantomFaty(2),'blue');
        
        set(ctrl.text_zone,'String','Drag a box on lean area');
        % example from MATLAB Functions: rbbox
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1_lean = round(min(point1,point2));             % calculate locations
        offset_lean = round(abs(point1-point2));         % and dimensions
        
        Analysis.PhantomLeanx = [p1_lean(1) p1_lean(1)+offset_lean(1)];
        Analysis.PhantomLeany = [p1_lean(2) p1_lean(2)+offset_lean(2)];
        funcbox(Analysis.PhantomLeanx(1),Analysis.PhantomLeany(1),Analysis.PhantomLeanx(2),Analysis.PhantomLeany(2),'blue'); 
        
        %temporary
         Analysis.PhantomD1= 40;
        Analysis.PhantomD2=40;
         Analysis.PhantomPosition=800;
       %{
        set(ctrl.text_zone,'String','click on the FIRST phantom hozizontal lead wires');
      
        set(ctrl.text_zone,'String','click on the SECOND phantom hozizontal lead wires');        
        y2=UserDrawLine('ROOT','horizontal');        
        set(ctrl.text_zone,'String','click on the FIRST phantom vertical lead wires of the fat area');        
        x1=UserDrawLine('ROOT','vertical');
        set(ctrl.text_zone,'String','click on the SECOND phantom vertical lead wires of the fat area');                
        x2=UserDrawLine('ROOT','vertical');        
        Analysis.PhantomD1=round(abs(y1-y2));
        Analysis.PhantomD2=round(abs(x1-x2));
        Analysis.PhantomPosition=min(x1,x2);
        %}
       % set(ctrl.text_zone,'String','click on the LEFT and RIGHT of  UPPER hozizontal lead wire');
       % hf = get(gcf)
      %  set(f0.axisHandle,'Linewidth', 1); 
      % af = get(f0.axisHandle, 'Linewidth') 
      % set(f0.UCSFhandle,'Linewidth', 1); 
      % af1 = get(f0.UCSFhandle, 'Linewidth')
       %axes(f0.UCSFhandle);
       %y1=UserDrawLine('ROOT','horizontal');
       %localScopeDirection=direction;
       MyLine=plot(0,0,'b','erasemode','xor');
       position=200;
       %set(MyLine,'xdata',[0,size(Image.image,2)],'ydata',[position position]);
       set(MyLine,'xdata',[0,1],'ydata',[1 1]);
       % MyLine=plot(0,0,'b','erasemode','xor');
      % set(MyLine,'xdata',[0,0],'ydata',[0 0]);
        [xup,yup] = ginput(2);
        plot(xup,yup,'Linewidth',1,'color','b');
         [xlow,ylow] = ginput(2);
        plot(xlow,ylow,'Linewidth',1,'color','r');
        talfa1 = (yup(2) - yup(1)) / (xup(2) - xup(1));
        talfa2 = (ylow(2) - ylow(1)) / (xlow(2) - xlow(1));
        Phantom.AngleHoriz = atan(talfa2 - talfa1) * 360 / 6.28
    else
        borderX=20;sizeY=30;
        borderY=15;borderYTop=10;
        try   %in the case the mammography machine is lorad and the film is big, prevent the topest pixels which are crappy 
            Info.BRAND=GetBRAND(Info);
            Info.ROOM=GetROOM(Info);
            if (Info.BRAND==2)&&(Error.BIGPADDLE)&&(Info.ROOM~=3)
                borderYTop=70;
            else
                borderYTop=10;
            end
        catch
            borderYTop=10;
        end
        Phantom=funcPhantomDetection2(Image,Analysis,f0.handle);
        miny=Phantom.Top+borderYTop;
        
        pause(0.01);  %to show the line
        %compute the boxes from the computation of the phantom lines
        Analysis.PhantomPosition=Phantom.Position;
        Analysis.PhantomD1=round(Phantom.Distance1);
        Analysis.PhantomD2=round(Phantom.Distance2);
        Analysis.PhantomDistanceFatRef = round(Phantom.Distance3);
        if Info.DigitizerId == 3
            Analysis.Filmresolution  = 0.15;
        else
            Analysis.Filmresolution = 0.169;
        end
            
        Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomDistanceFatRef * Analysis.Filmresolution + 33.5
        
        Analysis.PhantomFatx=[Phantom.Point1(1)+borderX,min(Phantom.Point5(1)-borderX,size(Image.image,2)-50)];
        Analysis.PhantomLeanx=sort([min(size(Image.image,2),Phantom.Point7(1)+borderX),min(Phantom.Point2(1)-borderX,size(Image.image,2)-50)]);
        
        BottomFat=min(Phantom.Point1(2),Phantom.Point5(2))-borderY;
        BottomLean=min(Phantom.Point2(2),Phantom.Point7(2))-borderY;
        %FAT WEDGE
        y1=max(miny,BottomFat-sizeY);y2=BottomFat;
        if y1>y2 % this is a bad case when the phantom wedges are very close to the border. take some precaution (little selection)
            Analysis.PhantomFaty=[BottomFat-1,BottomFat+1];
        else
            Analysis.PhantomFaty=[y1,y2];
        end
        %LEAN WEDGE
        y1=max(miny,BottomLean-sizeY);y2=BottomLean;
        if y1>y2 % this is a bad case when the phantom wedges are very close to the border. take some precaution (little selection)
            Analysis.PhantomLeany=[BottomLean-1,BottomLean+1];
        else
            Analysis.PhantomLeany=[y1,y2];
        end
        funcBox(Analysis.PhantomFatx(1),Analysis.PhantomFaty(1),Analysis.PhantomFatx(2),Analysis.PhantomFaty(2),'blue');    
    end
    Analysis.coordXFatcenter =  mean(Analysis.PhantomFatx)
    meanFat=mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
    meanLean=mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));
    if meanLean<meanFat %invert lean and fat if fat>lean
        set(ctrl.text_zone,'String','I invert Lean and Fat'); pause(1);
        tempX=Analysis.PhantomLeanx;
        tempY=Analysis.PhantomLeany;
        Analysis.PhantomLeanx=Analysis.PhantomFatx;
        Analysis.PhantomLeany=Analysis.PhantomFaty;
        Analysis.PhantomFatx=tempX;
        Analysis.PhantomFaty=tempY;    
    end
    
    Info.PhantomComputed=true;
    set(ctrl.text_zone,'String','Now, you can compute the breast density');        
  %  draweverything;
    FuncActivateDeactivateButton;
    
%% Error/warning management    
    
    sizeFat=(Analysis.PhantomFaty(2)-Analysis.PhantomFaty(1)+1)*(Analysis.PhantomFatx(2)-Analysis.PhantomFatx(1)+1);
    if sizeFat<1000
        ReportText=[ReportText, 'Phantom Fat small@'];
    end
    
    sizeLean=(Analysis.PhantomLeany(2)-Analysis.PhantomLeany(1)+1)*(Analysis.PhantomLeanx(2)-Analysis.PhantomLeanx(1)+1);
    if sizeLean<1000
        ReportText=[ReportText, 'Phantom lean small@'];
    end
     Error.PhantomDetection=false;
    
catch
    ReportText=[ReportText,'Phantom detection Failure@'];
    PhantomDetectionFailure = 1;
    Analysis.SXAanalysisStatus = 3;
    Error.PhantomDetection=true;
    set(ctrl.text_zone,'String','Phantom detection failed');        
end
