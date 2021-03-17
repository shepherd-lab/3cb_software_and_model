%LIONEL HERVE
%2-10-04

% table
% 1 . 1  -->  1
% 0 . 0  -->  1
% 1 . 0  --> -1
% 0 . 1  --> -1

%modification
%2-11-04: problem with 3 8 9, use a mask to weight on particular part of
%these characters
function [resultArrayX,resultArrayY,PowerArray]=findCharacter(TAG,Character,index,OPTION);

Figure=cell2mat(Character.Image(index));
%imagesc(Figure);
Mask=cell2mat(Character.Mask(index));
%figure;
%imagesc(Mask);
resultArrayX=[];
resultArrayY=[];
PowerArray=[];

tempFigure=rot90(rot90(Figure));   %correlation is the convolution after rotating the matrix
%figure;
%imagesc(tempFigure);

tempMask=rot90(rot90(Mask));
%figure;
%imagesc(tempMask);


signal=conv2(TAG,tempFigure.*tempMask,'same')/sum(sum(tempFigure.*tempMask))...
    +conv2(1-TAG,(1-tempFigure).*tempMask,'same')/sum(sum((1-tempFigure).*tempMask))...
    -conv2(1-TAG,tempFigure.*tempMask,'same')/sum(sum(tempFigure.*tempMask))...
    -conv2(TAG,(1-tempFigure).*tempMask,'same')/sum(sum((1-tempFigure).*tempMask));

if ~(exist('OPTION')&&strcmp(OPTION,'unique'))
    signalThesholded=signal>1.0; 
else 
    signalThesholded=(signal==max(max(signal)));
end
resultImage=zeros(size(TAG));
ZERO=zeros(size(TAG));

flagcontinue=true;
while (max(max(signalThesholded))~=0)&&flagcontinue
    [maxi,x]=max(max(signal));
    PowerArray=[PowerArray,maxi];
    [maxi,y]=max(signal(:,x));
    if mod(size(Figure,1),2)
        y=y+1;
    end
    if ~mod(size(Figure,2),2)
        x=x+1;
    end
    
    resultArrayX=[resultArrayX,x];
    resultArrayY=[resultArrayY,y];    
    
    %empty region around the dirac for next maximum detection
    HalfSizePattern=floor(size(Figure,2)/2);
    signal(max(y-13,1):min(y+13,size(TAG,1)),max(x-HalfSizePattern,1):min(x+HalfSizePattern,size(TAG,2)))=0;
    signalThesholded=signal>1.0;
    
    if exist('OPTION')&&strcmp(OPTION,'unique')
            flagcontinue=false;
    end
    
end
