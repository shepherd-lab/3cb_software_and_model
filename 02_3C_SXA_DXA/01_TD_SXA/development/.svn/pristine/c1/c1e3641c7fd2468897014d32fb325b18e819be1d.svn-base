%Vidar GUI
%author Lionel HERVE
%creation date 6-5-2003

function vidargui(RequestedAction,option)
%#function vidarinitialize
%#function VidarInitialize
%#function VidarStartScan
%#function UnloadMedium

global vidar Info data file Database ctrl

if ~exist('RequestedAction')
    RequestedAction='ROOT'
end
if ~exist('option')
    option='NONE';
end

switch RequestedAction
    case 'FROMGUI'
        if ~Info.DigitizerWindow 
            VidarGUI('ROOT');
        end
        if strcmp(option,'SPINE')
            QAreport('ROOT','NONE',option);
        end
        vidar.ScanType=option;
    case 'ROOT'
        Info.DigitizerDescription='Vidar Diagnostic Pro Plus'; 
        vidar.CALIBRATE_BLACK_AND_WHITE	= 0;
        vidar.CALIBRATE_WHITE	= vidar.CALIBRATE_BLACK_AND_WHITE + 1;
        vidar.CALIBRATE_BLACK	= vidar.CALIBRATE_WHITE+1;

        vidar.figure=figure;

        background=[0.1 0.1 0.4];
        foreground=[1 1 1];

        set(vidar.figure,'units','normalized','position',[0.0 0.05 0.3 0.65],'NumberTitle','off','name','Digitizer tools','deletefcn','global Info; Info.DigitizerWindow=false;Calendar(''CLOSE'')','color',background);
        Info.DigitizerWindow=true;
        set(vidar.figure,'MenuBar','None');

        buttony=0.85;separation=0.07;heightbox=0.035;
        buttonminx=0.45;buttonsizex=0.50;
        buttonminx2=0.05;buttonsizex2=0.40;
        heightbutton=0.07;

        uicontrol('style','text','string','Vidar digitizer tools','units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);
    
        uicontrol('style','pushbutton','string','Initialization','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','VidarInitialize');
        vidar.checkbox1=uicontrol('style','checkbox','units','normalized','position',[buttonminx+buttonsizex,buttony,0.05,0.02],'background',background);

        buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Calibrate','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','vidargui(''CALIBRATE'')');
        vidar.checkbox5=uicontrol('style','checkbox','units','normalized','position',[buttonminx+buttonsizex,buttony,0.05,0.02],'background',background);
    
        buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Digitize','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','VidarStartScan;');
        vidar.checkbox4=uicontrol('style','checkbox','units','normalized','position',[buttonminx+buttonsizex,buttony,0.05,0.02],'background',background);

        buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Unload medium','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','UnloadMedium(vidar.activex)');

        buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Blind tag','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','VidarBlindTag');

        %study_ID
        buttony=buttony-separation;
        uicontrol('style','text','string','Study  ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.ctrlStudy=uicontrol('style','edit','string','SXADXA','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white','callback','VidarGUI(''UPDATEFILENAME'');');

        %patient_ID
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Patient_ID  ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.ctrlPatient=uicontrol('style','edit','string','','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white','callback','VidarGUI(''UPDATEFILENAME'')');

        %visit_ID
        buttony=buttony-heightbox;
        uicontrol('style','text','string','visit_ID  ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.ctrlVisit=uicontrol('style','edit','string','1','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white','callback','VidarGUI(''UPDATEFILENAME'')');

        %FilmIdentifier
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Film Identifier ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.FilmIdentifier=uicontrol('style','edit','string','','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');

        %Acqusition Date
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Acquisition Date ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.AcqusitionDate=uicontrol('style','edit','string','','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');
        uicontrol('style','pushbutton','string','>>','units','normalized','position',[0.95,buttony,0.05,heightbox],'callback','Calendar(''DRAW'');');

        %mAs    
        buttony=buttony-heightbox;
        uicontrol('style','text','string','mAs (0 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.ctrlmAs=uicontrol('style','edit','string','0','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');

        %kVp
        buttony=buttony-heightbox;
        uicontrol('style','text','string','kVp (0 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        vidar.ctrlkVp=uicontrol('style','edit','string','0','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');

        %view
        buttony=buttony-heightbox;
        uicontrol('style','text','string','View ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrlView=uicontrol('style','popupmenu','string',data.view(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white','callback','VidarGUI(''UPDATEFILENAME'')');
        
        %Phantom
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Phantom ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrlPhantom=uicontrol('style','popupmenu','string',data.phantom(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
        
        %technique
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Technique ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrlTechnique=uicontrol('style','popupmenu','string',data.technique(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',3,'BackgroundColor','white','ListboxTop',3);
        
        %location
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Center ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrllocation=uicontrol('style','popupmenu','string',data.centerlistname(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
        
        %path
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Path ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrlPathText=uicontrol('style','edit','string',file.startpath,'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','BackgroundColor','white');
        uicontrol('style','pushbutton','string','>>','units','normalized','position',[0.95,buttony,0.05,heightbox],'callback',['global file; if file.startpath == 0 file.startpath=''''; end;file.startpath=uigetdir(file.startpath,''Select the path'');set(vidar.ctrlPathText,''string'',file.startpath);']);
    
        %filename
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Filename ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        vidar.ctrlFileName=uicontrol('style','edit','string','Untitled.tif','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','BackgroundColor','white');
        
        %Save 
        buttony=buttony-2*heightbox;
        uicontrol('style','pushbutton','string','Save in database','units','normalized','position',[buttonminx,buttony,buttonsizex2,heightbox],'CallBack','vidargui(''SAVEINDATABASE'')');
        
    case 'CALIBRATE'
        CalibrateBlackAndWhite(vidar.activex,vidar.CALIBRATE_BLACK_AND_WHITE);
        set(vidar.checkbox5,'value',true);

    case 'SAVEINDATABASE'
        VidarAddAnEntrie(Database,vidar,data,vidar.DigitalizedImage,ctrl);
                
    case 'UPDATEFILENAME'
        ViewList=get(vidar.ctrlView,'string');
        if strcmp(vidar.ScanType,'SPINE')
            FileEnding='.dcm';
            Filename=[get(vidar.ctrlStudy,'string'),get(vidar.ctrlPatient,'string'),get(vidar.ctrlVisit,'string'),deblank(ViewList{get(vidar.ctrlView,'value')}),FileEnding];
        else
            FileEnding='.tif';
            Filename=[get(vidar.ctrlStudy,'string'),get(vidar.ctrlPatient,'string'),deblank(ViewList{get(vidar.ctrlView,'value')}),'-',get(vidar.ctrlVisit,'string'),FileEnding];
        end

        set(vidar.ctrlFileName,'string',Filename);
        
end