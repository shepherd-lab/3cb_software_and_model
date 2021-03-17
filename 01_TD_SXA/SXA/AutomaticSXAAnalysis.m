%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE  6-17-04
% Developed by Amir Pasha M 11-11-2013


function  AutomaticSXAAnalysis
global ctrl Image Error ReportText AutomaticAnalysis Database Info Recognition Correction Analysis  Threshold Site ROI
global  SXAAnalysis debugMode SXAreport  versionSXA versionstruc  MaskROIproj thickness_mapproj thickness_mapreal BreastMask ROI
%{
 xx1 = [1 1211];
 yy1 = [831 124];
 signal=improfile(Image.image,xx1,yy1);
%}
warning off;

Info.ReportCreated = false;
Info.study_3C = true; % only for 3CB 
time = 0;
auto = AutomaticAnalysis;
%database = Database
inf = Info
rec = Recognition;
cor = Correction;
anal = Analysis;
Analysis.AngleHoriz = [];
Analysis.DensityPercentage = [];
Analysis.DensityPercentageAngle = [];
Analysis.roi_values = [];
Analysis.roi_valuescorr = [];
Analysis.ph_slope80 = [];
Analysis.ph_offset = [];
Analysis.km = [];
Analysis.klean = [];
Analysis.Phantomleanlevel = [];
Analysis.Phantomfatlevel = [];
Analysis.params = [];
Analysis.rx = [];
Analysis.ry = [];
Analysis.ph_thickness = [];
SXAAnalysis.SXABreastVolumeReal = -1;
Error.DENSITY=false;
Error.SkinEdgeFailed = false;
Error.Error = false;
Error.DENSITY = false;
Error.NoCorrection = false;
Error.StepPhantomFailure = false;
Error.PeripheryCalculation = false;
Error.NoBreast = false;
Error.ROIFailed = false;
%qa = QA
control = ctrl;
MaskROIproj=[];
flag.paddle_type = false; %two different paddle types? 0 and 1 in SQL DB 

% %version_type = version_retreiving(Info.AcquisitionKey);
% multiWaitbar( 'Automatic SXA Analysis Progress',  1/5, 'Color', [0.2 0.9 0.3] );
try
    version_type = version_retreiving(Info.AcquisitionKey);
catch
    errmsg = lasterr
    try
        version_type = version_retreiving(Info.AcquisitionKey);
        % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
    catch
        errmsg = lasterr
        nextpatient(0);
        % %         multiWaitbar( 'CloseAll' );
        return;
    end
end



% Added by Am to get ride of phantoms from SXA analysis

if ((~isempty(findstr( Info.PerformedProcedureStepDescription,'Weekly QC')))|(~isempty(findstr( Info.ViewPosition,'PHANTOM')))|(~isempty(findstr( Info.SeriesDescription,'Phantom')))|...
        (~isempty(findstr( Info.patient_id,'111111')))| (~isempty(findstr( Info.patient_id,'S1')))|(~isempty(findstr( Info.patient_id,'RM')))|(~isempty(findstr( Info.patient_id,'DSM')))) %#ok<FSTR,*OR2>
    Message('There is no Breast...');
    Error.NoBreast=true;
    %         AutomaticAnalysis.StructuralAnalysisDone=0;
    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        nextpatient(0);
        %             multiWaitbar( 'CloseAll' );
        return;
    end
    nextpatient(0);
    %         multiWaitbar( 'CloseAll' );
    return;
end;



size_version = size(version_type);
AutomaticAnalysis.ThresholdAnalysisDone = false;
xm = strmatch('mammo_Marsden', Database.Name, 'exact');

if size_version(1) > 0 |Info.DigitizerId >= 4 | xm > 0
    AutomaticAnalysis.CharacterRecognitionDone=0;
    %AutomaticAnalysis.StructuralAnalysisDone=0;
    AutomaticAnalysis.Room = 1;
    Automatic_BDMDanalysis = 1;
else
    AutomaticAnalysis.CharacterRecognitionDone=1;
    % AutomaticAnalysis.StructuralAnalysisDone=1;
    AutomaticAnalysis.Room = -1;
    Automatic_BDMDanalysis = 1;
    
end

Automatic_BDMDanalysis = 0; % no threshold calculation
Analysis.SXAanalysisStatus = 3;
%Automatic_BDMDanalysis = 1;

SaveBool=1;
Analysis.Height1=0;
Analysis.Height2=0;
%Error.DENSITY=1;
Analysis.DensityPercentage=-1;
Correction.Filename='Aborted';
if Info.DigitizerId >= 4
    Error.Correction=false;
    Error.BIGPADDLE=false;
else
    Error.Correction=true;
end
%AutomaticAnalysis.Room = -1;

% AutomaticAnalysis.Room=-1;
AutomaticAnalysis.Marker=-1;
%AutomaticAnalysis.CharacterRecognitionDone=0;
Recognition.TECHNIQUE='ERROR';
% AutomaticAnalysis.StructuralAnalysisDone=0;


%% Determine if the paddle is big or little (in the case it is big, cut the edges)
try %comment for test only
    AutomaticAnalysis.Step=0;
    
    if size(Image.OriginalImage,1)>1800 & Info.DigitizerId ~= 4%detect small / big paddle
        %{
        top=DetectImageEdge(Image.OriginalImage,'TOP');
        imagemenu('CutTopWithParam',top);
        bottom=DetectImageEdge(Image.OriginalImage,'BOTTOM');
        imagemenu('CutBottomWithParam',bottom);
        right=DetectImageEdge(Image.OriginalImage,'RIGHT');
        imagemenu('CutRightWithParam',right);
        left=DetectImageEdge(Image.OriginalImage,'LEFT');
        imagemenu('CutLeftWithParam',left);
        %}
        Error.BIGPADDLE=true;
    end
    %10.09.06
    %set(ctrl.Cor,'value',true);
    %imagemenu('AutomaticCrop');
    
    %{

    MachineID=get(ctrl.Center,'value');
   if AutomaticAnalysis.Room == -1
     if MachineID < 11

        AutomaticAnalysis.Step=0;
       [AutomaticAnalysis.Room,AutomaticAnalysis.Imagette,AutomaticAnalysis.Marker]=FindRoomNumber2;
        if AutomaticAnalysis.Room==-1
            The room was not detected
        end
        SetTheLocationDropMenu(AutomaticAnalysis.Room);
         % Update Room number in the acquisition database
        AutomaticAnalysis.Step=1;

        [foe,index] = max(Site.RoomTable(:,1)==AutomaticAnalysis.Room)

        MachineID=num2str(Site.RoomTable(index,2));
        mid = MachineID
        mxDatabase(Database.Name,['update acquisition set machine_id=''',MachineID,''' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
     else
         ab = [Site.RoomTable(:,2) Site.RoomTable(:,1)];
       %  b = bc(bc(:,1)==4,:)
         roomnum = ab(ab(:,1)==MachineID,:);
        %index = Site.RoomTable(:,1)==MachineID)

        AutomaticAnalysis.Room=num2str(roomnum(2)) ;
     end
   end
    %}
    
    %% Determine Machine Brand
    %Info.BRAND=GetBRAND(Info);
    
    %part2 = toc
    
    %tic
    %% Read the Tag
    if AutomaticAnalysis.CharacterRecognitionDone ~= 0
        AutomaticAnalysis.Step=-1;
        CharacterRecognition('CharacterRecognition',Info.BRAND);
        AutomaticAnalysis.CharacterRecognitionDone=1;
    end
    
    
    
    %%%%%%%%%Added by AM  11112013%%%%%%%%%%%
    
    CheckSXA_Struc();
    
    if flag.paddle_type == 0
        % %     versionstruc=false;
        % %     versionSXA=false;
        % % %     if (Info.date_GEN3_num==false | Analysis.PhantomID == false)
        % % %         Message('Date Acquisition of image is greater than the last Gen3, Check MachineParametersCorrection table!');
        % % %         nextpatient(0);
        % % %         return;
        % % %     end
        Info.date_GEN3_num=true;
        if (~versionSXA==false & ~versionstruc==false);
            Message('It seems there are results with the same Verion in Database');
            nextpatient(0);
            return;
        else
            if Info.CheckSXAStepAnalysis==false
                if Info.date_GEN3_num==true
                    
                    %% phantom detection
                    try   %fit SXA phantom position and orientation
                        %set(ctrl.CheckManualPhantom,'value',0); %manual
                        AutomaticAnalysis.Step=2;
                        CallBack=get(ctrl.Phantom,'callback');
                        eval(CallBack);     %PhantomDetection
                        %                 multiWaitbar( 'Automatic SXA Analysis Progress',  2/5, 'Color', [0.2 0.9 0.3] );
                        %%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%
                        
                    catch
                        Message('There is no Phantom or Phantom Faild...');
                        Error.PhantomDetection = true;
                        if  (Info.Operator==5 & AutomaticAnalysis.StructuralAnalysisDone==0)
                            
                            errmsg = lasterr
                            %                     multiWaitbar( 'CloseAll' );
                            
                            try
                                SaveInDatabase('QACODES');
                            catch
                                errmsg = lasterr
                                try
                                    SaveInDatabase('QACODES');
                                catch
                                    if  (Info.Operator==5 & AutomaticAnalysis.StructuralAnalysisDone==0)
                                        errmsg = lasterr
                                        nextpatient(0);
                                        %                                 multiWaitbar( 'CloseAll' );
                                        return;
                                        
                                    else
                                        Message('There is no Phantom but we continue to compute the Structural Analysis...');
                                    end
                                end
                            end
                            if  (Info.Operator==5 & AutomaticAnalysis.StructuralAnalysisDone==0)
                                nextpatient(0);
                                %                         multiWaitbar( 'CloseAll' );
                                return;
                            else
                                Message('There is no Phantom but we continue to compute the Structural Analysis...');
                            end
                        else
                            Message('There is no Phantom but we continue to compute the Structural Analysis...');
                            SaveInDatabase('QACODES');
                        end
                    end
                    
                else
                    if  ~Info.CheckStructural==false
                        AutomaticAnalysis.StructuralAnalysisDone
                        Analysis.SXA=true;
                        nextpatient(0);
                        %                     multiWaitbar( 'CloseAll' );
                        return;
                    else
                        Info.CheckStructural=false;
                    end;
                    
                end;
                
            else
                if  ~Info.CheckStructural==false
                    AutomaticAnalysis.StructuralAnalysisDone
                    Analysis.SXA=true;
                    nextpatient(0);
                    %                     multiWaitbar( 'CloseAll' );
                    return;
                else
                    Info.CheckStructural=false;
                end;
            end;
            
        end
        
        
        %%%%% Modified by AM 11042013 for operator 23 %%%%%
        %     try
        %% draw ROI (rectangle)
        AutomaticAnalysis.Step=4;
        set(ctrl.CheckAutoROI,'value',true);
        CallBack=get(ctrl.ROI,'callback');
        eval(CallBack);
        %         multiWaitbar( 'Automatic SXA Analysis Progress',  3/5, 'Color', [0.2 0.9 0.3] );
        
        %     catch
        %         multiWaitbar( 'CloseAll' );
        %
        %       if   Error.NoBreast
        %
        %           Error.NoBreast=true;
        %
        %             try
        %                 SaveInDatabase('QACODES');
        %             catch
        %                 errmsg = lasterr
        %                 nextpatient(0);
        %                 multiWaitbar( 'CloseAll' );
        %                 return;
        %             end
        %
        %         else
        %
        %             Error.ROIFailed = true;
        %
        %             try
        %                 SaveInDatabase('QACODES');
        %             catch
        %                 errmsg = lasterr
        %                 nextpatient(0);
        %                 multiWaitbar( 'CloseAll' );
        %                 return;
        %             end
        %         end
        %         errmsg = lasterr
        %         nextpatient(0);
        %         multiWaitbar( 'CloseAll' );
        %         return;
        %     end
        
        
        %% Skin detection
        %         try
        AutomaticAnalysis.Step=5;
        % SkinDetection('ROOT');
        set(ctrl.CheckAutoSkin,'value',true);
        CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
        eval(CallBack);
        %             multiWaitbar( 'Automatic SXA Analysis Progress',  4/5, 'Color', [0.2 0.9 0.3] );
        %         catch
        %
        %             Error.SkinEdgeFailed = true;
        %             errmsg = lasterr
        %             multiWaitbar( 'CloseAll' );
        %             try
        %                 SaveInDatabase('QACODES');
        %             catch
        %                 errmsg = lasterr
        %                 multiWaitbar( 'CloseAll' );
        %                 try
        %                     SaveInDatabase('QACODES');
        %                 catch
        %                     errmsg = lasterr
        %                     nextpatient(0);
        %                     multiWaitbar( 'CloseAll' );
        %                     return;
        %                 end
        %             end
        %             Analysis.Step = 1.5;
        %             nextpatient(0);
        %             multiWaitbar( 'CloseAll' );
        %             return;
        %         end
        
        
        %% Automatic BDPC analysis
        % % %  if (Info.Analysistype == 23) || (Info.Analysistype == 12)   % added by AM 11042013
        % % %
        % % %      AutomaticAnalysis.StructuralAnalysisDone=1;
        % % %
        
        % % % if Info.Operator23==true
        % % %     AutomaticAnalysis.StructuralAnalysisDone=1
        % % % end
        % % %        AutomaticAnalysis.StructuralAnalysisDone=1;
        
        if  (Info.CheckStructural==false) & (AutomaticAnalysis.StructuralAnalysisDone ~= 0)
            AutomaticAnalysis.Step=8;
            Message('Computing parenchymal parameters...');
            
            % added by AM 11072013
            
            try
                StructuralAnalysisComputation;
                
                
            catch
                
                Error.FeaturesFailed = true;
                errmsg = lasterr
                %         multiWaitbar( 'CloseAll' );
                try
                    SaveInDatabase('QACODES');
                catch
                    errmsg = lasterr
                    %             multiWaitbar( 'CloseAll' );
                    try
                        SaveInDatabase('QACODES');
                    catch
                        errmsg = lasterr
                        %         AutomaticAnalysis.StructuralAnalysisDone=0;
                        %         multiWaitbar( 'CloseAll' );
                        nextpatient(0);
                        return;
                    end
                end
                % % %         Analysis.Step = 1.5;
                %         AutomaticAnalysis.StructuralAnalysisDone=0;
                nextpatient(0);
                %         multiWaitbar( 'CloseAll' );
                return;
            end
            
            AutomaticAnalysis.StructuralAnalysisDone=1;
        end
        
        %%%%% End of changing  by AM 11042013 for operator 23 %%%%%
        
        
        % % %     %% phantom detection
        % % %     try   %fit SXA phantom position and orientation
        % % %         %set(ctrl.CheckManualPhantom,'value',0); %manual
        % % %         AutomaticAnalysis.Step=2;
        % % %         CallBack=get(ctrl.Phantom,'callback');
        % % %         eval(CallBack);     %PhantomDetection
        % % %         %%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%
        % % %
        % % %     catch
        % % %         Error.PhantomDetection = true;
        % % %         errmsg = lasterr
        % % %         %SaveInDatabase('QACODES');
        % % %         %           if Info.centerlistactivated == 18 | Info.centerlistactivated == 19
        % % %         %               imagemenu('flipH');
        % % %         %              try
        % % %         %                CallBack=get(ctrl.Phantom,'callback');
        % % %         %                eval(CallBack);
        % % %         %              catch
        % % %         try
        % % %             SaveInDatabase('QACODES');
        % % %         catch
        % % %             errmsg = lasterr
        % % %             try
        % % %                 SaveInDatabase('QACODES');
        % % %             catch
        % % %                 errmsg = lasterr
        % % %                 nextpatient(0);
        % % %                 return;
        % % %             end
        % % %         end
        % % %         %                    nextpatient(0);
        % % %         %                    return;
        % % %         %              end
        % % %         %           end
        % % %         % set(ctrl.CheckManualPhantom,'value','0');%manual
        % % %         %CallBack=get(ctrl.Phantom,'callback');
        % % %         %eval(CallBack);
        % % %
        % % %         nextpatient(0);
        % % %         return;
        % % %     end
        
        
        
        %  part1 = toc
        
        %  tic
        
        %% Detect the Room
        if Info.DigitizerId < 4 & ~(xm > 0)
            Info.BRAND=GetBRAND(Info);
            if AutomaticAnalysis.Room == -1
                AutomaticAnalysis.Step=0;
                
                [AutomaticAnalysis.Room,AutomaticAnalysis.Imagette,AutomaticAnalysis.Marker]=FindRoomNumber2;
                
                if AutomaticAnalysis.Room==-1
                    Message('The room was not detected...');
                end
                SetTheLocationDropMenu(AutomaticAnalysis.Room);
                % Update Room number in the acquisition database
                AutomaticAnalysis.Step=1;
                
                [foe,index] = max(Site.RoomTable(:,1)==AutomaticAnalysis.Room);
                %             MachineID=num2str(Site.RoomTable(index,2));
                %             mxDatabase(Database.Name,['update acquisition set machine_id=''',MachineID,''' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
            else
                MachineID=get(ctrl.Center,'value');
                ab = [Site.RoomTable(:,2) Site.RoomTable(:,1)];
                roomnum = ab(ab(:,1)==MachineID,:);
                AutomaticAnalysis.Room=num2str(roomnum(2)) ;
            end
        else
            AutomaticAnalysis.Room =  Info.centerlistactivated;
            Info.BRAND= 2;
        end
        
        
        if ~Error.PhantomDetection
            %% Correction
            AutomaticAnalysis.Step=3;
            if Info.DigitizerId < 4
                set(ctrl.Cor,'value', true);
                CallBack=get(ctrl.CorrectionButton,'callback');  %press on correction button
                eval(CallBack);
            else
                Error.NoCorrection = false;
            end
            
            if Analysis.PhantomID == 7 | Analysis.PhantomID == 8  | Analysis.PhantomID == 9
                X_right = ROI.xmax + 50;
            else
                X_right = Analysis.coordXFatcenter
            end
            % vertical profiles
            yc = (ROI.ymax - ROI.ymin) / 2 + ROI.ymin;
            yup = yc - (ROI.ymax - ROI.ymin)* 0.35  / 2;
            ydown = yc + (ROI.ymax - ROI.ymin)* 0.35  / 2;
            xx1 = [1 X_right];
            yy1 = [yc yc];
            xx2 = [1 X_right];
            yy2 = [yup yup];
            xx3 = [1 X_right];
            yy3 = [ydown ydown];
            
            signal1=improfile(Image.image,xx1,yy1);
            signal2=improfile(Image.image,xx2,yy2);
            signal3=improfile(Image.image,xx3,yy3);
            ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
            ln_size = size(ln);
            
            %{
         len_c = round(length(signal1)*0.7);
         signal_fit = signal1(1:len_c);
         x_fit = (1:len_c)';
         results = fit(x_fit,signal_fit, 'poly1');
         slope = results.p1;
         offset = results.p2;
         signal4 = slope * x_fit + offset;
         alfa = atan(slope)*180/pi;
         Analysis.alfa = 90+alfa;
         ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
         ln_size = size(ln)
         signal4(len_c+1:length(signal1)) = Analysis.BackGroundThreshold;
            %}
            
            Analysis.signal = [ln' signal1 signal2 signal3 ];
            
            szauto = size(Analysis.signal);
            %horizontal profile
            xleft = (ROI.xmax - ROI.xmin) * 0.1;
            xc = (ROI.xmax - ROI.xmin) * 0.37 ;
            xright = (ROI.xmax - ROI.xmin)* 0.63;
            xx1 = [xleft xleft];
            yy1 = [ROI.ymax ROI.ymin];
            xx2 = [xc xc];
            yy2 = [ROI.ymax ROI.ymin];
            xx3 = [xright xright];
            yy3 =  [ROI.ymax ROI.ymin];
            
            signal1_horiz=improfile(Image.image,xx1,yy1);
            signal2_horiz=improfile(Image.image,xx2,yy2);
            signal3_horiz=improfile(Image.image,xx3,yy3);
            ln_horiz = (1:length(signal1_horiz)) * Analysis.Filmresolution ; %Xcoord
            ln_size = size(ln);
            Analysis.signal_horiz = [ln_horiz' signal1_horiz signal2_horiz signal3_horiz];
            szauto = size(Analysis.signal_horiz);
        else
            Analysis.signal = -1;
            Analysis.signal_horiz = -1;
        end
        % phantomdetection = toc
        if Info.CheckSXAStepAnalysis==false;
            if ~Error.NoCorrection
                %% Periphery calculation
                try
                    if  (~Error.PhantomDetection) & (~Error.StepPhantomFailure)
                        if ~isempty(strfind(Info.fname,'Homogenization')) %| ~isempty(strfind(Analysis.film_identifier,'stiff'))
                            Periphery_calculation_cadaver;
                        else
                            Periphery_calculation;
                        end
                        
                        
                        
                        
                    end
                catch
                    Error.PeripheryCalculation = true;
                    errmsg = lasterr
                    %             multiWaitbar( 'CloseAll' );
                    try
                        SaveInDatabase('QACODES');
                    catch
                        errmsg = lasterr
                        %                 multiWaitbar( 'CloseAll' );
                        try
                            SaveInDatabase('QACODES');
                        catch
                            errmsg = lasterr
                            %                     AutomaticAnalysis.StructuralAnalysisDone=0;
                            %                     multiWaitbar( 'CloseAll' );
                            nextpatient(0);
                            return;
                        end
                        
                    end
                    nextpatient(0);
                    return;
                end
                
                %% Density
                if (~Error.PeripheryCalculation) & (~Error.PhantomDetection) & (~Error.StepPhantomFailure)
                    
                    AutomaticAnalysis.Step=6;
                    
                    try
                        CallBack=get(ctrl.Density,'callback');  %press on Density button
                        eval(CallBack); %call Computedensity
                        if ~Error.DENSITY
                            [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
                            Analysis.FileNameDensity = fileNameDensity;
                            Analysis.FileNameThickness = fileNameThickness;
                            %Commented by Song, 07-27-10 (need to save the output files to another new
                            %directory)
                            %                 Analysis.FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ];
                            %                 Analysis.FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)];
                            %                 densfile_name = Analysis.FileNameDensity;
                            %dens_image = uint16(Analysis.DensityImage*100);
                            % temporary only for fat angle fitting
                            
                            %%%JW temp coded out, MING storage space issues, Sept 2011
                            
                            
                            if Info.study_3C == true
                                Analysis.FileNameDensity2 = [Analysis.FileNameDensity(1:end-4),'SXA.png'];
                                Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
                                imwrite(uint16(Analysis.SXADensityImageCrop*100), Analysis.FileNameDensity2, 'png');
                                imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                                %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
                                density_map = Analysis.SXADensityImageCrop;
                                fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
                                szim = size(Image.OriginalImage);
                                thickness_map = zeros(szim);
                                thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
                                imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
                                if  ~isempty(strfind(Analysis.film_identifier,'ucsf_03-12-2014'))
                                    fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,patient_id,'_',num2str(Info.kvp),'.mat', ];
                                    flip_info = [Info.flipH Info.flipV];
                                    ROI.image = [];
                                    version_name = Info.Version;
                                    save(fNamemat, 'thickness_map','ROI','flip_info','density_map','version_name');
                                    
                                else
                                    fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,'.mat', ];
                                    flip_info = [Info.flipH Info.flipV];
                                    ROI.image = [];
                                    version_name = Info.Version;
                                    save(fNamemat, 'thickness_map','ROI','flip_info','density_map','version_name');
                                end
                                
                                % % % %                 SaveInDatabase('COMMONANALYSIS');
                                %%%%%%%%%%%%%  end of 3C study  %%%%%%%%%%%%%%%%%%%%
                            else
                                dir_stiffness = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\Results\SXA\';
                                if ~isempty(strfind(Info.patient_id,'50199690'))
                                    patient_stiff  =  'B1931';
                                elseif ~isempty(strfind(Info.patient_id,'10231612'))
                                    patient_stiff  =  'B2014';
                                elseif ~isempty(strfind(Info.patient_id,'50845028'))
                                    patient_stiff  =  'B2061';
                                elseif ~isempty(strfind(Info.patient_id,'49494335'))
                                    patient_stiff  =  'B2065';
                                elseif ~isempty(strfind(Info.patient_id,'46115678'))
                                    patient_stiff  =  'B2066';
                                elseif ~isempty(strfind(Info.patient_id,'44317907'))
                                    patient_stiff  =  'B2076';
                                elseif ~isempty(strfind(Info.patient_id(1:5),'TT033'))
                                    patient_stiff  =  'B2064';
                                elseif ~isempty(strfind(Info.patient_id(1:5),'TT034'))
                                    patient_stiff  =  'B2056';
                                else
                                    patient_stiff  = Info.patient_id;
                                end
                                
                                Analysis.FileNameDensity2 = [dir_stiffness,patient_stiff,Analysis.filename,'_densitySXA.png'];
                                Analysis.FileNameThickness2 = [dir_stiffness,patient_stiff,Analysis.filename,'_thicknessSXA.png'];
                                imwrite(uint16(Analysis.SXADensityImageCrop*100), Analysis.FileNameDensity2, 'png');
                                imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                                fNamemat = [dir_stiffness,patient_stiff, '_Mat_v',Info.Version(8:end) ,'.mat', ];
                                density_map = Analysis.SXADensityImageCrop;
                                thickness_map = Analysis.SXAthickness_mapproj;
                                attenuation_image = Image.OriginalImageInit;
                                flip_info = [Info.flipH Info.flipV];
                                version_name = Info.Version;
                                save(fNamemat, 'density_map','thickness_map','ROI','flip_info','attenuation_image','version_name');
                            end
                            
                            % imwrite(Analysis.DensityImage,densfile_name,'png');
                            % imwrite(Analysis.ThicknessImage,Analysis.FileNameThickness,'png');
                            %figure;imagesc(uint16(Analysis.DensityImage*100)); colormap(gray);
                            %figure;imagesc(uint16(Analysis.ThicknessImage*1000)); colormap(gray);
                            len_c = round(length(signal1)*0.65);
                            signal_fit = signal1(1:len_c);
                            x_fit = (1:len_c)';
                            % Xcoord = 1:x_ROI;
                            
                            results = polyfit(x_fit,signal_fit,1);
                            slope = results(1);
                            offset = results(2);
                            signal4 = slope * x_fit + offset;
                            
                            %ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
                            %ln_size = size(ln)
                            
                            X_position = Analysis.params(5);
                            %Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
                            X = (X_position-x_fit*Analysis.Filmresolution*0.1);
                            results_thick = polyfit(X,signal_fit, 1);
                            slope_thick = results_thick(1);
                            offset_thick = results_thick(2);
                            alfa = atan(slope_thick/Analysis.ph_afat_lin)*180/pi;
                            Analysis.alfa = alfa;
                            %thickness_profile = Analysis.ph_thickness + X*tan(alfa*pi/180);
                            %signal4 = Analysis.ph_afat_lin * thickness_profile + Analysis.ph_bfat_lin;
                            signal4(len_c+1:length(signal1)) = Analysis.BackGroundThreshold;
                            Analysis.signal = [Analysis.signal, signal4];
                            
                        end
                        
                    catch
                        Error.Density = true;
                        if Info.study_3C == true
                            [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
                            
                            Analysis.FileNameThickness = fileNameThickness;
                            
                            Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
                            imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                            %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
                            fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
                            szim = size(Image.OriginalImage);
                            thickness_map = zeros(szim);
                            thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
                            imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
                            fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,'.mat', ];
                            flip_info = [Info.flipH Info.flipV];
                            ROI.image = [];
                            version_name = Info.Version;
                            save(fNamemat, 'thickness_map','ROI','flip_info','version_name');
                            % % % %                 SaveInDatabase('COMMONANALYSIS');
                            %%%%%%%%%%%%%  end of 3C study  %%%%%%%%%%%%%%%%%%%%
                            
                        end
                        errmsg = lasterr
                        %              multiWaitbar( 'CloseAll' );
                        try
                            SaveInDatabase('QACODES');
                        catch
                            errmsg = lasterr
                            %                  multiWaitbar( 'CloseAll' );
                            try
                                SaveInDatabase('QACODES');
                            catch
                                errmsg = lasterr
                                %                      AutomaticAnalysis.StructuralAnalysisDone=0;
                                %                      multiWaitbar( 'CloseAll' );
                                nextpatient(0);
                                return;
                            end
                        end
                        nextpatient(0);
                        return;
                    end
                    %figure;
                    %plot(Analysis.signal);
                    %mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(Info.SXAAnalysisKey)]);
                end
                set(ctrl.Cor,'value',false);
                
            end
        end
        
    else
        %thickness and ROI from patient directory file
        flag.Pectoral_MLOView = false;
        root_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
        mat_thick = ['LE',Info. ViewPosition(1:2),'raw_Mat.mat'];
        lehe_fnames.mat_thickness = [root_dir,Info.PatientID(1:7),'\png_files\',mat_thick];
        load(lehe_fnames.mat_thickness);
%         Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
        thickness_mapproj = thickness_map;
        thickness_mapreal = thickness_map;
        BreastMask = circle_spotpaddle;
        Analysis.rx = 0;
        Analysis.ry = 0;
         CallBack=get(ctrl.Density,'callback');  %press on Density button
         eval(CallBack); %call Computedensity
               
        [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
        
        Analysis.FileNameThickness = fileNameThickness;
        
        Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
        imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
        %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
        fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
        szim = size(Image.OriginalImage);
        thickness_map = zeros(szim);
        thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
        imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
        
    end
    
    %% Automatic BDMD analysis
    if Automatic_BDMDanalysis == 1
        if ~Error.PhantomDetection
            Error.AutoBDMD=false;
            AutomaticAnalysis.Step=7;
            Threshold.value=(Analysis.Ref0+0.3*(Analysis.Ref100-Analysis.Ref0))/Image.maximage;  %threshold at 30%
            HistogramManagement('DrawHistLine',0);
            % funcThresholdContour;
            AutomaticAnalysis.ThresholdAnalysisDone = ThresholdCalculation;
            % draweverything;
            %AutomaticAnalysis.ThesholdAnalysisDone = true;
        else
            Error.AutoBDMD=true;
        end
        
    end
    AutomaticAnalysis.Step=9;
    
    %% Report creation
    if SXAreport == true
        switch AutomaticAnalysis.Step
            case -1
                ReportText=[ReportText,'Character recognition (stop)@'];
            case 0
                ReportText=[ReportText,'Room detection (stop)@'];
                Error.NoCorrection=true;
            case 1
                ReportText=[ReportText,'Database access (stop)@'];
            case 2
                ReportText=[ReportText,'Phantom detection (stop)@'];
            case 3
                ReportText=[ReportText,'Image correction (stop)@'];
                Error.NoCorrection=true;
            case 4
                ReportText=[ReportText,'ROI detection (stop)@'];
            case 5
                ReportText=[ReportText,'Skin detection (stop)@'];
            case 6
                ReportText=[ReportText,'Density computation (stop)@'];
                Error.DENSITY=true;
                Analysis.DensityPercentage=-1;
            case 7
                ReportText=[ReportText,'BDMD computation (stop)@'];
            case 8
                ReportText=[ReportText,'BDPC computation (stop)@'];
        end
        
        
        if ~debugMode
            if SaveBool
                %% Add QA codes
                try
                    SaveInDatabase('QACODES');
                catch
                    errmsg = lasterr
                    try
                        SaveInDatabase('QACODES');
                        % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
                    catch
                        errmsg = lasterr
                        nextpatient(0);
                        %                 multiWaitbar( 'CloseAll' );
                        return;
                    end
                end
                
                %% Update information on Acquisition table
                if AutomaticAnalysis.CharacterRecognitionDone ~= 0
                    mxDatabase(Database.Name,['update acquisition set mAs=',num2str(Recognition.MAS),' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
                    mxDatabase(Database.Name,['update acquisition set kVp=',num2str(Recognition.KVP),' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
                    mxDatabase(Database.Name,['update acquisition set thickness=',num2str(Recognition.MM),' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
                    mxDatabase(Database.Name,['update acquisition set force=',num2str(Recognition.DAN),' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
                    if Error.TECHNIQUE
                        TechniqueID=3;
                    else
                        switch Recognition.TECHNIQUE
                            case 'MO/MO'
                                TechniqueID=1;
                            case 'MO/RH'
                                TechniqueID=2;
                            case 'RH/RH'
                                TechniqueID=4;
                            otherwise
                                TechniqueID=3;
                        end
                    end
                    mxDatabase(Database.Name,['update acquisition set Technique_id=''',num2str(TechniqueID),''' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
                end
            end
            
            
            %% Report
            %
            % % %     try
            %{
    if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
        % mxDatabase(Database.Name,['update acquisition set phantom_id=''',num2str(Analysis.PhantomID),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
        % for angle only
        p = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis.sxastepanalysis_id FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]);
        sxastep_id = max(cell2mat(p));
       % mxDatabase(Database.Name,['update sxastepanalysis set flatfieldcorrection_id=''',num2str(Analysis.alfa),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
    end
            %}
            %part4 = toc
            
            %tic
            if ~Error.StepPhantomFailure
                Message('Creating report...');
                CreateReport('ADDCOMMON');
                if Analysis.PhantomID ~= 7 & Analysis.PhantomID ~= 8 & Analysis.PhantomID ~= 9
                    CreateReport('SXASPECIFIC');
                else
                    CreateReport('SXASTEPSPECIFIC');
                end
                
                if AutomaticAnalysis.CharacterRecognitionDone
                    CreateReport('TAGINFORMATION');
                end
                CreateReport('QACODES');
                CreateReport('ADDREPORTTEXT');
                if  Error.PeripheryCalculation == false & Error.DENSITY == false
                    if Analysis.signal ~= -1
                        if Analysis.PhantomID ~= 7 & Analysis.PhantomID ~= 8 & Analysis.PhantomID ~= 9
                            CreateReport('QACODES');
                            CreateReport('ADDREPORTTEXT');
                            CreateReport('ADDPOFILES');
                        else
                            CreateReport('ADDREPORTTEXT');
                            CreateReport('ADDSTEPPOFILES');
                        end
                        %else
                        %   delete(h_init);
                    end
                end
                Info.ReportCreated = true;
            end
            
            
            % % %     catch
            % % %         errmsg = lasterr
            % % %         nextpatient(0);
            % % %         multiWaitbar( 'CloseAll' );
            % % %         return;
            % % %
            % % %     %end
            % % %     end
        end
    end
    
    
catch
    % lasterr
    errmsg = lasterr
    %     multiWaitbar( 'CloseAll' );
    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        %         multiWaitbar( 'CloseAll' );
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            %             multiWaitbar( 'CloseAll' );
            return;
        end
    end
    nextpatient(0);
    %     multiWaitbar( 'CloseAll' );
    return;
end



%% Go to next patient
% Added by Am 11112013
% multiWaitbar( 'Automatic SXA Analysis Progress',  4/4, 'Color', [0.2 0.9 0.3] );
if (Error.DENSITY|Error.NoCorrection| Error.NoBreast| Error.ROIFailed)
    nextpatient(0);
else
    if (Info.Operator==5 & AutomaticAnalysis.StructuralAnalysisDone==0) & (Error.StepPhantomFailure & Error.PeripheryCalculation)  % In Opertaor 23 it is possible no phantom but there is feature results
        nextpatient(0);
    else
        nextpatient(1);
        
    end
end
end


%%
function [fPathNameDen fPathNameThk] = genFileNameDenThk(fNameRaw, ver);

backSlashPos = strfind(fNameRaw, '\');
fPath = fNameRaw(1:backSlashPos(end));
fName = fNameRaw(backSlashPos(end)+1:end);

verName = ver(8:end);
verName = regexprep(verName, '\.', '_');
fNameDensity = [fName(1:end-4), 'Density', verName, fName(end-3:end)];
fNameThick = [fName(1:end-4), 'Thickness', verName, fName(end-3:end)];
fPathNameDen = [fPath, fNameDensity];
fPathNameThk = [fPath, fNameThick];
end



