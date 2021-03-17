% skin detection
% 
% version 2g
% find a first rough skin detection with a min max metod
% then find a fitted ellise
%       merit function = distance to the outline curve
%       don't try to calculate analytic derivative = more changeable
% apply snake algorithm on this
%
%       Author Lionel HERVE 2/03
% 
%  revision history
%       19-2-03 don't try to calculate analytic derivative = more changeable
%       9-19-03 point mode created 
function skindetectionv2(RequestedAction,select)
global ROI 
global Analysis f0 ctrl Outline ManualEdge SkinEdge xy PreciseOutline Info Image flag Result BreastMask


warning off MATLAB:divideByZero
Analysis.Step=3;    

switch RequestedAction
    case 'SkinDetection'  %0
        set(f0.handle,'WindowButtonDownFcn','');      
        SkinDetectionv2('DeactivateFigureReaction',0);
        if get(ctrl.CheckAutoSkin,'value')
            Message('Computing skin edge...');                    
            %find outline 
            
            [Outline.x,Outline.y,error]=funcfindOutline(1-ROI.BackGround);
%            figure;plot(Outline.x,Outline.y,'b-');
            
            if error 
                Message('Failure: enable to find inner ellipse');                    
                Analysis.Step=1.5;    
                return;
            end
            
            [PreciseOutline,Analysis.Surface,Analysis.midcurve_p,Analysis.midpoint]=funcFindStuffOnOutline(Outline);
%             figure;plot(PreciseOutline.x,PreciseOutline.y,'b-');
%%added by Am 11162013
% if Analysis.Surface>=2550000
%     Message('Skin Detection Failed...');
%     stop;
% end;
            SkinROImatch();   
            draweverything;
            FuncActivateDeactivateButton;    
            BreastMask = [];
            [C,I]=max(Outline.x);
            Npoint=size(Outline.x,2);
            innerline1_x=Outline.x(1:I-1);
            innerline1_y=Outline.y(1:I-1);
            innerline2_x=Outline.x(Npoint:-1:Npoint-I+2);
            innerline2_y=Outline.y(Npoint:-1:Npoint-I+2);

            ImageDensity=0;
            y1=min(innerline2_y,innerline1_y);
            y2=max(innerline2_y,innerline1_y);

            MaskROI=zeros(size(ROI.image));
            for x=1:I-1
                MaskROI(y1(x):y2(x),x)=1;
            end
            BreastMask = MaskROI;
            Info.SkinDetection = true;
            flag.EdgeMode='Auto';
            Message('Ok');
        else   %Manual drawing
            DeactivateContour;
            FreezeButtons(ctrl,f0,Info);
            figure(f0.handle);
            axes(f0.axisHandle);
            ManualEdge.DrawingInProgress=1;
            ManualEdge.NumberPoints=0;
            ManualEdge.Points=[];
    
            % Initially, the list of points is empty.
            
            Message('Press LEFT button to ADD a new point and RIGHT button to FINISH');
            ok=true;
            hold on;
                   
            while ok
                k = waitforbuttonpress;
                point1 = get(f0.axisHandle,'CurrentPoint'); 
                if ~strcmp(get(f0.handle,'SelectionType'),'alt')
                    if (flipdim(point1(1,1:2),2)<size(Image.image))&(point1(1,1:2)>0)
                        ManualEdge.NumberPoints=ManualEdge.NumberPoints+1;                
                        ManualEdge.Points(ManualEdge.NumberPoints,:)=point1(1,1:2);
                        SkinEdge.handle(ManualEdge.NumberPoints)=plot(point1(1,1),point1(1,2),'EraseMode','xor','linestyle','none','marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','markersize',10);
                    end
                else
                    ManualEdge.DrawingInProgress=2;                
                    ok=false;
                    set(ctrl.text_zone,'String','Drag the point and press RIGHT when finished');    
                    SkinDetectionv2('SetBehavior',0);
                    SkinDetectionv2('DrawInterpolation',0);
                end
            end
        end
    case 'Redraw'  %6
        DeactivateContour;
        ManualEdge.NumberPoints=size(ManualEdge.Points,1);   %redefine ManualEdge.NumberPoints since it could be reach from a database call
        for index=1:ManualEdge.NumberPoints
             SkinEdge.handle(index)=plot(ManualEdge.Points(index,1),ManualEdge.Points(index,2),'EraseMode','xor','linestyle','none','marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','markersize',10);
        end
        if ManualEdge.DrawingInProgress==2      %when the points can be moved
            SkinDetectionv2('SetBehavior',0);      %set some behavior
            SkinDetectionv2('DrawInterpolation',0);
        end
    case 'SetBehavior' %7
        set(f0.handle,'WindowButtonDownFcn','SkinDetectionv2(''ButtonDownSkinModif'',0)');   
        for index=1:ManualEdge.NumberPoints
              set(SkinEdge.handle(index),'ButtonDownFcn',['SkinDetectionv2(''SetIndividualBehavior'',',num2str(index),')']);
        end
        SkinEdge.ContourHandle=plot([0],[0],'erasemode','xor','HitTest','off');
    case 'ButtonDownSkinModif'  %set the right button to end the drawing
        if strcmp(get(f0.handle,'SelectionType'),'alt')
            SkinDetectionv2('DeactivateFigureReaction',0);
            SkinDetectionv2('EndManualDrawing',0);
        end
    case 'DrawInterpolation'  %3
        %compel first and last point to be on the edge of the ROI
%       if ~Result.DXAProdigyCalculated
%        set(SkinEdge.handle(1),'xdata',ROI.xmin);
%        ManualEdge.Points(1,1)=ROI.xmin;
%        set(SkinEdge.handle(ManualEdge.NumberPoints),'xdata',ROI.xmin);
%        ManualEdge.Points(ManualEdge.NumberPoints,1)=ROI.xmin;  
%       end
%        ManualEdge.NumberPoints =  ManualEdge.NumberPoints +1;
%        ManualEdge.Points(ManualEdge.NumberPoints,1)= ManualEdge.Points(1,1);
%        ManualEdge.Points(ManualEdge.NumberPoints,2)= ManualEdge.Points(1,2);
%        ManualEdge.Curve=funcComputeInterpolationCurve(ManualEdge);
%        set(SkinEdge.ContourHandle,'xdata',ManualEdge.Curve(:,1),'ydata',ManualEdge.Curve(:,2))
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
          set(SkinEdge.handle(1),'xdata',ROI.xmin);
          ManualEdge.Points(1,1)=ROI.xmin;
          set(SkinEdge.handle(ManualEdge.NumberPoints),'xdata',ROI.xmin);
          ManualEdge.Points(ManualEdge.NumberPoints,1)=ROI.xmin;  
        
        if Result.DXAProdigyCalculated    
         ManualEdge.NumberPoints =  ManualEdge.NumberPoints +1;
         ManualEdge.Points(ManualEdge.NumberPoints,1)= ManualEdge.Points(1,1);
         ManualEdge.Points(ManualEdge.NumberPoints,2)= ManualEdge.Points(1,2);
        end
       ManualEdge.Curve=funcComputeInterpolationCurve(ManualEdge);
       set(SkinEdge.ContourHandle,'xdata',ManualEdge.Curve(:,1),'ydata',ManualEdge.Curve(:,2))
       %}
       
       
       
       
       
       
    case 'SetIndividualBehavior' %2   
        set(f0.handle,'WindowButtonUpFcn','SkinDetectionv2(''DeactivateFigureReaction'',0)');
        set(f0.handle,'WindowButtonMotionFcn',['SkinDetectionv2(''SetIndividualMoveBehavior'',',num2str(select),')']);
    case 'SetIndividualMoveBehavior'
        point1 = get(f0.axisHandle,'CurrentPoint');
        ManualEdge.Points(select,:)=point1(1,1:2);
        set(SkinEdge.handle(select),'xdata',point1(1,1),'ydata',point1(1,2));
        SkinDetectionv2('DrawInterpolation',0);
    case 'DeactivateFigureReaction'  %4
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
    case  'EndManualDrawing'  %1
        ManualEdge.DrawingInProgress=0;     
        set(f0.handle,'WindowButtonDownFcn','');          
        ManualEdge.Points=round(ManualEdge.Points);
        ManualEdge.Curve=funcComputeInterpolationCurve(ManualEdge);
        clear xy;
%         ROI=ROI2;
        xy=[round(ManualEdge.Curve(:,1)-ROI.xmin+1) round(ManualEdge.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
        
        if Result.DXAProdigyCalculated
            PreciseOutline.x = xy(:,1);
            PreciseOutline.y = xy(:,2);
            %BW = roipoly(ROI.image,PreciseOutline.x',PreciseOutline.y');
            %plot((PreciseOutline.x+ROI.xmin-1)/Undersamplingfactor,(PreciseOutline.y+ROI.ymin-1)/Undersamplingfactor,'linewidth',LINEPLOTSIZE); %draw precise outline
            Analysis.Step = 2;
            %imshow(ROI.image);
            %figure;%(ctrl.roi);
            %imagesc(BW); colormap(gray);
        else
            xy(1,1)=1;   %put the first and the last point to the edge of the ROI region
            xy(size(xy,1),1)= 1;
            [xy(:,1),xy(:,2)]=funcclipping(xy(:,1),xy(:,2),ROI.rows,ROI.columns);       %clip to the ROI


            %modify the curve in order there just remain 2 points per abscisse
            Outline1=funcSemiEdgeComputation(xy);  %find the first part of the curve (increasing x)
            xy=flipdim(xy,1);
            Outline2=flipdim(funcSemiEdgeComputation(xy),1); %find the second part of the curve (decreasing x)
            I=size(Outline1,1);
            Outline.x=[Outline1(:,1)' Outline2(1,1)+1 Outline2(:,1)'];
            Outline.y=round([Outline1(:,2)' round((Outline1(I,2)+Outline2(1,2))/2)+1  Outline2(:,2)']);
            [Outline,PreciseOutline,Analysis.Surface,Analysis.midcurve_p,Analysis.midpoint]=funcFindStuffOnOutlinePointsDrawing(Outline);
            %draweverything;
        end
%         SkinROImatch();
        draweverything;
        FuncActivateDeactivateButton;    
        flag.EdgeMode='Manual';
         BreastMask = [];
          [C,I]=max(Outline.x);
            Npoint=size(Outline.x,2);
            innerline1_x=Outline.x(1:I-1);
            innerline1_y=Outline.y(1:I-1);
            innerline2_x=Outline.x(Npoint:-1:Npoint-I+2);
            innerline2_y=Outline.y(Npoint:-1:Npoint-I+2);

            ImageDensity=0;
            y1=min(innerline2_y,innerline1_y);
            y2=max(innerline2_y,innerline1_y);

            MaskROI=zeros(size(ROI.image));
            for x=1:I-1
                MaskROI(y1(x):y2(x),x)=1;
            end
            BreastMask = MaskROI;
            Info.SkinDetection = true;
            %figure;
            %imagesc(BreastMask);colormap(gray);
        Message('Ok');
end
   
    % im = 1-ROI.BackGround;
           %figure; imagesc(im); colormap(gray);hold on;
           %plot(Outline.x,Outline.y,'r-');
           
            %{
            im = 1-ROI.BackGround;
            L = bwlabel(im);
            stats = regionprops(L,'all');
            figure;
            imagesc(stats.Image);colormap(gray);hold on;
            plot(stats.Centroid(1),stats.Centroid(2), '*r');
            a  = 1;
            %}
             
             % periphery region
             %{
            % figure; imagesc(im); colormap(gray);
            %
             im = 1- ROI.BackGround;
             distbw =  bwdist(1-im);
             figure; imagesc(distbw); colormap(gray);
            % figure; imagesc(L); colormap(gray);
             %bw = Zs1>0.3*max(max(Zs1));
             periph2 = 1 - (distbw < 77);
             figure; imagesc(periph2); colormap(gray);
             periph = im.*(distbw < 77);
             figure; imagesc(periph); colormap(gray);
             [Outline_inner.x,Outline_inner.y,error]=funcfindOutline(periph2);
             figure;plot(Outline.x,Outline.y, '-r', Outline_inner.x,Outline_inner.y,'-b');
                
             av = 1;
             %}
              
            %figure;plot(Outline.x, Outline.y);hold;
            
           % [Outline.x,Outline.y,error]=funcfindOutline(1-ROI.BackGround);
           %  plot(Outline.x,Outline.y,'-b');
     %{
            xsm = smooth(Outline.x,5);
            ysm = smooth(Outline.y,5);
             % figure;plot(Outline.x, Outline.y);
           % d = diff(Outline.x);
           % d = gradient(Outline.x);
           % plot(diff(Outline.x), Outline.y(1:end-1));
            yp = gradient(xsm)./gradient(ysm);
           %figure;plot(yp, Outline.y);
           ypp = gradient(yp)./gradient(ysm);
           % figure;plot(ypp, Outline.y);
            k1 = abs(ypp)./ ((1+ yp.*yp).^(3/2));
             figure;plot(k1, ysm);
            %}