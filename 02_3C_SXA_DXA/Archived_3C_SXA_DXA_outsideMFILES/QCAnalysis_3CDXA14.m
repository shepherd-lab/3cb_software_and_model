%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_3CDXA14(RequestedAction)%GammaROI
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
    k = 150/140 ;
end
phantom_values = zeros(8,6);
%FatGleanRefs(:,1) = [ 6.6500;4.7500; 2.8500; 0.9500;7.6000; 5.7000; 3.8000;1.90000];
heights = [1.14808; 1.88214; 2.59588; 3.23342; 3.96494; 4.67614; 5.55752; 6.27634; 7.0104];

    PhantomRefData.QuaterX = 125* k;
    PhantomRefData.QuaterY = 133* k;
    PhantomRefData.Draw.MainBox= [750,1050] * k;
    PhantomRefData.Draw.Compartments=48;
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
        QCAnalysis_3CDXA14('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_3CDXA14(''Motion'')','WindowButtonDownFcn','nextpatient(1);');
       
        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_3CDXA14('Hide');
        QCAnalysis_3CDXA14('compute');
        Message('Ok...');
            
    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_3CDXA14('Redraw');
        
    case 'InitDrawing'
         PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:48
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end
        
    case 'Redraw'
           
        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1);
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2);
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:8
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
        
  
        for y_index=1:8
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
% % %         water_vect = [60	60	30	30	10	10	60	60	30	30	10	10	45	45	20	20	12	12	45	45	20	20	12	12	30	30	20	20	8	8	30	30	20	20	8	8	40	40	15	15	5	5	40	40	15	15	5	5];
% % %         wax_vect = [0	0	10	10	10	10	0	0	10	10	10	10	15	15	20	20	48	48	15	15	20	20	48	48	30	30	0	0	32	32	30	30	0	0	32	32	0	0	5	5	15	15	0	0	5	5	15	15];
% % %         total_vect = [68.875	73.355	44.44	46.66	20	20.83	60	64.42	40	42.23	21.5	22.27	66.67	69.993	40	41.495	60	61.14	60	63.335	42.96	44.445	62.23	63.345	60	62.215	22.985	24.435	40	40.78	64.435	66.67	20	21.535	41.51	42.23	45.925	48.87	22.205	23.405	20	20.465	40	42.965	20	21.175	20.83	21.165];        
% % %         
% % %         water_vect = [60	60	30	30	10	10	60	60	30	30	10	10	45	45	20	20	12	12	45	45	20	20	12	12	30	30	20	20	8	8	30	30	20	20	8	8	40	40	15	15	5	5	40	40	15	15	5	5];
% % %         wax_vect = [0	0	10	10	10	10	0	0	10	10	10	10	15	15	20	20	48	48	15	15	20	20	48	48	30	30	0	0	32	32	30	30	0	0	32	32	0	0	5	5	15	15	0	0	5	5	15	15];
% % %         total_vect = [68.875	73.355	44.44	46.66	20	20.83	60	64.42	40	42.23	21.5	22.27	66.67	69.993	40	41.495	60	61.14	60	63.335	42.96	44.445	62.23	63.345	60	62.215	22.985	24.435	40	40.78	64.435	66.67	20	21.535	41.51	42.23	45.925	48.87	22.205	23.405	20	20.465	40	42.965	20	21.175	20.83	21.165];        

%%%24 points 2, 4 and 6 cm and 305 protein
%         WLT = [60	0	60
% 40	0	40
% 20	0	20
% 45	15	60
% 30	10	40
% 15	5	20
% 30	30	60
% 20	20	40
% 10	10	20
% 15	45	60
% 10	30	40
% 5	15	20
% 20	0	24.43
% 40	0	48.87
% 45	15	69.99
% 30	10	46.66
% 30	30	66.67
% 20	20	44.45
% 60	0	73.36
% 15	45	63.34
% 10	30	42.23
% 10	10	22.27
% 15	5	23.41
% 5	15	21.16
% ];
% index = [7	9	11	19	21	23	25	27	29	37	39	41	6	4	14	16	32	34	2	44	46	36	18	48];

%%%16 points 2, 4 cm and 30% protein
%  WLT = [
% 40	0	48.87
% 40	0	40
% 30	10	46.66
% 30	10	40
% 20	20	44.45
% 20	20	40
% 10	30	42.23
% 10	30	40
% 20	0	24.43
% 20	0	20
% 15	5	23.41
% 15	5	20
% 10	10	22.27
% 10	10	20
% 5	15	21.16
% 5	15	20
%  ];          
%   
% index = [4	9	16	21	34	27	46	39	6	11	18	23	36	29	48	41];

%%%24 points 2, 4 cm and 15, 30% protein
 WLT = [
40	0	48.87
40	0	44.445
40	0	40
30	10	46.66
30	10	43.335
30	10	40
20	20	44.45
20	20	42.225
20	20	40
10	30	42.23
10	30	41.145
10	30	40
20	0	24.43
20	0	22.26
20	0	20
15	5	23.41
15	5	21.69
15	5	20
10	10	22.27
10	10	21.165
10	10	20
5	15	21.16
5	15	20.65
5	15	20
 ];        

index = [4	3	9	16	15	21	34	33	27	46	45	39	6	5	11	18	17	23	36	35	29	48	47	41];

%          LE_vect(49) = mean(LE_vect(49:50));
%          LE_vect(50) = mean(LE_vect(51:52));
%          LE_vect(51) = mean(LE_vect(53:54));
%          HE_vect(49) = mean(HE_vect(49:50));
%          HE_vect(50) = mean(HE_vect(51:52));
%          HE_vect(51) = mean(HE_vect(53:54));
            
            
% % % it was before
% % % 12	48	60;
% % % 12	48	61.14;
% % % 8	32	40;
% % % 8	32	40.78;
% % % 5	15	20;
% % % 5	15	20.47;
% % % 12	48	62.23;
% % % 12	48	63.34;
% % % 8	32	41.51;
% % % 8	32	42.23;
% % % 5	15	20.83;
% % % 5	15	21.16 ;  
            
          LE_vect = LE_vect(index);
          HE_vect = HE_vect(index);
          phantom_values2 = [WLT(:,1),WLT(:,2), LE_vect, HE_vect, WLT(:,3)];
% %          if Info.kVp > 29 
% %              %phantom_values2([ 2 41 42 47 48],:) = [];
% %              phantom_values2([ 2 8 42 47 48 ],:) = [];
% %          else
% %              phantom_values2([ 2 8],:) = [];
% %          end
% % % %        phantom_values2 = [water_vect',wax_vect', LE_vect, HE_vect, total_vect'];
% % % %          
       % [fname,pname]=uiputfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt');
        pname = file.startpath;
        [pathstr,name,ext] = fileparts(Image.fnameLE)
        
        fname = ['Calibration_',name,'WLT_24points_24cm.txt'];
  %      fname = ['Calibration_',name,'WLT48.txt'];
        fid=fopen([pname fname],'wt');
        fprintf(fid,'%6.1f %12.2f %12.2f %12.2f %12.2f\n',phantom_values2');
        fclose(fid);
%         Excel('INIT');
%         Excel('TRANSFERT',phantom_values2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
