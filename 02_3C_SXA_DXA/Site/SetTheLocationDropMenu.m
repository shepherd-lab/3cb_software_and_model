%set the drop menu in the upper right corner of the GUI to the right
%position. 
% example SetTheLocationDropMenu(4) --> search from CPMC#4

function SetTheLocationDropMenu(Room)

global Site ctrl

String=get(ctrl.Center,'string');
SeekedString=[Site.Name,'#',num2str(Room)];
for index=1:size(String,1)
   if strncmpi(String{index},SeekedString,length(SeekedString))
       set(ctrl.Center,'value',index);
   end
end

