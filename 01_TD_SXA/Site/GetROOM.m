function ROOM=GetROOM(Info);

%compute the brand of the mammography machine. 
%Some consequences:
%   -in the case of lorad: we oberse a big border effect on big images.
%    So, the phantom must not include this zone. 
%   -the size measured on the tag change a lot between GE and lorad

global ctrl Site

machineID=get(ctrl.Center,'value');
ROOM=Site.RoomTable(find(Site.RoomTable(:,2)==machineID),1);
