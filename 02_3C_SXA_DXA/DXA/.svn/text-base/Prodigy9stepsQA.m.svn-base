function Prodigy9stepsQA(RequestedAction)
global dummyuicontrol2 ctrl f0  Analysis Image ROI Prodigy9stepsQAData Result flag%QCAnalysisData

%Analysis.GammaDSP = false; 
%k = 150 / 169;
k = 1;
Prodigy9stepsQAData.Draw.MainBox=[68,172] * k;
Prodigy9stepsQAData.Draw.Compartments=9;
Prodigy9stepsQAData.Draw.BorderY= 5 * k;
Prodigy9stepsQAData.Draw.BorderX=10 * k;
%Prodigy9stepsQAData.Output = zeros{1,19};
Prodigy9stepsQAData.Output =  zeros(3,10)
%Prodigy9stepsQAData.Output = {Result.acqid_str,Result.filenameLE_str,Result.filenameHE_str,...
%                                   Result.date_str, 100.00, 65.19,  28, 2, 10, 20};

Prodigy9stepsQAData.Output = {'a','b','c',...
                                   'd', 100.00, 65.19,  28, 2, 10, 20};
                               
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        Prodigy9stepsQA('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','Prodigy9stepsQA(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
                
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
       
        Prodigy9stepsQA('Hide');
        Prodigy9stepsQA('compute');
        Message('Ok...');
        
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        Prodigy9stepsQAData.x0=CurrentPoint(1,1);Prodigy9stepsQAData.y0=CurrentPoint(1,2);
        Prodigy9stepsQA('Redraw');

    case 'InitDrawing'
        Prodigy9stepsQAData.MainBox=plot(0,0,'g','linewidth',2);
        for index=1:Prodigy9stepsQAData.Draw.Compartments
            Prodigy9stepsQAData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
        x1=Prodigy9stepsQAData.x0;
        x2=Prodigy9stepsQAData.x0+Prodigy9stepsQAData.Draw.MainBox(1);
        y1=Prodigy9stepsQAData.y0;
        y2=Prodigy9stepsQAData.y0+Prodigy9stepsQAData.Draw.MainBox(2);
        set(Prodigy9stepsQAData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        for index=1:Prodigy9stepsQAData.Draw.Compartments
            X1=x1+Prodigy9stepsQAData.Draw.BorderX;
            X2=x2-Prodigy9stepsQAData.Draw.BorderX;
            Y1=y1+(y2-y1)/(Prodigy9stepsQAData.Draw.Compartments)*(index-1)+Prodigy9stepsQAData.Draw.BorderY;
            Y2=y1+(y2-y1)/(Prodigy9stepsQAData.Draw.Compartments)*(index)-Prodigy9stepsQAData.Draw.BorderY;
            set(Prodigy9stepsQAData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
        end
        
    case 'Hide'
        set(Prodigy9stepsQAData.MainBox,'xdata',0,'ydata',0);
        for index=1:Prodigy9stepsQAData.Draw.Compartments
            set(Prodigy9stepsQAData.Box(index),'xdata',0,'ydata',0);
        end
        
    case 'compute'
        set(ctrl.CheckBreast,'value',true);
        x1=Prodigy9stepsQAData.x0;
        x2=Prodigy9stepsQAData.x0+Prodigy9stepsQAData.Draw.MainBox(1);
        y1=Prodigy9stepsQAData.y0;
        y2=Prodigy9stepsQAData.y0+Prodigy9stepsQAData.Draw.MainBox(2);
        mmax = max(max(Image.LE))
        mmin = min(min(Image.LE))
        mmax = max(max(Image.HE))
        mmin = min(min(Image.HE))
        DensityResults={};
        
        if flag.ShowThickness == false
           Prodigy9stepsQAData.Output = {zeros(1,10)};
        end
            
        for index=1:Prodigy9stepsQAData.Draw.Compartments
            ROI.xmin=floor(x1+Prodigy9stepsQAData.Draw.BorderX);
            ROI.xmax=floor(x2-Prodigy9stepsQAData.Draw.BorderX);
            ROI.ymin=floor(y1+(y2-y1)/(Prodigy9stepsQAData.Draw.Compartments)*(index-1)+Prodigy9stepsQAData.Draw.BorderY);
            ROI.ymax=floor(y1+(y2-y1)/(Prodigy9stepsQAData.Draw.Compartments)*(index)-Prodigy9stepsQAData.Draw.BorderY);
            ROI.rows=ROI.ymax-ROI.ymin+1;
            ROI.columns=ROI.xmax-ROI.xmin+1;
            if flag.ShowThickness == true
                 Prodigy9stepsQAData.Output{1,10+index} = mean(mean(Image.material(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
                 Prodigy9stepsQAData.Output{2,index} = mean(mean(Image.LE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
                 Prodigy9stepsQAData.Output{3,index} = mean(mean(Image.HE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
            else
                 Prodigy9stepsQAData.Output{1,index} = mean(mean(Image.LE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
                 Prodigy9stepsQAData.Output{2,index} = mean(mean(Image.HE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
            end
       
        end
        Excel('INIT');
        Excel('TRANSFERT',Prodigy9stepsQAData.Output);
end