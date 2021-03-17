function version5(Operator);
global Order file Info ctrl Analysis f0 Result FreeForm flag Correction Hist Threshold Image key data;
global ManualEdge handle DXA EnterPressedEvent Database Phantom
global dummyuicontrol2 vidar GUIvalues Site ChestWallData CalendarData DEBUG figuretodraw1 axestodraw1
DEBUG=0;  %plot a lot of stuffs if debug==1


%          File:    version6.1.m
%
%   Description:    This file defines the GUI used to implement the SXA
%                   software tool.
%                   
%   Object                  Description
%   -------------------------------------------------------------------
%
% 6.1 the phantom box are more little
% ROI detection improved
% 6.2 phantom detection improved

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Some parameters that can be set %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Info.Database=true;
%Info.DigitizerOK=true;  %not compilable if true
%Info.SenographOK=true;  %not compilable if true

Info.Database=false;
Info.DigitizerOK=false;  %not compilable if true
Info.SenographOK=false;  %not compilable if tru


%Info.DXAOK=true;        
Info.DXAOK=false;        
%Info.BIRADS=true;
Info.BIRADS=false;
Site.Name='CPMC';
Site.RoomTable=[1 11;2 12; 3 13;4 14;6 15;7 16;8 17];
file.RepositoryDrive='D:';  %where to look is the file is not present on the server
Info.Analysistype = 0;
Info.DigitizerId=1;    %choice between 1='vidar',2='kodak',3=R2DG  (see database)  = default digitizer, this parameter is update if an image is loaded through the database
Info.centerlistactivated=1; %default center
Info.CorrectionId=1;   %defualt correction ('no correction Vidar')
Info.Version='Version6.3';   %version
Info.BackGround=true;   %No background Computation
Info.DXACalibration='lateral';  %defaultCalibration  (otherwise PA)
Info.FlatFieldCorrectionAsked=true; %false for just film response correction
Database.ChoiceNumber=3;  %Database choice 1=mammotest, 2=mammo 3=mammoCPMC (see after)
Analysis.SXAMode='Manual';
Analysis.SaveInFile = false;
Info.CorrectionName='none';
 Correction.InterpolatedImage1 = [];
%some influence on SXA computation
Info.UseSuperFatLeanImage=true;
Info.SXAnegativeValueForbidden=true;       %if it is true, pixel with %G<0 are put to 0
Info.SXAGreaterValueForbidden=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization (not to be changed) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Info.DXAModeOn=false;
Result.DXA=false;
key.buffer='';
key.message='';
Correction.activeCorrection=0;
Correction.Filename='none';
Database.Choice={'mammo_test','mammo','mammo_CPMC'}; Database.Name=cell2mat(Database.Choice(Database.ChoiceNumber));
Info.DigitizerDescription='Unknown';
Info.FilmDate='JESUS';
ChestWallData.Valid=false;

%figuretodraw1 = figure;
%axestodraw1 = axes;

rootdir=[pwd,'\'];
addpath(rootdir);
addpath([rootdir,'Site']);
addpath([rootdir,'Compiler']);
addpath([rootdir,'functions']);
addpath([rootdir,'Database']);
addpath([rootdir,'Correction']);
addpath([rootdir,'Vidar']);
addpath([rootdir,'DXA']);
addpath([rootdir,'SXA']);
addpath([rootdir,'Contour']);
addpath([rootdir,'CommonAnalysis']);
addpath([rootdir,'CommonAnalysis\SkinDetection']);
addpath([rootdir,'CommonAnalysis\ChestWall']);
addpath([rootdir,'Automation']);
addpath([rootdir,'Fractalanalysis']);
addpath([rootdir,'PhantomDetection']);
addpath([rootdir,'Recognition']);
addpath([rootdir,'BIRADS']);
addpath([rootdir,'ACTIVEX']);
addpath([rootdir,'Senograph']);
addpath([rootdir,'StatisticalAnalysis']);
addpath([rootdir,'SQLscripts']);
addpath([rootdir,'SimulationX']);

if Info.DigitizerOK
    %creation of vidar activex
    vidar.dummyfigure=figure;
    set(vidar.dummyfigure,'visible','off');
  %  vidar.activex = actxcontrol('VdScanTk.ScanTk', [0 0 200 200], vidar.dummyfigure, {'OnStartScan' 'FireEvent'});
    %actxcontrol('VIDARASYNCHRONEOUS.VidarAsynchroneousCtrl.1', [0 0 200 200], vidar.dummyfigure);
end

%initialisation
Info.TagToolWindow =false;
Info.DigitizerWindow=false;                 %there is no digitizer window already open
Info.QAWindow=false;                        %there is no QA window already open
Info.Info.saveAcquisitionTool=false;        %there is save acquisition tool open
Info.AcquisitionKey=0;                      %No acquisition open
Info.Renderer='painters';                   %Can also choose OpenGL but the threshold analysis is less beautifull
Info.Renderer='zbuffer';                   %Can also choose OpenGL but the threshold analysis is less beautifull
%Image2=[];                                  %for arythmetic operation
Image.colornumber=256;
Image.colormap=[[0:Image.colornumber-1]' [0:Image.colornumber-1]' [0:Image.colornumber-1]']/Image.colornumber;
Info.mAs=0;                                 %default value for mAs and kVp
Info.kVp=0;
Info.technique=1;                           %Technique (MO/MO...) unknown
Info.AcquisitionKey=0;                      %no image is open from the Database
Info.CommonAnalysisKey=0;                    %no common analysis is open from the Database
Info.MultiAcquisitionAnalysis=false;        %when multi analysis= true, some menu are lighted off
Info.MultiCommonAnalysis=false;             %when multi analysis= true, some menu are lighted off
Info.DICOMfile=false;                        %if the current open file is a DICOM or not (in order to be able to retrieve information inthe header)
Order='PatientID';
CalendarData.FigureOn=false;
ChestWallData.DrawingInProgress=0;
flag.noimage = false;

%Info.Operator=1;                            %no Operator name
FreeForm.FreeFormnumber=0;                  %no FreeForm
file.startpath='P:\Vidar Images\';
Database.Step=0;                            %Nothing has already been open from the database
Analysis.Step=0;                            %This indicator shows the advancement in the analysis
Analysis.OperationList={};
flag.Debug=false;                           %This flag is true when Redraw is pressed
Threshold.bool=false;                        %is the threshold analysis switched on or not?
Threshold.Computed=false;                   %do not show threshold result in report as long as it is not asked
flag.FileFromDatabase=false;
ManualEdge.DrawingInProgress=0;
Senograph.Flag.LE=false;
Senograph.Flag.HE=false;
Senograph.Flag.RST=false;
Info.CompressedAreaAsked=true;             %to know if it compute the compressed Area from the database
Info.PhantomComputed=false;
flag.ShowMaterial=false;
DXA.selectBackground=false;
Analysis.BackGroundComputed=false; 
Analysis.ThresholdOnly = false;
Analysis.GammaDSP = false;

if Info.Database 
    EnableDatabase='on';
else 
    EnableDatabase='off';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    GUI   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
background=[0.90 0.90 0.90];
orange=[1 0.6 0];
f0.handle=figure('units','normalized','position',[0.0 0.01 1.0 .95],'KeyPressFcn','KeypressedProcessing','Renderer',Info.Renderer,'DoubleBuffer','on','NumberTitle','off','name','SXA-DXA','color',[0.1 0.1 0.4],'MenuBar','None');

dummyuicontrol2=uicontrol('style','checkbox','visible','off','value',false);

set(f0.handle,'units','normalized','position',[0.0 0.01 1.0 .95],'KeyPressFcn','KeypressedProcessing','Renderer',Info.Renderer,'DoubleBuffer','off','NumberTitle','off','name','SXA-DXA','color',[0.1 0.1 0.4],'BackingStore','off');

f0.axisHandle=axes;
ctrl.text_zone = uicontrol('Style','text','units','normalized','position',[0.275 0.94 0.5 0.02],'backgroundcolor',orange);

set(f0.axisHandle,'units','normalized','position',[0.275 0.05 0.5 0.88]);  %image window
button_y=0.98;
f0.UCSFhandle=axes;

%logos
axes(f0.axisHandle);
UCSFlogo=imread('ucsfbackground2.bmp');
imagesc(UCSFlogo);
axes(f0.UCSFhandle);
UCSFlogo=imread('logo2.bmp');
imagesc(UCSFlogo);set(f0.UCSFhandle,'units','normalized','position',[0.02 0.85 0.25 0.10],'XTick',[],'YTick',[]);  %UCSF logo

%password check

if exist('Operator')
    Info.Operator=Operator;
elseif Info.Database
    Message('Type your password');
    Info.Operator=cell2mat(funcSelectInTable('operator','Who are you?',1));
    bnn = Info.Operator;
    if (Info.Operator==9)|| (Info.Operator==10)
        Database.ChoiceNumber=3;
    end
    ok=false;EnterPressedEvent=uicontrol('style','checkbox','visible','off','value',false);  %message
    while ok==false
        waitfor(EnterPressedEvent,'value',true);
        EnterPressedEvent=uicontrol('value',false);  %message
        ok=AskPassword(Info,key);
    end
end
EnterPressedEvent=uicontrol('style','checkbox','visible','off','value',false);


%GUI values
GUIvalues.heightbutton=0.05;
GUIvalues.heightcheckbox=0.02;
GUIvalues.heighteditbox=0.02;
GUIvalues.spacebeforebutton=0.01;
GUIvalues.spacebeforecheckbox=0.00;
GUIvalues.spaceforbox=0.005;
GUIvalues.heightBrightnessContrast=0.1;
GUIvalues.ButtonSizeX=0.075;

%%%% Comment zone
ctrl.comment=uicontrol('style','edit','string','','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox]);button_y=button_y-GUIvalues.heighteditbox;

%%%%%%%%%%%%%%%%%%%%%%%% Flat field Correction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distance=6*GUIvalues.heighteditbox+1*GUIvalues.spaceforbox+0*GUIvalues.spacebeforecheckbox+2*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','Acquisition parameters','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange)
button_y=button_y-GUIvalues.heighteditbox;
button_y=button_y-GUIvalues.spacebeforebutton;
button_y=button_y-GUIvalues.heighteditbox;ctrl.Cor=uicontrol('style','checkbox','string','Corrections','Value',false,...
    'units','normalized','position',[0.84 button_y 0.15 GUIvalues.heighteditbox],'backgroundcolor',background);
ctrl.CheckBreast=uicontrol('style','checkbox','string','Chest','Value',true,...
    'units','normalized','position',[0.90 button_y 0.07 GUIvalues.heighteditbox],'backgroundcolor',background,'Callback','buttonProcessing(''ChestChecked'')');
uicontrol('style','pushbutton','string','Save','units','normalized','position',[0.95 button_y 0.04 GUIvalues.heighteditbox],'Callback','buttonProcessing(''SaveInfo'')');
button_y=button_y-GUIvalues.heighteditbox;
uicontrol('style','text','string','kVp','units','normalized','position',[0.84 button_y 0.02 GUIvalues.heighteditbox],'backgroundcolor',background,'HorizontalAlignment','left');
ctrl.kVp=uicontrol('style','edit','string',num2str(Info.kVp),'units','normalized','position',[0.86 button_y 0.03 GUIvalues.heighteditbox],'HorizontalAlignment','left','backgroundcolor',[1 1 1]);
uicontrol('style','text','string','mAs','units','normalized','position',[0.90 button_y 0.02 GUIvalues.heighteditbox],'backgroundcolor',background,'HorizontalAlignment','left');
ctrl.mAs=uicontrol('style','edit','string',num2str(Info.mAs),'units','normalized','position',[0.925 button_y 0.03 GUIvalues.heighteditbox],'HorizontalAlignment','left','backgroundcolor',[1 1 1]);
button_y=button_y-GUIvalues.heighteditbox;
uicontrol('style','text','string','Technique','units','normalized','position',[0.84 button_y 0.06 GUIvalues.heighteditbox],'backgroundcolor',background,'HorizontalAlignment','left');
ctrl.technique=uicontrol('style','popupmenu','units','normalized','value',1,'position',[0.92 button_y 0.07 GUIvalues.heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'BackgroundColor','white','string',{'',''});
button_y=button_y-GUIvalues.heighteditbox;ctrl.Center = uicontrol('Style','popupmenu','value',1,'units','normalized','Position',[0.84 button_y 0.15 GUIvalues.heighteditbox],'BackgroundColor','white','Max',1,'Min',1,'string',{'',''}); 
button_y=button_y-GUIvalues.heighteditbox-GUIvalues.spaceforbox;
ctrl.CorrectionButton=uicontrol('style','pushbutton','string','Correction','units','normalized','position',[0.915 button_y GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback','buttonProcessing(''CorrectionAsked'')');

%%%%%%%%%%%%%%%%%%%%%%%% Brightness Contrast %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-GUIvalues.heightBrightnessContrast-2*GUIvalues.spacebeforebutton;
Hist.Handle=axes;set(Hist.Handle,'position',[0.84 button_y 0.15 GUIvalues.heightBrightnessContrast],'YTick',[]);%,'XTick',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Common Analysis  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-3*GUIvalues.spacebeforebutton+GUIvalues.heighteditbox;
distance=4*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;
button_y=button_y-2*GUIvalues.spacebeforebutton;

uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','Common Analysis','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange)
button_y=button_y-GUIvalues.heighteditbox;
button_y=button_y-GUIvalues.spacebeforebutton;

button_y=button_y-GUIvalues.heighteditbox;
ctrl.CheckAutoROI=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 button_y 0.04 GUIvalues.heighteditbox],'backgroundcolor',background);
ctrl.ROI=uicontrol('style','pushbutton','string','ROI',...
    'units','normalized','position',[0.88 button_y 0.075 GUIvalues.heighteditbox],'callback','ROIDetection(''FROMGUI'')');
button_y=button_y-GUIvalues.heighteditbox;
ctrl.CheckAutoSkin=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 button_y 0.04 GUIvalues.heighteditbox],'backgroundcolor',background);
ctrl.SkinDetection=uicontrol('style','pushbutton','string','Skin Detection',...
    'units','normalized','position',[0.88 button_y 0.075 GUIvalues.heighteditbox],'Callback','SkinDetection(''FROMGUI'')');     
ctrl.SkinModif=uicontrol('style','pushbutton','string','Modif',...
    'units','normalized','position',[0.957 button_y 0.03 GUIvalues.heighteditbox],'Callback','skinmodifgui');     
button_y=button_y-GUIvalues.heighteditbox;
ctrl.ChestWall=uicontrol('style','pushbutton','string','Chest Wall',...
    'units','normalized','position',[0.88 button_y 0.075 GUIvalues.heighteditbox],'Callback','Chestwall(''FROMGUI'')');     
ctrl.ChestWallModif=uicontrol('style','pushbutton','string','Modif',...
    'units','normalized','position',[0.957 button_y 0.03 GUIvalues.heighteditbox],'Callback','ChestwallDrawing(''MODIF'')');     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Free Form %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-2*GUIvalues.spacebeforebutton;
distance=3*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;

uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','Contour Analysis','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange)
button_y=button_y-GUIvalues.heighteditbox;
button_y=button_y-GUIvalues.spacebeforebutton;

button_y=button_y-GUIvalues.heighteditbox;
ctrl.AddFreeForm=uicontrol('style','pushbutton','string','Add',...
    'units','normalized','position',[0.84 button_y 0.07 GUIvalues.heighteditbox],'Callback','AddFreeForm(''BeginDrawing'')');
ctrl.DeleteFreeForm=uicontrol('style','pushbutton','string','Delete',...
    'units','normalized','position',[0.915 button_y 0.075 GUIvalues.heighteditbox],'Callback','deletefreeformgui');
button_y=button_y-GUIvalues.heighteditbox;
ctrl.ModifyFreeForm=uicontrol('style','pushbutton','string','Modify',...
    'units','normalized','position',[0.84 button_y 0.07 GUIvalues.heighteditbox],'Callback','AddFreeForm(''ModifyFreeForm'')');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Threshold   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-2*GUIvalues.spacebeforebutton;
distance=2*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','Threshold Analysis','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Auto PC insert
uicontrol('style','frame','units','normalized','position',[0.05 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','PC Analysis','units','normalized','position',[0.05 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange);
button_y1=button_y-GUIvalues.heighteditbox;
button_y1=button_y1-GUIvalues.spacebeforebutton;

button_y1=button_y1-GUIvalues.heighteditbox;
ctrl.ThresholdButton=uicontrol('style','pushbutton','string','Compute',...
    'units','normalized','position',[0.13 button_y1 GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback','StructuralAnalysisComputation;draweverything;');   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-GUIvalues.heighteditbox;
button_y=button_y-GUIvalues.spacebeforebutton;

button_y=button_y-GUIvalues.heighteditbox;
ctrl.ThresholdButton=uicontrol('style','pushbutton','string','Compute',...
    'units','normalized','position',[0.915 button_y GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback','functhresholdcontour;draweverything;');                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% SXA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_y=button_y-2*GUIvalues.spacebeforebutton;
distance=3*GUIvalues.heighteditbox+3*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
uicontrol('style','text','string','SXA Analysis','units','normalized','position',[0.835 button_y-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange)
button_y=button_y-GUIvalues.heighteditbox;
button_y=button_y-GUIvalues.spacebeforebutton;

%%%%%%%%%%%%%%%%%%%%%%%% Auto Manual Phantom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
button_y=button_y-GUIvalues.heighteditbox;
ctrl.CheckManualPhantom=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 button_y 0.04 GUIvalues.heighteditbox],'backgroundcolor',background);
ctrl.Phantom=uicontrol('style','pushbutton','string','Phantom',...
    'units','normalized','position',[0.915 button_y GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'callback','PhantomDetection');

%%%%%%%%%%%%%%%%%%%%%%%% Density Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
button_y=button_y-GUIvalues.heighteditbox;
ctrl.Density=uicontrol('style','pushbutton','string','Density',...
    'units','normalized','position',[0.915 button_y GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback','ComputeDensity');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   DEBUG Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

button_y=button_y-2*GUIvalues.spacebeforebutton;
distance=4*GUIvalues.heightcheckbox+2*GUIvalues.spacebeforebutton+6*GUIvalues.spacebeforecheckbox+GUIvalues.heightbutton;
uicontrol('style','frame','units','normalized','position',[0.835 button_y-distance 0.16 distance],'backgroundcolor',background,'foreground',background);
button_y=button_y-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.ShowBackGround=uicontrol('style','checkbox','string','Show Background',...
    'units','normalized','position',[0.84 button_y 0.12 GUIvalues.heightcheckbox],'backgroundcolor',background);
button_y=button_y-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.ShowAL=uicontrol('style','checkbox','string','Show Analysis lines',...
    'units','normalized','position',[0.84 button_y 0.12 GUIvalues.heightcheckbox],'backgroundcolor',background,'value',true);
button_y=button_y-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.SFLI=uicontrol('style','checkbox','string','Show Fat Lean Image',...
    'units','normalized','position',[0.84 button_y 0.12 GUIvalues.heightcheckbox],'backgroundcolor',background);
button_y=button_y-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.separatedfigure=uicontrol('style','checkbox','string','Separate figure',...
    'units','normalized','position',[0.84 button_y 0.12 GUIvalues.heightcheckbox],'backgroundcolor',background);

button_y=button_y-GUIvalues.spacebeforebutton-GUIvalues.heightbutton;ctrl.Debug=uicontrol('style','pushbutton','string','Redraw',...
    'units','normalized','position',[0.86 button_y 0.12 GUIvalues.heightbutton],'callback','redraw;');

button_y=button_y-2*GUIvalues.spacebeforebutton-GUIvalues.heightbutton/2;ctrl.SaveNextPatient=uicontrol('style','pushbutton','string','Save/Next Patient','enable','off',...
    'units','normalized','position',[0.84 button_y 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(1)');
button_y=button_y-GUIvalues.heightbutton/2;ctrl.DontSaveNextPatient=uicontrol('style','pushbutton','string','Next Patient','enable','off',...
    'units','normalized','position',[0.84 button_y 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(0);');
button_y=button_y-GUIvalues.heightbutton/2;ctrl.StopReading=uicontrol('style','pushbutton','string','Stop Reading','enable','off',...
    'units','normalized','position',[0.84 button_y 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(2);');
ctrl.QAreport=uicontrol('style','pushbutton','string','QA','enable',EnableDatabase,...
    'units','normalized','position',[0.945 button_y 0.04 GUIvalues.heightbutton],'callback','QAreport(''ROOT'')');
button_y=button_y-GUIvalues.heightbutton/2;ctrl.Skip=uicontrol('style','pushbutton','string','Skip/Save','enable','off',...
    'units','normalized','position',[0.84 button_y 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(3);');

%global CheckControl;
%button_y=button_y-GUIvalues.heightbutton/2;CheckControl=uicontrol('style','checkbox','string','Continue',...
%    'units','normalized','position',[0.84 button_y 0.1 GUIvalues.heightbutton/2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Help text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Message('Ready');
ctrl.rapport_zone = uicontrol('Style','listbox','String','Report','units','normalized','position',[0.02 0.1 0.25 0.3],'backgroundcolor',[1 1 1]);
%ctrl.LittleGraph= axes;
%set(ctrl.LittleGraph,'units','normalized','position',[0.02 0.6 0.25 0.23],'YTick',[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MENU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Info.Database
    f0.menu.Database = uimenu('Label','Database');
    f0.menu.DatabaseRetrieve=uimenu(f0.menu.Database,'Label','retrieve...');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve acquisitions','callback','RetrieveInDatabase(''ACQUISITIONFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve common analyses','callback','RetrieveInDatabase(''COMMONANALYSISFROMLIST'')');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a contour analysis','callback','RetrieveInDatabase(''FREEFROMFROMLIST'');');                  
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a SXA analysis','callback','RetrieveInDatabase(''SXAANALYSISFROMLIST'');');        
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a threshold analysis','callback','RetrieveInDatabase(''THRESHOLDANALYSISFROMLIST'');'); 
    f0.menu.DatabaseSave=uimenu(f0.menu.Database,'Label','save...');     
    uimenu(f0.menu.DatabaseSave,'Label','save a common analysis','callback','SaveInDatabase(''COMMONANALYSIS'')');        
    uimenu(f0.menu.DatabaseSave,'Label','save a contour analysis','callback','SaveInDatabase(''FREEFORMANALYSIS'')');
    uimenu(f0.menu.DatabaseSave,'Label','save a SXA analysis','callback','SaveInDatabase(''SXAANALYSIS'')');
    uimenu(f0.menu.DatabaseSave,'Label','save a threshold analysis','callback','SaveInDatabase(''THRESHOLDANALYSIS'')');        
    f0.menu.DatabaseResults=uimenu(f0.menu.Database,'Label','Results...','separator','on');        
    uimenu(f0.menu.DatabaseResults,'Label','FreeFrom','callback','funcShowResume(''Retrievefreeformanalysis'',''FreeForm Results'');');   
    uimenu(f0.menu.DatabaseResults,'Label','Threshold','callback','funcShowResume(''Threshold'',''Threshold Results'');');                   
    uimenu(f0.menu.DatabaseResults,'Label','SXA','callback','funcShowResume(''SXA'',''SXA Results'');');                                   
    uimenu(f0.menu.DatabaseResults,'Label','BIRADS','callback','global Database;funcShowResume(''BIRADSresults'',''BIRADS Results'');');
    uimenu(f0.menu.DatabaseResults,'Label','General Results','callback','global Database;funcShowResume(''GENERALresults'',''BIRADS Results'');');                
    uimenu(f0.menu.DatabaseResults,'Label','Generate Report','callback','SavePPT(''CONTOUR_'');');                                                   
    uimenu(f0.menu.DatabaseResults,'Label','Generate SXADXA Report for Jessie','callback','SavePPT(''SXADXAJESSIE_'');');                                                   
    uimenu(f0.menu.DatabaseResults,'Label','Generate SXADXA Report','callback','SavePPT(''SXADXA_'');');                                                   
    uimenu(f0.menu.DatabaseResults,'Label','Report for Mike','callback','Mike;');           
    uimenu(f0.menu.Database,'Label','see the database','callback','DataBaseMain(''ROOT'',0)','separator','on');    
    
    f0.menu.DatabaseChange=uimenu(f0.menu.Database,'Label','Change of database');    
    for index=1:size(Database.Choice,2)
        f0.menuDatabaseChangeMenus(index)=uimenu(f0.menu.DatabaseChange,'Label',cell2mat(Database.Choice(index)),'callback',['ChangeDatabase(',num2str(index),')']);
    end
else 
    Database.ChoiceNumber=0;
end  
ChangeDatabase(Database.ChoiceNumber);   

f0.menu.file = uimenu('Label','File');
uimenu(f0.menu.file,'Label','Open Image','Callback','Funcmenuopenimage');
ctrl.menuGE=uimenu(f0.menu.file,'Label','DXA Prodigy');
uimenu(ctrl.menuGE,'Label','Open LE and HE','Callback','funcopenLEDXAGE');
%uimenu(ctrl.menuGE,'Label','Open HE','Callback','funcopenHEDXAGE');
ctrl.menuSave=uimenu(f0.menu.file,'Label','Save Image','Callback','saveImage');
f0.menu.image = uimenu('Label','Image');
ctrl.menuRotate=uimenu(f0.menu.image,'Label','Rotate...');
uimenu(ctrl.menuRotate,'Label','Rotate90','Callback','imagemenu(''rotation'');');
uimenu(ctrl.menuRotate,'Label','Rotate','Callback','LittleRotation;');
ctrl.menuFlip=uimenu(f0.menu.image,'Label','Flip...');
uimenu(ctrl.menuFlip,'Label','Horizontal','Callback','imagemenu(''flipH'');');
uimenu(ctrl.menuFlip,'Label','Vertical','Callback','imagemenu(''flipV'');');
ctrl.menuZoom=uimenu(f0.menu.image,'Label','Zoom','Callback','imagemenu(''zoom'');');        
ctrl.menuMeanValue=uimenu(f0.menu.image,'Label','Mean - Standard Deviation','Callback','imagemenu(''meanStandarddeviation'');');                
ctrl.menuExtract=uimenu(f0.menu.image,'Label','Extract Signal','Callback','ExtractSignal(''BeginLine'')');                
ctrl.menuUnderSampling=uimenu(f0.menu.image,'Label','Under Sampling','Callback','imagemenu(''undersampling'');');                
ctrl.HProj=uimenu(f0.menu.image,'Label','Horizontal projection','Callback','imagemenu(''HProj'');');                
ctrl.menuCut=uimenu(f0.menu.image,'Label','Crop...');                        
ctrl.menuCutLeft=uimenu(ctrl.menuCut,'Label','Crop Left Margin','Callback','imagemenu(''CutLeftMargin'');');      
ctrl.menuCutRight=uimenu(ctrl.menuCut,'Label','Crop Right Margin','Callback','imagemenu(''RightMargin'');'); 
ctrl.menuCutTop=uimenu(ctrl.menuCut,'Label','Crop Top Margin','Callback','imagemenu(''CutTopMargin'');');      
ctrl.menuCutBottom=uimenu(ctrl.menuCut,'Label','Crop Bottom Margin','Callback','imagemenu(''BottomMargin'');'); 
ctrl.menuCutAuto=uimenu(ctrl.menuCut,'Label','Automatic Crop Margins','Callback','imagemenu(''AutomaticCrop'');'); 
uimenu(f0.menu.image,'Label','BLind Tag','Callback','blindtag;'); 
f0.menu.Analysis = uimenu('Label','Analysis');
ctrl.menuROI=uimenu(f0.menu.Analysis,'Label','ROI detection','Callback','roidetectiongui');
ctrl.MenuSkinDetection=uimenu(f0.menu.Analysis,'Label','Skin detection','Callback','skindetectiongui');
ctrl.menuPhantom=uimenu(f0.menu.Analysis,'Label','Find Phantom','callback','PhantomDetection');
ctrl.menuDensity=uimenu(f0.menu.Analysis,'Label','Density Computation','callback','ComputeDensity');
ctrl.menuFreeForm = uimenu(f0.menu.Analysis,'Label','Free Form','Separator','on');
uimenu(ctrl.menuFreeForm,'Label','Add Free Form','Callback','AddFreeForm(''BeginDrawing'')');
uimenu(ctrl.menuFreeForm,'Label','Eraze All Free Forms','Callback','funcEraseFreeForms;DrawEverything;');
uimenu(ctrl.menuFreeForm,'Label','Modify Free Form','Callback','AddFreeForm(''ModifyFreeForm'')');            
ctrl.menuAnalysisThreshold = uimenu(f0.menu.Analysis,'Label','Switch Threshold','Separator','on','callback','Histogrammanagement(''SwitchThreshold'',0);draweverything;');            
ctrl.menuComputeThreshold = uimenu(f0.menu.Analysis,'Label','Threshold Computation','callback','ThresholdContour;');                
if Info.DXAOK
    f0.menu.DXA = uimenu('Label','Hologic');
    ctrl.DXA.showLE=uimenu(f0.menu.DXA,'Label','Show LE','Callback','ImageType=''LE'';ShowDXAImage(ImageType);');                
    ctrl.DXA.showHE=uimenu(f0.menu.DXA,'Label','Show HE','Callback','ImageType=''HE'';ShowDXAImage(ImageType);');                
    ctrl.DXA.showRst=uimenu(f0.menu.DXA,'Label','Show RST','Callback','ImageType=''RST'';ShowDXAImage(ImageType);');        
    ctrl.DXA.showMaterial=uimenu(f0.menu.DXA,'Label','Show material','Callback','ImageType=''MATERIAL'';ShowDXAImage(ImageType);');                
    uimenu(f0.menu.DXA,'Label','ROI DXA','Callback','DXAroi;');                        
    uimenu(f0.menu.DXA,'Label','Compute % glandular','Callback','ComputeDXAGlandular;');
    ctrl.DXA.CalibrationLateral=uimenu(f0.menu.DXA,'Label','Calibration: Lateral','Callback','funcCalibrationSwap;','separator','on');                
    ctrl.DXA.CalibrationPA=uimenu(f0.menu.DXA,'Label','Calibration: PA','Callback','funcCalibrationSwap;');    
    uimenu(f0.menu.DXA,'Label','point cloud -> CLOUD','Callback','DXAPointCloud','separator','on');    
    FuncCalibrationSwap;
    uimenu(f0.menu.DXA,'Label','Read header p-file','Callback','readHeader');    
    uimenu(f0.menu.DXA,'Label','Reselect Background','Callback','DXA.selectBackground=true;AddFreeForm;');    
end

if Info.SenographOK
    f0.menu.Senograph = uimenu('Label','Senograph');
    uimenu(f0.menu.Senograph,'Label','Open LE','Callback','SenographFnc(''OpenLE'')');                      
    uimenu(f0.menu.Senograph,'Label','Open HE','Callback','SenographFnc(''OpenHE'')');                              
    uimenu(f0.menu.Senograph,'Label','Show LE','Callback','SenographFnc(''ShowLE'')');      
    uimenu(f0.menu.Senograph,'Label','Show HE','Callback','SenographFnc(''ShowHE'')');              
    uimenu(f0.menu.Senograph,'Label','Show LE Attenuation','Callback','flag.action=1;SenographCompute;','separator','on');     
    uimenu(f0.menu.Senograph,'Label','Show Flat LE','Callback','SenographFnc(''ShowFlatLE'')');      
    uimenu(f0.menu.Senograph,'Label','Show Flat HE','Callback','SenographFnc(''ShowFlatHE'')');              
end
if Info.DigitizerOK
    f0.menu.Digitizer = uimenu('Label','Digitizer');        
    uimenu(f0.menu.Digitizer,'Label','Digitizer','Callback','VidarGUI(''FROMGUI'')');
    uimenu(f0.menu.Digitizer,'Label','Digitizer for Spine','Callback','VidarGUI(''FROMGUI'',''SPINE'')');
end

f0.menu.QA = uimenu('Label','QA');        
uimenu(f0.menu.QA,'Label','QA report','Callback','QAreport');
uimenu(f0.menu.QA,'Label','Post QA report','Callback','QAreport(''ROOT'',''POST'')');
uimenu(f0.menu.QA,'Label','Create correction','Callback','CorrectionCreator');
uimenu(f0.menu.QA,'Label','Analyze density step phantom QC film','Callback','QCAnalysis');
uimenu(f0.menu.QA,'Label','Check SXA Analysis','Callback','CheckSXAAnalysis');
uimenu(f0.menu.QA,'Label','Calculate Phantom Fat-Lean References ','Callback','GammaROI');
uimenu(f0.menu.QA,'Label','Analyze DSP phantom with gamma phantom','Callback','GammaDSP');
uimenu(f0.menu.QA,'Label','Analyze Vidar QA','Callback','VidarQA');


uicontrol('style','pushbutton','string','Defreeze!!',...
    'units','normalized','position',[0.1 0.05 0.1 0.05],'callback','FuncActivateDeactivateButton');

if Info.BIRADS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%   BIRADS  Buttons  %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    button_y=0.7;
    distance=4*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;
    BIRADSdescription=mxDatabase(Database.Name,'select description from BIRADSdescription order by BIRADSdescription_id');
    ctrl.BIRADS(5)=uicontrol('style','frame','units','normalized','position',[0.045 button_y-distance 0.08 distance],'backgroundcolor',background,'foreground',background,'visible','off');
    button_y=button_y-GUIvalues.spacebeforebutton-GUIvalues.heightcheckbox;
    ctrl.BIRADS(1)=uicontrol('style','radiobutton','string',cell2mat(BIRADSdescription(1)),'Value',false,...
        'units','normalized','position',[0.05 button_y 0.07 GUIvalues.heighteditbox],'backgroundcolor',background,'visible','off');
    button_y=button_y-GUIvalues.heightcheckbox;                  
    ctrl.BIRADS(2)=uicontrol('style','radiobutton','string',cell2mat(BIRADSdescription(2)),'Value',false,...
        'units','normalized','position',[0.05 button_y 0.07 GUIvalues.heighteditbox],'backgroundcolor',background,'visible','off');
    button_y=button_y-GUIvalues.heightcheckbox;
    ctrl.BIRADS(3)=uicontrol('style','radiobutton','string',cell2mat(BIRADSdescription(3)),'Value',false,...
        'units','normalized','position',[0.05 button_y 0.07 GUIvalues.heighteditbox],'backgroundcolor',background,'visible','off');
    button_y=button_y-GUIvalues.heightcheckbox;                  
    ctrl.BIRADS(4)=uicontrol('style','radiobutton','string',cell2mat(BIRADSdescription(4)),'Value',false,...
        'units','normalized','position',[0.05 button_y 0.07 GUIvalues.heighteditbox],'backgroundcolor',background,'visible','off');
end              
FuncActivateDeactivateButton;

if Info.DigitizerOK
    set(f0.handle,'deletefcn','global vidar; close(vidar.dummyfigure)');
end
%{
a1 = Order 
b1 = f0
c1 = Result 
d1 = FreeForm 
e1 =  Threshold
f1 = key 
g1 = data
i1 = FreeForm
j1 = ManualEdge
k1 = Hist
l1 = handle
m1 = DXA
n1 = EnterPressedEvent
o1 = dummyuicontrol2
p1 = vidar
q1 = GUIvalues
r1 = Site
s1 = ChestWallData
t1 = CalendarData
u1 = Operator
%}




%ctrl.LE=uicontrol('style','edit','string','LE','units','normalized','position',[0.05 0.9 0.1 0.05]);
%ctrl.HE=uicontrol('style','edit','string','HE','units','normalized','position',[0.15 0.9 0.1 0.05]);