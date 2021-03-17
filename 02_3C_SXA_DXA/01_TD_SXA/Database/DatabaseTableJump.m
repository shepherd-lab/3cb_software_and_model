function DatabaseTableJump
%Lionel HERVE
%12-21-04
% request from David:
% make the user be able to jump in the tables

global ctrl Database

ID=get(ctrl.jump,'string');
if str2num(ID)>0
    [mini,LINE]=min(abs(cell2mat(Database.content(:,1))-str2num(ID)));
    set(ctrl.Tabular,'ListboxTop',LINE);
end