%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_3CDXA51(RequestedAction)%GammaROI
global dummyuicontrol2 ctrl f0 PhantomRefData Analysis Image ROI Info
global h_phantom  h_axis  J LeanHeightRefs  figuretodraw file patient_ID 

%k = 150 / 169;
%k = 150 / 140;
%k = 1;
if Info.DigitizerId == 3
     k = 1;
 elseif Info.DigitizerId == 4
    k = 150 / 169;
 else
    k = 126/200;
end
phantom_values = zeros(9,6);
%FatGleanRefs(:,1) = [ 6.6500;4.7500; 2.8500; 0.9500;7.6000; 5.7000; 3.8000;1.90000];
heights = [1.14808; 1.88214; 2.59588; 3.23342; 3.96494; 4.67614; 5.55752; 6.27634; 7.0104];

    PhantomRefData.QuaterX = 125* k;
    PhantomRefData.QuaterY = 133* k;
    PhantomRefData.Draw.MainBox= [750,1200] * k;
    PhantomRefData.Draw.Compartments=54;
    PhantomRefData.Draw.BorderY= 50 * k;  %53
    PhantomRefData.Draw.BorderX= 37 * k; %13  68
    box_scale = 1;
      
if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
    

switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');
        
    case 'ROOT'
        QCAnalysis_3CDXA51('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_3CDXA51(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_3CDXA51('Hide');
        QCAnalysis_3CDXA51('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_3CDXA51('Redraw');
        
    case 'InitDrawing'
         PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:54
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
           
        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1);
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2);
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:9
            for x_index=1:6
              if ~x_index %==1
                X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 30; %(y_index,x_index) +PhantomRefData.Draw.BorderX
                X2=x1+PhantomRefData.QuaterX*x_index -2* PhantomRefData.Draw.BorderX +20; %
              else
                X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1); 
                 X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);;
                Y2=y1+PhantomRefData.QuaterY*y_index -PhantomRefData.Draw.BorderY;
                count = count + 1;
                set(PhantomRefData.Box(count),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
%                 plot(mean([Y1,Y2]),mean([X1,X2],x_index*y_index,'r'));
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
        
  
        for y_index=1:9
            for x_index=1:6
              if ~x_index %==1
                ROI.X1=x1 + PhantomRefData.QuaterX*(x_index-1)+ 30; %(y_index,x_index)
                ROI.X2=x1+PhantomRefData.QuaterX*x_index - 2 * PhantomRefData.Draw.BorderX + 20;
              else
                ROI.X1=x1+PhantomRefData.Draw.BorderX + PhantomRefData.QuaterX*(x_index-1);  
                 ROI.X2=x1+PhantomRefData.QuaterX*x_index -PhantomRefData.Draw.BorderX;
              end
               
                 
                ROI.Y1=y1+PhantomRefData.Draw.BorderY + PhantomRefData.QuaterY*(y_index-1);
                ROI.Y2=y1+PhantomRefData.QuaterY*y_index - PhantomRefData.Draw.BorderY;
                count = count + 1;
                
                   phantom_valuesLE(y_index,x_index) =mean(mean(Image.LE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   phantom_valuesHE(y_index,x_index) =mean(mean(Image.HE(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                  % phantom_valuesRST(y_index,x_index) =mean(mean(Image.RST(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));
                   
                
            end
        end   
       
         LE_vect = reshape(phantom_valuesLE',[],1);
         HE_vect = reshape(phantom_valuesHE',[],1);
         %phantom_valuesRST = reshape(phantom_valuesRST,48,1);
       % density_vect = repmat([100	76.92307692	69.23076923	61.53846154	57.69230769	46.15384615	23.07692308],1,4);
        water_vect = [60	60	30	30	10	10	60	60	30	30	10	10	45	45	20	20	12	12	45	45	20	20	12	12	30	30	20	20	8	8	30	30	20	20	8	8	40	40	15	15	5	5	40	40	15	15	5	5];
        wax_vect = [0	0	10	10	10	10	0	0	10	10	10	10	15	15	20	20	48	48	15	15	20	20	48	48	30	30	0	0	32	32	30	30	0	0	32	32	0	0	5	5	15	15	0	0	5	5	15	15];
        total_vect = [68.875	73.355	44.44	46.66	20	20.83	60	64.42	40	42.23	21.5	22.27	66.67	69.993	40	41.495	60	61.14	60	63.335	42.96	44.445	62.23	63.345	60	62.215	22.985	24.435	40	40.78	64.435	66.67	20	21.535	41.51	42.23	45.925	48.87	22.205	23.405	20	20.465	40	42.965	20	21.175	20.83	21.165];        
        
        water_vect = [60	60	30	30	10	10	60	60	30	30	10	10	45	45	20	20	12	12	45	45	20	20	12	12	30	30	20	20	8	8	30	30	20	20	8	8	40	40	15	15	5	5	40	40	15	15	5	5];
        wax_vect = [0	0	10	10	10	10	0	0	10	10	10	10	15	15	20	20	48	48	15	15	20	20	48	48	30	30	0	0	32	32	30	30	0	0	32	32	0	0	5	5	15	15	0	0	5	5	15	15];
        total_vect = [68.875	73.355	44.44	46.66	20	20.83	60	64.42	40	42.23	21.5	22.27	66.67	69.993	40	41.495	60	61.14	60	63.335	42.96	44.445	62.23	63.345	60	62.215	22.985	24.435	40	40.78	64.435	66.67	20	21.535	41.51	42.23	45.925	48.87	22.205	23.405	20	20.465	40	42.965	20	21.175	20.83	21.165];        

        WLT = [ 60	0	68.88;
                60	0	73.36;
                40	0	45.92;
                40	0	48.87;
                20	0	22.98;
                20	0	24.43;
                60	0	60;
                60	0	64.42;
                40	0	40;
                40	0	42.97;
                20	0	20;
                20	0	21.54;
                45	15	66.67;
                45	15	69.99;
                30	10	44.44;
                30	10	46.66;
                15	5	22.2;
                15	5	23.41;
                45	15	60;
                45	15	63.34;
                30	10	40;
                30	10	42.23
                15	5	20;
                15	5	21.18;
                30	30	60;
                30	30	62.22
                20	20	40;
                20	20	41.49;
                10	10	20;
                10	10	20.83;
                30	30	64.44;
                30	30	66.67;
                20	20	42.96;
                20	20	44.45;
                10	10	21.5;
                10	10	22.27;                
                15	45	60;
                15	45	61.14;
                10	30	40;
                10	30	40.78;
                5	15	20;
                5	15	20.47;
                15	45	62.23;
                15	45	63.34;
                10	30	41.51;
                10	30	42.23;
                5	15	20.83;
                5	15	21.16 ;  
                0  60   60;
                0  40   40;
                0  20   20;
          ];
        
         LE_vect(49) = mean(LE_vect(49:50));
         LE_vect(50) = mean(LE_vect(51:52));
         LE_vect(51) = mean(LE_vect(53:54));
         HE_vect(49) = mean(HE_vect(49:50));
         HE_vect(50) = mean(HE_vect(51:52));
         HE_vect(51) = mean(HE_vect(53:54));
         
         
         
         
         phantom_values2 = [WLT(:,1),WLT(:,2), LE_vect(1:51), HE_vect(1:51), WLT(:,3)];
         RHE_values2 = [LE_vect(1:51)./HE_vect(1:51), HE_vect(1:51), LE_vect(1:51)];
%        phantom_values2 = [water_vect',wax_vect', LE_vect, HE_vect, total_vect'];
% % % %          
       % [fname,pname]=uiputfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt');
        pname = file.startpath;
        [pathstr,name,ext] = fileparts(Image.fnameLE)
%     commented for temporary    
        fname = ['Calibration51point_',name,'auto_test.txt'];
        fid=fopen([pname fname],'wt');
        fprintf(fid,'%6.1f %12.2f %12.2f %12.2f %12.2f\n',phantom_values2');
        fclose(fid);
        Excel('INIT');
        Excel('TRANSFERT',RHE_values2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
