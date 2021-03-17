% AskPasswrd;
%author Lionel HERVE
%creation date 6-23-2003
function ok=AskPassword(Info,key);

ok=false;
if size(key.message,2)>0
    if (Info.Operator==4)
        if prod(double(key.message).*[1:size(key.message,2)])==1.559705466654720e+017
            ok=true;    
        end
    elseif (Info.Operator==2)
        if prod(double(key.message).*[1:size(key.message,2)])==1.051265376403200e+015
            ok=true;    
        end
    elseif (Info.Operator==5)
        if prod(double(key.message).*[1:size(key.message,2)])==1.213180325280000e+015
            ok=true;    
        end
    elseif (Info.Operator==7)
        if prod(double(key.message).*[1:size(key.message,2)])==146941200
            ok=true;    
        end
    else 
        ok=true;    
    end
end


key.message='';