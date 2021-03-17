function GammaROI(RequestedAction)
global dummyuicontrol2 ctrl f0 PhantomRefData Analysis Image ROI
global h_phantom  h_axis  J  FatGleanRefs figuretodraw

%k = 150 / 169;
k = 150 / 140;
%k = 1;
FatGleanRefs = zeros(8,3);
FatGleanRefs(:,1) = [ 6.6500;4.7500; 2.8500; 0.9500;7.6000; 5.7000; 3.8000;1.90000];
    thickness = 1.5;
    PhantomRefData.BoxY = round((198 + 6 * (thickness-3))* k) ;
    PhantomRefData.BoxX = round((205 + 2.5 * (thickness-3))* k);
    PhantomRefData.QuaterX = round(PhantomRefData.BoxX / 4)-5;
    PhantomRefData.QuaterY = round(PhantomRefData.BoxY / 4)-1;;
    PhantomRefData.Draw.MainBox= [PhantomRefData.BoxY+5,round(PhantomRefData.BoxX)* k +10];
    PhantomRefData.Draw.Compartments=16;
    PhantomRefData.Draw.BorderY= 14 * k;
    PhantomRefData.Draw.BorderX= 13 * k;

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
         h_phantom = figure;
         h_axis = axes;
        GammaROI('InitDrawing');
        %set(f0.handle,'WindowButtonMotionFcn','QCAnalysis(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
         set(h_phantom,'WindowButtonMotionFcn','GammaROI(''Motion'')','WindowButtonDownFcn','nextpatient(1);');       
        set(dummyuicontrol2,'value',false);
        GammaROI('Redraw');
        waitfor(dummyuicontrol2,'value',true);
       % set(f0.handle,'WindowButtonMotionFcn','');
       % set(f0.axisHandle,'ButtonDownFcn','');
        set(h_phantom,'WindowButtonMotionFcn','');
        set(h_axis,'ButtonDownFcn','');
       
      %  GammaROI('Hide');
        GammaROI('compute');
        Message('Ok...');
        
    case 'Motion'
        %CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        CurrentPoint=get(h_axis,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        GammaROI('Redraw');

    case 'InitDrawing'
         rot_image = Image.image(1:620,690:end);
        % rot_image2 = uint8(Image.image(1:420,690:end)/126000*255);
       %  imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
      %{
         [X1, Y] = bbs_position;
         X = X1 + 689;
         len = length(X);
         figure(figuretodraw); hold on;
          for i=1:len
            plot(X(i),Y(i),'.b','MarkerSize',7); hold on;
          end
      %} 
         J = imrotate(rot_image,-32,'bilinear'); %,'crop'28.85 -33
         rot_image2 = uint8(J/126000*255);
       % figure;
        figure(h_phantom);
        imagesc(J); colormap(gray); hold on;
       % imwrite(rot_image2,'C:\MATLAB7\toolbox\SDC Morphology Toolbox for MATLAB 1.3\phan3.tif', 'tif');
       %[BW,thresh] = edge(J,'canny',[ ],3);
       % BW = bwmorph(J,'skel',Inf);
     % se = strel('disk',15);
     %  J1 = imtophat(J,se);
      %  J1= imadjust(J-J1);
      
       % background = imopen(J,strel('disk',15));%figure, imshow(J)
       %BW = edge(J,'log',0.9);
       % J1=J-background;
        %background = imopen(J,strel('disk',15));%figure, imshow(J)
        %J1=J-background;
       %J1 = imadjust(J,[0 1], [0 1]);
       %figure;
       %imagesc(J1); colormap(gray); 
        %J1 = J1(J1 > 8000);
       % J1=(J1>7000).*J1;
     %   figure(h_phantom);
       % level = graythresh(J1);
      % sz = size(J1);
       %index = find(J1>200);
       %im = zeros(sz);
       %im(index) = 1;
      % BW = im2bw(J1,level);
      % BW = edge(J1,'log',0.1);
      % imagesc(im); colormap(gray); hold on;
       
        PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:16
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
         CurrentPoint=get(h_axis,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1);
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2);
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:4
            for x_index=1:4
              if x_index==1
                X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20; %(y_index,x_index) +PhantomRefData.Draw.BorderX
                X2=x1+PhantomRefData.QuaterX*x_index -2* PhantomRefData.Draw.BorderX +10; %
              else
                X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1); 
                 X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);;
                Y2=y1+PhantomRefData.QuaterY*y_index -PhantomRefData.Draw.BorderY;
                count = count + 1;
                set(PhantomRefData.Box(count),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
            end
        end
        
    case 'Hide'
        set(PhantomRefData.MainBox,'xdata',0,'ydata',0);
        for index=1:PhantomRefData.Draw.Compartments
            set(PhantomRefData.Box(index),'xdata',0,'ydata',0);
        end
        
    case 'compute'
       % set(ctrl.CheckBreast,'value',true);
        x1= round(PhantomRefData.x0);
        x2=round(PhantomRefData.x0+PhantomRefData.Draw.MainBox(1));
        y1=round(PhantomRefData.y0);
        y2=round(PhantomRefData.y0+PhantomRefData.Draw.MainBox(2));
        count = 0;
        
  
        for y_index=1:4
            for x_index=1:4
              if x_index==1
                ROI.X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20; %(y_index,x_index)
                ROI.X2=x1+PhantomRefData.QuaterX*x_index - 2 * PhantomRefData.Draw.BorderX + 10;
              else
                ROI.X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1);  
                 ROI.X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                ROI.Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);
                ROI.Y2=y1+PhantomRefData.QuaterY*y_index - PhantomRefData.Draw.BorderY;
                count = count + 1;
                if count < 9
                   FatGleanRefs(count,2) =mean(mean(J(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                else
                   FatGleanRefs(count-8,3) =mean(mean(J(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                end
                   %set(QCAnalysisData.Box(count),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
                
            end
        end     
        a =  FatGleanRefs(1:4,3);
        FatGleanRefs(1:4,3) = FatGleanRefs(5:8,3);
        FatGleanRefs(5:8,3) =  a;
        Analysis.FatGleanRefs = sortrows(FatGleanRefs,1);
        Excel('INIT');
        Excel('TRANSFERT',Analysis.FatGleanRefs);
end