function VidarQA(RequestedAction)
global dummyuicontrol2 ctrl f0 QCAnalysisData Analysis Image ROI

%Analysis.GammaDSP = false; 
k = 150 / 169;
%k = 1;
VidarQAData.Output(:,1) = [0.06;0.11;0.19;0.28;0.38;0.48;0.59;0.71;0.82;0.93;1.03;1.13;1.23;1.37;...
   1.48;1.61;1.72;1.83;1.96;2.1;2.22;2.32;2.43;2.59;2.72;2.87;3.01;3.16;3.32;3.48;3.63;3.73;3.78];
VidarQAData.Draw.MainBox=[700,1250] * k;
VidarQAData.Draw.Compartments=33;
VidarQAData.Draw.BorderY=10 * k;
VidarQAData.Draw.BorderX=200 * k;

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        VidarQA('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','VidarQA(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
                
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
       
        VidarQA('Hide');
        VidarQA('compute');
        Message('Ok...');
        
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        VidarQAData.x0=CurrentPoint(1,1);VidarQAData.y0=CurrentPoint(1,2);
        VidarQA('Redraw');

    case 'InitDrawing'
        VidarQAData.MainBox=plot(0,0,'g','linewidth',2);
        for index=1:33
            VidarQAData.Box(index)=plot(0,0,'g','linewidth',2);
        end
        
    case 'Redraw'
        x1=VidarQAData.x0;
        x2=VidarQAData.x0+VidarQAData.Draw.MainBox(1);
        y1=VidarQAData.y0;
        y2=VidarQAData.y0+VidarQAData.Draw.MainBox(2);
        set(VidarQAData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        for index=1:VidarQAData.Draw.Compartments
            X1=x1+VidarQAData.Draw.BorderX;
            X2=x2-VidarQAData.Draw.BorderX;
            Y1=y1+(y2-y1)/(VidarQAData.Draw.Compartments)*(index-1)+VidarQAData.Draw.BorderY;
            Y2=y1+(y2-y1)/(VidarQAData.Draw.Compartments)*(index)-VidarQAData.Draw.BorderY;
            set(VidarQAData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
        end
        
    case 'Hide'
        set(VidarQAData.MainBox,'xdata',0,'ydata',0);
        for index=1:VidarQAData.Draw.Compartments
            set(VidarQAData.Box(index),'xdata',0,'ydata',0);
        end
        
    case 'compute'
        set(ctrl.CheckBreast,'value',true);
        x1=VidarQAData.x0;
        x2=VidarQAData.x0+VidarQAData.Draw.MainBox(1);
        y1=VidarQAData.y0;
        y2=VidarQAData.y0+VidarQAData.Draw.MainBox(2);
             
        DensityResults={};
        for index=1:VidarQAData.Draw.Compartments
            ROI.xmin=floor(x1+VidarQAData.Draw.BorderX);
            ROI.xmax=floor(x2-VidarQAData.Draw.BorderX);
            ROI.ymin=floor(y1+(y2-y1)/(VidarQAData.Draw.Compartments)*(index-1)+VidarQAData.Draw.BorderY);
            ROI.ymax=floor(y1+(y2-y1)/(VidarQAData.Draw.Compartments)*(index)-VidarQAData.Draw.BorderY);
            ROI.rows=ROI.ymax-ROI.ymin+1;
            ROI.columns=ROI.xmax-ROI.xmin+1;
            VidarQAData.Output(:,2) = mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));  
        end
       
       
        Excel('INIT');
        Excel('TRANSFERT',VidarQAData.Output);
end