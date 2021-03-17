function GammaROI(RequestedAction)
global dummyuicontrol2 ctrl f0 QCAnalysisData Analysis Image ROI


k = 150 / 169;
%k = 1;
thickness = 3;
    box.y = 198 + 6 * (thickness-3);
    box.x = 204 + 3 * (thickness-3);
    QCAnalysisData.Draw.MainBox=[box.y,box.x] * k;
    QCAnalysisData.Draw.Compartments=16;
    QCAnalysisData.Draw.BorderY=5 * k;
    QCAnalysisData.Draw.BorderX=5 * k;

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
                
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
       
        QCAnalysis('Hide');
        QCAnalysis('compute');
        Message('Ok...');
        
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        QCAnalysisData.x0=CurrentPoint(1,1);QCAnalysisData.y0=CurrentPoint(1,2);
        QCAnalysis('Redraw');

    case 'InitDrawing'
        QCAnalysisData.MainBox=plot(0,0,'g','linewidth',2);
        for index=1:16
            QCAnalysisData.Box(index)=plot(0,0,'g','linewidth',2);
        end
        
    case 'Redraw'
        x1=QCAnalysisData.x0;
        x2=QCAnalysisData.x0+QCAnalysisData.Draw.MainBox(1);
        y1=QCAnalysisData.y0;
        y2=QCAnalysisData.y0+QCAnalysisData.Draw.MainBox(2);
        set(QCAnalysisData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        for index=1:QCAnalysisData.Draw.Compartments
            X1=x1+QCAnalysisData.Draw.BorderX;
            X2=x2-QCAnalysisData.Draw.BorderX;
            Y1=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY;
            Y2=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY;
            set(QCAnalysisData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
        end
        
    case 'Hide'
        set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
        for index=1:QCAnalysisData.Draw.Compartments
            set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
        end
        
    case 'compute'
        set(ctrl.CheckBreast,'value',true);
        x1=QCAnalysisData.x0;
        x2=QCAnalysisData.x0+QCAnalysisData.Draw.MainBox(1);
        y1=QCAnalysisData.y0;
        y2=QCAnalysisData.y0+QCAnalysisData.Draw.MainBox(2);
             
        DensityResults={};
        for index=1:QCAnalysisData.Draw.Compartments
            ROI.xmin=floor(x1+QCAnalysisData.Draw.BorderX);
            ROI.xmax=floor(x2-QCAnalysisData.Draw.BorderX);
            ROI.ymin=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY);
            ROI.ymax=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY);
            ROI.rows=ROI.ymax-ROI.ymin+1;
            ROI.columns=ROI.xmax-ROI.xmin+1;
            
            
            Analysis=funcComputePhantomDensity2(ROI,Image,Analysis);
            DensityResults{1,index}=Analysis.DensityPercentage;
            DensityResults{2,index}=mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));
        end
        DensityResults{2,index+1}=Analysis.Phantomfatlevel;
        DensityResults{2,index+2}=Analysis.Phantomleanlevel;
        Excel('INIT');
        Excel('TRANSFERT',DensityResults);
end