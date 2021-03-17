%Create SXA report
%Lionel HERVE
%9-8-04

function CreateSXAReport(RequestedAction,param)

global data Database Info ctrl figuretodraw ReportText Error Image ROI  PhantomDetectionFailure   axestodraw f copyfigure_handle
global PowerPointReport AutomaticAnalysis Correction Analysis Recognition Phantom h_init h_slope current_fighandle SXAAnalysis
global DXAAnalysis SXAAnalysis startdir_report maps_CC mapsCC_noflip mapsML_noflip maps_ML Position Position1 pat10 patient_id Position_rad

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
        PowerPoint('addtext','text',['BDSXA :' ,num2str(Analysis.DensityPercentage)]);% ,' (BDSXA (no Skin correction): ',num2str(Analysis.DensityPercentageSkin),')']);
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
                PowerPoint('addtext','text',['/',num2str(funcFindNextAvailableKey(Database,'SXAStepanalysis'))],'position',[0.7,0.0],'bold',true,'fontsize',1.5);
            end
        end
        
        %PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ' (Lead marker: ',AutomaticAnalysis.Marker,')',' (Angle: ',Phantom.Angle,')' ],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ',  Angle chest-nipple ry: ',num2str(Analysis.ry)],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Angle rx :',num2str(Analysis.rx), ',  Thickness: ',num2str(Analysis.ph_thickness)]);
         %Position=PowerPoint('gettextposition');
        %PowerPoint('addtext','text',['BDSXA :',num2str(Analysis.DensityPercentage)]);% ,', BDSXA_angle: ',num2str(Analysis.alfa)
        PowerPoint('addtext','text',['BDSXA (Skin corrected) :',num2str(Analysis.DensityPercentageSkin)]);% ,' (BDSXA (no Skin correction): ',num2str(Analysis.DensityPercentageSkin)]);
        PowerPoint('addtext','text',['BDSXA (No Skin correction) :',num2str(Analysis.DensityPercentage)]);
        PowerPoint('addtext','text',['kVp :',num2str(Info.kVp), ',  mAs: ',num2str(Info.mAs),',  Convergence: ',num2str(Analysis.params(7))]);
        PowerPoint('addtext','text',['Absolute Volume Real:',num2str(SXAAnalysis.SXABreastVolumeReal),' , Absolute Volume Real:',num2str(SXAAnalysis.SXABreastVolumeProj)]);
        
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
    
    case 'DXASPECIFIC'
       
        Position=PowerPoint('gettextposition');
        DXAID='';
        try 
            if ~Error.DENSITY
                PowerPoint('addtext','text',['/',num2str(funcFindNextAvailableKey(Database,'DXAanalysis'))],'position',[0.7,0.0],'bold',true,'fontsize',1.5);
            end
        end
               
        %PowerPoint('addtext','text',['Room :',num2str(AutomaticAnalysis.Room), ' (Lead marker: ',AutomaticAnalysis.Marker,')',' (Angle: ',Phantom.Angle,')' ],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Room :',num2str(Info.centerlistactivated)],'position',Position);
        %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['DXA Breat Area Total :',num2str(DXAAnalysis.DXABreastAreaTotal)]); %, ',  Thickness: ',num2str(Analysis.ph_thickness)]);
         %Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['DXA Density Total:',num2str(DXAAnalysis.DXADensityPercentageTotal)]);
        PowerPoint('addtext','text',['kVp :',num2str(Info.kVp), ',  mAs: ',num2str(Info.mAs)]);
        PowerPoint('addtext','text',['DXA Dense Volume Proj :',num2str(DXAAnalysis.DXABreastVolumeProj)]);
        
        SQLstatement=['SELECT ALL SXAstepAnalysis.SXAstepAnalysis_id, SXAstepAnalysis.SXAStepresultTotal FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxastepanalysis.commonanalysis_id  AND acquisition.acquisition_id =' ,num2str(Info.AcquisitionKeyLE),  'ORDER BY SXAstepAnalysis.SXAstepAnalysis_id DESC']; 
        temp = cell2mat(mxDatabase(Database.Name,SQLstatement));
        if ~isempty(temp)
           sxa_density = temp(1,2);
        else
           sxa_density = [];
        end
        
        PowerPoint('addtext','text',['SXA Density Total:',num2str(sxa_density) ]);
        Position=PowerPoint('gettextposition');
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
        
         sz = size(Analysis.signal);
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
         
     case 'ADD3CIMAGES'   
         % CC and MLO images
          PowerPoint('AddSlide');
         PowerPoint('addtext','text',['patient ID:   ',patient_id],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.3);
         Position=PowerPoint('gettextposition');
         PowerPoint('addtext','text',['LCC' ],'position',[Position(1)+0.2 Position(2)]);
         PowerPoint('addtext','text',['LMLO' ],'position',[0.75 Position(2)]);
         % CC
         foe=figure;imagesc(mapsCC_noflip.LEPres);colormap(gray); colorbar;
         hold on;  plot(mapsCC_noflip.lesion.xy(:,1), mapsCC_noflip.lesion.xy(:,2),'LineWidth',1.0, 'color','g');
         PowerPoint('copypastefigure','position',[0 0.06 0.5 0.75],'LockAspectRatio',false);delete(foe); 
         % MLO
         foe=figure;imagesc(mapsML_noflip.LEPres);colormap(gray); colorbar; hold on;
         hold on;  plot(mapsML_noflip.lesion.xy(:,1), mapsML_noflip.lesion.xy(:,2),'LineWidth',1.0, 'color','g');
         PowerPoint('copypastefigure','position',[0.5 0.06 0.5 0.75],'LockAspectRatio',false);delete(foe); 
           
         % next slide
         PowerPoint('AddSlide');
         PowerPoint('addtext','text',['patient ID:   ',patient_id],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.3);
         Position=PowerPoint('gettextposition');
         clims_water = [0 5]; 
         clims_prot = [-0.5 3];
         clims_lipid = [0 8];
        
         foe=figure;imagesc(mapsCC_noflip.LEPres);colormap(gray); colorbar;
         hold on;  plot(mapsCC_noflip.lesion.xy(:,1), mapsCC_noflip.lesion.xy(:,2),'LineWidth',1.0, 'color','g');
         PowerPoint('addtext','text',['LCC' ],'position',[Position(1)+0.07 Position(2)]);
         PowerPoint('addtext','text',['LMLO' ],'position',[0.25 Position(2)]);
         
         PowerPoint('addtext','text',['CC' ],'position',[0.36 Position(2)+0.06]);
         PowerPoint('addtext','text',['MLO' ],'position',[0.36 Position(2)+0.16]);
         
         PowerPoint('addtext','text',['lesion ROI' ],'position',[0.42 Position(2)]);
         PowerPoint('addtext','text',['Water' ],'position',[0.58 Position(2)]);
         PowerPoint('addtext','text',['Lipid' ],'position',[0.73 Position(2)]);
         PowerPoint('addtext','text',['Protein' ],'position',[0.87 Position(2)]);
         PowerPoint('copypastefigure','position',[Position(1)+0.02 0.06 0.15 0.2],'LockAspectRatio',false);delete(foe);   
         
         foe=figure;imagesc(mapsML_noflip.LEPres);colormap(gray); colorbar; hold on;
         hold on;  plot(mapsML_noflip.lesion.xy(:,1), mapsML_noflip.lesion.xy(:,2),'LineWidth',1.0, 'color','g');               
         PowerPoint('copypastefigure','position',[0.2 0.06 0.15 0.2],'LockAspectRatio',false);delete(foe); 
         
         %%% ROI around lesion
         kc= 0.8;
         %CC view 
         xy = [];
        xy = mapsCC_noflip.lesion.xy;
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.ymin_ppt = roi.ymin-roi.rows*kc;
        roi.ymax_ppt = roi.ymin+roi.rows*(1+kc)-1;
        roi.xmin_ppt = roi.xmin-roi.columns*kc;
        roi.xmax_ppt = roi.xmin+roi.columns*(1+kc)-1;
        im_sz = size(mapsCC_noflip.LEPres);
        
        if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
            kc = 0.55;
            roi.ymin_ppt = roi.ymin-roi.rows*kc;
            roi_ymax_ppt = roi.ymin+roi.rows*(1+kc)-1;
            roi.xmin_ppt = roi.xmin-roi.columns*kc;
            roi.xmax_ppt = roi.xmin+roi.columns*(1+kc)-1;
            if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
                kc = 0.3;
                roi.ymin_ppt = roi.ymin-roi.rows*kc;
                roi_ymax_ppt = roi.ymin+roi.rows*(1+kc)-1;
                roi.xmin_ppt = roi.xmin-roi.columns*kc;
                roi.xmax_ppt = roi.xmin+roi.columns*(1+kc)-1;
                if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
                    kc = 0;
                end
            end
            
        end
        xy_cc = xy;
        xy = [];
        % MLO view
        km=0.8;
        xy = mapsML_noflip.lesion.xy;
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.ymin_ppt = roi.ymin-roi.rows*km;
        roi.ymax_ppt = roi.ymin+roi.rows*(1+km)-1;
        roi.xmin_ppt = roi.xmin-roi.columns*km;
        roi.xmax_ppt = roi.xmin+roi.columns*(1+km)-1;
        im_sz = size(mapsML_noflip.LEPres);
        
        if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
            km = 0.55;
            roi.ymin_ppt = roi.ymin-roi.rows*km;
            roi_ymax_ppt = roi.ymin+roi.rows*(1+km)-1;
            roi.xmin_ppt = roi.xmin-roi.columns*km;
            roi.xmax_ppt = roi.xmin+roi.columns*(1+km)-1;
            if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
                km = 0.3;
                roi.ymin_ppt = roi.ymin-roi.rows*km;
                roi_ymax_ppt = roi.ymin+roi.rows*(1+km)-1;
                roi.xmin_ppt = roi.xmin-roi.columns*km;
                roi.xmax_ppt = roi.xmin+roi.columns*(1+km)-1;
                if (roi.xmin_ppt < 1 | roi.ymin_ppt < 1 | roi.xmax_ppt > im_sz(2) | roi.ymax_ppt >  im_sz(1))
                    km = 0;
                end
            end           
        end
        
        xy_ml = xy;
        xy = [];
        k= min([km, kc])
        km=k;
        kc=k;
        %CC view
        minx = min(xy_cc(:,1));maxx = max(xy_cc(:,1));miny = min(xy_cc(:,2));maxy = max(xy_cc(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*kc); roi.rows1k = round(roi.rows*(1+kc)); roi.columnsk = round(roi.columns*kc); roi.columns1k = round(roi.columns*(1+kc));
         roicc = mapsCC_noflip.LEPres(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        %roicc = mapsCC_noflip.LEPres(roi.ymin_ppt:roi_ymax_ppt,roi.xmin_ppt:roi.xmax_ppt);
        foe=figure;imagesc(roicc);colormap(gray); colorbar; hold on;
        plot(xy_cc(:,1)-roi.xmin+roi.columnsk, xy_cc(:,2)-roi.ymin+roi.rowsk, '-g');
        % PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.4 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;
         
% %          xy = maps_CC.lesion.xy;
% %         minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
% %         roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
% %         roi.rowsk = round(roi.rows*k); roi.rows1k = round(roi.rows*(1+k)); roi.columnsk = round(roi.columns*k); roi.columns1k = round(roi.columns*(1+k));
% %         roicc = maps_CC.LEPres(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
% %         foe=figure;imagesc(roicc*1000);colormap(gray); hold on; %,clims_water
% %         plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
% %          %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
% %          PowerPoint('copypastefigure','position',[0.4 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
% %          clear roicc;
         
         
% % %          flip_image = maps_CC.LEPres;
% % %          xy = maps_CC.lesion.xy;
% % %          if maps_CC.flip_info(1)
% % %             flip_image = flipdim(flip_image,2);
% % %             xy = flip_xy(xy,size(flip_image),'flipH');          
% % %          end
% % %          if maps_CC.flip_info(2)
% % %             flip_image = flipdim(flip_image,1);
% % %             xy = flip_xy(xy,size(flip_image),'flipV'); 
% % %          end
% % %          
% % %         minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
% % %         roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
% % %         roi.rowsk = round(roi.rows*kc); roi.rows1k = round(roi.rows*(1+kc)); roi.columnsk = round(roi.columns*kc); roi.columns1k = round(roi.columns*(1+kc));
% % %         roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
% % %         foe=figure;imagesc(roicc*1000);colormap(gray); hold on; %,clims_water
% % %         plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
% % %          %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
% % %          PowerPoint('copypastefigure','position',[0.4 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
% % %          clear roicc xy flip_image;
         
          flip_image = maps_CC.water;
         xy = maps_CC.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
         
               
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*kc); roi.rows1k = round(roi.rows*(1+kc)); roi.columnsk = round(roi.columns*kc); roi.columns1k = round(roi.columns*(1+kc));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_water);colormap(gray);h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
         %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.55 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc xy flip_image;
         
          flip_image = maps_CC.lipid;
         xy = maps_CC.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
        
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*kc); roi.rows1k = round(roi.rows*(1+kc)); roi.columnsk = round(roi.columns*kc); roi.columns1k = round(roi.columns*(1+kc));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_lipid);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
        % PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.7 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;

          flip_image = maps_CC.protein;
         xy = maps_CC.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
                        
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*kc); roi.rows1k = round(roi.rows*(1+kc)); roi.columnsk = round(roi.columns*kc); roi.columns1k = round(roi.columns*(1+kc));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_prot);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
        % PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.85 0.06 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;
         
         %%% MLO view
          minx = min(xy_ml(:,1));maxx = max(xy_ml(:,1));miny = min(xy_ml(:,2));maxy = max(xy_ml(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*km); roi.rows1k = round(roi.rows*(1+km)); roi.columnsk = round(roi.columns*km); roi.columns1k = round(roi.columns*(1+km));
         roicc = mapsML_noflip.LEPres(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
         foe=figure;imagesc(roicc);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on;
        plot(xy_ml(:,1)-roi.xmin+roi.columnsk, xy_ml(:,2)-roi.ymin+roi.rowsk, '-g');
        % PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.4 0.162 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;
         
% %           xy = mapsML_noflip.lesion.xy;
% %         minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
% %         roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
% %         roi.rowsk = round(roi.rows*k); roi.rows1k = round(roi.rows*(1+k)); roi.columnsk = round(roi.columns*k); roi.columns1k = round(roi.columns*(1+k));
% %         roicc = mapsML_noflip.LEPres(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
% %         foe=figure;imagesc(roicc);colormap(gray); hold on;
% %         plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
% %          %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
% %          PowerPoint('copypastefigure','position',[0.4 0.162 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         
         
           flip_image = maps_ML.water;
          xy = maps_ML.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
          
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*km); roi.rows1k = round(roi.rows*(1+km)); roi.columnsk = round(roi.columns*km); roi.columns1k = round(roi.columns*(1+km));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_water);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
         %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.55 0.162 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;
%          
          flip_image = maps_ML.lipid;
          xy = maps_ML.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*km); roi.rows1k = round(roi.rows*(1+km)); roi.columnsk = round(roi.columns*km); roi.columns1k = round(roi.columns*(1+km));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_lipid);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
        % PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.7 0.162 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;

         flip_image = maps_ML.protein;
          xy = maps_ML.lesion.xy;
         if maps_CC.flip_info(1)
            flip_image = flipdim(flip_image,2);
            xy = flip_xy(xy,size(flip_image),'flipH');          
         end
         if maps_CC.flip_info(2)
            flip_image = flipdim(flip_image,1);
            xy = flip_xy(xy,size(flip_image),'flipV'); 
         end
        minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
        roi.xmin = minx; roi.ymin = miny; roi.columns = (maxx - minx); roi.rows = (maxy-miny);
        roi.rowsk = round(roi.rows*km); roi.rows1k = round(roi.rows*(1+km)); roi.columnsk = round(roi.columns*km); roi.columns1k = round(roi.columns*(1+km));
        roicc = flip_image(roi.ymin-roi.rowsk:roi.ymin+roi.rows1k-1,roi.xmin-roi.columnsk:roi.xmin+roi.columns1k-1);
        foe=figure;imagesc(roicc,clims_prot);colormap(gray); h=colorbar;set(h,'fontsize',14); hold on; %,clims_water
        plot(xy(:,1)-roi.xmin+roi.columnsk, xy(:,2)-roi.ymin+roi.rowsk, '-g');
         %PowerPoint('addtext','text',['Lipid ' ],'position',[Position(1)+0.55 Position(2)]);
         PowerPoint('copypastefigure','position',[0.85 0.162 0.1 0.1],'LockAspectRatio',false);delete(foe);  
         clear roicc;
         
      
     
     case 'ADD3CRADIOLOGYFORM'   
% %         
      ind_pathol = find(strcmp('Study ID',pat10(:,1)));
 PowerPoint('AddSlide');
% Study Radiologist Input Form
        PowerPoint('addtext','text',['Study Radiologist Input Form'],'position',[0.02 0.25],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0); %'position',[0.3 0],
        Position=PowerPoint('gettextposition');
        Position1 = Position;
        for i=1:5
            % %         PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',char(pat10(i,2)),'position',[Position(1)+0.25 Position1(2)],'carriage',1.0);
            % %         Position1=PowerPoint('gettextposition');
            
            finding_str = num2str(cell2mat(pat10(i,2))); %           char(pat10(i,2));
            if length(finding_str) > 36
                PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(1:36),'position',[Position(1)+0.25 Position1(2)],'carriage',1);
                Position1=PowerPoint('gettextposition');
                PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(39:end),'position',[Position(1)+0.25 Position1(2)],'carriage',1.0);
                Position1=PowerPoint('gettextposition');
            else
                PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str,'position',[Position(1)+0.25 Position1(2)],'carriage',1);
                Position1=PowerPoint('gettextposition');
            end
        end
        
        PowerPoint('addtext','text',char(pat10(6,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',char(pat10(6,2)),'position',[Position(1)+0.25 Position1(2)],'carriage',1);
        %PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',2.0);    
        Position_rad=PowerPoint('gettextposition');
        % Abnormalities in the circled area of the biopsy
        PowerPoint('addtext','text',['Abnormalities in the circled area of the biopsy'],'position',[0.5 0.25],'bold',true,'underlined',true,'fontsize',1.0,'carriage',1); %'position',[0.3 0],
        Position1=PowerPoint('gettextposition');
        Position = Position1;
% %          PowerPoint('addtext','text',['Calcification Morphology:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['Fine pleomorphic'],'position',[Position(1)+0.35 Position1(2)],'carriage',1.0);
% %         Position1=PowerPoint('gettextposition');
        
        
        for i=7:ind_pathol(2)-1
        sec_line =  char(pat10(i,1));  
        if length(sec_line) > 45 %54
            sec_line = [sec_line(1:41),')'];
        end
        PowerPoint('addtext','text',sec_line,'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',num2str(cell2mat(pat10(i,2))),'position',[Position(1)+0.3 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
        end
        
        %%%%%%%%%%%%%%% 3CB-QIA results
        Position1(2) = max([(Position1(2)+0.01),Position_rad(2)+0.01]);
% %           PowerPoint('addtext','text',[''],'position',[0.02 Position1(2)+0.04],'carriage',0.5);  
        Position(1)=0.02;
        PowerPoint('addtext','text',['Results of QIA'],'position',[0.02 Position1(2)],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
       PowerPoint('addtext','text',['Results:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[''],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
              
        %Results of 3CB
        results_3CB = [3, 0.3, 0.14, 3.44];
         results_3CB = [];
        cc = maps_CC.results;
        ml = maps_ML.results;
        PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)+0.04],'carriage',0.5);         
        PowerPoint('addtext','text',['Results of 3CB'],'bold',true,'underlined',true,'fontsize',1.2); 
        Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['CC view'],'bold',true,'fontsize',1.0,'position',[Position(1)+0.4 Position1(2)]);   
        PowerPoint('addtext','text',['CC view'],'bold',true,'fontsize',1.0,'position',[Position(1)+0.6 Position1(2)],'carriage',1.0); 
        Position1=PowerPoint('gettextposition');
       % sz = size(results_3CB);
        if ~isempty(maps_CC.results) %& sz(1)>= 1
            PowerPoint('addtext','text',['Breast water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(cc.ROIW),'/',num2str(cc.ROIL),'/',num2str(cc.ROIP)],'position',[Position(1)+0.4 Position1(2)]); % /total  ,'/',num2str(results_3CB(1,4))
            PowerPoint('addtext','text',[num2str(ml.ROIW),'/',num2str(ml.ROIL),'/',num2str(ml.ROIP)],'position',[Position(1)+0.6 Position1(2)],'carriage',1.0); %,'/',num2str(results_3CB(1,4))
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Breast water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0); %/total
            Position1=PowerPoint('gettextposition');
        end
        
        if ~isempty(results_3CB) & sz(1)>= 2
            PowerPoint('addtext','text',['Lesion ROI water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(2,1)),'/',num2str(results_3CB(2,2)),'/',num2str(results_3CB(2,3)),'/',num2str(results_3CB(2,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Lesion ROI water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        end
         
        if ~isempty(results_3CB) & sz(1)>= 3
            PowerPoint('addtext','text',['Periphery water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(3,1)),'/',num2str(results_3CB(3,2)),'/',num2str(results_3CB(3,3)),'/',num2str(results_3CB(3,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Periphery water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        end
        
        if ~isempty(results_3CB) & sz(1)>= 4
         PowerPoint('addtext','text',['SXA %FGV/Volume/FGV, %/cm3/cm3:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(4,1)),'/',num2str(results_3CB(4,2)),'/',num2str(results_3CB(4,3)),'/',num2str(results_3CB(4,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['SXA %FGV/Volume/FGV, %/cm3/cm3:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition'); 
        end
                
        PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)+0.005],'carriage',0.5);         
        PowerPoint('addtext','text',['Results of QIA/3CB'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Results:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[''],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
         
        PowerPoint('addtext','text',['Study Pathologist Input Form'],'position',[0.02 Position1(2)+0.04],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0); %'position',[0.3 0],
        Position=PowerPoint('gettextposition');
        Position1=PowerPoint('gettextposition');
         last_i = [];
         szp = size(pat10);
         for i = ind_pathol(2)+2:szp(1)
             finding_str = num2str(cell2mat(pat10(i,2))); %           char(pat10(i,2));
             if length(finding_str) > 80 & length(finding_str) <= 160
                 PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[finding_str(1:80)],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 Position1=PowerPoint('gettextposition');
                 PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(81:end),'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
                 Position1=PowerPoint('gettextposition');
             elseif length(finding_str) > 160    
                 PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[finding_str(1:80)],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 Position1=PowerPoint('gettextposition');
                 PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(81:160),'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
                 Position1=PowerPoint('gettextposition');
                 PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(161:end),'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
                 Position1=PowerPoint('gettextposition');
                 
             else
                 PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[finding_str],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 Position1=PowerPoint('gettextposition');
             end
             if Position1(2) > 0.95
                 PowerPoint('addtext','text','(continued on the next slide)','position',[Position(1)+0.2 Position1(2)]); PowerPoint('addtext','text','','position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 last_i = i;
                 break;
             end
         end
        
         if ~isempty(last_i)
             PowerPoint('AddSlide');
             PowerPoint('addtext','text',['patient ID:   ',patient_id],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.3);
         Position1=PowerPoint('gettextposition');
             PowerPoint('addtext','text',['Study Pathologist Input Form (continued)'],'position',[0.02 Position1(2)+0.04],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0); %'position',[0.3 0],
        Position=PowerPoint('gettextposition');
        Position1=PowerPoint('gettextposition');
             for i = last_i:szp(1)
             finding_str = num2str(cell2mat(pat10(i,2))); %           char(pat10(i,2));
             if length(finding_str) > 80
                 PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[finding_str(1:80)],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 Position1=PowerPoint('gettextposition');
                 PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(81:end),'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
                 Position1=PowerPoint('gettextposition');
             else
                 PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[finding_str],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
                 Position1=PowerPoint('gettextposition');
             end
             end
         end
% %         szp = size(pat10);
% %          for i = ind_pathol(2)+3:szp(1)
% %             if pat10(ind_pathol(2)+2,2));
% %          PowerPoint('addtext','text',char(pat10(i,1)),'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',num2str(cell2mat(pat10(i,2))),'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
% %          Position1=PowerPoint('gettextposition');
% %         end
         
       case 'ADD3CPATHOLOGYFORM'   
        PowerPoint('addtext','text',['Study Pathologist Input Form'],'position',[0.02 Position1(2)],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0); %'position',[0.3 0],
        Position=PowerPoint('gettextposition');
        Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Details of Finding:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['1. Benign breast tissue with columnar cell changes and associated microcalcifications.'],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
        Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['2. Microscopic intraductal papilloma.'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Size in Cm (by imaging):'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['0.4'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Clinical Hx:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['42 year-old female with clustered calcifications in the left breast'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Was there a mixture present in the biopsy:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['No'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
       
           PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',0.5);         
        PowerPoint('addtext','text',['Papilary Lesion'],'bold',true,'underlined',true,'fontsize',1.0,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
         PowerPoint('addtext','text',['Papilary Lesion:']); PowerPoint('addtext','text',['Intraductal Papilloma'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0); %,'position',[0.5 0.25]
         Position1=PowerPoint('gettextposition');
          PowerPoint('addtext','text',['Description:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['Microscopic sclerosed papilloma (~0.05 cm, excised)'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
         
         % Other Benign Breast Diseases
         PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',0.5);    
            PowerPoint('addtext','text',['Other Benign Breast Diseases'],'bold',true,'underlined',true,'fontsize',1.0,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
         PowerPoint('addtext','text',['Proliferative Disease without Atypia:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['Columnar cell change/hyperplasia'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
          PowerPoint('addtext','text',['Calcifications:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['Yes'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');

          PowerPoint('addtext','text',['Unremarkable finding:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['With calcifications involving benign breast tissue'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         Position1=PowerPoint('gettextposition');
      
     case 'ADD3CQIARESULTS'         
         %Results of QIA;
        PowerPoint('addtext','text',[''],'position',[0.02 Position1(2)],'carriage',0.5);  
        Position=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Results of QIA'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
       PowerPoint('addtext','text',['Results:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[''],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
              
        %Results of 3CB
        results_3CB = [3, 0.3, 0.14, 3.44];
        PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',0.5);         
        PowerPoint('addtext','text',['Results of 3CB'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
        sz = size(results_3CB);
        if ~isempty(results_3CB) & sz(1)<= 1
            PowerPoint('addtext','text',['Central ROI water/lipid/protein/total, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(1,1)),'/',num2str(results_3CB(1,2)),'/',num2str(results_3CB(1,3)),'/',num2str(results_3CB(1,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Central ROI water/lipid/protein/total, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        end
        
        if ~isempty(results_3CB) & sz(1)<= 2
            PowerPoint('addtext','text',['Lesion ROI water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(2,1)),'/',num2str(results_3CB(2,2)),'/',num2str(results_3CB(2,3)),'/',num2str(results_3CB(2,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Lesion ROI water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        end
         
        if ~isempty(results_3CB) & sz(1)<= 3
            PowerPoint('addtext','text',['Periphery water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(3,1)),'/',num2str(results_3CB(3,2)),'/',num2str(results_3CB(3,3)),'/',num2str(results_3CB(3,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['Periphery water/lipid/protein, cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
            Position1=PowerPoint('gettextposition');
        end
        
        if ~isempty(results_3CB) & sz(1)<= 3
         PowerPoint('addtext','text',['SXA %FGV/Volume/FGV, %/cm3/cm3:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(4,1)),'/',num2str(results_3CB(4,2)),'/',num2str(results_3CB(4,3)),'/',num2str(results_3CB(4,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
        else
            PowerPoint('addtext','text',['SXA %FGV/Volume/FGV, %/cm3/cm3:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',' -/-/-/-','position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition'); 
        end
                
        PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',0.5);         
        PowerPoint('addtext','text',['Results of QIA/3CB'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);  
        Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Results:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[''],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
        Position1=PowerPoint('gettextposition');
     case 'ADDDXAPROFILES'   
         %imagesc(AutomaticAnalysis.Imagette);colormap(gray);
         PowerPoint('AddSlide');
        
         sz = size(DXAAnalysis.signal1)
         foe = figure; 
         set(foe, 'Visible','on');
         scrsz = get(0,'ScreenSize');
         plot(DXAAnalysis.signal1);hold on; plot(SXAAnalysis.signal1,'-r') %'Linewidth',1,'color','k'
         XLim([1 ROI.xmax]);
         Info.AcquisitionKeyLE
         
         grid on; hold off; 
         copyfigure_handle = foe;
         PowerPoint('copypastefigure','position',[0.1 0.1 0.4 0.4],'LockAspectRatio',false);
         delete(foe);  
         
         foe2 = figure; 
         set(foe2, 'Visible','on');
         scrsz = get(0,'ScreenSize');
         plot(DXAAnalysis.signal2); hold on; plot(SXAAnalysis.signal2,'-r')
         XLim([1 ROI.ymax]);
         grid on; hold off; 
         copyfigure_handle = foe2;
         PowerPoint('copypastefigure','position',[0.5 0.1 0.45 0.4],'LockAspectRatio',false);
         delete(foe2);
       
    case 'ADDDENSITY'
        Position=PowerPoint('gettextposition'); %[Position(1) Position(2)+0.25],
       % PowerPoint('addtext','text',['mAs :',num2str(Recognition.MAS)],'position',[Position(1) Position(2)+0.25],'ERROR',Error.MAS);
         PowerPoint('addtext','text',['Threshold_density, % :',num2str(Analysis.Threshold_density) ,'   BDSXA_angle, %: ',num2str(Analysis.DensityPercentageAngle)]);
         
    case 'SAVECLOSE'
            %PowerPoint('saveclose','text',['D:\aaDATA\Breast Studies\CPMC\AutomaticAnalysysReports\DigitalImages\6.5version\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']); %aaDATA\Breast Studies\CPMC
            PowerPoint('saveclose','text',[startdir_report,'\AutomaticAnalysisReports\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']);
end