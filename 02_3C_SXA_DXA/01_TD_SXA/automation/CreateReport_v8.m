%Create SXA report
%Lionel HERVE
%9-8-04

function CreateSXAReport(RequestedAction,param)

global data Database Info ctrl figuretodraw ReportText Error Image ROI  PhantomDetectionFailure   axestodraw f copyfigure_handle
global PowerPointReport AutomaticAnalysis Correction Analysis Recognition Phantom h_init h_slope current_fighandle SXAAnalysis flag
global startdir_report MachineParams 

switch RequestedAction
    case 'NEW'
        PowerPoint('INIT');
        if exist('param')
            PowerPointReport.PatientIDbeginning=num2str(param);
        else
            PowerPointReport.PatientIDbeginning='';
        end
        
    case 'ADDCOMMONGEN3' % add the first part of the DXA slide
        PowerPoint('AddSlide');
        
        %gather the information from the acquisition
        SQLstatement=['select date_acquisition, machine_id, Thickness, patient_id from acquisition'];
        SQLstatement=[SQLstatement,' where acquisition.acquisition_id=''',num2str(Info.AcquisitionKey),''''];
        a=mxDatabase(Database.Name,SQLstatement);
        
        machine_id = cell2mat(a(2));
        date_acq = cell2mat(a(1));
        Thickness = cell2mat(a(3));
        patient_id = char(a(4));
        %GEN3_thicknesses = [ 62.57 57.95 52.85  62.57 57.95 52.85];
        Tz_thickness = 52.39;
        Tz_diff = Analysis.thicknessDSP7*10 - Tz_thickness;
        
                    
% %         Diff_1 = Analysis.thicknessWax1*10 - GEN3_thicknesses(1);
% %         Diff_2 = Analysis.thicknessWax2*10  - GEN3_thicknesses(2);
% %         Diff_3 = Analysis.thicknessWax3*10  - GEN3_thicknesses(3);
% %         Diff_4 = Analysis.thicknessWax4*10  - GEN3_thicknesses(4);
% %         Diff_5 = Analysis.thicknessWax5*10  - GEN3_thicknesses(5);
% %         Diff_6 = Analysis.thicknessWax6*10  - GEN3_thicknesses(6);
        Diff_1 = Analysis.Diff_1;
        Diff_2 = Analysis.Diff_2;
        Diff_3 = Analysis.Diff_3;
        Diff_4 = Analysis.Diff_4;
        Diff_5 = Analysis.Diff_5;
        Diff_6 = Analysis.Diff_6;

% %         mean_diff = mean([Diff_1 Diff_2 Diff_3 Diff_4 Diff_5 Diff_6]);
        mean_diff = Analysis.thickness_diff;
        
        set(ctrl.separatedfigure,'value',true);
        % draweverything(1,'PHANTOMLINE');
        Position=PowerPoint('gettextposition');
         PowerPoint('addtext','text','','position',Position,'carriage',0);   
        scrsz = get(0,'ScreenSize');
%          h_fmat = findobj('Tag', 'femur_material');
%          set(h_fmat,'Position',[1 scrsz(4)*3/8 scrsz(3)*3/8 scrsz(4)*3/8]);
%           copyfigure_handle = h_fmat;
%           PowerPoint('copypastefigure','position',[0.1 0.1 0.45 0.45],'LockAspectRatio',false);
%           delete(h_fmat); 
%         copyfigure_handle1 = findobj('Tag','BreastImage');
%         draweverything(1,'PHANTOMLINE');
         
         

        copyfigure_handle = findobj('Tag','GEN3');
         draweverything(1,'PHANTOMLINE');
        PowerPoint('copypastefigure','position',[0 0 0.5 0.75],'LockAspectRatio',false);
       
        delete(copyfigure_handle);
        
        % Add text acquisition description
        PowerPoint('addtext','text',[ 'acquisition_id: ',num2str(Info.AcquisitionKey)],'bold',true,'underlined',true,'carriage',2.5,'position',[0.5 0],'fontsize',1.5);
        rows_num = Image.rows 
        if flag.small_paddle == true %rows_num < 1800
             PowerPoint('addtext','text',' Small paddle','bold',true,'carriage',3);
         else
             PowerPoint('addtext','text',' Large paddle','bold',true,'carriage',3); 
        end
         param_list=mxDatabase(Database.Name,['select * from MachineParameters where machine_id=',num2str(Info.centerlistactivated)]);
        x_center = cell2mat(param_list(2));
        y_center = cell2mat(param_list(3));
        PowerPoint('addtext','text',['Machine ID: ',num2str(machine_id)]);
        PowerPoint('addtext','text',['Patient ID: ',patient_id]);
        PowerPoint('addtext','text',['Date: ',num2str(date_acq)],'carriage',2);   
        PowerPoint('addtext','text',['DICOM Thickness: ',num2str(Thickness), ' mm']); 
        PowerPoint('addtext','text',['SXA  tz point thickness: ',num2str(Analysis.thicknessDSP7*10), ' mm'],'carriage',3); 
        PowerPoint('addtext','text',['Line 1 difference ',num2str(Diff_1), ' mm']);
        PowerPoint('addtext','text',['Line 4 difference ',num2str(Diff_4), ' mm']);
        PowerPoint('addtext','text',['Line 2 difference ',num2str(Diff_2), ' mm']);
        PowerPoint('addtext','text',['Line 5 difference ',num2str(Diff_5), ' mm']);
        PowerPoint('addtext','text',['Line 3 difference ',num2str(Diff_3), ' mm']);
        PowerPoint('addtext','text',['Line 6 difference ',num2str(Diff_6), ' mm']);
        PowerPoint('addtext','text',['tz difference: ',num2str(Tz_diff)], ' mm');  
        PowerPoint('addtext','text',['Average difference: ',num2str(mean_diff), ' mm'],'carriage',3);
       % PowerPoint('addtext','text',['Dtabase Thickness offset: ',num2str(MachineParams.bucky_distance)]);
        PowerPoint('addtext','text',['index of date: ',num2str(Analysis.index_date)]); 
        PowerPoint('addtext','text',['thickness error: ',num2str(Analysis.error_thickDB)]); 
        PowerPoint('addtext','text',['ry angle: ',num2str(Analysis.Y_angle)]); 
        PowerPoint('addtext','text',['rx angle: ',num2str(Analysis.X_angle)]); 
        PowerPoint('addtext','text',['rz angle: ',num2str(Analysis.params(3))]); 
        PowerPoint('addtext','text',['Error reconstruction: ',num2str(Analysis.params(7))]);
       PowerPoint('addtext','text',['GEN3 Background: ',num2str(Analysis.Ibkg)]); 
        
        PowerPoint('addtext','text',['Density GEN3 100 6cm = ',num2str(Analysis.density_GEN3(1)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(1))]);
        Position2=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Density GEN3 100 4cm =  ',num2str(Analysis.density_GEN3(2)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(2))]);
        PowerPoint('addtext','text',['Density GEN3 100 2cm = ',num2str(Analysis.density_GEN3(3)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(3))]);
        PowerPoint('addtext','text',['Density GEN3 50 6cm = ',num2str(Analysis.density_GEN3(4)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(4))]);
        PowerPoint('addtext','text',['Density GEN3 50 4cm = ',num2str(Analysis.density_GEN3(5)),', known thickness= ',num2str(Analysis.density_GEN3_246cm(5))]);
        PowerPoint('addtext','text',['Density GEN3 50 2cm = ',num2str(Analysis.density_GEN3(6)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(6))]);
        PowerPoint('addtext','text',['Density GEN3 0 6cm = ',num2str(Analysis.density_GEN3(7)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(7))]);
        PowerPoint('addtext','text',['Density GEN3 0 4cm = ',num2str(Analysis.density_GEN3(8)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(8))]);
        PowerPoint('addtext','text',['Density GEN3 0 2cm = ',num2str(Analysis.density_GEN3(9)), ', known thickness= ',num2str(Analysis.density_GEN3_246cm(9))]);
     %werPoint('addtext','text',['Average difference due to thickness error ',num2str(Analysis.density_diff), ' %']);
        % PowerPoint('addtext','text',['GEN3 Calibration difference in days :',num2str(Analysis.calib_diffdays)]); 
        PowerPoint('addtext','text',['GEN3 Calibration difference in days :',num2str(Analysis.GEN3diffdays)]);
        PowerPoint('addtext','text',['Source center, x= ',num2str(Analysis.x0cm_diff), ' cm;  ','x(Database)= ',num2str(x_center), ' cm']);
        PowerPoint('addtext','text',['Source center, y= ',num2str(Analysis.y0cm_diff), ' cm;  ','y(Database,= ',num2str(y_center), ' cm'],'carriage',3);
%         PowerPoint('AddSlide');
%          Position=PowerPoint('gettextposition');
         Position = [0 Position2(2)];
        PowerPoint('addtext','text','','position',Position,'carriage',0); 
        PowerPoint('addtext','text',['BEFORE corr 100 6cm = ',num2str(Analysis.density_GEN3BFCorr(1)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(1))],'position',Position);
        PowerPoint('addtext','text',['BEFORE Corr 100 4cm =  ',num2str(Analysis.density_GEN3BFCorr(2)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(2))]);
        PowerPoint('addtext','text',['BEFORE corr 100 2cm = ',num2str(Analysis.density_GEN3BFCorr(3)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(3))]);
        PowerPoint('addtext','text',['BEFORE corr 50 6cm = ',num2str(Analysis.density_GEN3BFCorr(4)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(4))]);
        PowerPoint('addtext','text',['BEFORE corr 50 4cm = ',num2str(Analysis.density_GEN3BFCorr(5)),', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(5))]);
        PowerPoint('addtext','text',['BEFORE corr 50 2cm = ',num2str(Analysis.density_GEN3BFCorr(6)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(6))]);
        PowerPoint('addtext','text',['BEFORE corr 0 6cm = ',num2str(Analysis.density_GEN3BFCorr(7)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(7))]);
        PowerPoint('addtext','text',['BEFORE corr 0 4cm = ',num2str(Analysis.density_GEN3BFCorr(8)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(8))]);
        PowerPoint('addtext','text',['BEFORE corr 0 2cm = ',num2str(Analysis.density_GEN3BFCorr(9)), ', known thickness= ',num2str(Analysis.density_GEN3_246cmBFCorr(9))]);
              
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
        PowerPoint('addtext','text',['Date: ',PowerPointReport.Date,  '     Thickness correction:  ',num2str(Analysis.error_thickDB),'mm']);
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
         PowerPoint('addtext','text',['GEN3 Calibration difference in days :',num2str(Analysis.calib_diffdays)]); num2str(Analysis.DensityPercentageBFCorr)
         PowerPoint('addtext','text',['BDSXA before poly correction :',num2str(Analysis.DensityPercentageBFCorr)]);
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
%           h_init = findobj('Tag', 'hInit');
         %figure(h_init);
           h_init =figure;imagesc(Analysis.DensityImagev8);colormap(gray);
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
         sz1 = size(Analysis.signal_horiz(:,1))
         
         plot(Analysis.signal_horiz(1:sz1(1)-1,1), Analysis.signal_horiz(1:sz1(1)-1,2:4)); hold on;
         legend('left', 'center','right',4);
         %plot([Analysis.signal(1,1) Analysis.signal(end,1)],[Analysis.Phantomfatlevel  Analysis.Phantomfatlevel ],'Linewidth',1,'color','k'); hold on;
        
         sz1 = size(Analysis.Fatref_profile_horiz(1:end-1))
         plot(Analysis.signal_horiz(1:sz1(1)-1,1), Analysis.Fatref_profile_horiz(1:sz1(1)-1),'-m'); hold on; %'Linewidth',3,'color','m'
        % ax1 = gca; 
         set(gca,'XAxisLocation','top');
         xlabel('vertical profile','FontSize',12);
         plot(Analysis.signal_horiz(1:sz1(1)-1,1), Analysis.Leanref_profile_horiz(1:sz1(1)-1),'-m');hold on;
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
            %PowerPoint('saveclose','text',[startdir_report,'\AutomaticAnalysysReports\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']);
           % startdir_report = '\\ming\users\smalkov\GEN3 phantom test';
            file_path = [startdir_report,'\AutomaticAnalysysReports\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']
             PowerPoint('saveclose','text',[startdir_report,'\AutomaticAnalysysReports\AutomaticAnalysis',PowerPointReport.PatientIDbeginning,'_',num2str(param),'.ppt']);
end