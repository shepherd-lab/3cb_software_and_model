%Lionel HERVE
%creation date 6-17-03
figure1=figure;
global SimulationX
initcoef;
initcoef2;
initcoef3;

SimulationX.numbermaterialSource=0;
SimulationX.numbermaterialAttenuant=0;
SimulationX.figurehandle=figure;
set(SimulationX.figurehandle,'units','normalized','position',[0.0 0.02 1.0 0.92]);


heightbutton=0.05;                          
heightcheckbox=0.02;
heighteditbox=0.02;
spacebeforebutton=0.01;
spacebeforecheckbox=0.00;
spaceforbox=0.005;
heightBrightnessContrast=0.1;
button_y=0.9;

%%%%%%%%%%%  Anode Choice %%%%%%%%%
SimulationX.AnodeList=[{'Molybdenum18-50'},{1};{'Tungsten30-140'},{2};{'Rhodium18-50'},{3}];

uicontrol('style','text','string','SOURCE','units','normalized','position',[0.01 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.Anode=uicontrol('style','listbox','string',SimulationX.AnodeList(:,1),'units','normalized','position',[0.1 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
uicontrol('style','text','string','kVp','units','normalized','position',[0.71 button_y+heighteditbox 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.AnodekVp=uicontrol('style','edit','string','25','units','normalized','position',[0.71 button_y 0.19 1*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');

%%%%%%%%%%% Filtration Choice %%%%%
SimulationX.FiltrationList=[{'Adipous'},{1};{'Aluminum'},{2};{'Copper'},{6};{'Glandular'},{3};{'Molybdenum'},{4};{'Rhodium'},{5};{'Copper'},{6};{'Water'},{7};{'Cortical Bone'},{8};{'Beryllium'},{9};{'PMMA'},{10};{'Poly Ethylene'},{11};{'Cesium Iodide'},{12};{'Cerium'},{13};{'Polystyrene'},{14};{'Muscle'},{15};{'PVC'},{16};{'Tin'},{17}];


button_y=button_y-4*heighteditbox;
SimulationX.ctrl.FiltrationChoiceSource=uicontrol('style','listbox','string',SimulationX.FiltrationList(:,1),'units','normalized','position',[0.1 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
uicontrol('style','text','string','thickness (cm)','units','normalized','position',[0.71 button_y+heighteditbox 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.FiltrationThicknessSource=uicontrol('style','edit','string','1','units','normalized','position',[0.71 button_y 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor','white');
uicontrol('style','pushbutton','string','Add','units','normalized','position',[0.91 button_y 0.05 1*heighteditbox],'CallBack','AddFiltrationSource');
SimulationX.FiltrationSource=[{'None'} {0} {0}];
button_y=button_y-4*heighteditbox;
SimulationX.ctrl.FiltrationSourceListBox=uicontrol('style','listbox','string',SimulationX.FiltrationSource(:,1),'units','normalized','position',[0.1 button_y 0.8 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
uicontrol('style','pushbutton','string','Delete','units','normalized','position',[0.91 button_y 0.05 1*heighteditbox],'CallBack','DeleteFiltrationSource');

button_y=button_y-4*heighteditbox;
uicontrol('style','text','string','ATTENUANT','units','normalized','position',[0.01 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.FiltrationChoiceAttenuant=uicontrol('style','listbox','string',SimulationX.FiltrationList(:,1),'units','normalized','position',[0.1 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
uicontrol('style','text','string','thickness (cm)','units','normalized','position',[0.71 button_y+heighteditbox 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.FiltrationThicknessAttenuant=uicontrol('style','edit','string','1','units','normalized','position',[0.71 button_y 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor','white');
uicontrol('style','pushbutton','string','Add','units','normalized','position',[0.91 button_y 0.05 1*heighteditbox],'CallBack','AddFiltrationAttenuant');
SimulationX.FiltrationAttenuant=[{'None'} {0} {0}];
button_y=button_y-4*heighteditbox;
SimulationX.ctrl.FiltrationAttenuantListBox=uicontrol('style','listbox','string',SimulationX.FiltrationAttenuant(:,1),'units','normalized','position',[0.1 button_y 0.8 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
uicontrol('style','pushbutton','string','Delete','units','normalized','position',[0.91 button_y 0.05 1*heighteditbox],'CallBack','DeleteFiltrationAttenuant');

%%%%%%%%%% Result Choice %%%%%
SimulationX.ResultList=[{'Attenuant'},{1};{'Source Spectrum'},{2};{'Detector Spectrum'},{3}];

button_y=button_y-4*heighteditbox;
uicontrol('style','text','string','RESULTS','units','normalized','position',[0.01 button_y 0.6 3*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.ResultChoice=uicontrol('style','listbox','string',SimulationX.ResultList(:,1),'units','normalized','position',[0.1 button_y 0.8 3*heighteditbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');

%%%%% Compute 
button_y=button_y-4*heighteditbox;
uicontrol('style','pushbutton','string','Compute','units','normalized','position',[0.1 button_y 0.3 3*heighteditbox],'callback','compute');
uicontrol('style','pushbutton','string','Export in Excel','units','normalized','position',[0.41 button_y 0.29 3*heighteditbox],'callback','ExportExcel');
uicontrol('style','text','string','attenuation','units','normalized','position',[0.71 button_y+heighteditbox 0.19 1*heighteditbox],'HorizontalAlignment','left','BackgroundColor',[0.8 0.8 0.8]);
SimulationX.ctrl.result=uicontrol('style','edit','string','','units','normalized','position',[0.71 button_y 0.1 1*heighteditbox],'BackgroundColor','white');


clear heightbutton;clear heightcheckbox;clear heighteditbox;clear spacebeforebutton;clear spacebeforecheckbox; clear spaceforbox;
clear heightBrightnessContrast; clear button_y;
