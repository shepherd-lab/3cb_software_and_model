function UserGUI(RequestedAction)
global f0 Database CPMC SOPInstanceUIDList Event
format compact
warning off Images:genericDICOM
ErrorNumber=0;
LogFile='LogFile.txt';
Dicom.Database='eFilmDatabase';

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end

switch RequestedAction
    case 'ROOT'
        Event='';
        CPMC.figure=figure;
        
        background=[0.1 0.1 0.4];
        foreground=[1 1 1];
        
        set(CPMC.figure,'units','normalized','position',[0.3 0.05 0.3 0.65],'NumberTitle','off','name','User GUI','color',background);   %'deletefcn','UserGUI',
        set(CPMC.figure,'MenuBar','None');
        
        buttony=0.85;separation=0.07;heightbox=0.035;
        buttonminx=0.20;buttonsizex=0.70;
        buttonminx2=0.05;
        heightbutton=0.07;
        
        uicontrol('style','text','string','waiting for the night','units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Push recalled patient for R2','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','CPMCPushR2');buttony=buttony-separation;
        uicontrol('style','pushbutton','string','Blind Tag','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','UserGUI(''BLINDTAG'')');buttony=buttony-separation;      
        CPMC.Text1=uicontrol('style','text','string','scans to be night processed','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'backgroundcolor',[1 0.6 0]);buttony=buttony-separation;
        CPMC.Text2=uicontrol('style','text','string','recalled patients to be pushed','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'backgroundcolor',[1 0.6 0]);buttony=buttony-separation;
        CPMC.Text3=uicontrol('style','text','string','films to be blinded','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'backgroundcolor',[1 0.6 0]);buttony=buttony-separation;        
        uicontrol('style','Pushbutton','string','Refresh','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'Callback','global Event;Event=''REFRESH'';');buttony=buttony-3*separation;        
        uicontrol('style','pushbutton','string','Quit','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbutton],'Callback','global Event;Event=''QUIT'';');
        UserGUI('WAITLOOP');
    case 'WAITLOOP'
        while (1)
            pause(1);
            try
                %test if a new file has come in the efilm database
                while (1)   %wait for the night and update the text every minutes
                    if strcmp(Event,'REFRESH')
                        UserGUI('REFRESH');
                    end
                 
                    if strcmp(Event,'QUIT')
                        exit;
                    end
                    H=clock;
                    if (H(4)>=0)&&(H(4)<=6)   %process the data during the night
                        SOPInstanceUIDList=mxDatabase(Dicom.Database,'select SOPInstanceUID from Image',1);     %find the filename == key
                        break
                    end
                    pause(1);
                end
                EraseOldFile;
                PushRecalledPatients;
                ReadDicomFromEfilm;
            catch
                Msg=lasterr;
                
                display(lasterr);
                ErrorNumber=ErrorNumber+1;
                fid = fopen(LogFile,'a');
                for i=1:size(Msg,2)
                    if double(Msg(i))<32
                        Msg(i)=' ';
                    end
                end
                fprintf(fid,[hour,'  ',Msg,' on file:',cell2mat(SOPInstanceUIDList),'\n']);
                status = fclose(fid);        
                if ErrorNumber==3
                    !C:\MATLAB6p5p1\bin\win32\matlab.exe -nosplash -r "cd 'C:\SXADXA\SXAVersion6.0';version6(4);UserGUI;"&
                    exit;
                end
                end
        end
        set(CPMC.figure,'deletefcn','');
        delete (CPMC.figure);
    case 'BLINDTAG'        
        BlindTagTool;
    case 'REFRESH'
        Event='';
        sizeList=size(mxDatabase(Dicom.Database,'select SOPInstanceUID from Image'),1);
        set(CPMC.Text1,'string',[num2str(sizeList),' scans to be night processed']);       %write the number of waiting scans in the GUI
        
        sizeList=size(mxDatabase(Database.Name,'select * from fileoninternaldrive where status=''ToBePushed'''),1);
        set(CPMC.Text2,'string',[num2str(sizeList),' recalled patients to be pushed']);       %write the number of waiting scans to be pushed in the GUI                                        
        
        sizeList=size(mxDatabase(Database.Name,'select * from acquisition where study_id=''CPUCSFnotBlinded'''),1);
        set(CPMC.Text3,'string',[num2str(sizeList),' films to be blinded']);       %write the number of waiting scans to be pushed in the GUI                                        
end