%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function  AutomaticSXAAnalysis
global ctrl Image Error ReportText AutomaticAnalysis Database Info Recognition Correction Analysis QA Threshold Site ROI h_init
%tic
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
%qa = QA
control = ctrl
%im = Image
%sit = Site
%Analysis.signal = -1
version_type = version_retreiving(Info.AcquisitionKey);
size_version = size(version_type)
AutomaticAnalysis.ThresholdAnalysisDone = false;
if size_version(1) > 0
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
    Analysis.SXAanalysisStatus = 3;

SaveBool=1;
Analysis.Height1=0;
Analysis.Height2=0;
Error.DENSITY=1;Analysis.DensityPercentage=-1;
Correction.Filename='Aborted';
Error.Correction=1;
%AutomaticAnalysis.Room = -1;

  % AutomaticAnalysis.Room=-1;
   AutomaticAnalysis.Marker=-1;
   %AutomaticAnalysis.CharacterRecognitionDone=0;
   Recognition.TECHNIQUE='ERROR'
  % AutomaticAnalysis.StructuralAnalysisDone=0;


%% Determine if the paddle is big or little (in the case it is big, cut the edges)
try
    AutomaticAnalysis.Step=0;
    if size(Image.OriginalImage,1)>1800   %detect small / big paddle
        top=DetectImageEdge(Image.OriginalImage,'TOP');
        imagemenu('CutTopWithParam',top);
        bottom=DetectImageEdge(Image.OriginalImage,'BOTTOM');
        imagemenu('CutBottomWithParam',bottom);
        right=DetectImageEdge(Image.OriginalImage,'RIGHT');
        imagemenu('CutRightWithParam',right);
        left=DetectImageEdge(Image.OriginalImage,'LEFT');
        imagemenu('CutLeftWithParam',left);
        Error.BIGPADDLE=true;
    end
        set(ctrl.Cor,'value',true);
        imagemenu('AutomaticCrop');
%% ROI
        AutomaticAnalysis.Step=4;
        CallBack=get(ctrl.ROI,'callback');
        eval(CallBack);

%% Skin detection
        AutomaticAnalysis.Step=5;
        CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
        eval(CallBack);
    
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
    Info.BRAND=GetBRAND(Info);
   
  %part2 = toc  
  
  %tic
%% Read the Tag
  if AutomaticAnalysis.CharacterRecognitionDone ~= 0 
    AutomaticAnalysis.Step=-1;
    CharacterRecognition('CharacterRecognition',Info.BRAND);
    AutomaticAnalysis.CharacterRecognitionDone=1;
  end
 
  %% phantom detection
    AutomaticAnalysis.Step=2;
    CallBack=get(ctrl.Phantom,'callback');
    eval(CallBack);
       
    if ~Error.PhantomDetection
        %% Correction
        AutomaticAnalysis.Step=3;
        set(ctrl.Cor,'value', true);
        CallBack=get(ctrl.CorrectionButton,'callback');  %press on correction button
        eval(CallBack);
        if Analysis.PhantomID == 7
            X_right = ROI.xmax + 50;
        else
            X_right = Analysis.coordXFatcenter
        end
        % profiles
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
         ln = (1:length(signal1)) * 0.15;
         ln_size = size(ln)
         Analysis.signal = [ln' signal1 signal2 signal3];
         szauto = size(Analysis.signal)
    else
         Analysis.signal = -1;
    end
% phantomdetection = toc

    
    if ~Error.NoCorrection
             
       
%% Density
        if ~Error.PhantomDetection
            AutomaticAnalysis.Step=6;
            CallBack=get(ctrl.Density,'callback');  %press on Density button
            eval(CallBack);
            mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(Info.SXAAnalysisKey)]);
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
catch
   % lasterr
   errmsg = lasterr
  % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
    nextpatient(0);
     return;

end

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
    SaveInDatabase('QACODES')

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

if Analysis.PhantomID == 7
     mxDatabase(Database.Name,['update acquisition set phantom_id=''',num2str(Analysis.PhantomID),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
 end
%part4 = toc

%tic
%% Report
Message('Creating report...');
CreateReport('ADDCOMMON');
if Analysis.PhantomID ~= 7
    CreateReport('SXASPECIFIC');
else
    CreateReport('SXASTEPSPECIFIC');
end

if AutomaticAnalysis.CharacterRecognitionDone 
    CreateReport('TAGINFORMATION');
end
CreateReport('QACODES');
CreateReport('ADDREPORTTEXT');
if Analysis.signal ~= -1
   if Analysis.PhantomID ~= 7 
      CreateReport('ADDPOFILES');
   else
      CreateReport('ADDSTEPPOFILES'); 
   end
%else
 %   delete(h_init);
end
     %% Go to next patient
% save if the analysis was ok otherwise choose nextpatient
 %reportcreation = toc
 
%        nextpatient(4);
%        return;
% end
 %ph = Analysis.PhantomID;
 %p = ph
if (Error.DENSITY|Error.NoCorrection)&(SaveBool)
    nextpatient(0);
else
    nextpatient(1);
end
%part5 = toc
%parts = [part1;part2; part3;part4;part5]
;

