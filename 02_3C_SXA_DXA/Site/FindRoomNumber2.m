%findRoomNumber
%Lionel HERVE
%8-3-04
function [Room,Imagette,Marker,score]=FindRoomNumber2
global Image Error ThresholdedImage DEBUG;

Message('searching room number...');

MotifFileName='CPMCMarkersTopHat';
    
try 
    load(MotifFileName);
catch
    ListMotif={};
end

score=[];

SearchWindowSize=60;TagHeight=600;
try
for index=1:size(ListMotif,1)
    MotifImage=flipdim(flipdim(cell2mat(ListMotif(index,1)),1),2);
    ValidRightEdge=DetectImageEdge(Image.image,'RIGHT')-15;
    x1=min(max(1,cell2mat(ListMotif(index,2))-SearchWindowSize),ValidRightEdge);
    x2=min(x1+size(MotifImage,2)+2*SearchWindowSize,ValidRightEdge);
    y1=min(max(1,cell2mat(ListMotif(index,3))-1.5*SearchWindowSize),size(Image.image,1));
    y2=min(y1+size(MotifImage,1)+2.5*SearchWindowSize,size(Image.image,1)-TagHeight);
    ExtractedImage=Image.image(y1:y2,x1:x2);
    if (min(size(ExtractedImage,1),size(ExtractedImage,2))>=10)&&((ValidRightEdge-cell2mat(ListMotif(index,2)))<300)  %to mange little paddle / big paddle
        if DEBUG figure;imagesc(ExtractedImage);title('findRoomNumber2: Extracted Image (Original)');end
        ExtractedImage=Opening(ExtractedImage,3,'HORIZONTAL');
        if DEBUG figure;imagesc(ExtractedImage);title('findRoomNumber2: first filtration = horizontal opening to get rid of some vertical lines');end
        ThresholdedImage=TopHat2(ExtractedImage,floor(1.2*sum(sum(MotifImage))));
        if DEBUG figure;imagesc(ThresholdedImage);title('findRoomNumber2: After Top Hat'); end
        conv11=conv2(+ThresholdedImage,+MotifImage,'valid');
        conv00=conv2(1-ThresholdedImage,1-MotifImage,'valid');    
        toto=(2*conv11+conv00-prod(size(MotifImage)))/sum(sum(MotifImage==1));
        if sum(size(toto))>0   %in the case the extracted image is too little
            tempscore=max(max(toto));
        else
            tempscore=-100;
        end
        score(index,:)=[tempscore,cell2mat(ListMotif(index,4)),str2num(cell2mat(ListMotif(index,5)))];
    else
        score(index,:)=[-100,cell2mat(ListMotif(index,4)),str2num(cell2mat(ListMotif(index,5)))];
    end
end
if DEBUG==1 display(score);end

[ScoreMax,i]=max(score);i=i(1);
if (ScoreMax>-0.95) %considere the score is big enough to be sure the detection is correct
    MotifImage=cell2mat(ListMotif(i,1));
    x1=max(1,cell2mat(ListMotif(i,2))-SearchWindowSize);
    x2=min(x1+size(MotifImage,2)+2*SearchWindowSize,size(Image.image,2));
    y1=max(1,cell2mat(ListMotif(i,3))-SearchWindowSize);
    y2=min(y1+size(MotifImage,1)+2*SearchWindowSize,size(Image.image,1)-TagHeight);
    Imagette=Image.OriginalImage(y1:y2,x1:x2);
    Marker=cell2mat(ListMotif(i,5));
    Room=cell2mat(ListMotif(i,4));
else %Detection error
    Error.RoomDetection=true;
    [X,Y]=meshgrid(-50:50); %prepare image with a cross
    Imagette=(abs(X+Y)<10)|(abs(X-Y)<10);
    Marker=-1;
    Room=-1;
end

catch
   % lasterr
   errmsg = lasterr
   if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
     Error.RoomDetection=true;
    [X,Y]=meshgrid(-50:50); %prepare image with a cross
    Imagette=(abs(X+Y)<10)|(abs(X-Y)<10);
    Marker=-1;
    Room=-1;
     return;
   end
end