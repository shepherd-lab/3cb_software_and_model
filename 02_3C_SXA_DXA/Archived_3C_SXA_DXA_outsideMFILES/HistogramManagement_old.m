%HistogramManagement;
%author Lionel HERVE
%date of creation 4-11-2003
%modification 9-17-03: destruction of invisible sliders and avoid
%computation of the histogram everytime a bar is moved

function histogrammanagement(ActionRequested,select);
global f0 Analysis Hist Image Threshold ctrl CurrentX;
if ~exist('ActionRequested')
    ActionRequested='ComputeHistogram';
end

switch ActionRequested
    case 'EndMoveHistLine'
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.handle,'WindowButtonUpFcn','');
            HistogramManagement('DrawHistLine',0);
    case 'DrawHistLine'  %draw the Histogram and the 3 bars
        if Analysis.Step>=1;
            figure(f0.handle);
            %draw histogram
            axes(Hist.Handle);
            temp=Hist.values.^0.5;
            %remove the Highest value of the histogram = Background
            [C,I]=max(Hist.values);temp(I)=0;
            Hist.maxGraphY=max(temp);
            if (Hist.maxGraphY==0)
                Hist.maxGraphY=1; 
            end
            set(Hist.Handle,'nextPlot','replace');
            bar(Hist.xvalues,Hist.values.^0.5);
                    
            select=0;
            %draw line;
            set(Hist.Handle,'nextPlot','add');
            Hist.Handleline1=plot([Hist.x0 Hist.x0],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','blue','ButtonDownFcn','HistogramManagement(''BarMoved'',1)');
            Hist.Handleline2=plot([Hist.xmax Hist.xmax],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','blue','ButtonDownFcn','HistogramManagement(''BarMoved'',2)');
            funcdrawHistline(Hist.x0*Image.maximage/100,Hist.xmax*Image.maximage/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
            ab = Image.maximage
            set(Hist.Handle,'YTick',[],'Xlim',[0 Image.maximage],'Ylim',[0 Hist.maxGraphY]);    
            
            %draw threshold
            Threshold.Handleline=plot([Threshold.value*Image.maximage Threshold.value*Image.maximage],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','red','ButtonDownFcn','HistogramManagement(''BarMoved'',3)');
            
            Image.color0=Hist.x0*63/100;
            Image.colormax=Hist.xmax*63/100;
            recomputevisu;draweverything;
        end   
    case 'BarMoved'
        CurrentX=0;
        CurrentPoint=0;
        if (select==1||select==2)  %use little image for contrast selection
            axes(f0.axisHandle);
            hold off;
            imagesc(UnderSamplingN(Image.image/Image.maximage,2));
        end
        if select==1
            set(f0.handle,'WindowButtonMotionFcn','HistogramManagement(''DetectMoveement'',0);');
            set(f0.handle,'WindowButtonUpFcn','HistogramManagement(''EndMoveHistLine'',0);');
        elseif select==2
            set(f0.handle,'WindowButtonMotionFcn','HistogramManagement(''DetectMoveement'',1);');
            set(f0.handle,'WindowButtonUpFcn','HistogramManagement(''EndMoveHistLine'',0);');
        elseif select==3   
            Threshold.Computed=0;
            set(f0.handle,'WindowButtonMotionFcn','HistogramManagement(''DetectMoveement'',2);');
            set(f0.handle,'WindowButtonUpFcn','HistogramManagement(''ThresholdManagement'',1);');    
        end
    case 'ThresholdManagement'
        if Analysis.Step>=1;
            if select==0   %threshold.action=1 when colormap should be changed;
                axes(Hist.Handle);
                %draw line;
                set(Threshold.Handleline,'xdata',[Threshold.value*Image.maximage Threshold.value*Image.maximage]);
                colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));  
            else            %end move of the threshold bar
                set(f0.handle,'WindowButtonMotionFcn','');
                set(f0.handle,'WindowButtonUpFcn','');            
                HistogramManagement('ThresholdManagement',0);
            end;
        end       
    case 'ComputeHistogram'
        %compute Histogram, this is just called from button preprocessing that is
        %to say when the image could have changed
        Hist.values=histc(reshape(Image.image,1,prod(size(Image.image))),[0:0.01:1]*Image.maximage);
        Hist.xvalues=[0:0.01:1]*Image.maximage;
        Hist.MaxValue=max(Hist.values);
        HistogramManagement('EndMoveHistLine',0);
        
    case 'DetectMoveement'
        CurrentPoint=get(Hist.Handle,'CurrentPoint');CurrentX=CurrentPoint(1,1)*100/Image.maximage;
        if select==0
            Hist.x0=max(0,min(CurrentX,Hist.xmax-1));funcdrawHistline(Hist.x0*Image.maximage/100,Hist.xmax*Image.maximage/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
        elseif select==1        
            Hist.xmax=min(100,max(CurrentX,Hist.x0+1));funcdrawHistline(Hist.x0*Image.maximage/100,Hist.xmax*Image.maximage/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
        elseif select==2                
            Threshold.value=min(1,max(CurrentX/100,0));HistogramManagement('ThresholdManagement',0);                
        end
        if (select==0)||(select==1)
            %redraw the image in real time!!
            set(f0.axisHandle,'clim',[Hist.x0/100 Hist.xmax/100]);
        end

    case 'SwitchThreshold'
        if Threshold.bool==false 
            Threshold.bool=true; 
        else 
            Threshold.bool=false;
        end;
end
