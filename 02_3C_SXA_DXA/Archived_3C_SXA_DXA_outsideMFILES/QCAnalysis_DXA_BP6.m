%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXA_BP(RequestedAction)%GammaROI
global dummyuicontrol2 ctrl f0 PhantomRefData Analysis Image ROI Info
global h_phantom  h_axis  J LeanHeightRefs  figuretodraw 
global X;
global CalibrationPoints;

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
phantom_values = zeros(7,4);
%FatGleanRefs(:,1) = [ 6.6500;4.7500; 2.8500; 0.9500;7.6000; 5.7000; 3.8000;1.90000];
heights = [1.14808; 1.88214; 2.59588; 3.23342; 3.96494; 4.67614; 5.55752; 6.27634; 7.0104];

    PhantomRefData.QuaterX = 250* k;
    PhantomRefData.QuaterY = 170* k;
    PhantomRefData.Draw.MainBox= [1000,1200] * k;
    PhantomRefData.Draw.Compartments=28;
    PhantomRefData.Draw.BorderY= 53 * k;
    PhantomRefData.Draw.BorderX= 68 * k; %13
    box_scale = 1;
      
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis_DXA_BP6('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXA(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXA_BP6('Hide');
        QCAnalysis_DXA_BP6('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_BP6('Redraw');
        
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
        
  
        for y_index=1:5
            for x_index=1:3
              if ~x_index %==1
                ROI.X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 20; %(y_index,x_index)
                ROI.X2=x1+PhantomRefData.QuaterX*x_index - 2 * PhantomRefData.Draw.BorderX + 10;
              else
                ROI.X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1);  
                 ROI.X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                ROI.Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);
                ROI.Y2=y1+PhantomRefData.QuaterY*y_index - PhantomRefData.Draw.BorderY;
                count = count + 1;
                
                   phantom_valuesLE(y_index,x_index) =mean(mean(Image.LE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   phantom_valuesHE(y_index,x_index) =mean(mean(Image.HE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   phantom_valuesRST(y_index,x_index) =mean(mean(Image.RST(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   
                
            end
        end   
        
         phantom_valuesLE = reshape(phantom_valuesLE,28,1);
         phantom_valuesHE = reshape(phantom_valuesHE,28,1);
         phantom_valuesRST = reshape(phantom_valuesRST,28,1);
        density_vect = repmat([100	76.92307692	69.23076923	61.53846154	57.69230769	46.15384615	23.07692308],1,4);
        thickness_vect = [5 5 5 5 5 5 5 4 4 4 4 4 4 4 2 2 2 2 2 2 2 3 3 3 3 3 3 3];
        phantom_values2 = [thickness_vect',density_vect', phantom_valuesLE, phantom_valuesHE, phantom_valuesRST]
         
%          
        [fname,pname]=uiputfile('Y:\Breast Studies\AL_SeleniaData\CalibrationFiles\*.txt');
        fid=fopen([pname fname],'wt');
        fprintf(fid,'%6.1f %12.2f %12.2f %12.2f %12.2f\n',phantom_values2');
        fclose(fid);
        
        %%plot the fitting plot:
        CalibrationPoints=load([pname fname]);

        Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)];
        
        Data(:,3)=Data(:,3)/1000;
        Data(:,4)=Data(:,4)/1000;

        Data(:,3)=Data(:,3)./Data(:,4);
        B=[Data(:,1) Data(:,2)];
        A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
        
        X=A\B

        Result=A*X
        figure;plot(Result(:,2),'o');hold on;
        plot(Data(:,2),'rx');
        ylabel('%Glandular');xlabel('ROI');

        Info.DXAAnalysisRetrieved = false;

        dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
        dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
        
        CalibrationPlot_Se_BP6()
        %         Excel('INIT');
        %         Excel('TRANSFERT',phantom_values2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
