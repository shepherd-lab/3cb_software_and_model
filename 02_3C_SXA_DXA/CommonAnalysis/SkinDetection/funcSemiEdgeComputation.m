%semiedgeComputation
%file used by skin detection. It compute point of a curve when x is always
%increasing by one
%author Lionel HERVE   (see p91lh1)
%creation date 5-13-03    

function Outline=FuncSemiEdgeComputation(xy)
    
    [C,I]=max(xy(:,1));
    savex=xy(1,1);
    currentindex=1;
    saveindex=currentindex;
    indexResult=1;    
    Outline(indexResult,1)=savex;
    Outline(indexResult,2)=xy(currentindex,2);
    while savex<C
        while xy(currentindex,1)<=savex
            currentindex=currentindex+1;            
        end
        Outline(indexResult+1:indexResult+xy(currentindex,1)-savex,1)=[savex+1:xy(currentindex,1)]';
        Outline(indexResult+1:indexResult+xy(currentindex,1)-savex,2)=[1:xy(currentindex,1)-savex]'/(xy(currentindex,1)-savex)*(xy(currentindex,2)-xy(saveindex,2))+xy(saveindex,2);
        indexResult=indexResult+xy(currentindex,1)-savex;         
        saveindex=currentindex;
        savex=Outline(indexResult,1);
        currentindex=currentindex+1;
    end
