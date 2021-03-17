%%% Aurelie 12/12/07 (rewrite the original file).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QCAnalysis_DXAtinyVert(RequestedAction)% Tiny Phantom Vertical
global dummyuicontrol2 f0 PhantomRefData  Image ROI

n1=3; % number of columns
n2=4; % number of lines

phantom_values = zeros(n1,n2); %ROI numbers, here 4 by 3.

PhantomRefData.LengthY = 65; % Lenght of the ROI on axis Y
PhantomRefData.LengthX = 15; % Lenght of the ROI on axis X
PhantomRefData.Draw.Compartments=n1*n2;
PhantomRefData.Draw.BorderX= 55;
PhantomRefData.Draw.BorderY=105;
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
        QCAnalysis_DXAtinyVert('InitDrawing');
        set(f0.handle,'WindowButtonMotionFcn','QCAnalysis_DXAtinyVert(''Motion'')','WindowButtonDownFcn','nextpatient(1);');

        set(dummyuicontrol2,'value',false);
        waitfor(dummyuicontrol2,'value',true);
        set(f0.handle,'WindowButtonMotionFcn','');
        set(f0.axisHandle,'ButtonDownFcn','');
        QCAnalysis_DXAtinyVert('Hide');
        QCAnalysis_DXAtinyVert('compute');
        Message('Ok...');

    case 'Motion'
        CurrentPoint=get(f0.axisHandle,'CurrentPoint');
        PhantomRefData.x0=CurrentPoint(1,1);PhantomRefData.y0=CurrentPoint(1,2);
        QCAnalysis_DXAtinyVert('Redraw');

    case 'InitDrawing' % what does it mean?
        PhantomRefData.MainBox=plot(0,0,'g','linewidth',1);
        for index=1:28
            PhantomRefData.Box(index)=plot(0,0,'g','linewidth',1);
        end

    case 'Redraw'

        x1=PhantomRefData.x0;
        x2=PhantomRefData.x0+PhantomRefData.Draw.MainBox(1)+38; % +38 and +36 are for the edge of the box
        y1=PhantomRefData.y0;
        y2=PhantomRefData.y0+PhantomRefData.Draw.MainBox(2)+36;
        set(PhantomRefData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
        count = 0;
        for y_index=1:n2
            for x_index=1:n1
                X1=x1+PhantomRefData.Draw.BorderX*(x_index-1)+19;
                X2=X1+PhantomRefData.LengthX;

                Y1=y1+PhantomRefData.Draw.BorderY*(y_index-1)+18;
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

                phantom_values(x_index,y_index) =mean(mean(Image.image(ROI.Y1:ROI.Y2,ROI.X1:ROI.X2)));

            end
        end

        phantom_values2 = zeros(n1*n2,n2);
        phantom_values2(:,3) = reshape(phantom_values',n1*n2,1); % note the ' for right reading order
        density_vect = repmat([0 50 80 100],1,n1);
        thickness_vect = [0.4 0.4 0.4 0.4 0.8 0.8 0.8 0.8 0.6 0.6 0.6 0.6];
        phantom_values2(:,1:2) = [thickness_vect',density_vect'];

        %% put the pixel values in an excel table
        Excel('INIT');
        Excel('TRANSFERT',phantom_values2);

end

