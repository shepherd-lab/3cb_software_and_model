%QA GUI
%author Lionel HERVE
%creation date 7-16-2003
%% QA report
% Shows a checkbox list with QA codes.
% To add some new QA codes, go to the database, tabular QAcode.
% The order of appearence of the code is given by AppereanceOrder (in the
% database)
% QAcode (in the database) should be integer>0
%if the box QAreport doesn't look well change the parameters:
%windowsizey,ratio and separation

%4-7-04:    change to a function
%           fill the field with the content of the database
%           use mxDatabase

function answer=QAreport(RequestedAction,option,option2)
global Info Database QA ctrl
answer=false;

%Variable added by Song to store all acquisition_id, 03/14/11
persistent acquisitionKeyList;
if isempty(acquisitionKeyList)
	acquisitionKeyList = cell2mat(mxDatabase(Database.Name, ...
                        'SELECT acquisition_id FROM acquisition'));
end
%End of modification

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
if ~exist('option')
    option='NULL';
end

if ~exist('option2')
    option2='NULL';
end


if strcmp(RequestedAction,'ROOT')
    if ~Info.QAWindow;
        %QA.AcquisitionKeyList is replaced by 'acquisitionKeyList'
        %Modified by Song, 03/14/11
        % QA.AcquisitionKeyList=cell2mat(mxDatabase(Database.Name,'select acquisition_id from acquisition'));
        %End of modification
        QA.acquisitionKey=Info.AcquisitionKey;
        QA.figure=figure;

        %Retrieve QA codes from the database
        QA.codeDescription=mxDatabase(Database.Name,'select description,QAcode,Studies from QAcode order by AppearenceOrder');
        for index=size(QA.codeDescription):-1:1
            if strcmp(option2,'SPINE')
                if (QA.codeDescription{index,3}==1)
                    QA.codeDescription(index,:)=[];
                    endh
            else
                if (QA.codeDescription{index,3}==2)
                    QA.codeDescription(index,:)=[];
                end
            end
        end
        
        QA.numbercode=size(QA.codeDescription,1);
        
        %retrieve the QA status
        background=[0.1 0.1 0.4];
        foreground=[1 1 1];
    
        windowsizey=0.75;ratio=0.5/windowsizey;  %allow to change the window height without change the aspect of the stuff inside
        set(QA.figure,'units','normalized','position',[0.01 0.06 0.3 windowsizey],'NumberTitle','off','name','QA tools','deletefcn','QAreport(''DELETEFNC'');','color',background);
        set(QA.figure,'MenuBar','None');
    
        buttonyBeginning=0.85;separation=0.1*ratio;heightbox=0.03*ratio;
        buttonminx=0.01;buttonsizex=0.45;
        heightbutton=0.06*ratio;buttonsizex2=0.45;
        columnsItems=26;
        SizeColumn=0.40;
                
        %put the acquisition ID and the arrows for Post mode
        
        if ~strcmp(option2,'SPINE')
            QA.ctrlID=uicontrol('style','edit','units','normalized','string',num2str(QA.acquisitionKey),'position',[0.5,0.95,0.20,heightbox],'CallBack','QAreport(''CHANGEID'');');
        end
        if strcmp(option,'POST');
            QA.mode='POST';
            uicontrol('style','pushbutton','units','normalized','string','RETRIEVE','position',[0.5,0.95-2*heightbox,0.20,1.8*heightbox],'CallBack','QAreport(''RETRIEVEACQUISITION'');');
            uicontrol('style','text','string','Acquisition ID','units','normalized','position',[0.02,0.95,0.35,heightbox],'background',background,'foreground',foreground);
            uicontrol('style','pushbutton','string','<','units','normalized','position',[0.39,0.95,0.10,heightbox],'CallBack','QAreport(''CHANGEID'',''BEFORE'');','background',background);
            QA.ctrlID=uicontrol('style','edit','units','normalized','string',num2str(QA.acquisitionKey),'position',[0.5,0.95,0.20,heightbox],'CallBack','QAreport(''CHANGEID'');');
            uicontrol('style','pushbutton','string','>','units','normalized','position',[0.71,0.95,0.10,heightbox],'CallBack','QAreport(''CHANGEID'',''NEXT'');','background',background);
        else 
            QA.mode='NORMAL';
        end
        
        uicontrol('style','text','string','Quality assurance','units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);
        
        buttony=buttonyBeginning;
        QA.check=[];
        for index=1:QA.numbercode
            String=cell2mat(QA.codeDescription(index,1));
            indent=0.02*((QA.codeDescription{index,2}>=36)&&(QA.codeDescription{index,2}<=40));
            QA.check(index)=uicontrol('style','checkbox','string',String,'units','normalized','position',[buttonminx+indent,buttony,buttonsizex,heightbox],'background',background,'foreground',foreground);
            buttony=buttony-1.5*heightbox;
            if ~mod(index,columnsItems)
                buttonminx=buttonminx+SizeColumn;
                buttony=buttonyBeginning;
            end
        end            
        %OK
        buttony=buttony-2*heightbox;
        if ~strcmp(option2,'SPINE')
            uicontrol('style','pushbutton','string','OK / Save in database','units','normalized','position',[0.1,0.03,buttonsizex2,2*heightbox],'CallBack','global QA;QAreport(''SAVE'');if ~strcmp(QA.mode,''POST'') QAreport(''CLOSE'');end');
        end
        %SKIP
        if option=='POST';
            QA.ctrlSkip=uicontrol('style','check','string','SKIPPED SXA','enable','off','units','normalized','position',[0.65,0.03+2*heightbox,0.30,heightbox]);
            uicontrol('style','pushbutton','string','SKIP SXA','units','normalized','position',[0.65,0.03,0.30,2*heightbox],'CallBack','QAreport(''SKIPSXA'');');
        end
        QAreport('CHANGEID','NULL',option2);   
        Info.QAWindow=true;
    else
        figure(QA.figure);
        QA.acquisitionKey=Info.AcquisitionKey;
        try
            set(QA.ctrlID,'string',num2str(QA.acquisitionKey)); 
            QAreport('CHANGEID',option,option2);        
        end
    end
elseif strcmp(RequestedAction,'CHANGEID')
    if ~strcmp(option2,'SPINE')
%Replace QA.AcquisitionKeyList with persistent variable 'acquisitionKeyList'
%         if strcmp(option,'NULL')
%             [foe,QA.indexID]=min(abs(QA.AcquisitionKeyList-str2num(get(QA.ctrlID,'string'))));
%         elseif strcmp(option,'NEXT')
%             QA.indexID=min(QA.indexID+1,length(QA.AcquisitionKeyList));
%         elseif strcmp(option,'BEFORE')        
%             QA.indexID=max(QA.indexID-1,1);
%         end
%     QA.acquisitionKey=QA.AcquisitionKeyList(QA.indexID);

        if strcmp(option, 'NULL')
            [foe, QA.indexID] = min(abs(acquisitionKeyList - ...
                                        str2num(get(QA.ctrlID,'string'))));
        elseif strcmp(option, 'NEXT')
            QA.indexID = min(QA.indexID+1, length(acquisitionKeyList));
        elseif strcmp(option, 'BEFORE')        
            QA.indexID = max(QA.indexID-1, 1);
        end
    QA.acquisitionKey = acquisitionKeyList(QA.indexID);
%End of modification

    QAreport('RETRIEVE');
    QAreport('UPDATECHECK');
    end    
    
elseif strcmp(RequestedAction,'UPDATECHECK')    
    for index=1:QA.numbercode
            QAcodeNumber=cell2mat(QA.codeDescription(index,2));            
            set(QA.check(index),'value',QA.value(QAcodeNumber));
    end 
    try
        set(QA.ctrlID,'string',num2str(QA.acquisitionKey));
        set(QA.ctrlSkip,'value',QA.SkippedSXA)
    end
    
elseif strcmp(RequestedAction,'SAVE')
    if strcmp(option2,'SPINE')
         QA.acquisitionKey=funcFindNextAvailableKey(Database,'acquisition');
    end
    %delete the last QA code un the database that concern the open acquisiton
    %execute SQL command
    SQLstatement=['delete from QA_code_results where acquisition_ID=',num2str(QA.acquisitionKey)];
    mxDatabase(Database.Name,SQLstatement);
    for index=1:QA.numbercode
        if get(QA.check(index),'value')
            QAcodeNumber=cell2mat(QA.codeDescription(index,2));                                
            funcAddInDatabase(Database,'QA_code_results',[{num2str(QA.acquisitionKey)},{num2str(QAcodeNumber)},...
                {num2str(date)}, {num2str(datestr(now,13))}, {num2str(Info.ViewId)},...
                {num2str(Info.study_id)}, {num2str(Info.acqDate)}]);
        end
    end
    
    
elseif strcmp(RequestedAction,'CLOSE')
     close(QA.figure);  
     
elseif strcmp(RequestedAction,'RETRIEVE')
    %retrieve the state of the QA report
    SQLstatement=['select * from QA_code_results where acquisition_ID=',num2str(QA.acquisitionKey)];
    QAcodeFromDatabase=mxDatabase(Database.Name,SQLstatement); 
    %
% %      QAcodeFromDatabase=[QAcodeFromDatabase;0 0 0 0 0 0 0 0]; %to prevent empty QAcodeFromDatabase
    
    for index=1:QA.numbercode
        QAcodeNumber=cell2mat(QA.codeDescription(index,2));
        QA.value(QAcodeNumber)=(sum(cell2mat(QAcodeFromDatabase(:,3))==QAcodeNumber)>0);
    end
    QA.SkippedSXA=size(mxDatabase(Database.Name,['select * from SkippedSXAAnalysis where acquisitionID=''',num2str(QA.acquisitionKey),'''']),1)>0;
elseif strcmp(RequestedAction,'DELETEFNC')
    Info.QAWindow=false;
elseif strcmp(RequestedAction,'SKIPSXA')
    mxDatabase(Database.Name,['insert into SkippedSXAAnalysis values (''',num2str(QA.acquisitionKey),''',''',date,''',''',num2str(Info.Operator),''')']);
    QAreport('RETRIEVE');
    QAreport('UPDATECHECK');
elseif strcmp(RequestedAction,'RETRIEVEACQUISITION')
    set(ctrl.Cor,'value',false);
    Info.AcquisitionKey=QA.acquisitionKey;Database.Step=1;
    RetrieveInDatabase('ACQUISITION');
elseif strcmp(RequestedAction,'OPEN?')    
    answer=Info.QAWindow;
elseif strcmp(RequestedAction,'ERASEMARK')
       for index=1:QA.numbercode
           set(QA.check(index),'value',false);
       end
end
