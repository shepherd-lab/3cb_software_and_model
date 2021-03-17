%funcShowResume
%organize the result in some proper tables

function funcShowResume(table,msg);
global Database

%draw the asked table
windowhandle=figure;
set(windowhandle,'name',msg);
set(windowhandle,'units','normalized','position',[0.1 0.3 0.8 0.4]);
ctrl.Tabular = uicontrol('Style','listbox','units','normalized',...
    'Position',[0.1 0.2 0.8 0.7],...
    'BackgroundColor','white',...
    'Max',1,'Min',1,'FontName','FixedWidth'); 

set(windowhandle,'MenuBar','None');
set(windowhandle,'units','normalized','position',[0.0 0 1 1]);
set(ctrl.Tabular,'position',[0.02 0.1 0.96 0.88]);

%resume table
[content,columntitle]=funcPopulateResume(Database,ctrl.Tabular,table);

%management of Save/Cancel buttons
global ExcelCopie dummyuicontrol2
ctrl.ok=uicontrol('style','pushbutton','string','Save in Excel','units','normalized','Position',[0.8 0.02 0.08 0.06],'callback','buttoncancelsaveinexcel(1)');
ctrl.Cancel=uicontrol('style','pushbutton','string','Cancel','units','normalized','Position',[0.9 0.02 0.08 0.06],'callback','buttoncancelsaveinexcel(0);');    
%check the selection


set(dummyuicontrol2,'value',false);
waitfor(dummyuicontrol2,'value',true)

if ExcelCopie
    Excel('INIT');
    Excel('TRANSFERT',content,columntitle);
end

close(windowhandle);
