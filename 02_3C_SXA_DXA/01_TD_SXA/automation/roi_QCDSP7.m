 function DensityROIResults = roi_QCDSP7()
    
    global ROI Analysis Info Image figuretodraw QCAnalysisData flag MachineParams
    
        flag.SXAphantomDisplay = false;

        if Info.DigitizerId == 3
              k = 1;
         elseif Info.DigitizerId == 4
              k = 150/140 ;
         elseif Info.DigitizerId >= 5 & Info.DigitizerId <= 7
              k = 150 / 200;
        end
       % figure;imagesc(Analysis.BackGround);colormap(gray);
        [xmax,ymin,ymax,xmin] = edge_roi(1-Analysis.BackGround);
        ROI.xmin = xmin;
        ROI.ymin = ymin;
        ROI.rows=ymax-ymin+1;
        ROI.columns=xmax-xmin+1;
        ROI.image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        Analysis.midpoint = round(ROI.rows/2);
        QCAnalysisData.Draw.MainBox=[210,1250] * k;
        QCAnalysisData.Draw.Compartments=9;
        QCAnalysisData.Draw.BorderY=45 * k;
        %QCAnalysisData.Draw.BorderX=280/box_scale * k;
        QCAnalysisData.Draw.BorderX=50 * k;
        Analysis.ROIbreast_midpoint =  round(ROI.rows/2);
        %set(ctrl.CheckBreast,'value',true);
        x1=xmin + 230;
        x2=x1+QCAnalysisData.Draw.MainBox(1);
        y1= ymin + 48;
        y2= y1 + QCAnalysisData.Draw.MainBox(2);
%         xr1 = xmin;
%         xr2 = xr1 + ROI.columns - 43;
%         yr1 = ymin + 48;
%         yr2 = yr1 + ROI.rows-96;
        
        x_corner = xmin + ROI.columns - 43;
        y_corner = ymin + 48;
        if flag.small_paddle ==  true  %small paddle
             X_angle = Analysis.rx - MachineParams.rx_correction;
             Y_angle = Analysis.ry - MachineParams.ry_correction;
        else
             X_angle = Analysis.rx;% - MachineParams.rx_correction;
             Y_angle = Analysis.ry - MachineParams.ry_correction;
        end
        thickness_ROI = thickness_ROIcreation(X_angle,Y_angle);
%         figure;imagesc(thickness_ROI);colormap(gray);hold on;
%          plot(x_corner,y_corner,'r*'); hold off;
        Analysis.thicknessDSP7 = thickness_ROI(y_corner,x_corner);
%         figure;imagesc(Image.image);colormap(gray);hold on;
%         plot(x_corner,y_corner,'r*');
%         if Info.PhantomComputed == false
%                 PhantomDetection();
%         end
        QCAnalysisData.MainBox=plot(0,0,'g','linewidth',2);
        for index=1:9
             QCAnalysisData.Box(index)=plot(0,0,'g','linewidth',2);
        end
        figure(figuretodraw);
        funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b',3);
        set(QCAnalysisData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        
        for index=1:QCAnalysisData.Draw.Compartments
            X1=x1+QCAnalysisData.Draw.BorderX;
            X2=x2-QCAnalysisData.Draw.BorderX;
            Y1=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY;
            Y2=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY;
           % pause(1);
            set(QCAnalysisData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
        end
    
        %DensityResults={};
        for index=2:QCAnalysisData.Draw.Compartments-1
            roi.xmin=floor(x1+QCAnalysisData.Draw.BorderX);
            roi.xmax=floor(x2-QCAnalysisData.Draw.BorderX);
            roi.ymin=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY);
            roi.ymax=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY);
            roi.rows=roi.ymax-roi.ymin+1;
            roi.columns=roi.xmax-roi.xmin+1;
            %pause(1);
            %set(QCAnalysisData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
            
            Analysis.Step=8;
            if Info.DigitizerId >= 4
                Z4ComputeBreastDensityNew_DSP7(ROI, Image,roi); %Z4ComputePhantomDensity(roi);
            else    
                Analysis = funcComputePhantomDensity(roi,Image,Analysis);
            end
            %DensityResults{1,index}=Analysis.DensityPercentage;
            %DensityResults{2,index}=mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));
            DensityResults(1,index-1)=Analysis.DensityPercentage';
            DensityResults(2,index-1)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
        end

         DensityROIResults = sortrows(DensityResults',2);
        %%%%% for phantom calibration
        
%          set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
%         for index=1:QCAnalysisData.Draw.Compartments
%             set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
%         end
%        