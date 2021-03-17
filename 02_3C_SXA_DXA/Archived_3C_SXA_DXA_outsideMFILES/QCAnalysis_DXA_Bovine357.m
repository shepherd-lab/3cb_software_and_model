%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXA_Bovine357(RequestedAction)%GammaROI
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

    PhantomRefData.QuaterX = 220* k;
    PhantomRefData.QuaterY = 220* k;
    PhantomRefData.Draw.MainBox= [750,1300] * k;
    PhantomRefData.Draw.Compartments=28;
    PhantomRefData.Draw.BorderY= 85 * k;
    PhantomRefData.Draw.BorderX= 48 * k; %13
    box_scale = 1;
      
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis_DXA_Bovine357('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXA_Bovine357(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXA_Bovine357('Hide');
        QCAnalysis_DXA_Bovine357('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_DXA_Bovine357('Redraw');
        
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
                Y2=y1+PhantomRefData.QuaterY*y_index -PhantomRefData.Draw.BorderY + 65;
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
                ROI.Y2=y1+PhantomRefData.QuaterY*y_index - PhantomRefData.Draw.BorderY + 65;
                count = count + 1;
                
                   phantom_valuesLE(y_index,x_index) =mean(mean(Image.LE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   phantom_valuesHE(y_index,x_index) =mean(mean(Image.HE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   phantom_valuesRST(y_index,x_index) =mean(mean(Image.RST(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   
                
            end
        end   
        
         phantom_valuesLE2 = reshape(phantom_valuesLE',15,1);
         phantom_valuesHE2 = reshape(phantom_valuesHE',15,1);
         phantom_valuesRST2 = reshape(phantom_valuesRST',15,1);
% %          bovine_lean = [0.00	0.00	0.00	2.36	1.43	0.68	2.95	1.89	1.04	6.05	4.03	2.01	4.75	2.55	1.31]'*10;
% %          bovine_fat = [6.05	4.03	2.01	3.69	2.60	1.33	3.10	2.14	0.97	0.00	0.00	0.00	1.30	1.48	0.70]'*10;
% %          bovine_water = [0.79	0.53	0.26	2.39	1.49	0.72	2.79	1.81	0.97	4.90	3.26	1.63	4.02	2.26	1.15]'*10;
% %          bovine_lipid = [5.17	3.44	1.72	3.18	2.24	1.15	2.69	1.85	0.84	0.07	0.05	0.02	1.17	1.30	0.61]'*10;
% %          bovine_total = [6.05	4.03	2.01	6.05	4.03	2.01	6.05	4.03	2.01	6.05	4.03	2.01	6.05	4.03	2.01]'*10;
      %%% from Malloi paper
%          bovine_lean = [0.00	0.00	0.00	1.30	1.48	0.70	3.10	2.14	0.97	6.05	4.03	2.01	3.69	2.60	1.33]';
%          bovine_fat = [6.05	4.03	2.01	4.75	2.55	1.31	2.95	1.89	1.04	0.00	0.00	0.00	2.36	1.42	0.68]';
%          bovine_water = [7.86	5.23	2.62	16.70	15.29	7.37	28.95	19.79	9.20	49.00	32.61	16.31	32.93	22.93	11.69]';
%          bovine_lipid = [51.73	34.43	17.21	40.78	21.96	11.32	25.58	16.38	9.05	0.73	0.48	0.24	20.66	12.48	5.96]';
%          bovine_total = [ 60.50	40.27	20.13	60.50	40.27	20.13	60.50	40.27	20.13	60.50	40.27	20.13	60.50	40.27	20.13]';
        %%%from Anresco
         bovine_lean = [0.00	0.00	0.00	5.22	3.83	1.96	4.28	2.53	1.47	6.94	4.91	2.92	2.09	1.45	0.68]';
         bovine_fat = [6.94	4.91	2.92	1.72	1.08	0.96	2.66	2.38	1.45	0.00	0.00	0.00	4.85	3.46	2.24]';
         bovine_water = [0.00	0.00	0.00	39.20	28.78	14.70	32.11	19.01	11.05	52.08	36.84	21.94	15.68	10.90	5.13]';
         bovine_lipid = [69.40	49.10	29.23	17.47	10.98	9.76	26.87	23.92	14.59	0.42	0.29	0.18	48.63	34.66	22.44]';
         bovine_total = [69.40	49.10	29.23	69.40	49.10	29.23	69.40	49.10	29.23	69.40	49.10	29.23	69.40	49.10	29.23]';
 
        phantom_values2 = [bovine_water, bovine_lipid,  phantom_valuesLE2, phantom_valuesHE2, bovine_total, phantom_valuesRST2,bovine_lean, bovine_fat]
       
%          
        [fname,pname]=uiputfile('\\researchstg\Breast Studies\3CB R01\Source Data\Bovine_experiment\E3CB20160201\Serghei_calibration_points\*.txt');
        fid=fopen([pname fname],'wt');
        fprintf(fid,'%6.1f %12.2f %12.2f %12.2f %12.2f %12.4f %12.2f %12.2f\n',phantom_values2');
        fclose(fid);
        
% %         %%plot the fitting plot:
% %         CalibrationPoints=load([pname fname]);
% % 
% %         Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)];
% %         
% %         Data(:,3)=Data(:,3)/1000;
% %         Data(:,4)=Data(:,4)/1000;
% % 
% %         Data(:,3)=Data(:,3)./Data(:,4);
% %         B=[Data(:,1) Data(:,2)];
% %         A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
% %         
% %         X=A\B
% % 
% %         Result=A*X
% %         figure;plot(Result(:,2),'o');hold on;
% %         plot(Data(:,2),'rx');
% %         ylabel('%Glandular');xlabel('ROI');
% % 
% %         Info.DXAAnalysisRetrieved = false;
% % 
% %         dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
% %         dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
        
%         CalibrationPlot_Se_BP6()
        %         Excel('INIT');
        %         Excel('TRANSFERT',phantom_values2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
