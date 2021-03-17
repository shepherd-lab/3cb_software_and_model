%Tag Tool
%Tool to enter te tag information
%author Lionel HERVE
%creation date 5-17-2004

function TagToolfnc(RequestedAction)

global Info data file Database ctrl TagTool

switch RequestedAction
    case 'FROMGUI'
        if ~Info.TagToolWindow 
            TagToolfnc('ROOT');
        end
    case 'ROOT'

        background=[0.1 0.1 0.4];
        foreground=[1 1 1];
        
        TagTool.figure=figure;
        
        set(TagTool.figure,'units','normalized','position',[0.0 0.05 0.3 0.65],'NumberTitle','off','name','TagTool','deletefcn','Info.TagToolWindow=false;','color',background);
        Info.TagToolWindow=true;
        set(TagTool.figure,'MenuBar','None');

        buttony=0.85;separation=0.07;heightbox=0.035;
        buttonminx=0.45;buttonsizex=0.50;
        buttonminx2=0.05;buttonsizex2=0.40;
        heightbutton=0.07;

        uicontrol('style','text','string','Tag Tool','units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);
    
        %Thickness
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Thickness (mm -1 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        TagTool.ctrlThickness=uicontrol('style','edit','string','-1','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');
    
        %Pressure
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Pressure (-1 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        TagTool.ctrlPressure=uicontrol('style','edit','string','-1','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');
        
        %kVp
        buttony=buttony-heightbox;
        uicontrol('style','text','string','kVp (-1 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        TagTool.ctrlkVp=uicontrol('style','edit','string','-1','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');

        
        %mAs    
        buttony=buttony-heightbox;
        uicontrol('style','text','string','mAs (-1 if Unknown) ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        TagTool.ctrlmAs=uicontrol('style','edit','string','-1','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');

        %technique
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Technique ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        TagTool.ctrlTechnique=uicontrol('style','popupmenu','string',data.technique(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white','ListboxTop',3);
        
        %Save 
        buttony=buttony-2*heightbox;
        uicontrol('style','pushbutton','string','Save in database','units','normalized','position',[buttonminx,buttony,buttonsizex2,heightbox],'CallBack','TagToolfnc(''SAVEINDATABASE'')');
        
    case 'SAVEINDATABASE'
        Field(1)={num2str(Info.AcquisitionKey)};
        Field(2)={get(TagTool.ctrlmAs,'String')};
        Field(3)={get(TagTool.ctrlkVp,'String')};
        Field(4)={num2str(get(TagTool.ctrlTechnique,'value'))};
        Field(5)={get(TagTool.ctrlPressure,'String')};        
        Field(6)={get(TagTool.ctrlThickness,'String')};                  
        funcaddinDatabase(Database,'TagInformation',Field);
        set(TagTool.DataSaved,'value',true);        
end