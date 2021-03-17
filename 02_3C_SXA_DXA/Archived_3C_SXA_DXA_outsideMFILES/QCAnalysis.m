function QCAnalysis(RequestedAction)
global dummyuicontrol2 ctrl f0 QCAnalysisData Analysis Image ROI Phantom Info

%Analysis.GammaDSP = false; 
 if Info.DigitizerId == 3
     k = 1;
 elseif Info.DigitizerId == 4
      k = 150/140 ;
     
 else
     k = 150 / 169;;
 end
  %k = 150 / 169;

 % k = 150/140 ;
 
box_scale = 1;
%k = 1;
%{
if Analysis.SeleniaDXADSP == true
    box_scale = 2.5;
end
%}
QCAnalysisData.Draw.MainBox=[700/box_scale,1250] * k;
QCAnalysisData.Draw.Compartments=9;
QCAnalysisData.Draw.BorderY=45 * k;
QCAnalysisData.Draw.BorderX=280/box_scale * k;

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
        for index=1:9
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
            
          if Analysis.GammaDSP == true  
             Analysis = funcComputeDSPwithGamma(ROI,Image,Analysis);
         % elseif Analysis.SeleniaDXADSP == true
         % Analysis.DensityPercentage = [];
          elseif Info.DigitizerId == 4
              Analysis = Z4ComputePhantomDensity(ROI,Image,Analysis);
          else    
              Analysis = funcComputePhantomDensity(ROI,Image,Analysis);
          end
            DensityResults{1,index}=Analysis.DensityPercentage;
            DensityResults{2,index}=mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));
        end
        %%%%% for phantom calibration
        %
        if Analysis.SeleniaDXADSP == true 
             dsp_values = cell2mat(DensityResults(2,:));
             xdata = [100, 70, 60,50, 45, 30,0];
             %xdata = [0, 30, 45,50, 60, 70,100];
             ydata = dsp_values(2:end-1);
             fresult = fit(xdata',ydata','poly2');
             
             %figure;
             %plot(xdata,ydata, 'bo', xdata, fresult.p1.*xdata.^2+fresult.p2.*xdata.^1+fresult.p3, '-r');
             
            % DensityResults{1,i} = [];
             
             DensityResults{2,1} = [];
             DensityResults{2,9} = [];
             DensityResults{3,2} = fresult.p1;
             DensityResults{3,3} = fresult.p2;
             DensityResults{3,4} = fresult.p3;
             for i  = 1:9
                 DensityResults{4,i} = Analysis.ydata_ph80(i);
                 DensityResults{1,i} = [];
             end
             
             DensityResults{5,2} = Analysis.fresult.p1;
             DensityResults{5,3} = Analysis.fresult.p2;
             DensityResults{5,4} = Analysis.fresult.p3;
             
            
        end
         Analysis.SeleniaDXADSP = false;
         %}
         
        %{
         DensityResults{2,index+1}=Analysis.Phantomfatlevel;
        DensityResults{2,index+2}=Analysis.Phantomleanlevel;
        DensityResults{2,index+3}=Analysis.AngleHoriz;
        DensityResults{2,index+4}=Analysis.Hfatcorr;
        DensityResults{2,index+5}=Analysis.Hleancorr;
        DensityResults{2,index+6}=Analysis.PhantomDistanceFatRef;
        %}
        Excel('INIT');
        Excel('TRANSFERT',DensityResults);
end