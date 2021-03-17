function version6(Operator)
global Order file Info ctrl Analysis f0 Result FreeForm flag Correction Hist Threshold Image key ...
    data Image_init ManualEdge handle DXA EnterPressedEvent Database Phantom flag h_init h_slope ...
    coef_tables Z4coef_tableBig Z4coef_tableSmall dummyuicontrol2 vidar GUIvalues Site ...
    ChestWallData CalendarData DEBUG figuretodraw1 axestodraw1 UKcoef_table fredData ffNAME

%added global to simplify retrieval of 3C data
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
flag.Senograph = false
ffNAME = 1;     %sypks 07-26-2018 to temp fix file naming error in function O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\02_3C_SXA_DXA\DXA\log_convertDXA_ZM10new.m
Info.ReportCreated = false;
Info.Database=false;  %Use to determine if database is to be used or not
Info.SeleniaDXAOK = true;
Info.SXAResultOK = true;
Info.PeripheryComputed = false;
Result.DXASelenia = false;
Result.flagHE = false;
Result.flagLE = false;
Info.SaveStatus = 0;
Site.Name='CPMC';
Site.RoomTable=[1 11;2 12; 3 13;4 14;6 15;7 16;8 17];
%file.RepositoryDrive='G:';
file.RepositoryDrive='D:';              %used in function log_convertDXA_ZM10new(image,mAs, kVp, Alfilter)
file.RepositoryDrive2='B:';             %all repo
file.RepositoryDrive3='Z:';             %where to look is the file is not present on the server
flag.open_image_file = false;
flag.SXAphantomDisplay = false;
flag.RawImage = false;
h_init = 0;
h_slope = 0;
Info.Analysistype = 0;
Info.DigitizerId=1;    %choice between 1='vidar',2='kodak',3=R2DG  (see database)  = default digitizer, this parameter is update if an image is loaded through the database
Info.centerlistactivated=1; %default center
Info.CorrectionId=1;   %defualt correction ('no correction Vidar')
Info.Version='Version6.5';   %version
Info.BackGround=true;   %No background Computation
Info.DXACalibration='lateral';  %defaultCalibration  (otherwise PA)
Info.FlatFieldCorrectionAsked=true; %false for just film response correction
Database.ChoiceNumber=5;  %Database choice 1=mammotest, 2=mammo 3=mammoCPMC (see after)
Analysis.SXAMode='Manual';
Analysis.SaveInFile = false;
Info.CorrectionName='none';

Correction.InterpolatedImage1 = [];
%some influence on SXA computation
Info.UseSuperFatLeanImage=true;
Info.SXAnegativeValueForbidden=true;       %if it is true, pixel with %G<0 are put to 0
Info.SXAGreaterValueForbidden=false;
Info.DXAAnalysisRetrieved = false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization (not to be changed) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Info.DXAModeOn=false;
Result.DXA=false;
key.buffer='';
key.message='';
Correction.activeCorrection=0;
Correction.Filename='none'; %'mammo_CPMC',%'mammo_CPMC',
Database.Choice={'mammo_test','mammo','mammo_Marsden','mammo_CPMC','mammo_DXA','mammo_Hawaii'};
Database.Name=cell2mat(Database.Choice(Database.ChoiceNumber));
Info.DigitizerDescription='Unknown';
Info.FilmDate='JESUS';
ChestWallData.Valid=false;
Image.centerlistactivated = 1;
Image.mAs = 0;
Image.kVp = 0;
%figuretodraw1 = figure;
%axestodraw1 = axes;
flag.Selenia_image = false;
%rootdir=[pwd,'\'];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ADD TO PATH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%Obtain path of version6 parent folder
rootdir = erase(mfilename('fullpath'),'version6')       %changed 3/27/2018

%Add path to current paths combined for readability 06042018 sypks
addpath(rootdir,...
    [rootdir,'Archived_3C_SXA_DXA_outsideMFILES'],...    %05242018 sypks folder containing outside m files (need to prune)
    [rootdir,'Site'],...
    [rootdir,'Compiler'],...
    [rootdir,'functions'],...
    [rootdir,'Database'],...
    [rootdir,'Correction'],...
    [rootdir,'Vidar'],...
    [rootdir,'DXA'],...
    [rootdir,'SXA'],...
    [rootdir,'SXA step phantom'],...
    [rootdir,'SXA step phantom\9step_phantom(digi)'],...
    [rootdir,'Contour'],...
    [rootdir,'CommonAnalysis'],...
    [rootdir,'CommonAnalysis\SkinDetection'],...
    [rootdir,'CommonAnalysis\ChestWall'],...
    [rootdir,'Automation'],...
    [rootdir,'Fractalanalysis'],...
    [rootdir,'PhantomDetection'],...
    [rootdir,'Recognition'],...
    [rootdir,'BIRADS'],...
    [rootdir,'ACTIVEX'],...
    [rootdir,'StatisticalAnalysis'],...
    [rootdir,'SQLscripts'],...
    [rootdir,'SimulationX'],...
    [rootdir,'3CB_functions'],...
    [rootdir,'DicomDeidentify'],...
    [rootdir,'iCAD'],...
    [rootdir,'Tomo_3CB'],...
    [rootdir,'Deep_Learning'],...
    [rootdir,'3CBfunctions_sypks']);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~END ADD TO PATH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

Error.SkinEdgeFailed = false;
Analysis.second_phantom = false;


%initialisation
Analysis.PhantomID = [];
Analysis.ChestWallID = 0;
Info.TagToolWindow =false;
Info.DigitizerWindow=false;                 %there is no digitizer window already open
Info.QAWindow=false;                        %there is no QA window already open
Info.Info.saveAcquisitionTool=false;        %there is save acquisition tool open
Info.AcquisitionKey=0;                      %No acquisition open

%set figure window render type
Info.Renderer='painters';                   %Can also choose OpenGL but the threshold analysis is less beautifull
Info.Renderer='zbuffer';                    %Can also choose OpenGL but the threshold analysis is less beautifull
%Image2=[];                                 %for arythmetic operation

Image.colornumber=2^8;                      %8-bit color rgb
Image.colormap=[[0:Image.colornumber-1]' ...
    [0:Image.colornumber-1]' [0:Image.colornumber-1]']...
    /(Image.colornumber-1);      %corrected divisor scaling from (Image.colornumber) to (Image.colornumber-1)
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
Threshold.ComputedCalc=false;
Threshold.DXAComputed=false;
flag.FileFromDatabase=false;
ManualEdge.DrawingInProgress=0;
Info.CompressedAreaAsked=true;              %to know if it compute the compressed Area from the database
Info.PhantomComputed=false;
Info.StepPhantomComputed=false;
flag.ShowMaterial=false;
flag.ShowThickness=false;
DXA.selectBackground=false;
Analysis.BackGroundComputed=false;
Analysis.ThresholdOnly = false;
Analysis.GammaDSP = false;

coef_tables = table_calculation;
Z4coef_tableSmall = Z4tableSmall_calculation;
Z4coef_tableBig =  Z4tableBig_calculation();
UKcoef_table = UKtable_calculation;

Image_init = Image;

%Turn on Database if true
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

%set color variables
%color scheme [r,g,b] range 0-1 so with 8-bit color 0-255 divide to get ratio
gray = [0.90 0.90 0.90];
orange = [1 0.6 0];
UhccLogoDarkBlue = [23/255 103/255 164/255];

%Set Main GUI window parameters
% position: [left bottom width height] determines distance of primary
% display to corresponding inner window for left and right; width and
% height are wrt to window dimensions

% combined commented out set below and combined into this; changing
% DoubleBuffer to 'off' sypks 06042018
f0.handle=figure('units','normalized','position',[0.0 0.01 1.0 .95],...
    'KeyPressFcn','KeypressedProcessing','Renderer',Info.Renderer,...
    'DoubleBuffer','off','NumberTitle','off','name','SXA-DXA','color',...
    UhccLogoDarkBlue,'MenuBar','None','BackingStore','off');

% % % commented out to delete sypks 06042018
% % % set(f0.handle,'units','normalized','position',[0.0 0.01 1.0 .95],'KeyPressFcn',...
% % %     'KeypressedProcessing','Renderer',Info.Renderer,'DoubleBuffer','off','NumberTitle',...
% % %     'off','name','SXA-DXA','color',UhccLogoDarkBlue,'BackingStore','off');
% % %end GUI window

% condition variable used to wait for calculation to finish before
% continuing on with next block of code; used in other functions
dummyuicontrol2=uicontrol('style','checkbox','visible','off','value',false);

%ctrl.text_zone does not have 'String' which throws error
%this affects funcOpenImage through funcMenuOpenImage_auto and
%funcopenSeleniaDXA_auto      change 3.27.2018 to add 'String' ----> NO
%                             try changing funcOpenImage 'String' --->
%                             'text'

% set update bar above main image window and assign to ctrl.text_zone
ctrl.text_zone = uicontrol('Style','text','units','normalized',...
    'position',[0.275 0.94 0.5 0.02],'backgroundcolor',orange);

%create new axis objects in current figure and assign
f0.axisHandle=axes;
f0.UHCChandle=axes;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START SET LOGO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%set mammogram image view window background (UHCClogo.bmp) and top-left
%text-logo (UHCCtextlogo.bmp)
axes(f0.axisHandle);                %take control of f0.axisHandle (new figure)
logo = imread('UHCClogo.bmp');      %read bmp image in
imagesc(logo);                      %show bmp image in current figure
axes(f0.UHCChandle);                %take control of f0.UHCChandle (new figure)
logo = imread('UHCCtextlogo.bmp');
imagesc(logo);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END SET LOGO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%resize image view window and logo text window
set(f0.axisHandle,'units','normalized','position',[0.275 0.05 0.5 0.88]);  %image window
GuiRelativeYAxisSpacing = 0.98;
set(f0.UHCChandle,'units','normalized','position',[0.02 0.85 0.25 0.10],...%UHCC text logo
    'XTick',[],'YTick',[]);


%password check *currently disabled 06042018 by sypks
if exist('Operator')
    Info.Operator=Operator;
elseif Info.Database
    Message('Type your password');
    Info.Operator=cell2mat(funcSelectInTable('operator','Who are you?',1));
    bnn = Info.Operator;
    if (Info.Operator==9)|| (Info.Operator==10)
        Database.ChoiceNumber=3;
    end
    ok=false;
    EnterPressedEvent=uicontrol('style','checkbox','visible','off','value',false);  %message
    while ok==false
        waitfor(EnterPressedEvent,'value',true);
        EnterPressedEvent=uicontrol('value',false);  %message
        ok=AskPassword(Info,key);
    end
end

%Another dummy variable used to wait for button press in DB password test
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

%%%% Comment text box (location top-right above Acquisition parameters box)
% no other update or call to ctrl.comment after this in version6.m code
ctrl.comment=uicontrol('style','edit','string','','units','normalized',...
    'position',[0.835 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 ...
    GUIvalues.heighteditbox]);
GuiRelativeYAxisSpacing = GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;

%%%%%%%%%%%%%%%%%%%%%%%% Flat field Correction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the Aquisition Parameters box in GUI
GuiRelativeDistance = 6*GUIvalues.heighteditbox+1*GUIvalues.spaceforbox+0*GUIvalues.spacebeforecheckbox+...
    2*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],...
    'backgroundcolor',gray,'foreground',gray);
uicontrol('style','text','string','Acquisition parameters','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],...
    'backgroundcolor',orange)
GuiRelativeYAxisSpacing = GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
GuiRelativeYAxisSpacing = GuiRelativeYAxisSpacing-GUIvalues.spacebeforebutton;
GuiRelativeYAxisSpacing = GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.Cor=uicontrol('style','checkbox','string','Corrections','Value',false,...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.15 GUIvalues.heighteditbox],...
    'backgroundcolor',gray);
ctrl.CheckBreast=uicontrol('style','checkbox','string','Chest','Value',true,'units','normalized',...
    'position',[0.90 GuiRelativeYAxisSpacing 0.07 GUIvalues.heighteditbox],'backgroundcolor',...
    gray,'Callback','buttonProcessing(''ChestChecked'')');
uicontrol('style','pushbutton','string','Save','units','normalized','position',...
    [0.95 GuiRelativeYAxisSpacing 0.04 GUIvalues.heighteditbox],'Callback',...
    'buttonProcessing(''SaveInfo'')');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
uicontrol('style','text','string','kVp','units','normalized','position',...
    [0.84 GuiRelativeYAxisSpacing 0.02 GUIvalues.heighteditbox],'backgroundcolor',gray,...
    'HorizontalAlignment','left');
ctrl.kVp=uicontrol('style','edit','string',num2str(Info.kVp),'units','normalized','position',...
    [0.86 GuiRelativeYAxisSpacing 0.03 GUIvalues.heighteditbox],'HorizontalAlignment','left',...
    'backgroundcolor',[1 1 1]);
uicontrol('style','text','string','mAs','units','normalized','position',...
    [0.90 GuiRelativeYAxisSpacing 0.02 GUIvalues.heighteditbox],'backgroundcolor',gray,...
    'HorizontalAlignment','left');
ctrl.mAs=uicontrol('style','edit','string',num2str(Info.mAs),'units','normalized','position',...
    [0.925 GuiRelativeYAxisSpacing 0.03 GUIvalues.heighteditbox],'HorizontalAlignment','left',...
    'backgroundcolor',[1 1 1]);
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
uicontrol('style','text','string','Technique','units','normalized','position',...
    [0.84 GuiRelativeYAxisSpacing 0.06 GUIvalues.heighteditbox],'backgroundcolor',gray,...
    'HorizontalAlignment','left');
ctrl.technique=uicontrol('style','popupmenu','units','normalized','value',1,'position',...
    [0.92 GuiRelativeYAxisSpacing 0.07 GUIvalues.heighteditbox],'HorizontalAlignment','left',...
    'Max',1,'Min',1,'BackgroundColor','white','string',{'',''});
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;ctrl.Center = ...
    uicontrol('Style','popupmenu','value',1,'units','normalized','Position',...
    [0.84 GuiRelativeYAxisSpacing 0.15 GUIvalues.heighteditbox],'BackgroundColor','white',...
    'Max',1,'Min',1,'string',{'',''});
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox-GUIvalues.spaceforbox;
ctrl.CorrectionButton=uicontrol('style','pushbutton','string','Correction','units','normalized',...
    'position',[0.915 GuiRelativeYAxisSpacing GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'Callback','buttonProcessing(''CorrectionAsked'')');

%%%%%%%%%%%%%%%%%%%%%%%% Brightness Contrast %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the histogram in the GUI
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heightBrightnessContrast-...
    2*GUIvalues.spacebeforebutton;
Hist.Handle=axes;set(Hist.Handle,'position',...
    [0.84 GuiRelativeYAxisSpacing 0.15 GUIvalues.heightBrightnessContrast],'YTick',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Common Analysis  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-3*GUIvalues.spacebeforebutton+...
    GUIvalues.heighteditbox;
GuiRelativeDistance=4*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-2*GUIvalues.spacebeforebutton;

uicontrol('style','frame','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',...
    gray,'foreground',gray);
uicontrol('style','text','string','Common Analysis','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],...
    'backgroundcolor',orange)
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforebutton;

GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.CheckAutoROI=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.04 GUIvalues.heighteditbox],...
    'backgroundcolor',gray);
ctrl.ROI=uicontrol('style','pushbutton','string','ROI',...
    'units','normalized','position',[0.88 GuiRelativeYAxisSpacing 0.075 GUIvalues.heighteditbox],...
    'callback','ROIDetection(''FROMGUI'')');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.CheckAutoSkin=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.04 GUIvalues.heighteditbox],...
    'backgroundcolor',gray);
ctrl.SkinDetection=uicontrol('style','pushbutton','string','Skin Detection',...
    'units','normalized','position',[0.88 GuiRelativeYAxisSpacing 0.075 GUIvalues.heighteditbox],...
    'Callback','SkinDetection(''FROMGUI'')');
ctrl.SkinModif=uicontrol('style','pushbutton','string','Modify',...
    'units','normalized','position',[0.957 GuiRelativeYAxisSpacing 0.03 GUIvalues.heighteditbox],...
    'Callback','skinmodifgui');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.ChestWall=uicontrol('style','pushbutton','string','Chest Wall',...
    'units','normalized','position',[0.88 GuiRelativeYAxisSpacing 0.075 GUIvalues.heighteditbox],...
    'Callback','Chestwall(''FROMGUI'')');
ctrl.ChestWallModif=uicontrol('style','pushbutton','string','Modify',...
    'units','normalized','position',[0.957 GuiRelativeYAxisSpacing 0.03 GUIvalues.heighteditbox],...
    'Callback','ChestwallDrawing(''MODIF'')');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Threshold   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-2*GUIvalues.spacebeforebutton;
GuiRelativeDistance=2*GUIvalues.heighteditbox+2*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',...
    gray,'foreground',gray);
uicontrol('style','text','string','Threshold Analysis','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],...
    'backgroundcolor',orange)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Auto PC insert
uicontrol('style','frame','units','normalized','position',...
    [0.05 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',...
    gray,'foreground',gray);
uicontrol('style','text','string','Selenia Whole Breast DXA Analysis','units','normalized',...
    'position',[0.05 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],...
    'backgroundcolor',orange);
button_y1=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
button_y1=button_y1-GUIvalues.spacebeforebutton;

button_y1=button_y1-GUIvalues.heighteditbox;
ctrl.WholeBreastDensityDXAButton=uicontrol('style','pushbutton','string','Compute',...
    'units','normalized','position',[0.13 button_y1 GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'Callback','ComputeWholeBreastDensityDXA;draweverything;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  DXA
button_y1 = button_y1 + 0.13;
uicontrol('style','frame','units','normalized','position',...
    [0.05 button_y1 - GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',gray,...
    'foreground',gray);
uicontrol('style','text','string','Selenia Slice DXA Analysis','units','normalized','position',...
    [0.05 button_y1-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],'backgroundcolor',orange); %Prodigy
button_y2=button_y1-GUIvalues.heighteditbox;
button_y2=button_y2-GUIvalues.spacebeforebutton;

button_y2=button_y2-GUIvalues.heighteditbox;
ctrl.SliceBreastDensityDXAButton=uicontrol('style','pushbutton','string','Compute',...
    'units','normalized','position',[0.13 button_y2 GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'Callback','ComputeSliceBreastDensityDXA;draweverything;');   %ProdigyDXAdensityComputation
% ctrl.ThresholdButton=uicontrol('style','pushbutton','string','Compute',...
%     'units','normalized','position',[0.13 button_y2 GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback','BlockComputeBDDXA;draweverything;');   %ProdigyDXAdensityComputation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforebutton;

GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.ThresholdButton=uicontrol('style','pushbutton','string','Compute','units','normalized',...
    'position',[0.915 GuiRelativeYAxisSpacing GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'Callback','functhresholdcontour;draweverything;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% SXA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-2*GUIvalues.spacebeforebutton;
GuiRelativeDistance=3*GUIvalues.heighteditbox+3*GUIvalues.spacebeforebutton;
uicontrol('style','frame','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',...
    gray,'foreground',gray);
uicontrol('style','text','string','SXA Analysis','units','normalized','position',...
    [0.835 GuiRelativeYAxisSpacing-GUIvalues.heighteditbox 0.16 GUIvalues.heighteditbox],...
    'backgroundcolor',orange)
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforebutton;

%%%%%%%%%%%%%%%%%%%%%%%% Auto Manual Phantom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.CheckManualPhantom=uicontrol('style','checkbox','string','Auto','Value',true,...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.04 GUIvalues.heighteditbox],...
    'backgroundcolor',gray);
ctrl.Phantom=uicontrol('style','pushbutton','string','Phantom','units','normalized','position',...
    [0.915 GuiRelativeYAxisSpacing GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'callback','PhantomDetection');

%%%%%%%%%%%%%%%%%%%%%%%% Density Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.Periphery=uicontrol('style','pushbutton','string','Periphery','units','normalized',...
    'position',[0.915 GuiRelativeYAxisSpacing GUIvalues.ButtonSizeX GUIvalues.heighteditbox],...
    'Callback','Periphery_calculation');

%%%%%%%%%%%%%%%%%%%%%%%% Density Computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heighteditbox;
ctrl.Density=uicontrol('style','pushbutton','string','Density','units','normalized','position',...
    [0.915 GuiRelativeYAxisSpacing GUIvalues.ButtonSizeX GUIvalues.heighteditbox],'Callback',...
    'ComputeDensity');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   DEBUG Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-2*GUIvalues.spacebeforebutton;
GuiRelativeDistance=4*GUIvalues.heightcheckbox+2*GUIvalues.spacebeforebutton+6*GUIvalues.spacebeforecheckbox+GUIvalues.heightbutton;
uicontrol('style','frame','units','normalized','position',[0.835 GuiRelativeYAxisSpacing-GuiRelativeDistance 0.16 GuiRelativeDistance],'backgroundcolor',gray,'foreground',gray);
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.ShowBackGround=uicontrol('style','checkbox','string','Show Background',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.12 GUIvalues.heightcheckbox],'backgroundcolor',gray);
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.ShowAL=uicontrol('style','checkbox','string','Show Analysis lines',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.12 GUIvalues.heightcheckbox],'backgroundcolor',gray,'value',true);
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.SFLI=uicontrol('style','checkbox','string','Show Fat Lean Image',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.12 GUIvalues.heightcheckbox],'backgroundcolor',gray);
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforecheckbox-GUIvalues.heightcheckbox;ctrl.separatedfigure=uicontrol('style','checkbox','string','Separate figure',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.12 GUIvalues.heightcheckbox],'backgroundcolor',gray);

GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.spacebeforebutton-GUIvalues.heightbutton;ctrl.Debug=uicontrol('style','pushbutton','string','Redraw',...
    'units','normalized','position',[0.86 GuiRelativeYAxisSpacing 0.12 GUIvalues.heightbutton],'callback','redraw;');

GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-2*GUIvalues.spacebeforebutton-GUIvalues.heightbutton/2;ctrl.SaveNextPatient=uicontrol('style','pushbutton','string','Save/Next Patient','enable','off',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(1)');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heightbutton/2;ctrl.DontSaveNextPatient=uicontrol('style','pushbutton','string','Next Patient','enable','off',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(0);');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heightbutton/2;ctrl.StopReading=uicontrol('style','pushbutton','string','Stop Reading','enable','off',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(2);');
ctrl.QAreport=uicontrol('style','pushbutton','string','QA','enable',EnableDatabase,...
    'units','normalized','position',[0.945 GuiRelativeYAxisSpacing 0.04 GUIvalues.heightbutton],'callback','QAreport(''ROOT'')');
GuiRelativeYAxisSpacing=GuiRelativeYAxisSpacing-GUIvalues.heightbutton/2;ctrl.Skip=uicontrol('style','pushbutton','string','Skip/Save','enable','off',...
    'units','normalized','position',[0.84 GuiRelativeYAxisSpacing 0.1 GUIvalues.heightbutton/2],'callback','NextPatient(3);');

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
    %uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve acquisitions','callback','RetrieveInDatabase(''ACQUISITIONFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve acquisitions','callback','RetrieveInDatabase(''FILEOFLISTNAMES'');'); %ACQUISITIONFROMLIST
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve common analyses','callback','RetrieveInDatabase(''COMMONANALYSISFROMLIST'')');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a contour analysis','callback','RetrieveInDatabase(''FREEFROMFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a SXA Step phantom analysis','callback','RetrieveInDatabase(''SXASTEPANALYSISFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a SXA analysis','callback','RetrieveInDatabase(''SXAANALYSISFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a threshold analysis','callback','RetrieveInDatabase(''THRESHOLDANALYSISFROMLIST'');');
    uimenu(f0.menu.DatabaseRetrieve,'Label','retrieve a DXA analysis','callback','RetrieveInDatabase(''DXAANALYSIS'');');
    f0.menu.DatabaseSave=uimenu(f0.menu.Database,'Label','save...');
    uimenu(f0.menu.DatabaseSave,'Label','save a common analysis','callback','SaveInDatabase(''COMMONANALYSIS'')');
    uimenu(f0.menu.DatabaseSave,'Label','save a contour analysis','callback','SaveInDatabase(''FREEFORMANALYSIS'')');
    uimenu(f0.menu.DatabaseSave,'Label','save a SXA STEP analysis','callback','SaveInDatabase(''SXASTEPANALYSIS'')');
    %uimenu(f0.menu.DatabaseSave,'Label','save a SXA analysis','callback','SaveInDatabase(''SXAANALYSIS'')');
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

%if Database.ChoiceNumber ~= 6
ChangeDatabase(Database.ChoiceNumber);
%end

f0.menu.file = uimenu('Label','File');
uimenu(f0.menu.file,'Label','Open Selenia Raw Image','Callback','OpenSeleniaRawImage');
uimenu(f0.menu.file,'Label','Open Selenia Attenuation Image','Callback','funcOpenSeleniaImage');
uimenu(f0.menu.file,'Label','Open Selenia DXA LE and HE images WB ZM10 new','Callback','funcopenSeleniaDXA(''Breast ZM10new'')');
uimenu(f0.menu.file,'Label','Open Selenia DXA LE and HE images Processed Mat File','Callback',@openSeleniaDXAMAT);
uimenu(f0.menu.file,'Label','Open Hologic *.R* Image','Callback','funcOpenHologic_rfile');
uimenu(f0.menu.file,'Label','Open Prodigy DXA LE and HE images','Callback','funcopenLEDXAGE'); %ctrl.menuGE=
ctrl.menuSave=uimenu(f0.menu.file,'Label','Save Image','Callback','saveImage');
%ctrl.matSave=uimenu(f0.menu.file,'Label','Save 3C mat file', 'Callback','saveMat3C');
ctrl.matSave=uimenu(f0.menu.file,'Label','Save 3C Results mat file', 'Callback','save_3CResults');

f0.menu.ThreeC=uimenu('Label', '3C');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Manually Create 3C calibration points', 'Callback', 'manual_3Ccalibration');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Manually Create 3C calibration 31 points ', 'Callback', 'manual_3Ccalibration_Fredphantom');
%f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Automaticall Create 3C Calibration', 'Callback', 'auto_3Ccalibration');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Create 3C Calibration with 14 (2 and 4 cm) ROI template', 'Callback', 'QCAnalysis_3CDXA14');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Create 3C Calibration with 36 ROI template', 'Callback', 'QCAnalysis_3CDXA36');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Create 3C Calibration with 48 ROI template', 'Callback', 'QCAnalysis_3CDXA48');
f0.menu.ThreeCROI=uimenu(f0.menu.ThreeC,'Label', 'Create 3C Calibration with 51 ROI template', 'Callback', 'QCAnalysis_3CDXA51');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Generate 3C CUBIC calibration coefficients', 'Callback', 'CalibrationDXA_3C_fat_water_protein(''CUBIC'');');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Generate 3C QUADRATIC calibration coefficients', 'Callback', 'CalibrationDXA_3C_fat_water_protein(''QUADRATIC'');');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Generate 3C LINEAR calibration coefficients', 'Callback', 'CalibrationDXA_3C_fat_water_protein(''LINEAR'');');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Generate 2C QUADRATIC calibration coefficients', 'Callback', 'CalibrationDXA_2C_water_SA(''TWOCOMP'');');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Generate 3C QUADRATIC CVX calibration coefficients', 'Callback', 'CalibrationDXA_3C_fat_water_protein_JA(''QUADRATIC'');');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Load Thickness, Flip and ROI mat file', 'Callback', 'Load_thicknessFLIPROI');
f0.menu.ThreeCLoad=uimenu(f0.menu.ThreeC,'Label', 'Load Annotation mat file', 'Callback', 'LoadAnnotation');

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
uimenu(f0.menu.image,'Label','Plot 3D map of ROI on displayed image','callback','plot_3dMap;'); %%%%%%
uimenu(f0.menu.image,'Label','Plot 3D Thickness map SXA and DXA','callback','plot_3dThickness;');
uimenu(f0.menu.image,'Label','Plot 3D Density map SXA and DXA','callback','plot_3dMaterial2;');
uimenu(f0.menu.image,'Label','Plot 3D Dense Volume map SXA and DXA','callback','plot_3dDenseVolume;');
uimenu(f0.menu.image,'Label','Creation of 3C phantom thickness mask','callback','mask_creation3C;');
uimenu(f0.menu.image,'Label','Label Removal','Callback','imagemenu(''Label Removal'');');

f0.menu.Analysis = uimenu('Label','Analysis');
uimenu(f0.menu.Analysis,'Label','Automatic 3C Analysis','callback',@Automatic3CAnalysis); %added 06012018 sypks
ctrl.menuROI=uimenu(f0.menu.Analysis,'Label','ROI detection','Callback','roidetectiongui');
ctrl.MenuSkinDetection=uimenu(f0.menu.Analysis,'Label','Skin detection','Callback','skindetectiongui');
ctrl.menuPhantom=uimenu(f0.menu.Analysis,'Label','Find Phantom','callback','PhantomDetection');
ctrl.menuDensity=uimenu(f0.menu.Analysis,'Label','Density Computation','callback','ComputeDensity');
ctrl.menuFreeForm = uimenu(f0.menu.Analysis,'Label','Free Form','Separator','on');
uimenu(ctrl.menuFreeForm,'Label','Add Free Form','Callback','AddFreeForm(''BeginDrawing'')');
uimenu(ctrl.menuFreeForm,'Label','Eraze All Free Forms','Callback','funcerasefreeforms;AddFreeForm;');
uimenu(ctrl.menuFreeForm,'Label','Modify Free Form','Callback','AddFreeForm(''ModifyFreeForm'')');
ctrl.menuAnalysisThreshold = uimenu(f0.menu.Analysis,'Label','Switch Threshold','Separator','on','callback','Histogrammanagement(''SwitchThreshold'',0);draweverything;');
ctrl.menuComputeThreshold = uimenu(f0.menu.Analysis,'Label','Threshold Computation','callback','ThresholdContour;');

if Info.SXAResultOK
    f0.menu.SXAResult = uimenu('Label','SXA Result');
    uimenu(f0.menu.SXAResult,'Label','Show Density Map','Callback','SXAResultFnc(''ShowDensityMap'')');
    uimenu(f0.menu.SXAResult,'Label','Show Thickness Map','Callback','SXAResultFnc(''ShowThicknessMap'')');
    uimenu(f0.menu.SXAResult,'Label','Show Original Image','Callback','SXAResultFnc(''ShowOriginalImage'')');
end

if Info.SeleniaDXAOK
    f0.menu.SeleniaDXA = uimenu('Label','DXA');
    uimenu(f0.menu.SeleniaDXA,'Label','Show LE','Callback','SeleniaDXAFnc(''ShowLE'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show HE','Callback','SeleniaDXAFnc(''ShowHE'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show RST','Callback','SeleniaDXAFnc(''ShowRST'')');
    % % %     uimenu(f0.menu.SeleniaDXA,'Label','Load Calibration Points','Callback','CalibrationCoeffs_Dialog');
    uimenu(f0.menu.SeleniaDXA,'Label','Load Thickness Map','Callback','LoadThicknessmap');
    uimenu(f0.menu.SeleniaDXA,'Label','Show Material','Callback','SeleniaDXAFnc(''ShowMaterial'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show Thickness','Callback','SeleniaDXAFnc(''ShowThickness'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show Third Component','Callback','SeleniaDXAFnc(''ShowThirdComponent'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show Dense Volume','Callback','SeleniaDXAFnc(''ShowDensevolume'')');
    uimenu(f0.menu.SeleniaDXA,'Label','Show Tmask3C','Callback','SeleniaDXAFnc(''ShowTMASK3C'')');
end

f0.menu.QA = uimenu('Label','QA');
uimenu(f0.menu.QA,'Label','Analyze Bovine 246 phantom','Callback','QCAnalysis_DXA_Bovine');
uimenu(f0.menu.QA,'Label','Analyze Bovine 246 phantom','Callback','QCAnalysis_DXA_Bovine357');
uimenu(f0.menu.QA,'Label','QA report','Callback','QAreport');
uimenu(f0.menu.QA,'Label','Post QA report','Callback','QAreport(''ROOT'',''POST'')');
uimenu(f0.menu.QA,'Label','Create correction','Callback','CorrectionCreator');
uimenu(f0.menu.QA,'Label','Analyze density step phantom QC film','Callback','QCAnalysis');
uimenu(f0.menu.QA,'Label','Check SXA Analysis','Callback','CheckSXAAnalysis');
uimenu(f0.menu.QA,'Label','Analyze SELENIA DXA DSP7 phantom ','Callback','SeleniaDXADSP');
uimenu(f0.menu.QA,'Label','Analyze Prodigy DXA 3 steps x 3 thicknesses phantom QA','Callback','Prodigy9stepsQA');
uimenu(f0.menu.QA,'Label','Analyze Prodigy DXA 3 steps x 4 thicknesses phantom QA','Callback','Prodigy12stepsQA');
uimenu(f0.menu.QA,'Label','Analyze DSP7, 4 thicknesses','Callback','QCAnalysis_DXA');
uimenu(f0.menu.QA,'Label','Analyze thin Vertical DSP , 5 thicknesses','Callback','QCAnalysis_DXAthin');
uimenu(f0.menu.QA,'Label','Analyze thin Horizontal DSP , 5 thicknesses ','Callback','QCAnalysis_DXAthinHoriz');
uimenu(f0.menu.QA,'Label','Analyze Tiny Phantom Vertical ','Callback','QCAnalysis_DXAtinyVert');
uimenu(f0.menu.QA,'Label','Analyze Tiny Phantom Horizontal ','Callback','QCAnalysis_DXAtinyHoriz');
uimenu(f0.menu.QA,'Label','Analyze Blue Phantom Vertical ','Callback','QCAnalysis_DXAblueVert');
uimenu(f0.menu.QA,'Label','Analyze Selenia DSP7 BP (cal)','Callback','QCAnalysis_DXA_BP');
uimenu(f0.menu.QA,'Label','Analyze Selenia DSP7 BP6 (cal)','Callback','QCAnalysis_DXA_BP6');
uimenu(f0.menu.QA,'Label','Analyze Selenia DSP7 BP7 (cal)','Callback','QCAnalysis_DXA_BP7');

uicontrol('style','pushbutton','string','Defreeze!!',...
    'units','normalized','position',[0.1 0.05 0.1 0.05],'callback','funcActivateDeactivateButton');

funcActivateDeactivateButton;
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