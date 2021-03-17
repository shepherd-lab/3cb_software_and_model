%Lionel HERVE
%2-4-2004

function ReadTag=DrawTheReadTag(GlobalArray,Character,Size);
    %Draw the read Tag
    ZEROS=zeros(Size);
    ReadTag=zeros(Size);
    for index=1:size(GlobalArray,2)
        dirac=ZEROS;dirac(GlobalArray(4,index),GlobalArray(3,index))=1;
        k = cell2mat(Character.Image(GlobalArray(1,index)));
        p = conv2(dirac,k,'same');
    %    if size(ReadTag)==size(p)
            ReadTag=ReadTag+p;
     %   end
    end
