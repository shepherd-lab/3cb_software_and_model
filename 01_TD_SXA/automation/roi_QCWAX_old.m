function DensityROIResults = roi_QCWAX()
    
    global ROI Analysis Info Image figuretodraw QCAnalysisData flag MachineParams
    
        flag.SXAphantomDisplay = false;
        tz = Analysis.params(4); 
        
        if Info.DigitizerId == 3
              k = 1;
              m = 24;
         elseif Info.DigitizerId == 4
              k = 150/140 ;
              m = 48;
         elseif Info.DigitizerId == 5 || Info.DigitizerId == 6 || Info.DigitizerId == 7
              k = 150 / 200;
              m = 48 * 150 / 200;
        end
        
%             bkgr = background_phantomdigital(Image.OriginalImage);
%                   
%             Analysis.BackGroundThreshold = bkgr+5000
%            Analysis.BackGround = Image.OriginalImage<Analysis.BackGroundThreshold;
        
        %figure;imagesc(Analysis.BackGround);colormap(gray);
       % [xmax,ymin,ymax,xmin] = edge_roi(1-Analysis.BackGround);
                
%         [xmin,ymin] =  ginput(1);   %for manual pointing to ROI
%         [xmax,ymax] =  ginput(1);
        Analysis.midpoint = round(ROI.rows/2);
          if Info.DigitizerId > 3
            if flag.small_paddle ==  true  %small paddle
                 X_angle = Analysis.rx - MachineParams.rx_correction;
                 Y_angle = Analysis.ry - MachineParams.ry_correction;
            else
                 X_angle = Analysis.rx- MachineParams.rx_correction;% - MachineParams.rx_correction;
                 Y_angle = Analysis.ry - MachineParams.ry_correction;
            end
            thickness_ROI = thickness_ROIcreation(X_angle,Y_angle);
        else
            X_angle = 0;
            Y_angle = Analysis.AngleHoriz;
            thickness_ROI = thickness_ROIcreation_film(X_angle,Y_angle);
        end
        
         % figure;imagesc(thickness_ROI);colormap(gray);hold on;
%          plot(x_corner,y_corner,'r*'); hold off;
%         [x_corner,y_corner] =  ginput(1);
%         y_corner = round(y_corner);
%         x_corner = round(x_corner);
       % Analysis.thicknessDSP7 = thickness_ROI(y_corner,x_corner);
        Analysis.thicknessDSP7 = tz -  MachineParams.bucky_distance;
         
        if (~isnan(Analysis.y_1) | ~isnan(Analysis.x_1)) 
            Analysis.thicknessWax1 = thickness_ROI(Analysis.y_1,Analysis.x_1); 
%             plot(Analysis.x_1,Analysis.y_1,'*b');hold on;text(Analysis.x_1,Analysis.y_1,num2str(1),'Color', 'y');hold on;
        else
            Analysis.thicknessWax1 = [];
        end
        if (~isnan(Analysis.y_2) | ~isnan(Analysis.x_2)) 
            Analysis.thicknessWax2 = thickness_ROI(Analysis.y_2,Analysis.x_2); 
%             plot(Analysis.x_2,Analysis.y_2,'*b');hold on;text(Analysis.x_2,Analysis.y_2,num2str(2),'Color', 'y');hold on;
        else Analysis.thicknessWax2 = [];
        end
        if (~isnan(Analysis.y_3) | ~isnan(Analysis.x_3)) 
            Analysis.thicknessWax3 = thickness_ROI(Analysis.y_3,Analysis.x_3); 
%             plot(Analysis.x_3,Analysis.y_3,'*b');hold on;text(Analysis.x_3,Analysis.y_3,num2str(3),'Color', 'y');hold on;
        else Analysis.thicknessWax3 = [];
        end
        if (~isnan(Analysis.y_4) | ~isnan(Analysis.x_4)) 
            Analysis.thicknessWax4 = thickness_ROI(Analysis.y_4,Analysis.x_4);
%             plot(Analysis.x_4,Analysis.y_4,'*b');hold on;text(Analysis.x_4,Analysis.y_4,num2str(4),'Color', 'y');hold on;
        else Analysis.thicknessWax4 = [];
        end
        if (~isnan(Analysis.y_5) | ~isnan(Analysis.x_5)) 
            Analysis.thicknessWax5 = thickness_ROI(Analysis.y_5,Analysis.x_5); 
%             plot(Analysis.x_5,Analysis.y_5,'*b');hold on;text(Analysis.x_5,Analysis.y_5,num2str(5),'Color', 'y');hold on;
        else Analysis.thicknessWax5 = [];
        end
        if (~isnan(Analysis.y_6) | ~isnan(Analysis.x_6)) 
            Analysis.thicknessWax6 = thickness_ROI(Analysis.y_6,Analysis.x_6); 
%             plot(Analysis.x_6,Analysis.y_6,'*b');hold on;text(Analysis.x_6,Analysis.y_6,num2str(6),'Color', 'y');hold on;
        else Analysis.thicknessWax6 = [];
        end
        
        xmax = round(Analysis.xmax);
        ymax = round(Analysis.ymax);  
        xmin = round(Analysis.xmin);
        ymin = round(Analysis.ymin);
        
        ROI.xmin = round(xmin);
        ROI.ymin = round(ymin);
        if ROI.ymin < 0 %JW ROI.ymin in some cases negative
            ROI.ymin = 1
        end
        ROI.rows=ymax-ymin+1;
        ROI.columns=xmax-xmin+1;
        ROI.image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        Analysis.midpoint = round(ROI.rows/2);
        QCAnalysisData.Draw.MainBox=[210,1250] * k;
        QCAnalysisData.Draw.Compartments=9;
        QCAnalysisData.Draw.BorderY=75 * k;
        %QCAnalysisData.Draw.BorderX=280/box_scale * k;
        QCAnalysisData.Draw.BorderX=75 * k;

        %set(ctrl.CheckBreast,'value',true);
        x1=xmin + 230;
        x2=x1+QCAnalysisData.Draw.MainBox(1);
        y1= ymin + m;
        y2= y1 + QCAnalysisData.Draw.MainBox(2);
%         xr1 = xmin;
%         xr2 = xr1 + ROI.columns - 43;
%         yr1 = ymin + 48;
%         yr2 = yr1 + ROI.rows-96;
%         
%         x_corner = xmin + ROI.columns - 43;
%         y_corner = ymin + m;
        
      
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
        funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b',3); hold on;
% % %         set(QCAnalysisData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);

        for index=1:QCAnalysisData.Draw.Compartments
% % %             X1=x1+QCAnalysisData.Draw.BorderX;
% % %             X2=x2-QCAnalysisData.Draw.BorderX;
% % %             Y1=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY;
% % %             Y2=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY;
                j=index;
                l=0;
                if j > 3 && j <= 6
                    j=index-3;
                    l=1;
                elseif j > 6
                    j=index-6;
                    l=2;
                end
                    X1=xmin+(ROI.columns/3)*(j-1)+QCAnalysisData.Draw.BorderX;
                    X2=xmin+(ROI.columns/3)*(j-1)+QCAnalysisData.Draw.BorderX+(ROI.columns-(QCAnalysisData.Draw.BorderX*6))/3;
                if index <=4
                    Y1=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
                    Y2=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
                elseif index <=7
                    Y1=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
                    Y2=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
                elseif index <=9
                    Y1=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
                    Y2=ymin+(ROI.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
                end
% % %             pause(1);
% % %             set(QCAnalysisData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
% % %         end
    
        %DensityResults={};
% % %         for index=1:QCAnalysisData.Draw.Compartments
% % %             roi.xmin=floor(x1+QCAnalysisData.Draw.BorderX);
% % %             roi.xmax=floor(x2-QCAnalysisData.Draw.BorderX);
% % %             roi.ymin=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY);
% % %             roi.ymax=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY);
% % %             roi.rows=roi.ymax-roi.ymin+1;
% % %             roi.columns=roi.xmax-roi.xmin+1;
            roi.xmin=floor(X1);
            roi.xmax=floor(X2);
            roi.ymin=floor(Y1);
            roi.ymax=floor(Y2);
            roi.rows=roi.ymax-roi.ymin+1;
            roi.columns=roi.xmax-roi.xmin+1;
            %pause(1);
            set(QCAnalysisData.Box(index),'xdata',[roi.xmin,roi.xmax,roi.xmax,roi.xmin,roi.xmin],'ydata',[roi.ymin,roi.ymin,roi.ymax,roi.ymax,roi.ymin]);
            hold on;
            Analysis.Step=8;
            if Info.DigitizerId >= 4
                Analysis = Z4ComputeWAXPhantomDensity(roi,Image,Analysis,index);
            else    
                Analysis = funcComputePhantomDensity(roi,Image,Analysis);
            end
            %DensityResults{1,index}=Analysis.DensityPercentage;
            %DensityResults{2,index}=mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));
% % %             DensityResults(1,index-1)=Analysis.DensityPercentage';
% % %             DensityResults(2,index-1)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
            DensityResults(1,index)=Analysis.DensityPercentage';
            DensityResults(2,index)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
        end

% % %          DensityROIResults = sortrows(DensityResults',2);
         DensityROIResults = (DensityResults')
         Analysis.roi_DSP7values = DensityROIResults(:,2);
         Analysis.density_DSP7 = DensityROIResults(:,1);
         a = 1;
         
        %%%%% for phantom calibration
        
%          set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
%         for index=1:QCAnalysisData.Draw.Compartments
%             set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
%         end
%        