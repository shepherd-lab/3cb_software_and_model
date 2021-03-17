function [NewA,NewB,mixture]=Match(A,B)

%Lionel HERVE
%9-29-04
%match A and B respective to their first column. 
%A and B are supposed to be ordered respectively to this column.

ok=true;
index=1;
while ok
    if A(index)<B(index)
        A(index,:)=[];
    elseif A(index)>B(index)
        B(index,:)=[];
    else
        index=index+1;
    end
    if (index>size(A,1))|(index>size(B,1))
        ok=false;
        if (index<=size(A,1))
            A(index:end,:)=[];
        else (index<=size(B,1))
            B(index:end,:)=[];
        end
    end
end

NewA=A;
NewB=B;
mixture=[A,B(:,2:end)];
