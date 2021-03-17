%%% DatabaseMain
% gui for the Database
%author Lionel HERVE
%creation date 5-8-2003

function databasemain(action,Select);
global ctrl Table Database file
%#function funcshowtable


switch action
case 'ROOT'
    try 
        close (f1.handle);
    end
    
    Database.Table='';
    f1.handle=figure('DeleteFcn','global f1;f1.handle=[];');
    set(f1.handle,'name','Database');
    set(f1.handle,'units','normalized','position',[0.0 0.02 1.0 0.92]);

    %draw the table
    ctrl.Tabular = uicontrol('Style','listbox','units','normalized',...
        'Position',[0.01 0.1 0.98 0.85],...
        'BackgroundColor','white',...
        'Max',1,'Min',1,'FontName','FixedWidth'); 
    uicontrol('style','text','string','Jump to','units','normalized','Position',[0.0 0.05 0.05 0.02],'background',[0.8 0.8 0.8]);
    ctrl.jump=uicontrol('style','edit','string','','units','normalized','Position',[0.05 0.05 0.05 0.02],'callback','DatabaseTableJump');

    %retrieve the names of the tables 
    set(f1.handle,'MenuBar','None');
        f1.menu.Database = uimenu('Label','Table');

    Table={'acquisition','analysistype','BasicImageOperation','BIRADSdescription','BIRADSresults','ChestWall','ChestWallInfo','CancerStatus','Comment_results','Comment','commonanalysis','correction','digitizer','FileOnExternalDrive','FileOnInternalDrive','freeformanalysis','freeforms','machine','mammo_view','manualedge','manualthresholdanalysis','operator','OtherSXAinfo','peripheral_analysis','phantom','QAcode','QA_code_results','Reposition','SkippedSXAAnalysis','StructuralAnalysis','sxaanalysis','sxastepanalysis','TagInformation','technique','thresholdAnalysis'};
    %put the names in the menu
    for index=1:size(Table,2)
         uimenu(f1.menu.Database,'Label',cell2mat(Table(index)),'callback',['DataBaseMain(''SHOWTABLE'',',num2str(index),')']);    
    end
    f1.menu.Database = uimenu('Label','Action');    
         uimenu(f1.menu.Database,'Label','Delete an entry','callback','DataBaseMain(''DELETEENENTRIE'',0)');            
         uimenu(f1.menu.Database,'Label','Delete all analyses linked to an acquisition','callback','deleteAnalyses','enable','off');                 
         uimenu(f1.menu.Database,'Label','Find the whole database dead links','callback','FindDeadLinks','enable','off');                 
case 'SHOWTABLE'
    Database.Table=cell2mat(Table(Select));
    Database.content=funcShowTable(Database,Database.Table,ctrl.Tabular);
    set(ctrl.Tabular,'value',3,'ListboxTop',1);
case 'DELETEENENTRIE'
    line=get(ctrl.Tabular,'value');
    if (line >2) 
        funcDeleteAnEntrie(Database,line-2);
        set(ctrl.Tabular,'value',line-1);
        Database.content=funcShowTable(Database,Database.Table,ctrl.Tabular);
    end
end