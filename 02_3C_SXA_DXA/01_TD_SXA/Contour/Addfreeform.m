%free form
%author lionel HERVE
%Allow operator to draw a free form
%3-24-03
%modification
%5-15-03 AddFreeForm - EndFreeForm merged
%5-16-03 Modify FreeForm capability added
%6-23-03 Bug Correction: take the round part of the modified part (before,
%little discrepency between original results and retrieved ones)
%9-17-03 Bug corrections: modify free form previously computed the closest
%contour in all the contour list (even the deleted ones)
%9-17-03 Abort the drawing if the first point is outside of the image
%9-17-03 use polyarea to compute the pixel numbers
%10-11-03 compute DXA result if DXA mode
%3-25-03 apply a decimation factor to keep 1 point out of 'decimationfactor' (ex:5)
function addfreeform(RequestedAction)
global f0 DXA ctrl FreeForm xy Info Image n Result

decimationfactor=2;


switch RequestedAction    
    case 'BeginDrawing'  %0
        xy=[];
        FreezeButtons(ctrl,f0,Info);    
        figure(f0.handle);
        axes(f0.axisHandle);
        hold on
        % Initially, the list of points is empty.
        
        n = 1;
        set(ctrl.text_zone,'String','Press left button to begin the free form, release to end');
        k = waitforbuttonpress;
        point1 = get(f0.axisHandle,'CurrentPoint'); xy(n,:)=point1(1,1:2);
        %abort if the first point is outside of the image
        if sum(flipdim(point1(1,1:2),2)>size(Image.image))|sum(flipdim(point1(1,1:2),2)<0)
            set(ctrl.text_zone,'String','contour drawing aborted');
            FuncActivateDeactivateButton; %defreeze
        else
            FreeForm.handle=plot(xy(:,1),xy(:,2),'EraseMode','xor','linewidth',3,'color','blue');
            set(f0.handle,'WindowButtonUpFcn','addfreeform(''EndDrawing'')');
            set(f0.handle,'WindowButtonMotionFcn','addfreeform(''MoveDraw'')','Interruptible','off');
        end
    case 'MoveDraw'
        if ~strcmp(get(f0.handle,'WindowButtonMotionFcn'),'')
            n=n+1;
            point1=get(f0.axisHandle,'CurrentPoint');
            xy(n,:)=point1(1,1:2);
            set(FreeForm.handle,'XData',xy(:,1),'YData',xy(:,2));
            drawnow
        end
    case 'EndDrawing' %1
        xy(size(xy,1)+1,:)=xy(1,:);        
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
        xy=round(xy);    
        [xy(:,1),xy(:,2)]=funcclipping(xy(:,1),xy(:,2),Image.rows,Image.columns);
        if DXA.selectBackground  %recompute DXA background
            DXA.selectBackground=false;        
            LE0=funcComputeDXAcontour(Image.LE,xy,ones(size(Image.LE)));
            HE0=funcComputeDXAcontour(Image.HE,xy,ones(size(Image.HE)));
            Image.LE=Image.LE-LE0;
            Image.HE=Image.HE-HE0;
            Image.RST=Result.LE./Result.HE;    
        elseif Result.DXA |  Result.DXAProdigyCalculated
            %compute the mean glandular percent and put the result in the
            %command window
            set(ctrl.text_zone,'String','Working hard...');    
           % figure;
           % imagesc(Image.HE); colormap(gray);
            dxa_percent = funcComputeDXAcontour(funcclim(Image.material,-50,200),xy,Image.HE) %-50
            dxa_area = funcComputeFreeFormArea(xy);
            set(ctrl.text_zone,'String',strcat('Area surface:',num2str(dxa_area),'pixels - Image Density :',num2str(dxa_percent),'%'));
            ['area: ',num2str(funcComputeFreeFormArea(xy))]
        else
            set(FreeForm.handle,'XData',0,'YData',0);
            FreeForm.FreeFormnumber=FreeForm.FreeFormnumber+1;
            Endxy=xy(end,:);
            xy=[xy(1:decimationfactor:end,:);Endxy];
            FreeForm.FreeFormCluster(FreeForm.FreeFormnumber).face=xy;
            set(ctrl.text_zone,'String','Computing inner region...');
            pixels=funcComputeFreeFormArea(xy);
            set(ctrl.text_zone,'String',strcat('pixels:',num2str(pixels)));
            FreeForm.FreeFormCluster(FreeForm.FreeFormnumber).surface=pixels;
            FreeForm.FreeFormCluster(FreeForm.FreeFormnumber).valid=true;
            FreeForm=funcSelectPatch(FreeForm,FreeForm.FreeFormnumber);
            hold off;
            DrawEverything;
       end
       FuncActivateDeactivateButton;       
    case 'ModifyFreeForm' %2
        xy=[];
        FreezeButtons(ctrl,f0,Info);
        DeactivateContour;
        
        if FreeForm.FreeFormnumber>0
            figure(f0.handle);
            axes(f0.axisHandle);
            hold on
            % Initially, the list of points is empty.
            n = 1;
            set(ctrl.text_zone,'String','Press left button to begin the free form, release to end');
            waitforbuttonpress;
            point1 = get(f0.axisHandle,'CurrentPoint'); xy(n,:)=point1(1,1:2);
            %abort if the first point is outside of the image
            if sum(flipdim(point1(1,1:2),2)>size(Image.image))|sum(flipdim(point1(1,1:2),2)<0)
                set(ctrl.text_zone,'String','contour drawing aborted');
                FuncActivateDeactivateButton; %defreeze
            else
                FreeForm.handle=plot(xy(:,1),xy(:,2),'EraseMode','xor','linewidth',3,'color','blue');
                set(f0.handle,'WindowButtonUpFcn','AddFreeForm(''EndModifyFreeform'')');
                set(f0.handle,'WindowButtonMotionFcn','addfreeform(''MoveModifyFreeform'')','Interruptible','off');    
            end
        else
            FuncActivateDeactivateButton; %defreeze
        end
    case 'MoveModifyFreeform'
        n=n+1;
        point1=get(f0.axisHandle,'CurrentPoint');
        xy(n,:)=point1(1,1:2);
        set(FreeForm.handle,'XData',xy(:,1),'YData',xy(:,2));
        drawnow
    case 'EndModifyFreeform' %3
        set(f0.handle,'WindowButtonUpFcn','');
        set(f0.handle,'WindowButtonMotionFcn','');
        
        %decimation of xy
        Endxy=xy(end,:);
        xy=[xy(1:decimationfactor:end,:);Endxy];
        
        
        %compute which FreeForm we want to change
        C(1:FreeForm.FreeFormnumber)=Inf;
        for index=1:FreeForm.FreeFormnumber
            if FreeForm.FreeFormCluster(index).valid
                Coordinates=FreeForm.FreeFormCluster(index).face;        
                [C(index),I]=min(sum(((Coordinates-ones(size(Coordinates,1),1)*xy(1,:)).^2)'));
            end
        end
        [C,FreeForm.FreeFormSelect]=min(C);
        FreeForm.FreeFormSelect;
        
        %compute the two nearest points
        Coordinates=FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).face;
        OriginalFreeFormSize=size(Coordinates,1);
        AddPartSize=size(xy,1);
        [C,I1]=min(sum(((Coordinates-ones(size(Coordinates,1),1)*xy(1,:)).^2)'));
        [C,I2]=min(sum(((Coordinates-ones(size(Coordinates,1),1)*xy(size(xy,1),:)).^2)'));
        
        %check if the FreeForm is well oriented when compared to the new section
        if I1>I2 
            xy=flipdim(xy,1);
            temp=I1;
            I1=I2;
            I2=temp;
        end
        %change the former freeform by the new one    
        newFreeForm(I1+1:I1+AddPartSize,:)=xy;
        newFreeForm(1:I1,:)=Coordinates(1:I1,:);    
        newFreeForm(I1+AddPartSize+1:I1+AddPartSize+OriginalFreeFormSize-I2+1,:)=Coordinates(I2:OriginalFreeFormSize,:);
        newFreeForm=round(newFreeForm);
        FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).face=newFreeForm;
        %compute the new area
        pixels=funcComputeFreeFormArea(newFreeForm);
        set(ctrl.text_zone,'String',strcat('pixels:',num2str(pixels)));
        FreeForm.FreeFormCluster(FreeForm.FreeFormSelect).surface=pixels;
      
        FuncActivateDeactivateButton;DrawEverything;    
end
    
    


