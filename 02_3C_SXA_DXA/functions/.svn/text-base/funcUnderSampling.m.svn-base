%undersampling
%Author Lionel HERVE
%date 5-2-03
%modification
%9-24-03
%do a filtration

function tempimage2=funcUnderSampling(OriginalImage);

[rows,columns]=size(OriginalImage);
tempimage(ceil(rows/2)-1,columns)=0;
for y=1:ceil(rows/2)-1
     tempimage(y,:)=(OriginalImage(2*y,:)+OriginalImage(2*y-1,:))/2;
end

tempimage2(ceil(rows/2)-1,ceil(columns/2)-1)=0;
for x=1:ceil(columns/2)-1
    tempimage2(:,x)=(tempimage(:,2*x)+tempimage(:,2*x-1))/2;
end
