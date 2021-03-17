%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXAthinHoriz(RequestedAction)%GammaROI
global dummyuicontrol2 ctrl f0 PhantomRefData Analysis Image ROI Info
global h_phantom  h_axis  J LeanHeightRefs  figuretodraw 

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
%FatGleanRefs(:,1) = [ 6.6500;4.7500; 2.8500; 0.9500;7.6000; 5.7000; 3.8000;1.90000];
heights = [1.14808; 1.88214; 2.59588; 3.23342; 3.96494; 4.67614; 5.55752; 6.27634; 7.0104];
    scale_coef = 1.5; 
    %{
    PhantomRefData.QuaterX = round(125* k/scale_coef);
    PhantomRefData.QuaterY = round(250* k/scale_coef);
    PhantomRefData.Draw.MainBox= round([630,800] * k/scale_coef);
    PhantomRefData.Draw.Compartments=15;
    PhantomRefData.Draw.BorderY= round(53 * k/scale_coef);
    PhantomRefData.Draw.BorderX= round(35 * k/scale_coef); 
    %}
    PhantomRefData.QuaterY = round(125* k/scale_coef);
    PhantomRefData.QuaterX = round(250* k/scale_coef);
    PhantomRefData.Draw.MainBox= round([800,630] * k/scale_coef);
    PhantomRefData.Draw.Compartments=15;
    PhantomRefData.Draw.BorderX= round(53 * k/scale_coef);
    PhantomRefData.Draw.BorderY= round(35 * k/scale_coef); 
    %13
    box_scale = 1;
      
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis_DXAthinHoriz('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXAthinHoriz(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXAthinHoriz('Hide');
        QCAnalysis_DXAthinHoriz('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_DXAthinHoriz('Redraw');
        
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
        for y_index=1:5
            for x_index=1:3
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
       % set(ctrl.CheckBreast,'value',true);
        x1= round(PhantomRefData.x0);
        x2=round(PhantomRefData.x0+PhantomRefData.Draw.MainBox(1));
        y1=round(PhantomRefData.y0);
        y2=round(PhantomRefData.y0+PhantomRefData.Draw.MainBox(2));
        count = 0;
        
  
        for y_index=1:5
            for x_index=1:3
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
                   
                 phantom_valuesLE(y_index,x_index) =mean(mean(Image.LE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                 phantom_valuesHE(y_index,x_index) =mean(mean(Image.HE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                 phantom_valuesRST(y_index,x_index) =mean(mean(Image.RST(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));   
                   % else
               %    FatGleanRefs(count-8,3) =mean(mean(J(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                %end
                   %set(QCAnalysisData.Box(count),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
                
            end
        end     
        
         phantom_valuesLE = reshape(phantom_valuesLE,15,1);
         phantom_valuesHE = reshape(phantom_valuesHE,15,1);
         phantom_valuesRST = reshape(phantom_valuesRST,15,1);
                
        phantom_values2 = zeros(15,3);
%         phantom_values2(:,3) = reshape(phantom_values,15,1);
%         density_vect = repmat([0 50 100],1,5);
        density_vect = repmat([100 61.54 23.08],1,5);
        thickness_vect = [0.2 0.2 0.2];
        for i=2:5
            thickness_vect = [thickness_vect, [i i i]*0.2];
        end
%         phantom_values2(:,1:2) = [thickness_vect',density_vect',];
        phantom_values2 = [thickness_vect',density_vect', phantom_valuesLE, phantom_valuesHE, phantom_valuesRST]
        % DensityResults{3,2} = fresult.p1;
        %Analysis.LeanHeightRefs(:,1) =heights; %sortrows(FatGleanRefs,1);
        %Analysis.LeanHeightRefs(:,2) = a';
        
        Excel('INIT');
        Excel('TRANSFERT',phantom_values2);
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
