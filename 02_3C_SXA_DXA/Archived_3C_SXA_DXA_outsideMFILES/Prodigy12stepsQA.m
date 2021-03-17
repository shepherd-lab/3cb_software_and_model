function Prodigy12stepsQA(RequestedAction)
global dummyuicontrol2 ctrl f0  Analysis Image ROI Prodigy12stepsQAData Result%QCAnalysisData

%Analysis.GammaDSP = false; 
%k = 150 / 169;
k = 1;
Prodigy12stepsQAData.Draw.MainBox=[68,172] * k;
Prodigy12stepsQAData.Draw.Compartments=12;
Prodigy12stepsQAData.Draw.BorderY= 5 * k;
Prodigy12stepsQAData.Draw.BorderX=11 * k;
%Prodigy12stepsQAData.Output = zeros{1,19};
Prodigy12stepsQAData.Output =  zeros(3,10)
%Prodigy12stepsQAData.Output = {Result.acqid_str,Result.filenameLE_str,Result.filenameHE_str,...
%                                   Result.date_str, 100.00, 65.19,  28, 2, 10, 20};

Prodigy12stepsQAData.Output = {'a','b','c',...
                                   'd', 100.00, 65.19,  28, 2, 10, 20};
                               
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        Prodigy12stepsQA('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','Prodigy12stepsQA(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
                
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
       
        Prodigy12stepsQA('Hide');
        Prodigy12stepsQA('compute');
        Message('Ok...');
        
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        Prodigy12stepsQAData.x0=CurrentPoint(1,1);Prodigy12stepsQAData.y0=CurrentPoint(1,2);
        Prodigy12stepsQA('Redraw');

    case 'InitDrawing'
        Prodigy12stepsQAData.MainBox=plot(0,0,'g','linewidth',2);
        for index=1:Prodigy12stepsQAData.Draw.Compartments
            Prodigy12stepsQAData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
        x1=Prodigy12stepsQAData.x0;
        x2=Prodigy12stepsQAData.x0+Prodigy12stepsQAData.Draw.MainBox(1);
        y1=Prodigy12stepsQAData.y0;
        y2=Prodigy12stepsQAData.y0+Prodigy12stepsQAData.Draw.MainBox(2);
        set(Prodigy12stepsQAData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        for index=1:Prodigy12stepsQAData.Draw.Compartments
            X1=x1+Prodigy12stepsQAData.Draw.BorderX;
            X2=x2-Prodigy12stepsQAData.Draw.BorderX;
            Y1=y1+(y2-y1)/(Prodigy12stepsQAData.Draw.Compartments)*(index-1)+Prodigy12stepsQAData.Draw.BorderY;
            Y2=y1+(y2-y1)/(Prodigy12stepsQAData.Draw.Compartments)*(index)-Prodigy12stepsQAData.Draw.BorderY;
            set(Prodigy12stepsQAData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
        end
        
    case 'Hide'
        set(Prodigy12stepsQAData.MainBox,'xdata',0,'ydata',0);
        for index=1:Prodigy12stepsQAData.Draw.Compartments
            set(Prodigy12stepsQAData.Box(index),'xdata',0,'ydata',0);
        end
        
    case 'compute'
        set(ctrl.CheckBreast,'value',true);
        x1=Prodigy12stepsQAData.x0;
        x2=Prodigy12stepsQAData.x0+Prodigy12stepsQAData.Draw.MainBox(1);
        y1=Prodigy12stepsQAData.y0;
        y2=Prodigy12stepsQAData.y0+Prodigy12stepsQAData.Draw.MainBox(2);
        mmax = max(max(Image.LE))
        mmin = min(min(Image.LE))
        mmax = max(max(Image.HE))
        mmin = min(min(Image.HE))
        DensityResults={};
        for index=1:Prodigy12stepsQAData.Draw.Compartments
            ROI.xmin=floor(x1+Prodigy12stepsQAData.Draw.BorderX);
            ROI.xmax=floor(x2-Prodigy12stepsQAData.Draw.BorderX);
            ROI.ymin=floor(y1+(y2-y1)/(Prodigy12stepsQAData.Draw.Compartments)*(index-1)+Prodigy12stepsQAData.Draw.BorderY);
            ROI.ymax=floor(y1+(y2-y1)/(Prodigy12stepsQAData.Draw.Compartments)*(index)-Prodigy12stepsQAData.Draw.BorderY);
            ROI.rows=ROI.ymax-ROI.ymin+1;
            ROI.columns=ROI.xmax-ROI.xmin+1;
            Prodigy12stepsQAData.Output{1,10+index} = mean(mean(Image.material(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
            Prodigy12stepsQAData.Output{2,index} = mean(mean(Image.LE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax) - Result.LE0));  
            Prodigy12stepsQAData.Output{3,index} = mean(mean(Image.HE(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax) - Result.HE0));  
        end
       
       
        Excel('INIT');
        Excel('TRANSFERT',Prodigy12stepsQAData.Output);
end