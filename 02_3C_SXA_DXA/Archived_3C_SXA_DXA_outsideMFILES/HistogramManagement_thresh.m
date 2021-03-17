%HistogramManagement;
%author Lionel HERVE
%date of creation 4-11-2003
%modification 9-17-03: destruction of invisible sliders and avoid
%computation of the histogram everytime a bar is moved

function Histogrammanagement(ActionRequested,select);
global f0 Analysis Hist Image Threshold ctrl CurrentX Info;
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
            Hist.x0 = 0;
            Hist.xmax = 100;
%            if  ~isfield(Hist, 'xmax')
%             Hist.xmax = 100;
%            end
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
                    
%             select=0;
            %draw line;
            set(Hist.Handle,'nextPlot','add');
            Hist.Handleline1=plot([Hist.x0 Hist.x0],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','blue','ButtonDownFcn','HistogramManagement(''BarMoved'',1)');
            Hist.Handleline2=plot([Hist.xmax Hist.xmax],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','blue','ButtonDownFcn','HistogramManagement(''BarMoved'',2)');
            funcdrawHistline(Hist.x0*Image.maximage2/100,Hist.xmax*Image.maximage2/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
            set(Hist.Handle,'YTick',[],'Xlim',[0 Image.maximage2],'Ylim',[0 Hist.maxGraphY]);    
            
            %draw threshold
            Threshold.Handleline=plot([Threshold.value*Image.maximage2 Threshold.value*Image.maximage2],[0 Hist.maxGraphY],'EraseMode','xor','linewidth',3,'color','red','ButtonDownFcn','HistogramManagement(''BarMoved'',3)');
            
            Image.color0=Hist.x0*63/100;
            Image.colormax=Hist.xmax*63/100;
         %   recomputevisu;
            Hist.imagemin2 = Image.immin + Hist.x0* Image.maximage2 / 100;
            Hist.imagemax2 = Image.immin + Hist.xmax* Image.maximage2 / 100;
            if Info.DigitizerId == 8 %| Info.DigitizerId == 1
                Hist.imagemax2 = 20000;
                Hist.imagemin2 = - 3000;
                %Hist.imagemin2 = -5000; %Hist.imagemin2 - 10000;
            end
            draweverything;   
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
            Threshold.ComputedCalc=0;
            set(f0.handle,'WindowButtonMotionFcn','HistogramManagement(''DetectMoveement'',2);');
            set(f0.handle,'WindowButtonUpFcn','HistogramManagement(''ThresholdManagement'',1);'); 
         end
    case 'ThresholdManagement'
        if Analysis.Step>=1;
            if select==0   %threshold.action=1 when colormap should be changed;
                axes(Hist.Handle);
                %draw line;
                set(Threshold.Handleline,'xdata',[Threshold.value*Image.maximage2 Threshold.value*Image.maximage2]);
                colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));  
            else            %end move of the threshold bar
                set(f0.handle,'WindowButtonMotionFcn','');
                set(f0.handle,'WindowButtonUpFcn','');            
                set(f0.handle, 'Interruptible','on');
                funcThresholdContour2;
                draweverything;
                
                HistogramManagement('ThresholdManagement',0);
            end
        end       
    case 'ComputeHistogram'
        %compute Histogram, this is just called from button preprocessing that is
        %to say when the image could have changed
        
        bin2 =  Image.minOriginalImage + [0:0.01:1]*(Image.maxOriginalImage-Image.minOriginalImage);
      %  figure; imagesc(Image.OriginalImage); colormap(gray);
        mmax = max(max(Image.image));
        mmin = min(min(Image.image));
        mmaxoriginal = max(max(Image.image));
        mminoriginal = min(min(Image.image));
        
         if  isnan(mmaxoriginal) | isnan(mminoriginal)
%              Image.image = Image.OriginalImage;
             return;
         end
        %szim = size(Image.OriginalImage); % 2047 1663
       %{
        xh = [0, szim(2)];
        yh = [szim(1)/2, szim(1)/2];
        xv = [szim(2)/2 szim(2)/2];
        yv = [0, szim(1)];
        
        figure;
        signal2 = improfile(Image.OriginalImage,xh,yh);
        improfile(Image.OriginalImage,xh,yh);
        
        figure;
        improfile(Image.OriginalImage,xv,yv);
        signal3 = improfile(Image.OriginalImage,xv,yv);
        %}
        Hist.values1=histc(reshape(Image.image,1,prod(size(Image.image))),bin2);
        h = Hist.values1';
        % axes(Hist.Handle);
        temp=Hist.values1.^0.5;
        hv = Hist.values1;
        [C,I]=max(hv);
        temp(I)=0;
        tempI = Hist.values1(I);
        tempfirst = Hist.values1(1);
        templast = Hist.values1(end);
        Hist.values1 (I) = 0;
        if Hist.values1(2) == 0
            Hist.values1(1) = 0;
        end
         if Hist.values1(end-1) == 0
            Hist.values1(end) = 0;
         end
        ind = find(Hist.values1>0);
     
        if isempty(ind)
            Hist.values1(1)= tempfirst;
            Hist.values1(end)= templast;
            Hist.values1(I)=  tempI;
            ind = find(Hist.values1>0);
           % if isempty(ind)
           %     index_min = min(ind);
           %     immin = bin2(index_min);
           %     Image.maximage2 = 1;0 - immin;
            if length(ind) < 2
                Image.maximage2 = 1 - Image.immin;
            elseif length(ind) == 2
                Image.maximage2 = Image.immax - Image.immin;
            else
                index_min = min(ind);
                index_max = max(ind);
                immin = bin2(index_min);
                immax = bin2(index_max);
                Image.immin = immin;
                Image.immax = immax;
                Image.maximage2 = immax - immin;
            end    
            % bin = [Image.maximage2-1:0.01:Image.maximage2+1];
            %immin = 0;
        else
            index_min = min(ind);
            index_max = max(ind);
            immin = bin2(index_min);
            immax = bin2(index_max);
            Image.immin = immin;
            Image.immax = immax;
            Image.maximage2 = immax - immin;
            if Image.maximage2 == 0
                Image.maximage2 = immax;
            end
            %bin = [0:0.01:1]*Image.maximage2;
        end
       % bin =  immin + [0:0.01:1]*(Image.maxOriginalImage-immin);
         bin = [0:0.01:1]*Image.maximage2;
        im = Image.image - Image.immin;
        Hist.values=histc(reshape(im,1,prod(size(Image.image))),bin);
        %Hist.values = Hist.values1(index:end);
        Hist.xvalues= bin ;%[0:0.01:1]*Image.maximage;
       
        Hist.MaxValue=max(Hist.values);
        Hist.MinValue=min(Hist.values);
        Hist.imagemin2 = Image.immin ;
        Hist.imagemax2 = Image.maximage;
        HistogramManagement('EndMoveHistLine',0);
        
    case 'DetectMoveement'
        CurrentPoint=get(Hist.Handle,'CurrentPoint');
        CurrentX=CurrentPoint(1,1)*100/Image.maximage2;
        if select==0
            Hist.x0=max(0,min(CurrentX,Hist.xmax-1));
            % funcdrawHistline(Image.immin + Hist.x0*(Image.maximage -Image.immin)/100,Hist.xmax*Image.maximage/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
            funcdrawHistline(Hist.x0*Image.maximage2/100,Hist.xmax*Image.maximage2/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
        elseif select==1        
            Hist.xmax=min(100,max(CurrentX,Hist.x0+1));
           %  funcdrawHistline(Image.immin + Hist.x0*(Image.maximage -Image.immin)/100,Hist.xmax*Image.maximage/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
            funcdrawHistline(Hist.x0*Image.maximage2/100,Hist.xmax*Image.maximage2/100,Hist.Handleline1,Hist.Handleline2,Hist.maxGraphY);
        elseif select==2                
            Threshold.value=min(1,max(CurrentX/100,0));HistogramManagement('ThresholdManagement',0);                
        end
        if (select==0)||(select==1)
            %redraw the image in real time!!
           set(f0.axisHandle,'clim',[Hist.x0/100 Hist.xmax/100]);
           climits = [Hist.x0/100 Hist.xmax/100];
        end

    case 'SwitchThreshold'
        if Threshold.bool==false 
            Threshold.bool=true; 
        else 
            Threshold.bool=false;
        end;
end
