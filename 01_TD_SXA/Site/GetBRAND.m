function BRAND=GetBRAND(Info);

%compute the brand of the mammography machine. 
%Some consequences:
%   -in the case of lorad: we oberse a big border effect on big images.
%    So, the phantom must not include this zone. 
%   -the size measured on the tag change a lot between GE and lorad

global ctrl Site

machineID=get(ctrl.Center,'value');
Room=Site.RoomTable(find(Site.RoomTable(:,2)==machineID),1);

if strcmp(deblank(Info.StudyID),'CPUCSF')
    if (Room==2)||(Room==1)||(Room==4)
        BRAND=1;
    else 
        BRAND=2;
    end
end