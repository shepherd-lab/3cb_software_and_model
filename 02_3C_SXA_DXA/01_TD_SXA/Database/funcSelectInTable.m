function selection=funcSelectInTable(table,msg,default_line,varargin);
% the normal way to use this function
% example: Info.Operator=cell2mat(funcSelectInTable('operator','Who are you?',1));
% other way (example from charcaterrecognition):
% CharacterList={0,'Choice';'0','';'1','1';'2','2';'3','3';'4','4';'5','5';'6','6';'7','7';'8,''8';'9,''9';'10','0';'11','mAs';'12','kVp';'13','MO/MO';'14','mm';'15','MO/RH';'16','LF';'17','RH/RH';'18','daN'};
% selection=cell2mat(funcSelectInTable(CharacterList(:,2),'Which character do you want to define',0));

global Select Order DatabaseEvent Select ctrl f1 Database
%#function setdatabaseevent

try close(f1.handle);end %close possible window with the same handle

DatabaseEvent=uicontrol('style','checkbox','visible','off','value',false);  %to send some event

Order='AcqID';

if size(varargin,2)>0
    if strcmp(cell2mat(varargin(1)),'Cancel')
        CancelButton=true;
    end
else
    CancelButton=false;
end

%draw the asked table
f1.handle=figure;
set(f1.handle,'name',msg);
set(f1.handle,'units','normalized','position',[0.1 0.3 0.8 0.4]);
ctrl.Tabular = uicontrol('Style','listbox','units','normalized',...
    'Position',[0.1 0.2 0.8 0.7],...
    'BackgroundColor','white',...
    'Max',50,'Min',1,'FontName','FixedWidth');

set(f1.handle,'MenuBar','None');
ctrl.ok=uicontrol('style','pushbutton','string','OK','units','normalized','Position',[0.8 0.05 0.1 0.1],'callback','SetDatabaseEvent(1,1);');
uicontrol('style','text','string','Jump to','units','normalized','Position',[0.0 0.05 0.05 0.02],'background',[0.8 0.8 0.8]);
ctrl.jump=uicontrol('style','edit','string','','units','normalized','Position',[0.05 0.05 0.05 0.02],'callback','DatabaseTableJump');

if iscell(table)
    set(ctrl.Tabular,'string',table);
    Database.content=num2cell([1:size(table,1)]');
else %particular case retrieveAcq, RetrieveCommonAnalysis
    if strcmp(table,'retrieveAcq')|strcmp(table,'RetrieveCommonAnalysis')|strcmp(table,'Retrievefreeformanalysis')|strcmp(table,'RetrieveSXAanalysis')|strcmp(table,'RetrieveSXAStepanalysis')|strcmp(table,'RetrieveManualThresholdanalysis')|strcmp(table,'RetrieveThresholdanalysis')|strcmp(table,'StudySelect')|strcmpi(table,'FileOnInternalDrive')
        if strcmp(table,'retrieveAcq')
            [Database.content,names]=funcPopulateResume(Database,ctrl.Tabular,table,Order);
            if CancelButton
                ctrl.toggle=uicontrol('style','pushbutton','string',['Order:',Order],'units','normalized','Position',[0.6 0.01 0.08 0.08],'callback','SetDatabaseEvent(1,2);');
            end
        else
            [Database.content,names]=funcPopulateResume(Database,ctrl.Tabular,table);
        end
        if ~strcmp(table,'StudySelect')
            set(f1.handle,'units','normalized','position',[0.0 0 1 1]);
        end
        set(ctrl.Tabular,'position',[0.02 0.1 0.96 0.88]);
        set(ctrl.ok,'Position',[0.8 0.01 0.08 0.08]);
        if CancelButton
            ctrl.cancel=uicontrol('style','pushbutton','string','Cancel','units','normalized','Position',[0.9 0.01 0.08 0.08],'callback','SetDatabaseEvent(1,0);');
        end
    else
        Database.content=funcShowTable(Database,table,ctrl.Tabular);
    end;
end

%choose the default_line of selection
if default_line~=0
    set(ctrl.Tabular,'value',default_line+2);
end

%management of ok button  --- check the selection
flagContinue=true;
while flagContinue
    waitfor(DatabaseEvent,'value',true)
    set(DatabaseEvent,'value',false);
    if Select==1   %OK pressed
        line=get(ctrl.Tabular,'value')-2;
        if line>0
            flagContinue=false;
            %return the primary key of the selection
            selection={};
            for index=line
                if ischar(cell2mat(Database.content(index,1)))
                    selection=[selection;{str2num(cell2mat(Database.content(index,1)))}];
                else
                    selection=[selection;{cell2mat(Database.content(index,1))}];
                end
            end
        end
    elseif Select==2    %Toggle Pressed
        if strcmp(Order,'PatientID')
            Order='ContourAnalysisDate';
        elseif strcmp(Order,'ContourAnalysisDate')
            Order='AcqID';
        else
            Order='PatientID';
        end
        set(ctrl.toggle,'string',['Order:',Order]);
        if strcmp(Order,'ContourAnalysisDate')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %sort by ContourAnalysisDate and conserve study order
            % if toogle button is pressed
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Data=Database.content(:,8);  %column wontaining the contour analysis date
            indexes=find(~strcmp(Data,'NULL       '));
            Date=zeros(size(Data,1),1);
            Date(indexes)=datenum(Data(indexes)); 
            %sort by date first and then by study id
            [foe,index]=sort(Date);
            Database.content=Database.content(flipdim(index,1),:);
            [foe,index]=sort(Database.content(:,2));
            Database.content=Database.content(index,:);
        elseif strcmp(Order,'PatientID')
            [foe,index]=sort(Database.content(:,6));   %order =study_ID,patient_ID,view_id
            Database.content=Database.content(index,:);
            [foe,index]=sort(Database.content(:,3));
            Database.content=Database.content(index,:);
            [foe,index]=sort(Database.content(:,2));
            Database.content=Database.content(index,:);
        elseif strcmp(Order,'AcqID')
            [foe,index]=sort(cell2mat(Database.content(:,1)));   %order =study_ID,patient_ID,view_id
            Database.content=Database.content(index,:);
        end
        UpdateListBox(ctrl.Tabular,Database.content,names);
    else  %Cancel Pressed
        flagContinue=false;
        selection={0};
    end
end
close(f1.handle);f1.handle=[];
clear Database.content;
drawnow;