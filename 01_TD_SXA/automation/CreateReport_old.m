%Create SXA report
%Lionel HERVE
%9-8-04

function CreateSXAReport(RequestedAction,param)

global data Database Info ctrl figuretodraw ReportText Error Image ROI  PhantomDetectionFailure   axestodraw f copyfigure_handle
global PowerPointReport AutomaticAnalysis Correction Analysis Recognition Phantom h_init h_slope current_fighandle SXAAnalysis
global startdir_report

switch RequestedAction
    case 'NEW'
        PowerPoint('INIT');
        if exist('param')
            PowerPointReport.PatientIDbeginning=num2str(param);
        else
            PowerPointReport.PatientIDbeginning='';
        end
        
    case 'ADDCOMMON'
        PowerPoint('AddSlide');
        
        %gather the information from the acquisition
        SQLstatement=['select study_ID,patient_ID,view_description,film_identifier,date_acquisition,visit_id,phantom_id from mammo_view,acquisition'];
        SQLstatement=[SQLstatement,' where view_id=mammoview_id and acquisition.acquisition_id=''',num2str(Info.AcquisitionKey),''''];
        a=mxDatabase(Database.Name,SQLstatement);
        PowerPointReport.StudyID=cell2mat(a(1));
        PowerPointReport.PatientID=cell2mat(a(2));
        PowerPointReport.View=cell2mat(a(3));
        PowerPointReport.Identifier=cell2mat(a(4));
        PowerPointReport.Date=cell2mat(a(5));
        PowerPointReport.Visit=cell2mat(a(6));
        PowerPointReport.PhantomType=cell2mat(a(7));
         
        %Capture current figure into clipboard: %commented for autoanalysis
        %{
        if size(Image.OriginalImage,1)<=1800
            ReinitImage(Image.OriginalImage);
        end
        %}
        set(ctrl.separatedfigure,'value',true);
        
        %figure(figuretodraw_separated);
        
        %axes_image = axes;
       % set(himage, 'Visible','off');
       % axestodraw=axes;
        %set(himage,'position',[0 0 size(Image.image,2)/size(Image.image,1)*800 800]);
        copyfigure_handle1 = findobj('Tag','BreastImage');
         draweverything(1,'PHANTOMLINE');
        % put picture in the left side:
        %imagesc(Image.image); %,[Hist.imagemin2 Hist.imagemax2]);
           % colormap(funccomputecolormap(Image,Threshold,get(ctrl.ShowBackGround,'value')));
        %colormap(gray);   
        copyfigure_handle = findobj('Tag','BreastImage');
        PowerPoint('copypastefigure','position',[0 0 0.5 1],'LockAspectRatio',false);
       % tic
        delete(copyfigure_handle);
        %tcop = toc
        
        % Add text
        %acquisition description
        PowerPoint('addtext','text',[deblank(PowerPointReport.StudyID),'/',num2str(Info.AcquisitionKey)],'bold',true,'underlined',true,'carriage',2.5,'position',[0.5 0],'fontsize',1.5);
        PowerPoint('addtext','text',['patient ID: ',PowerPointReport.PatientID]);
        PowerPoint('addtext','text',['View: ',PowerPointReport.View]);
        PowerPoint('addtext','text',['Visit#: ',num2str(PowerPointReport.Visit)]);        
        PowerPoint('addtext','text',['Film Identifier: ',PowerPointReport.Identifier]);
        PowerPoint('addtext','text',['Date: ',PowerPointReport.Date]);
         PowerPoint('addtext','text',['Phantom Type: ',num2str(PowerPointReport.PhantomType)],'carriage',3);
       % PowerPoint('addtext','text',[' (BDSXA_angle: ',num2str(Analysis.DensityPercentageAngle),')']);
        
    case 'SXASPECIFIC'
       
        Position=PowerPoint('gettextposition');
        
        SXAID='';
        try 
            if ~Error.DENSITY
                PowerPoint('addtext','text',['/',num2str(funcFindNextAvailableKey(Database,'SXAanalysis'))],'position',[0.7,0.0],'bold',true,'fontsize',1.5);
            end
        end
        
        %PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ' (Lead marker: ',AutomaticAnalysis.Marker,')',' (Angle: ',Phantom.Angle,')' ],'position',Position);
        
        PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ' (Angle: ',num2str(Analysis.AngleHoriz),')' ],'position',Position);
        PowerPoint('addtext','text',['BDSXA :',num2str(Analysis.DensityPercentage) ,' (BDSXA_angle: ',num2str(Analysis.DensityPercentageAngle),')']);
        %,'ERROR',Error.DENSITY,        
        %add film marker 
       if AutomaticAnalysis.CharacterRecognitionDone ~= 0 
        foe=figure;
        set(foe, 'Visible','off');
        imagesc(AutomaticAnalysis.Imagette);colormap(gray);
        Position=PowerPoint('gettextposition');
        PowerPoint('copypastefigure','position',[Position(1)+0.3 Position(2)-0.15 0.15 0.15],'LockAspectRatio',false);delete(foe);
       end 
        %Correction used
         Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Correction :',Correction.Filename],'position',[Position(1),Position(2)],'ERROR',Error.Correction);
        
        %Measured height
        PowerPoint('addtext','text',['Heights :',num2str(Analysis.Height1)],'underlined',Analysis.ThicknessUsed==1,'bold',Analysis.ThicknessUsed==1,'ERROR',Error.DENSITY|Error.HEIGHT,'carriage',0);
        Position=PowerPoint('gettextposition')
        PowerPoint('addtext','text',['/',num2str(Analysis.Height2)],'position',[Position(1)+0.15 Position(2)],'underlined',Analysis.ThicknessUsed==2,'bold',Analysis.ThicknessUsed==2,'ERROR',Error.DENSITY|Error.HEIGHT);
    
        PowerPoint('addtext','text','','position',Position,'carriage',0);
  
     case 'SXASTEPSPECIFIC'
       
        Position=PowerPoint('gettextposition');
        
        SXAID='';
        try 
            if ~Error.DENSITY
                PowerPoint('addtext','text',['/',num2str(funcFindNextAvailableKey(Database,'SXAStepanalysis'))],'position',[0.8,0.0],'bold',true,'fontsize',1.5);
            end
        end
        
        %PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ' (Lead marker: ',AutomaticAnalysis.Marker,')',' (Angle: ',Phantom.Angle,')' ],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ',  Angle chest-nipple ry: ',num2str(Analysis.ry)],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Angle rx :',num2str(Analysis.rx), ',  Thickness: ',num2str(Analysis.ph_thickness)]);
         %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['BDSXA :',num2str(Analysis.DensityPercentage)]);% ,', BDSXA_angle: ',num2str(Analysis.alfa)
        PowerPoint('addtext','text',['kVp :',num2str(Info.kVp), ',  mAs: ',num2str(Info.mAs)]);
        PowerPoint('addtext','text',['Absolute Volume :',num2str(SXAAnalysis.SXABreastVolumeReal), ',  Convergence: ',num2str(Analysis.params(7))]);
        
        %,'ERROR',Error.DENSITY,        
        %add film marker 
       if AutomaticAnalysis.CharacterRecognitionDone ~= 0 
        foe=figure;
        set(foe, 'Visible','off');
        imagesc(AutomaticAnalysis.Imagette);colormap(gray);
        Position=PowerPoint('gettextposition');
        PowerPoint('copypastefigure','position',[Position(1)+0.3 Position(2)-0.15 0.15 0.15],'LockAspectRatio',false);delete(foe);
       end 
        %Correction used
         Position=PowerPoint('gettextposition');
       % PowerPoint('addtext','text',['Correction :',Correction.Filename],'position',[Position(1),Position(2)],'ERROR',Error.Correction);
       %{ 
        %Measured height
        PowerPoint('addtext','text',['Heights :',num2str(Analysis.Height1)],'underlined',Analysis.ThicknessUsed==1,'bold',Analysis.ThicknessUsed==1,'ERROR',Error.DENSITY|Error.HEIGHT,'carriage',0);
        Position=PowerPoint('gettextposition')
        PowerPoint('addtext','text',['/',num2str(Analysis.Height2)],'position',[Position(1)+0.15 Position(2)],'underlined',Analysis.ThicknessUsed==2,'bold',Analysis.ThicknessUsed==2,'ERROR',Error.DENSITY|Error.HEIGHT);
       %}
        PowerPoint('addtext','text','','position',Position,'carriage',0);    
    case 'TAGINFORMATION'
        %Tag reading
        if AutomaticAnalysis.CharacterRecognitionDone ~= 0
            foe=figure;
            set(foe, 'Visible','off');
            imagesc(Recognition.Imagette);colormap(gray);
            Position=PowerPoint('gettextposition');
            PowerPoint('copypastefigure','position',[Position(1) Position(2)+0.05 1-Position(1) 0.2],'LockAspectRatio',false);delete(foe);
        end
         Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['mAs :',num2str(Recognition.MAS)],'position',[Position(1) Position(2)+0.25],'ERROR',Error.MAS);
        PowerPoint('addtext','text',['kVp :',num2str(Recognition.KVP)],'position',[Position(1)+0.15 Position(2)+0.25],'ERROR',Error.KVPWarning|Error.KVP);
        PowerPoint('addtext','text',['Thickness :',num2str(Recognition.MM)],'position',[Position(1)+0.3 Position(2)+0.25],'ERROR',Error.MM,'underlined',Analysis.ThicknessUsed==3,'bold',Analysis.ThicknessUsed==3);
        PowerPoint('addtext','text',['Technique :',Recognition.TECHNIQUE],'position',[Position(1) Position(2)+0.28],'ERROR',Error.TECHNIQUE);
        PowerPoint('addtext','text',['Force :',num2str(Recognition.DAN)],'position',[Position(1)+0.2 Position(2)+0.28],'ERROR',Error.DAN);
        PowerPoint('addtext','text','','position',[Position(1) Position(2)+0.30],'carriage',2);
        
    case 'ROOMSPECIFIC'
        Position=PowerPoint('gettextposition');
        for index=0:size(AutomaticAnalysis.Score,1)-1
            PowerPoint('addtext','text',[num2str(AutomaticAnalysis.Score(index+1,1)),'      ',num2str(AutomaticAnalysis.Score(index+1,2)),'       (',num2str(AutomaticAnalysis.Score(index+1,3)),')'],'position',[Position(1)+(1-Position(1))/2*mod(index,2),Position(2)+0.02*floor(index/2)]);
        end
        PowerPoint('addtext','text','','position',[Position(1),Position(2)+0.02*floor(index/2)],'carriage',2);
        
        
    case 'QACODES'
        %QAcodes
        PowerPoint('addtext','text','','carriage',1); 
        SQLstatement=['select description,QAcode from QAcode,QA_code_results'];
        SQLstatement=[SQLstatement,' where acquisition_id=',num2str(Info.AcquisitionKey),' and QA_code=QAcode'];
        PowerPointReport.QAcode=mxDatabase(Database.Name,SQLstatement)
        Analysis.SXAanalysisStatus = 2;
        %QA codes
        PowerPoint('addtext','text','QA codes','fontsize',1.2,'underlined',true);
        for index=1:size(PowerPointReport.QAcode,1)
            PowerPoint('addtext','text',[cell2mat(PowerPointReport.QAcode(index,1)),' (',num2str(cell2mat(PowerPointReport.QAcode(index,2))),')']);
        end
        PowerPoint('addtext','text','','carriage',2);

    case 'ADDREPORTTEXT'
        %Add Report Text
        if length(ReportText)>0
	        %detect the @ (to set a carriage return)
	        indexAt=1;LineIndex=1;
	        while (1)
	           NextIndexAt=indexAt;
	           while (ReportText(NextIndexAt)~='@')&(NextIndexAt<length(ReportText)) 
	               NextIndexAt=NextIndexAt+1;
               end
	           PowerPoint('addtext','text',ReportText(indexAt:NextIndexAt-1),'color','red');
               NextIndexAt=NextIndexAt+1;               
	           if NextIndexAt>=length(ReportText)
	               break
               end
	           indexAt=NextIndexAt;
            end
        end
   
      case 'ADDPOFILES'   
         %imagesc(AutomaticAnalysis.Imagette);colormap(gray);
         PowerPoint('AddSlide');
        
         sz = size(Analysis.signal)
         foe=figure; 
         plot(Analysis.signal(:,1), Analysis.signal(:,2:4)); hold on;
         legend('center', 'upper','down');
         angl = Phantom.AngleHoriz
         xlen = Analysis.coordXFatcenter * 0.15
         y2 = tan(-angl * 1.1 * 6.28/ 360) *  xlen * 0.9 * 2000
         yfat = Analysis.Phantomfatlevel
         ylean = Analysis.Phantomleanlevel
          plot([0.15 xlen],[Analysis.Phantomfatlevel + y2  Analysis.Phantomfatlevel ],'Linewidth',3,'color','m'); 
          hold on;
          angl = Phantom.AngleCorr
          y2 = tan(-angl * 1.1 * 6.28/ 360) *  xlen * 0.9 * 2000
         yfat = Analysis.Phantomfatlevel
         ylean = Analysis.Phantomleanlevel
          plot([0.15 xlen],[Analysis.Phantomfatlevel + y2  Analysis.Phantomfatlevel ],'Linewidth',3,'color','m'); hold on;
           plot([0.15 xlen],[Analysis.Phantomleanlevel + y2  Analysis.Phantomleanlevel ],'Linewidth',3,'color','b'); 
          grid on;
          hold off; 
          %hold on; 
         %plot(signal2); hold on; 
         %plot(signal3); 
         % Position=PowerPoint('gettextposition');
         current_fighandle = foe;
         PowerPoint('copypastefigure','position',[0.1 0.1 0.8 0.8],'LockAspectRatio',false);delete(foe);  
      case 'ADDSTEPPOFILES'   
         %imagesc(AutomaticAnalysis.Imagette);colormap(gray);
         PowerPoint('AddSlide');
        
         sz = size(Analysis.signal)
         foe = figure; 
         set(foe, 'Visible','off');
         scrsz = get(0,'ScreenSize');
         %set(h_init,'Position',[1 scrsz(4)*3/8 scrsz(3)*2.5/8 scrsz(4)*3/8]);
        % set(foe, 'Visible','off');
         plot(Analysis.signal(15:end,1), Analysis.signal(15:end,2:5)); hold on;
         legend('center', 'upper','down','fit');
         plot([Analysis.signal(1,1) Analysis.signal(end,1)],[Analysis.Phantomfatlevel  Analysis.Phantomfatlevel ],'Linewidth',1,'color','k'); hold on;
         plot(Analysis.Xcoord*Analysis.Filmresolution, Analysis.Fat_ref_profile,'-m'); hold on; %'Linewidth',3,'color','m'
         %ax1 = gca;
         set(gca,'XAxisLocation','top');
         xlabel('chest-nipple profile','FontSize',12);
         plot(Analysis.Xcoord*Analysis.Filmresolution, Analysis.Lean_ref_profile,'-b');hold on;
           grid on;
         hold off; 
         copyfigure_handle = foe;
         PowerPoint('copypastefigure','position',[0.1 0.1 0.4 0.4],'LockAspectRatio',false);
         delete(foe);  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %hold on; 
         %plot(signal2); hold on; 
         %plot(signal3); 
         % Position=PowerPoint('gettextposition');
         %PowerPoint('copypastefigure','position',[0.1 0.1 0.4 0.4],'LockAspectRatio',false);delete(foe);  
         % PowerPoint('addtext','text','','position',Position,'carriage',0);
         Position=PowerPoint('gettextposition');
          h_init = findobj('Tag', 'hInit');
         %figure(h_init);
          set(h_init,'Position',[1 scrsz(4)*3/8 scrsz(3)*3/8 scrsz(4)*3/8]);
         copyfigure_handle = h_init;
          PowerPoint('copypastefigure','position',[0.5 0.1 0.45 0.4],'LockAspectRatio',false);
          delete(h_init); 
          h_slope = findobj('Tag', 'Slope');
          %figure(h_slope);
          set(h_slope,'Position',[1 scrsz(4)*3/8 scrsz(3)*3/8 scrsz(4)*3/8]);
          %ax1 = gca;
          set(gca,'XAxisLocation','top');
          xlabel('step height','FontSize',12)
          ylabel('ROI value','FontSize',12)
         % grid on;
          copyfigure_handle = h_slope;
          PowerPoint('copypastefigure','position',[0.1 0.55 0.4 0.4],'LockAspectRatio',false);
          delete(h_slope); 
         %%%%%%%%%%% add horizontal profile
         sz = size(Analysis.signal_horiz)
         foe=figure; 
         set(foe, 'Visible','off');
         scrsz = get(0,'ScreenSize');
         set(foe,'Position',[1 scrsz(4)*3/8 scrsz(3)*2/8 scrsz(4)*3/8]);
        % set(foe, 'Visible','off');
         plot(Analysis.signal_horiz(1:end,1), Analysis.signal_horiz(1:end,2:4)); hold on;
         legend('left', 'center','right',4);
         %plot([Analysis.signal(1,1) Analysis.signal(end,1)],[Analysis.Phantomfatlevel  Analysis.Phantomfatlevel ],'Linewidth',1,'color','k'); hold on;
         plot(Analysis.signal_horiz(1:end,1), Analysis.Fatref_profile_horiz(1:end-1),'-m'); hold on; %'Linewidth',3,'color','m'
        % ax1 = gca; 
         set(gca,'XAxisLocation','top');
         xlabel('vertical profile','FontSize',12);
         plot(Analysis.signal_horiz(1:end,1), Analysis.Leanref_profile_horiz(1:end-1),'-m');hold on;
         set(gca,'XLim',[Analysis.signal_horiz(1,1) Analysis.signal_horiz(end,1)]);
         grid('on');
         %grid on;
         hold off; 
         copyfigure_handle = foe;
         PowerPoint('copypastefigure','position',[0.5 0.5 0.45 0.45],'LockAspectRatio',false);
         delete(foe);  
    
    case 'ADDDENSITY'
        Position=PowerPoint('gettextposition'); %[Position(1) Position(2)+0.25],
       % PowerPoint('addtext','text',['mAs :',num2str(Recognition.MAS)],'position',[Position(1) Position(2)+0.25],'ERROR',Error.MAS);
         PowerPoint('addtext','text',['Threshold_density, % :',num2str(Analysis.Threshold_density) ,'   BDSXA_angle, %: ',num2str(Analysis.DensityPercentageAngle)]);
         
    case 'SAVECLOSE'
            %PowerPoint('saveclose','text',['D:\aaDATA\Breast Studies\MGH\AutomaticAnalysysReports\6.5version\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']); %aaDATA\Breast Studies\CPMC
            PowerPoint('saveclose','text',[startdir_report,'\AutomaticAnalysysReports\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']);
end