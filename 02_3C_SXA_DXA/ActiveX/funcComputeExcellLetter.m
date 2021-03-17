function Letter=funcComputeExcellLetter(k);
%compute the columns in excell way (26=Z 27=AA)

firstLetter=floor((k-1)/26);
secondLetter=char(64+mod(k-1,26)+1);

if firstLetter==0
    Letter=secondLetter;
else
    Letter=[char(64+firstLetter),secondLetter];
end



