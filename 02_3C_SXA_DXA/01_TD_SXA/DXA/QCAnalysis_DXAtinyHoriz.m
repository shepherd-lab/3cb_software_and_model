%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXAtinyHoriz(RequestedAction)%GammaROI
global dummyuicontrol2 f0 PhantomRefData  Image ROI Info

%k = 150 / 169;
%k = 150 / 140;
%k = 1;
if Info.DigitizerId == 3
     k = 1;
 elseif Info.DigitizerId == 4
    k = 150 / 169;
 else
    k = 150/140 ;
end

phantom_values = zeros(3,5);


    scale_coef = 1.5; 
    
%     PhantomRefData.QuaterY = round(125* k/scale_coef); %125
%     PhantomRefData.QuaterX = round(250* k/scale_coef);
%     PhantomRefData.Draw.MainBox= round([800,630] * k/scale_coef);
%     PhantomRefData.Draw.Compartments=15;
%     PhantomRefData.Draw.BorderX= round(53 * k/scale_coef); %53
%     PhantomRefData.Draw.BorderY= round(100 * k/scale_coef); 
   
    PhantomRefData.QuaterY = round(100); %125
    PhantomRefData.QuaterX = round(10);
    PhantomRefData.Draw.MainBox= round([800,630] * k/scale_coef);
    PhantomRefData.Draw.Compartments=15;
    PhantomRefData.Draw.BorderX= round(100); %53
    PhantomRefData.Draw.BorderY= round(100); 
    
    
    box_scale = 1;
      
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis_DXAtinyHoriz('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXAtinyHoriz(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXAtinyHoriz('Hide');
        QCAnalysis_DXAtinyHoriz('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_DXAtinyHoriz('Redraw');
        
    case 'InitDrawing'
         PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:28
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
           
        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1);
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2);
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:3
            for x_index=1:4
              if ~x_index %==1
                %X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20/2; %(y_index,x_index) +PhantomRefData.Draw.BorderX
                %X2=x1+PhantomRefData.QuaterX*x_index -2* PhantomRefData.Draw.BorderX +10/2; %
                X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20/2; %(y_index,x_index) +PhantomRefData.Draw.BorderX
                X2=x1+PhantomRefData.QuaterX*x_index -2* PhantomRefData.Draw.BorderX +10/2; %
              
              else
                X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1); 
                 X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);
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
        x1= round(PhantomRefData.x0);
        x2=round(PhantomRefData.x0+PhantomRefData.Draw.MainBox(1));
        y1=round(PhantomRefData.y0);
        y2=round(PhantomRefData.y0+PhantomRefData.Draw.MainBox(2));
        count = 0;
        
  
      for y_index=1:3
            for x_index=1:4
              if ~x_index %==1
                ROI.X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20/2; %(y_index,x_index)
                ROI.X2=x1+PhantomRefData.QuaterX*x_index - 2 * PhantomRefData.Draw.BorderX + 10/2;
              else
                ROI.X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1);  
                 ROI.X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                ROI.Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);
                ROI.Y2=y1+PhantomRefData.QuaterY*y_index - PhantomRefData.Draw.BorderY;
                count = count + 1;
                %if count < 9
                   phantom_values(x_index,y_index) =mean(mean(Image.image(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   
                   % else
               %    FatGleanRefs(count-8,3) =mean(mean(J(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                %end
                   %set(QCAnalysisData.Box(count),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
                
            end
        end     
        phantom_values2 = zeros(15,3);
        phantom_values2(:,3) = reshape(phantom_values,15,1);
        density_vect = repmat([0 50 100],1,5);
        thickness_vect = [0.2 0.2 0.2];
        for i=2:5
            thickness_vect = [thickness_vect, [i i i]*0.2];
        end
        phantom_values2(:,1:2) = [thickness_vect',density_vect'];
        
%         to put again when it works
%         Excel('INIT');
%         Excel('TRANSFERT',phantom_values2);
        
end

