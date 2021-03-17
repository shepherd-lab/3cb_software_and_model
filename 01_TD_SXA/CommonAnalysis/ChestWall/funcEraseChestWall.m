%Lionel HERVE
%11-9-04

function funcEraseChestWall

global ChestWallData;
ChestWallData.Curve=[];
ChestWallData.Valid=0;
ChestWallData.xy=[];
try 
    delete(ChestWallData.handle);
end

