% Phantom Manual

% draw two box (one for 100%fat, one for 100%lean)
% 
% Lionel HERVE 2/03
% modification
% 10-29-03 automatic detection 
function phantomdetection
global f0 ctrl Analysis Info figuretodraw Image Phantom ReportText Error  PhantomDetectionFailure Correction DEBUG Database
figure(f0.handle);   
Analysis.DensityPercentageAngle = [];
 Phantom = [];
 %Phantom.second_phantom = true;  %for down right corner    
 Error.PhantomDetection=false;
 Error.StepPhantomFailure=false;
 Error.StepPhantomBBsFailure=false;
 Error.StepPhantomPosition=false;
 Error.StepPhantomReconstruction=false;
 Error.SXAbbRecon = false;
 
 Error.SXAroiFitFailure = false;
 Error.SXAroiFitWarning = false;

  [v,d] = version;
  k = strfind(v, 'R2007a');
  if ~isempty(k)
      if isempty(getNumberOfComputationalThreads)
            fprintf('Multithreaded computation is disabled in your MATLAB session.\n');
            fprintf('Use Preferences to enable.\n');
            return
      end
      num = getNumberOfComputationalThreads;
      setNumberOfComputationalThreads(num);
  end 
%{
 if Info.DigitizerId == 3
            Analysis.Filmresolution  = 0.15;
 else
            Analysis.Filmresolution = 0.169;
 end
%}
 %try
    if Info.DigitizerId >= 4
        type = phantom_typedigital();
    else
        type = 'WEDGE';%phantom_type(Image.OriginalImage); 
    end
     % type = 'WEDGE';
     %type = 'STEP';
     if strcmp(type,'NO') | strcmp(type,'BAD') 
         Error.StepPhantomFailure = true
        stop;
    elseif strcmp(type, 'STEP')
       % Message('Step phantom');
        Analysis.Step = 1;
        if Info.DigitizerId >= 4
             % Analysis.PhantomID = 8; %commented for phantom calibration
            % stop;
              if ~get(ctrl.CheckManualPhantom,'value') % manual 
                  bbReconParams = Z2phantom_manual();
              else
                  bbReconParams = Z2phantom_automatic();
              end
        else
             %xm = strmatch('UKMarsden', Info.StudyID, 'exact');
              xm = strmatch('mammo_Marsden', Database.Name, 'exact');
             if xm > 0 
                 Analysis.PhantomID = 7;
             else
                 Analysis.PhantomID = 6; 
             end
            % stop;
              if ~get(ctrl.CheckManualPhantom,'value') % manual 
                  bbReconParams = Z1phantom_manual();
              else
                  bbReconParams = Z1phantom_automatic();
              end
          
        end
        
        %Modification by Song, 03/14/11
        %Check the 3D reconstruction error, if error larger than the
        %threshold, stop density calculation
        errorThreshold = 0.04; %0.025
        if bbReconParams(end) >= errorThreshold
            Error.SXAbbRecon = true;
            error('SXA BB 3D reconstruction error is larger than the threshold!');
        end
        %end of modification
        
          Info.PhantomComputed=true;
          Info.StepPhantomComputed=true;
          set(ctrl.text_zone,'String','Now, you can compute the breast density'); 
          %set(ctrl.text_zone,'String','Breast density = 93%'); 
          %  draweverything;
          FuncActivateDeactivateButton;
          Error.PhantomDetection=false;
          Error.StepPhantomFailure=false;
          Error.StepPhantomBBsFailure=false;
          Error.StepPhantomPosition=false;
          Error.StepPhantomReconstruction=false;
    else %wedge phantom    

        if ~get(ctrl.CheckManualPhantom,'value') % manual 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            maxX=size(Image.image,2);

           %% maximum value for the bottom of the phantom (to accelerate edge function)
           maxY=500;
            ExtractedImage=+(Image.OriginalImage(1:maxY,round(size(Image.OriginalImage,2)/4):round(3*size(Image.OriginalImage,2)/4)));
            ExtractedImage=(ExtractedImage<Correction.SaturatedThreshold)&(ExtractedImage~=0);
            if DEBUG figure;imagesc(ExtractedImage);title('PhantomDetection2: Extracted Image');colormap(gray); end

            %eliminate saturated islands (lead wires)
            [mini,minY]=max(sum(ExtractedImage')>400); minY=minY+10;  %minY corresponds to the first line more than 200 non saturated pixels
            if DEBUG display(['TOP OF THE IMAGE:',num2str(minY)]); end

            %% Left edge of the analysis box - Analyze the Image for y=minY+20:minY+50 (this line should cross the phantom)
            %the problem comes from the lag at the top of the image that screws the
            %bakground detection!!
            signal=mean(Image.OriginalImage(minY+20:minY+50,1:end));
            %the background is defined here when a third of the pixels are above a
            %threshold
            bin=[0:100]/100*max(signal);
            workinghist=histc(signal,bin);
            [maxi,index]=max(cumsum(workinghist)>(sum(workinghist)/3));
            threshold=bin(index);
            signal=signal<threshold;
            MinPhantomSize=200;
            signal=conv2(+signal,ones(1,MinPhantomSize),'same')==0;    %find were more than 200 consecutives pixels are over the background
            signal(1:round(length(signal)/3))=0;  %put the first value of the line to 0 to prevent the left lag to bother the computations
            [foe,minX]=max(signal); %the left corner is the lefter 200 pixels which don't belong to the background
            minX=minX-200;
            minXfix = 300;
            minxx = [minX minXfix]
            minX = max(minxx)
            corner1=[minX minY maxX maxY]
            if DEBUG display(corner1);end

            %% find the first horizontal line
            tempImage=Image.OriginalImage(corner1(2):corner1(4),corner1(1):corner1(3));
            tempBackGround=(1-Analysis.BackGround(corner1(2):corner1(4),corner1(1):corner1(3)));
            tempImage=tempImage.*(tempBackGround);   %keep just the image outside of the background

           scrsz = get(0,'ScreenSize');



            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(ctrl.text_zone,'String','Drag a box on fat area');
            htemp  = figure;  imagesc(tempImage); colormap(gray); title('TempImage');hold on;
            set(htemp,'Position',[1 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);
            % example from MATLAB Functions: rbbox
            waitforbuttonpress;
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2)              % extract x and y
            point2 = point2(1,1:2)
            p1_fat = round(min(point1,point2))             % calculate locations
            offset_fat = round(abs(point1-point2))         % and dimensions
            Analysis.coordXFatcenter =   round(p1_fat(1) + offset_fat(1)/2);
            Analysis.PhantomFatx = [p1_fat(1) p1_fat(1)+offset_fat(1)];
            Analysis.PhantomFaty = [p1_fat(2) p1_fat(2)+offset_fat(2)];

            funcBox(Analysis.PhantomFatx(1),Analysis.PhantomFaty(1),Analysis.PhantomFatx(2),Analysis.PhantomFaty(2),'blue');

            set(ctrl.text_zone,'String','Drag a box on lean area');
            % example from MATLAB Functions: rbbox
            k = waitforbuttonpress;
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1_lean = round(min(point1,point2));             % calculate locations
            offset_lean = round(abs(point1-point2));         % and dimensions

            Analysis.PhantomLeanx = [p1_lean(1) p1_lean(1)+offset_lean(1)];
            Analysis.PhantomLeany = [p1_lean(2) p1_lean(2)+offset_lean(2)];

            funcbox(Analysis.PhantomLeanx(1),Analysis.PhantomLeany(1),Analysis.PhantomLeanx(2),Analysis.PhantomLeany(2),'blue'); 

            Analysis.PhantomPosition = round(p1_fat(1) + offset_fat(1)/2);
            %%%%%%%%%%%%%%%%%%%%        
            %temporary
           %  Analysis.PhantomD1= 40;
           % Analysis.PhantomD2=40;
           %  Analysis.PhantomPosition=800;
           %{
            set(ctrl.text_zone,'String','click on the FIRST phantom hozizontal lead wires');

            set(ctrl.text_zone,'String','click on the SECOND phantom hozizontal lead wires');        
            y2=UserDrawLine('ROOT','horizontal');        
            set(ctrl.text_zone,'String','click on the FIRST phantom vertical lead wires of the fat area');        
            x1=UserDrawLine('ROOT','vertical');
            set(ctrl.text_zone,'String','click on the SECOND phantom vertical lead wires of the fat area');                
            x2=UserDrawLine('ROOT','vertical');        
            Analysis.PhantomD1=round(abs(y1-y2));
            Analysis.PhantomD2=round(abs(x1-x2));
            Analysis.PhantomPosition=min(x1,x2);
            %}
           % set(ctrl.text_zone,'String','click on the LEFT and RIGHT of  UPPER hozizontal lead wire');
           % hf = get(gcf)
          %  set(f0.axisHandle,'Linewidth', 1); 
          % af = get(f0.axisHandle, 'Linewidth') 
          % set(f0.UCSFhandle,'Linewidth', 1); 
          % af1 = get(f0.UCSFhandle, 'Linewidth')
           %axes(f0.UCSFhandle);
           %y1=UserDrawLine('ROOT','horizontal');
           %localScopeDirection=direction;

           MyLine=plot(0,0,'b','erasemode','xor');
           position=200;
           %set(MyLine,'xdata',[0,size(Image.image,2)],'ydata',[position position]);
           set(MyLine,'xdata',[0,1],'ydata',[1 1]);
           % MyLine=plot(0,0,'b','erasemode','xor');
          % set(MyLine,'xdata',[0,0],'ydata',[0 0]);
            [xup,yup] = ginput(2);
            plot(xup,yup,'Linewidth',1,'color','b');
            [xlow,ylow] = ginput(2);
            plot(xlow,ylow,'Linewidth',1,'color','r');
            talfa1 = (yup(2) - yup(1)) / (xup(2) - xup(1));
            talfa2 = (ylow(2) - ylow(1)) / (xlow(2) - xlow(1));
            Phantom.AngleHoriz = atan(talfa2 - talfa1) * 360 / 6.28
            %%%%%%%%%%%%%
            LineUp.x1 = xup(1)   ;   LineUp.x2 = xup(2);
            LineUp.y1 = yup(1)   ;   LineUp.y2 = yup(2);
            LineLow.x1 =  xlow(1);   LineLow.x2 =  xlow(2);
            LineLow.y1 =  ylow(1);   LineLow.y2 = ylow(2);

            LineFatRef.x1 = p1_fat(1) + offset_fat(1)/2;
            LineFatRef.x2 = p1_fat(1) + offset_fat(1)/2;
            LineFatRef.y1 = p1_fat(2);
            LineFatRef.y2 = p1_fat(2) + 200;

            Ifr1=funcComputeIntersection(LineFatRef,LineUp)
            Ifr6=funcComputeIntersection(LineFatRef,LineLow)
            Phantom.Distance1 = (sum((Ifr1-Ifr6).^2))^0.5 
            Phantom.Distance2 = 40;
            Phantom.Distance3 = (sum((Ifr1-Ifr6).^2))^0.5 + 1; %- 7
            plot([LineFatRef.x1  LineFatRef.x2],[LineFatRef.y1 LineFatRef.y2],'Linewidth',1,'color','y');
            hold off;
            %Phantom.Distance1 = 40;
            %Phantom.Distance3 = 40;
            %Analysis.PhantomPosition=Phantom.Position;
            Analysis.PhantomD1=round(Phantom.Distance1);
            Analysis.PhantomD2=round(Phantom.Distance2);
            Analysis.PhantomDistanceFatRef = round(Phantom.Distance3);
             Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomDistanceFatRef * Analysis.Filmresolution + 33.5
             Analysis.AngleHoriz = Phantom.AngleHoriz;
           %   corner1(2):corner1(4),corner1(1):corner1(3)
           % Line6.x1=Line6.x1+corner4(1)- corner1(1)-1;Line6.x2=Line6.x2+corner4(1)- corner1(1)-1;
           % Line6.y1=Line6.y1+corner4(2)- corner1(2)-1;Line6.y2=Line6.y2+corner4(2)- corner1(2)-1;
             Analysis.PhantomLeanx = Analysis.PhantomLeanx + corner1(1); %+ corner1(2);
             Analysis.PhantomLeany = Analysis.PhantomLeany + corner1(2);
             Analysis.PhantomFatx =  Analysis.PhantomFatx + corner1(1);%+ corner1(2)
             Analysis.PhantomFaty = Analysis.PhantomFaty + corner1(2);
           % meanFat=mean(mean(tempImage(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
           % meanLean=mean(mean(tempImage(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));
             an = Analysis

        else %automatic
            borderX=20;sizeY=30;
            borderY=15;borderYTop=10;
            try   %in the case the mammography machine is lorad and the film is big, prevent the topest pixels which are crappy 
                Info.BRAND=GetBRAND(Info);
                Info.ROOM=GetROOM(Info);
                if (Info.BRAND==2)&&(Error.BIGPADDLE)&&(Info.ROOM~=3)
                    borderYTop=70;
                else
                    borderYTop=10;
                end
            catch
                borderYTop=10;
            end

            Phantom=funcPhantomDetection2(Image,f0.handle);

            miny=Phantom.Top+borderYTop;

            pause(0.01);  %to show the line
            %compute the boxes from the computation of the phantom lines
            Analysis.PhantomPosition=Phantom.Position;
            Analysis.PhantomD1=round(Phantom.Distance1);
            Analysis.PhantomD2=round(Phantom.Distance2);
            Analysis.PhantomDistanceFatRef = round(Phantom.Distance3);
            Analysis.AngleHoriz = Phantom.AngleHoriz;
            if Info.DigitizerId == 3
                Analysis.Filmresolution  = 0.15;
            else
                Analysis.Filmresolution = 0.169;
            end

            Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomDistanceFatRef * Analysis.Filmresolution + 33.5

            Analysis.PhantomFatx=[Phantom.Point1(1)+borderX,min(Phantom.Point5(1)-borderX,size(Image.image,2)-50)];
            Analysis.PhantomLeanx=sort([min(size(Image.image,2),Phantom.Point7(1)+borderX),min(Phantom.Point2(1)-borderX,size(Image.image,2)-50)]);

            BottomFat=min(Phantom.Point1(2),Phantom.Point5(2))-borderY;
            BottomLean=min(Phantom.Point2(2),Phantom.Point7(2))-borderY;
            %FAT WEDGE
            y1=max(miny,BottomFat-sizeY);y2=BottomFat;
            if y1>y2 % this is a bad case when the phantom wedges are very close to the border. take some precaution (little selection)
                Analysis.PhantomFaty=[BottomFat-1,BottomFat+1];
            else
                Analysis.PhantomFaty=[y1,y2];
            end
            %LEAN WEDGE
            y1=max(miny,BottomLean-sizeY);y2=BottomLean;
            if y1>y2 % this is a bad case when the phantom wedges are very close to the border. take some precaution (little selection)
                Analysis.PhantomLeany=[BottomLean-1,BottomLean+1];
            else
                Analysis.PhantomLeany=[y1,y2];
            end
            if Analysis.PhantomFaty(1) <= 8 | Analysis.PhantomFaty(2) <= 8
                Analysis.PhantomFaty(2) = 12
                Analysis.PhantomFaty(1) = 9;
            end

            if Analysis.PhantomLeany(1) <= 8 | Analysis.PhantomLeany(2) <= 8
                Analysis.PhantomLeany(2) = 12
                Analysis.PhantomLeany(1) = 9;
            end

            diff_yfat = Analysis.PhantomFaty(2)-Analysis.PhantomFaty(1);
            diff_ylean = Analysis.PhantomLeany(2)-Analysis.PhantomLeany(1);

            if diff_yfat <=3
                Analysis.PhantomFaty(2) =  Analysis.PhantomFaty(1) + 4;
            end

            if diff_ylean <=3
                Analysis.PhantomLeany(2) =  Analysis.PhantomLeany(1) + 4;
            end

            funcBox(Analysis.PhantomFatx(1),Analysis.PhantomFaty(1),Analysis.PhantomFatx(2),Analysis.PhantomFaty(2),'blue');    

            Analysis.coordXFatcenter =  mean(Analysis.PhantomFatx)

        end

        meanFat=mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
        meanLean=mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));
       % meanFat=mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
       % meanLean=mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));
       %{
       if meanLean<meanFat %invert lean and fat if fat>lean
            set(ctrl.text_zone,'String','I invert Lean and Fat'); pause(1);
            tempX=Analysis.PhantomLeanx;
            tempY=Analysis.PhantomLeany;
            Analysis.PhantomLeanx=Analysis.PhantomFatx;
            Analysis.PhantomLeany=Analysis.PhantomFaty;
            Analysis.PhantomFatx=tempX;
            Analysis.PhantomFaty=tempY;    
        end
        %}
        Info.PhantomComputed=true;
        set(ctrl.text_zone,'String','Now, you can compute the breast density');        
      %  draweverything;
        FuncActivateDeactivateButton;

    %% Error/warning management    

        sizeFat=(Analysis.PhantomFaty(2)-Analysis.PhantomFaty(1)+1)*(Analysis.PhantomFatx(2)-Analysis.PhantomFatx(1)+1);
        if sizeFat<1000
            ReportText=[ReportText, 'Phantom Fat small@'];
        end

        sizeLean=(Analysis.PhantomLeany(2)-Analysis.PhantomLeany(1)+1)*(Analysis.PhantomLeanx(2)-Analysis.PhantomLeanx(1)+1);
        if sizeLean<1000
            ReportText=[ReportText, 'Phantom lean small@'];
        end
         Error.PhantomDetection=false;
    end %wedge phantom
%{    
catch
    ReportText=[ReportText,'Phantom detection Failure@'];
    PhantomDetectionFailure = 1;
    Analysis.SXAanalysisStatus = 3;
    Error.PhantomDetection=true;
    Error.StepPhantomFailure = true;
    set(ctrl.text_zone,'String','Phantom detection failed');   
    draweverything;
 end
%}
