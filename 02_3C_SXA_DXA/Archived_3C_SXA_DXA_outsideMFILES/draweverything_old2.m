%DrawEverything
% author Lionel HERVE
% creation  2 2003
% revision history
% 4-4-2003 100 gray level in the visible dynamic
% 4-8-2003 report management
% 9-19-2003 does not recompute the visu evrytime draweveryting is called

%#function FreeFromButtonDownFct

function draweverything(Undersamplingfactor,varargin)
warning off MATLAB:divideByZero
global ctrl f0 Analysis ROI FreeForm Outline PreciseOutline Info visu Threshold Image data flag ManualEdge Innerline 
global Phantom Error figuretodraw axestodraw ChestWallData  axestodraw Hist Result figuretodraw_separated axestodraw_separated
global stepdata
FREEFORMPLOTSIZE=2;FreeFormColor='green';
LINEPLOTSIZE=3;
if ~exist('Image.centerlistactivated')
    Image.centerlistactivated = 1;
end
    
%Analysis.Step = 2; 

%% Read arguments
DrawOption.PHANTOMLINE=0;
DrawOption.DONTCHANGE=0;
DrawOption.FIGUREIMPOSED=0;
DrawOption.ONLITTLEGRAPH=0;
DrawOption.STEPPHANTOMLINE=0;

for index=1:length(varargin)
    if strcmp(cell2mat(varargin(index)),'DONTCHANGE')
        DrawOption.DONTCHANGE=1;
    elseif strcmp(cell2mat(varargin(index)),'PHANTOMLINE')
        DrawOption.PHANTOMLINE=1;
    elseif strcmp(cell2mat(varargin(index)),'FIGUREIMPOSED')
        DrawOption.FIGUREIMPOSED=1;
    elseif strcmp(cell2mat(varargin(index)),'ONLITTLEGRAPH')
        DrawOption.ONLITTLEGRAPH=1;
    elseif strcmp(cell2mat(varargin(index)),'STEPPHANTOMLINE')
        DrawOption.STEPPHANTOMLINE=1;
    end
end

if ~exist('Undersamplingfactor')
    Undersamplingfactor=1;
end

%try
    if get(ctrl.separatedfigure,'value')
        set(ctrl.separatedfigure,'value',false);
        figuretodraw = figure('Tag','BreastImage');
        set(figuretodraw, 'Visible','off');
        axestodraw=axes;
        set(figuretodraw,'position',[0 0 size(Image.image,2)/size(Image.image,1)*800 800]);
        %figuretodraw =  figuretodraw_separated;
        % axestodraw = axestodraw_separated;
   
    elseif DrawOption.ONLITTLEGRAPH
        figuretodraw=f0.handle;
        axestodraw=f0.LittleAxis;
    elseif ~DrawOption.FIGUREIMPOSED
        figuretodraw=f0.handle;
        axestodraw=f0.axisHandle;
    end


    if Analysis.Step>0
        reportitem={};indexreport=1; %%%%%report
        [indexreport,reportitem]=funcAddToReport('Report: ',reportitem,indexreport);
        [indexreport,reportitem]=funcAddToReport(Info.Version,reportitem,indexreport);
        [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
        [indexreport,reportitem]=funcAddToReport('Mode:',reportitem,indexreport);
        [indexreport,reportitem]=funcAddToReport(Info.DigitizerDescription,reportitem,indexreport);
        [indexreport,reportitem]=funcAddToReport(['Correction:',Info.CorrectionName],reportitem,indexreport);
        if get(ctrl.CheckBreast,'value') stringitem='Breast Mode'; else stringitem='Phantom Mode';end
        [indexreport,reportitem]=funcAddToReport(stringitem,reportitem,indexreport);
        if get(ctrl.CheckAutoROI,'value') stringitem='ROI auto'; else stringitem='ROI manual';end
        [indexreport,reportitem]=funcAddToReport(stringitem,reportitem,indexreport);

        [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);

          % im = UnderSamplingN(visu,Undersamplingfactor);
          %  figure; imagesc(im); colormap(gray);
          %   figure; image(im); 
       %  figure;
         % image(UnderSamplingN(visu,Undersamplingfactor));
         % colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));
         % hold off;
       % figure(figuretodraw1);
       %axes(axestodraw1);
       % set(axestodraw1,'nextPlot','replace');
       %     image(UnderSamplingN(visu,Undersamplingfactor));
       %     colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));
        %    hold off;
        % figure(figuretodraw, 'Visible','off');
        axes(axestodraw);
       % if Info.Analysistype == 5
       %     set(figuretodraw, 'Visible','off');
       % end
        set(axestodraw,'nextPlot','replace');
        
        if ~DrawOption.DONTCHANGE
          %   im1 = UnderSamplingN(visu,Undersamplingfactor) ;        
            %im1 = UnderSamplingN(visu,Undersamplingfactor) ;
           %im2 = imadjust(im1, [0 1], [0.5 1]);
            imagesc(Image.image,[Hist.imagemin2 Hist.imagemax2]);
           % colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));
             colormap(gray);        
        end
       % hold off;
        set(axestodraw,'nextPlot','add'); % Set the axis to plot over the current picture.
        [indexreport,reportitem]=funcAddToReport(['Filename:',Analysis.filename],reportitem,indexreport);
        
            [indexreport,reportitem]=funcAddToReport(['Center:',char(data.centerlistname(Image.centerlistactivated,1))],reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(['mAs:',num2str(Image.mAs),'  kVp:',num2str(Image.kVp)],reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);


        if (Analysis.Step>=1.5)
            xmin=ROI.xmin;xmax=ROI.xmin+ROI.columns-1;ymin=ROI.ymin;ymax=ROI.ymin+ROI.rows-1;
            if get(ctrl.ShowAL,'value')
                funcBox(xmin/Undersamplingfactor,ymin/Undersamplingfactor,xmax/Undersamplingfactor,ymax/Undersamplingfactor,'b',LINEPLOTSIZE);
            end %draw ROI
            [indexreport,reportitem]=funcAddToReport('ROI',reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(['Xmin:',num2str(xmin),'  Ymin:',num2str(ymin)],reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(['Xmax:',num2str(xmax),'  Ymax:',num2str(ymax)],reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
        end

        if (Analysis.Step>=2)&get(ctrl.CheckBreast,'Value')&get(ctrl.ShowAL,'value')
            plot((PreciseOutline.x+ROI.xmin-1)/Undersamplingfactor,(PreciseOutline.y+ROI.ymin-1)/Undersamplingfactor,'linewidth',LINEPLOTSIZE); %draw precise outline
        end

        if (Analysis.Step>=3)&get(ctrl.CheckBreast,'Value')
            [indexreport,reportitem]=funcAddToReport('Skin Detection',reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(['Breast Surface:',num2str(Analysis.Surface)],reportitem,indexreport);
            if ChestWallData.Valid
                Analysis.ValidBreastSurface=Analysis.Surface-ChestWallData.pixels;
                [indexreport,reportitem]=funcAddToReport(['!!! ChestWall selected!!! Surface:',num2str(ChestWallData.pixels),' pixels =',num2str(ChestWallData.pixels/Analysis.Surface*100),'% of the breast area'],reportitem,indexreport);
                [indexreport,reportitem]=funcAddToReport(['==> Valid breast surface:',num2str(Analysis.ValidBreastSurface),' pixels'],reportitem,indexreport);
            else
                Analysis.ValidBreastSurface=Analysis.Surface;
            end

            [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);

            if Threshold.Computed
                try
                    [indexreport,reportitem]=funcAddToReport('Threshold',reportitem,indexreport);
                    [indexreport,reportitem]=funcAddToReport(strcat('pixels:',num2str(Threshold.pixels),'  %:',num2str(Threshold.pixels/Analysis.ValidBreastSurface*100)),reportitem,indexreport);
                    [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
                    if Threshold.plotflag == 0   
                        plot((ROI.xmin+Threshold.boundary(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary(:,1)-1)/Undersamplingfactor,'.r', 'LineWidth', 0.5,'markersize',0.5);
                    else    
                        plot((ROI.xmin+Threshold.boundary15(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary15(:,1)-1)/Undersamplingfactor,'.r', 'LineWidth', 0.5,'markersize',0.5);
                        plot((ROI.xmin+Threshold.boundary30(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary30(:,1)-1)/Undersamplingfactor,'.b', 'LineWidth', 0.5,'markersize',0.5);
                        plot((ROI.xmin+Threshold.boundary45(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary45(:,1)-1)/Undersamplingfactor,'.y', 'LineWidth', 0.5,'markersize',0.5);
                    end
                end
            end
        else
            Analysis.ValidBreastSurface=Analysis.Surface;
        end

        if Threshold.DXAComputed
                try
                   plot((ROI.xmin+Threshold.boundary(:,2)-1)/Undersamplingfactor,(ROI.ymin+Threshold.boundary(:,1)-1)/Undersamplingfactor,'.r', 'LineWidth', 0.5,'markersize',0.5);
                    
                end
         end

        if Analysis.PhantomID < 7
            if Info.PhantomComputed;
                funcBox(Analysis.PhantomFatx(1)/Undersamplingfactor,Analysis.PhantomFaty(1)/Undersamplingfactor,Analysis.PhantomFatx(2)/Undersamplingfactor,Analysis.PhantomFaty(2)/Undersamplingfactor,'blue');
                funcBox(Analysis.PhantomLeanx(1)/Undersamplingfactor,Analysis.PhantomLeany(1)/Undersamplingfactor,Analysis.PhantomLeanx(2)/Undersamplingfactor,Analysis.PhantomLeany(2)/Undersamplingfactor,'blue');
                [indexreport,reportitem]=funcAddToReport('Wedgies phantom:',reportitem,indexreport);
                [indexreport,reportitem]=funcAddToReport(strcat('Lean:',' xmin:',num2str(Analysis.PhantomLeanx(1)),' xmax:',num2str(Analysis.PhantomLeanx(2)),' ymin:',num2str(Analysis.PhantomLeany(1)),' ymax:',num2str(Analysis.PhantomLeany(2))),reportitem,indexreport);
                [indexreport,reportitem]=funcAddToReport(strcat('Fat :',' xmin:',num2str(Analysis.PhantomFatx(1)),' xmax:',num2str(Analysis.PhantomFatx(2)),' ymin:',num2str(Analysis.PhantomFaty(1)),' ymax:',num2str(Analysis.PhantomFaty(2))),reportitem,indexreport);
                [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
            end
        elseif Analysis.PhantomID == 9
            if Info.StepPhantomComputed
               draw_phantom();
            end
        end
        
        if (Analysis.Step>=8)
            [indexreport,reportitem]=funcAddToReport('Density Computation:',reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Phantom Lean level: ',num2str(uint16(Analysis.Phantomleanlevel))),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Phantom Fat level : ',num2str(uint16(Analysis.Phantomfatlevel))),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Breast Density :',num2str(Analysis.DensityPercentage),' %'),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Total Fat Mass : ',num2str(Analysis.TotalFatMass),' g/cm3'),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Total Lean Mass : ',num2str(Analysis.TotalLeanMass),' g/cm3'),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Paddle Tilt Angle :',num2str(Analysis.Y_angle)),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Breast Thickness :',num2str(Analysis.ph_thickness),' cm'),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('Breast Volume :',num2str(Analysis.BreastVolume),' cm3'),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport(strcat('3DRecontruction Error :',num2str(Analysis.error_3DReconstruction)),reportitem,indexreport);
            [indexreport,reportitem]=funcAddToReport('',reportitem,indexreport);
        end

        %plot the freeform
        figure(figuretodraw);
       % if Info.Analysistype == 5
        %    set(figuretodraw, 'Visible','off');
        %end
        [indexreport,reportitem]=funcAddToReport('Free Forms',reportitem,indexreport);
        tsurface=0;
        for index=1:FreeForm.FreeFormnumber
            if FreeForm.FreeFormCluster(index).valid
                if ~DrawOption.ONLITTLEGRAPH
                    FreeForm.FreeFormCluster(index).patch=plot((FreeForm.FreeFormCluster(index).face(:,1))/Undersamplingfactor,(FreeForm.FreeFormCluster(index).face(:,2))/Undersamplingfactor,'color',FreeFormColor,'ButtonDownFcn',['FreeFromButtonDownFct(',num2str(index),')'],'linewidth',FREEFORMPLOTSIZE);
                else
                    plot((FreeForm.FreeFormCluster(index).face(:,1))/Undersamplingfactor,(FreeForm.FreeFormCluster(index).face(:,2))/Undersamplingfactor,'color',FreeFormColor,'linewidth',FREEFORMPLOTSIZE);
                end
                [indexreport,reportitem]=funcAddToReport(strcat('Surface:',num2str(FreeForm.FreeFormCluster(index).surface),' pixels'),reportitem,indexreport);
                tsurface=tsurface+FreeForm.FreeFormCluster(index).surface;
            end;
        end
        %give percentage of the contour /breast area for breast mode /ROI for phantom mode
        %{
        if get(ctrl.CheckBreast,'Value')            
            Analysis.ValidBreastSurface=Analysis.Surface-ChestWallData.pixels;
            Analysis.FreeFormResult=tsurface/Analysis.ValidBreastSurface*100;
            [indexreport,reportitem]=funcAddToReport(strcat('Total Surface:',num2str(tsurface),'pixels =',num2str(Analysis.FreeFormResult),'% of the breast area'),reportitem,indexreport);

        else
            [indexreport,reportitem]=funcAddToReport(strcat('Total Surface:',num2str(tsurface),'pixels =',num2str(tsurface/ROI.rows/ROI.columns*100),'% of the ROI area'),reportitem,indexreport);
        end;
        %}
        FreeForm.Area=tsurface;

        if flag.Debug
            if (Analysis.Step>=7)
                if get(ctrl.SFLI,'Value')
                    figure;imagesc(Analysis.ImageFatLean);
                end
            end
        end
        set(ctrl.SFLI,'Value',false);
        
        

        %%%%%%%%%%%%%%%%%%%%%%%% Phantom detected line
        try
            if (DrawOption.PHANTOMLINE)&(~Error.PhantomDetection)
                plot([Phantom.Point1(1) Phantom.Point2(1)]/Undersamplingfactor,[Phantom.Point1(2) Phantom.Point2(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point3(1) Phantom.Point1(1)]/Undersamplingfactor,[Phantom.Point3(2) Phantom.Point1(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point4(1) Phantom.Point5(1)]/Undersamplingfactor,[Phantom.Point4(2) Phantom.Point5(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point6(1) Phantom.Point7(1)]/Undersamplingfactor,[Phantom.Point6(2) Phantom.Point7(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point8(1) Phantom.Point2(1)]/Undersamplingfactor,[Phantom.Point8(2) Phantom.Point2(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point8(1) Phantom.Point2(1)]/Undersamplingfactor,[Phantom.Point8(2) Phantom.Point2(2)]/Undersamplingfactor,'Linewidth',1,'color','r');
                plot([Phantom.Point9(1) Phantom.Point10(1)]/Undersamplingfactor,[Phantom.Point9(2) Phantom.Point10(2)]/Undersamplingfactor,'Linewidth',1,'color','b');
                plot(Phantom.Line1(:,1)/Undersamplingfactor,Phantom.Line1(:,2)/Undersamplingfactor);
                plot(Phantom.Line2(:,1)/Undersamplingfactor,Phantom.Line2(:,2)/Undersamplingfactor);
            end
        end

        %%%%%%%%%%%%%%%%%% write the report %%%%%%%%%%%%%%%%%
        set(ctrl.rapport_zone,'string',reportitem,'HorizontalAlignment','left','value',1);

        %redraw the skin edge big point if the drawing was in progress
        if ManualEdge.DrawingInProgress
            SkinDetection('Redraw');
        end;
        if ChestWallData.Valid
            plot((ChestWallData.Curve(:,1)+ROI.xmin-1)/Undersamplingfactor,(ChestWallData.Curve(:,2)+ROI.ymin-1)/Undersamplingfactor,'linewidth',LINEPLOTSIZE,'color','r');
        end
       if(Analysis.Step>=2)&get(ctrl.CheckBreast,'Value')&get(ctrl.ShowAL,'value')

       end 
        
        drawnow;
    end
%end