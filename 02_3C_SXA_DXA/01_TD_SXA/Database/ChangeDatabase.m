%ChangeDatabase
%Lionel HERVE
%4-7-04

function ChangeDatabase(Choice)
global Database f0 data Info ctrl

if Info.Database
    Database.Name=cell2mat(Database.Choice(Choice));
    for index=1:size(Database.Choice,2)
        if Choice==index
            set(f0.menuDatabaseChangeMenus(index),'checked','on');
        else
            set(f0.menuDatabaseChangeMenus(index),'checked','off');
        end
    end

    %data.study=mxDatabase(Database.Name,'select distinct study_id from acquisition order by study_id'); %different study present in database
    data.centerlistname=mxDatabase(Database.Name,'select location,machine_id from machine');     %retrieve data centerlist names
    data.technique=mxDatabase(Database.Name,'select technique_description,technique_id from technique');  %retrieve data technique names
    data.operator=mxDatabase(Database.Name,'select * from operator'); %retrieve data operator names
    data.view=mxDatabase(Database.Name,'select view_description,mammoview_id from mammo_view'); %retrieve view names
    data.phantom=mxDatabase(Database.Name,'select phantom_description,phantom_id from phantom'); %retrieve the list of the phantoms
    data.digitizer=mxDatabase(Database.Name,'select digitizer.internal_name,digitizer_id from digitizer'); %retrieve the list of the digitizers
else
    data.technique=[{'Mo/Mo','1'}];
    data.centerlistname=[{'Nowhere','1'}];
end

set(ctrl.technique,'string',data.technique(:,1),'value',Info.technique);
set(ctrl.Center ,'String',data.centerlistname(:,1)); 