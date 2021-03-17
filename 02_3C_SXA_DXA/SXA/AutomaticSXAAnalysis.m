%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function  AutomaticSXAAnalysis
global ctrl Image Error ReportText AutomaticAnalysis Database Info Recognition Correction Analysis QA Threshold Site ROI h_init
global Database 
%tic
%{
 xx1 = [1 1211];
 yy1 = [831 124];
 signal=improfile(Image.image,xx1,yy1);
%}
warning off;
Info.ReportCreated = false; 
time = 0;
auto = AutomaticAnalysis
%database = Database
inf = Info
rec = Recognition
cor = Correction;
anal = Analysis
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
Error.DENSITY=false;
Error.SkinEdgeFailed = false;
%qa = QA
control = ctrl
%im = Image
%sit = Site
%Analysis.signal = -1
version_type = version_retreiving(Info.AcquisitionKey);
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
         return;
    end
end   

size_version = size(version_type)
AutomaticAnalysis.ThresholdAnalysisDone = false;
 xm = strmatch('mammo_Marsden', Database.Name, 'exact');
 
 %for testing only           
 

 if size_version(1) > 0 |Info.DigitizerId == 4 | xm > 0
    AutomaticAnalysis.CharacterRecognitionDone=0;
    AutomaticAnalysis.StructuralAnalysisDone=0;
    AutomaticAnalysis.Room = 1;
    Automatic_BDMDanalysis = 1;
else
    AutomaticAnalysis.CharacterRecognitionDone=1;
    AutomaticAnalysis.StructuralAnalysisDone=1;
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
if Info.DigitizerId == 4
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
 
  %% phantom detection
  try
    %set(ctrl.CheckManualPhantom,'value',0); %manual
    AutomaticAnalysis.Step=2;
    CallBack=get(ctrl.Phantom,'callback');
    eval(CallBack);
    %%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%  
  
  catch
       Error.PhantomDetection = true;
       errmsg = lasterr
           %SaveInDatabase('QACODES');
          if Info.centerlistactivated == 18 | Info.centerlistactivated == 19
              imagemenu('flipH');
             try
               CallBack=get(ctrl.Phantom,'callback');
               eval(CallBack);
             catch    
                   try
                      SaveInDatabase('QACODES');
                   catch  
                         errmsg = lasterr
                         try
                            SaveInDatabase('QACODES'); 
                         catch
                                errmsg = lasterr   
                                nextpatient(0);
                                return;
                         end
                   end   
                   nextpatient(0);
                   return;
             end
          end
      % set(ctrl.CheckManualPhantom,'value','0');%manual
      %CallBack=get(ctrl.Phantom,'callback');
      %eval(CallBack);
  end
 
    try
   %% ROI
        AutomaticAnalysis.Step=4;
        CallBack=get(ctrl.ROI,'callback');
        eval(CallBack);

%% Skin detection
    
           AutomaticAnalysis.Step=5;
         % SkinDetection('ROOT');
           CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
           eval(CallBack);
     catch
      % lasterr
           %QAcodeNumber = 3;
           %addoneqacode_inDatabase(Database.Name,QAcodeNumber, Info.AcquisitionKey);
           Error.SkinEdgeFailed = true;
           errmsg = lasterr
           %SaveInDatabase('QACODES');
           try
              SaveInDatabase('QACODES');
           catch  
                 errmsg = lasterr
                 try
                    SaveInDatabase('QACODES'); 
                 catch
                        errmsg = lasterr   
                        nextpatient(0);
                        return;
                 end
           end   
           nextpatient(0);
           return;
     end
        
     %  part1 = toc

     %  tic
    %% Automatic BDPC analysis
      if  AutomaticAnalysis.StructuralAnalysisDone ~= 0  
        AutomaticAnalysis.Step=8;
        Message('Computing parenchymal parameters...');
        StructuralAnalysisComputation;
        AutomaticAnalysis.StructuralAnalysisDone=1;    
      end  
    %% Detect the Room
     if Info.DigitizerId ~= 4 & ~(xm > 0)
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
            MachineID=num2str(Site.RoomTable(index,2));
            mxDatabase(Database.Name,['update acquisition set machine_id=''',MachineID,''' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
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
        if Info.DigitizerId ~= 4
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
        yc = (ROI.ymax - ROI.ymin) / 2 + ROI.ymin
         yup = yc - (ROI.ymax - ROI.ymin)* 0.35  / 2
         ydown = yc + (ROI.ymax - ROI.ymin)* 0.35  / 2
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
         yy2 = [ROI.ymax ROI.ymin]
         xx3 = [xright xright];
         yy3 =  [ROI.ymax ROI.ymin]           
         
         signal1_horiz=improfile(Image.image,xx1,yy1);
         signal2_horiz=improfile(Image.image,xx2,yy2);
         signal3_horiz=improfile(Image.image,xx3,yy3);
         ln_horiz = (1:length(signal1_horiz)) * Analysis.Filmresolution ; %Xcoord
         ln_size = size(ln)
         Analysis.signal_horiz = [ln_horiz' signal1_horiz signal2_horiz signal3_horiz];
         szauto = size(Analysis.signal_horiz)
    else
         Analysis.signal = -1;
         Analysis.signal_horiz = -1;
    end
% phantomdetection = toc
    
    if ~Error.NoCorrection
%% Periphery calculation
        if  ~Error.PhantomDetection
            Periphery_calculation;
        end
%% Density
        if ~Error.PeripheryCalculation
            
            AutomaticAnalysis.Step=6;
            CallBack=get(ctrl.Density,'callback');  %press on Density button
            eval(CallBack);
            if ~Error.DENSITY
                Analysis.FileNameDensity = [Info.fname(1:end-4),'SXADensity',Info.fname(end-3:end) ]; 
                Analysis.FileNameThickness = [Info.fname(1:end-4),'SXAThickness',Info.fname(end-3:end)]; 
                densfile_name = Analysis.FileNameDensity;
                %dens_image = uint16(Analysis.DensityImage*100); 
                % temporary only for fat angle fitting
                if Info.Analysistype==16
                    imwrite(uint16(Analysis.SXADensityImageCrop*100),densfile_name,'png');
                else
                    imwrite(uint16(Analysis.SXADensityImageSkinCrop*100),densfile_name,'png');
                end
               imwrite(uint16(Analysis.SXAthickness_mapproj*1000),Analysis.FileNameThickness,'png');
               % imwrite(Analysis.DensityImage,densfile_name,'png');
               % imwrite(Analysis.ThicknessImage,Analysis.FileNameThickness,'png');
                %figure;imagesc(uint16(Analysis.DensityImage*100)); colormap(gray);
                %figure;imagesc(uint16(Analysis.ThicknessImage*1000)); colormap(gray);
                 len_c = round(length(signal1)*0.65);
                 signal_fit = signal1(1:len_c);
                 x_fit = (1:len_c)';
                % Xcoord = 1:x_ROI;

                 results = fit(x_fit,signal_fit, 'poly1');
                 slope = results.p1;
                 offset = results.p2;
                 signal4 = slope * x_fit + offset;

                 %ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
                 %ln_size = size(ln)

                 X_position = Analysis.params(5);
                 %Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
                 X = (X_position-x_fit*Analysis.Filmresolution*0.1);
                 results_thick = fit(X,signal_fit, 'poly1');
                 slope_thick = results_thick.p1;
                 offset_thick = results_thick.p2;
                 alfa = atan(slope_thick/Analysis.ph_afat_lin)*180/pi;
                 Analysis.alfa = alfa;
                 %thickness_profile = Analysis.ph_thickness + X*tan(alfa*pi/180);
                 %signal4 = Analysis.ph_afat_lin * thickness_profile + Analysis.ph_bfat_lin; 
                 signal4(len_c+1:length(signal1)) = Analysis.BackGroundThreshold;
                 Analysis.signal = [Analysis.signal, signal4];
            end
             %figure;
             %plot(Analysis.signal);
            %mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(Info.SXAAnalysisKey)]);
        end
        set(ctrl.Cor,'value',false);

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
    end
% comment only for testing
%    
catch
   % lasterr
   errmsg = lasterr
   try
      SaveInDatabase('QACODES');
   catch  
         errmsg = lasterr
         try
            SaveInDatabase('QACODES'); 
         catch
                errmsg = lasterr   
                nextpatient(0);
                return;
         end
   end   
   nextpatient(0); 
   return;
end

%}
 % part3 = toc   

 % tic
%% Report creation
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

try
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
%% Report

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
       
 
catch
    errmsg = lasterr   
    nextpatient(0);
    return;
    
end
     %% Go to next patient
% save if the analysis was ok otherwise choose nextpatient
 %reportcreation = toc
 
%        nextpatient(4);
%        return;
% end
 %ph = Analysis.PhantomID;
 %p = ph
 %image_count = image_count +1;
if (Error.DENSITY|Error.NoCorrection|Error.StepPhantomFailure|Error.PeripheryCalculation)&(SaveBool) %
    nextpatient(0);
else
    nextpatient(1);
   % nextpatient(0); % for angle only
end
%part5 = toc
%parts = [part1;part2; part3;part4;part5]
;

