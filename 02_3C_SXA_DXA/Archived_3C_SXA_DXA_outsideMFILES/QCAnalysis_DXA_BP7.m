%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXA_BP7(RequestedAction)%GammaROI

global dummyuicontrol2 f0 PhantomRefData  Image ROI

n1=3; % number of columns
n2=4; % number of lines

phantom_values = zeros(n1,n2); %ROI numbers, here 4 by 3.

PhantomRefData.LengthY = 100; % Lenght of the ROI on axis Y
PhantomRefData.LengthX = 100; % Lenght of the ROI on axis X
PhantomRefData.Draw.Compartments=n1*n2;
PhantomRefData.Draw.BorderX= 300; %distance from one ROI to the other on the X axis
PhantomRefData.Draw.BorderY=300;
PhantomRefData.Draw.MainBox= [PhantomRefData.LengthX + (n1-1)*PhantomRefData.Draw.BorderX,...
    PhantomRefData.LengthY + (n2-1)*PhantomRefData.Draw.BorderY];

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end


switch RequestedAction
    case 'INIT'
        Excel('INIT');
        PowerPoint('INIT');

    case 'ROOT'
        QCAnalysis_DXA_BP7('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXAblueVert(''Motion'')','WindowButtonDownFcn','nextpatient(1);');

        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXA_BP7('Hide');
        QCAnalysis_DXA_BP7('compute');
        Message('Ok...');

    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_DXA_BP7('Redraw');

    case 'InitDrawing' % what does it mean?
        PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:28
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end

    case 'Redraw'

        spacex=200; 
        spacey=200;
        
        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1)+spacex; 
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2)+spacey;
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:n2
            for x_index=1:n1
                X1=x1+PhantomRefData.Draw.BorderX*(x_index-1)+spacex/2;
                X2=X1+PhantomRefData.LengthX;

                Y1=y1+PhantomRefData.Draw.BorderY*(y_index-1)+spacex/2;
                Y2=Y1+PhantomRefData.LengthY;
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

        for y_index=1:n2 % repetition of rederaw parameters
            for x_index=1:n1
                ROI.X1=x1+PhantomRefData.Draw.BorderX*(x_index-1)+19;
                ROI.X2= ROI.X1+PhantomRefData.LengthX;
                ROI.Y1=y1+PhantomRefData.Draw.BorderY*(y_index-1)+18;
                ROI.Y2=ROI.Y1+PhantomRefData.LengthY;
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
%         Excel('INIT');
%         Excel('TRANSFERT',phantom_values2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
