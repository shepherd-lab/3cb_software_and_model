%set the conflict when more than one character is at the same position
% Lionel HERVE
% 2-11-04

function GlobalArray3=SetConflicts(GlobalArray,Character)

    %%Add the size of the characters in GlobalArray
    for index=1:size(GlobalArray,2)
        GlobalArray(5,index)=size(cell2mat(Character.Image(GlobalArray(1,index))),2);
    end

    %sort Global array in descending order of the power
    [GlobalArray2,Indexes]=sort(GlobalArray,2);
    GlobalArray2=GlobalArray(:,Indexes(2,:));
    GlobalArray2=flipdim(GlobalArray2,2);  
    
    %erase conflict numbers of the lowest power
    GlobalArray3=[];
    while size(GlobalArray2,2)
        GlobalArray3=[GlobalArray3,GlobalArray2(:,1)];  %the most powerfull character is selected
        %now, see if there was some other character around it.
        
        sizePattern=size(cell2mat(Character.Image(GlobalArray2(1,1))),2);
        ConflictXlist=((GlobalArray2(3,:)+GlobalArray2(5,:)/2-3)>(GlobalArray2(3,1)-sizePattern/2))&((GlobalArray2(3,:)-GlobalArray2(5,:)/2)<(GlobalArray2(3,1)+sizePattern/2-3));
        %remove the confict numbers
        for index=size(GlobalArray2,2):-1:1
            if ConflictXlist(index)==1
                GlobalArray2(:,index)=[];
            end
        end
    end
