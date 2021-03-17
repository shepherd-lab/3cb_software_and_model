%lionel HERVE
%12-10-04

%show the result of a SQL query on a window. The advantage is to see the
%title. 
%example:
% funcShowSQLinTable('select * from commonanalysis,sxaanalysis where acquisition_id=2800 and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id')

function [OutputContent,OutputTitle]=funcShowSQLinTable(SQLCommand)
global Database

[Database.content,Database.names]=mxDatabase(Database.Name,SQLCommand);
OutputContent=Database.content;
OutputTitle=Database.names;

if size(Database.content,1)>0
    content=funcconverttostring(Database.content);
else
    content(1,1:size(Database.content,2))={'No Data'}
end

for index=1:size(Database.names,2)
    Field(1,index)=Database.names(index);    %name of the column
    if size(content,1)>0
        FieldSize=size(cell2mat(content(1,index)),2); %width of the column
    else
        FieldSize=1;
    end
    Field(2,index)={max(size(cell2mat(Field(1,index)),2),FieldSize)+1};   %size of the column
end

%draw the legend
textstring(1,:)=funcConcatenateString(Field);
title=Field(1,:);

%draw the selection tabular
temptextstring='';
for index=1:size(content,2)
    text=char(content(:,index));
    sizeBefore=size(temptextstring,2);
    temptextstring=[temptextstring,text,char(ones(size(content,1),cell2mat(Field(2,index))-size(text,2))*' ')];
    sizeAfter=size(temptextstring,2);
end
textstring(3:2+size(temptextstring,1),:)=temptextstring;


%%draw the result

windowhandle=figure;
set(windowhandle,'units','normalized','position',[0.1 0.3 0.8 0.4]);
ctrl.Tabular = uicontrol('Style','listbox','units','normalized',...
    'Position',[0.1 0.2 0.8 0.7],...
    'BackgroundColor','white',...
    'Max',50,'Min',1,'FontName','FixedWidth');

set(windowhandle,'MenuBar','None');

set(ctrl.Tabular,'string',textstring);