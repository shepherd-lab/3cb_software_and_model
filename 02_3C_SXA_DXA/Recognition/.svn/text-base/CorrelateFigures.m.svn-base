%Do the correlation of the TAG with the number images
% Lionel HERVE
%2-11-4

function GlobalArray=CorrelateFigures(GlobalArray,Character,Image)
    for index=1:10
        [ArrayX,ArrayY,Power]=findCharacter(Image,Character,index);
        label=ones(size(Power)).*index;
        GlobalArray=[GlobalArray,[label;Power;ArrayX;ArrayY]];    
    end
