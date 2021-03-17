%findRoomNumber
%Lionel HERVE
%8-3-04
global Image
MotifFileName='CPMCMarkers';
    
try 
    load(MotifFileName);
catch
    ListMotif={};
end

score=[];

for index=1:size(ListMotif,1)
    SearchWindowSize=100;
    MotifImage=flipdim(flipdim(cell2mat(ListMotif(index,1)),1),2);
    x1=max(1,cell2mat(ListMotif(index,2))-SearchWindowSize);
    x2=min(x1+size(MotifImage,2)+2*SearchWindowSize,size(Image.image,2));
    y1=max(1,cell2mat(ListMotif(index,3))-SearchWindowSize);
    y2=min(y1+size(MotifImage,1)+2*SearchWindowSize,size(Image.image,1));
    LittleImage=Image.image(y1:y2,x1:x2);
    CurrentThreshold=LeadMarkerThreshold(LittleImage);
    ThresholdedImage=+LittleImage>CurrentThreshold;
    conv11=conv2(+ThresholdedImage,+MotifImage,'valid');
    conv00=conv2(1-ThresholdedImage,1-MotifImage,'valid');    
    toto=(2*conv11+conv00-prod(size(MotifImage)))/sum(sum(MotifImage==1));

    if (0)
        f1=figure('units','normalized','position',[0 0 0.5 0.25]);
        axes('units','normalized','position',[0.05 0 0.4 0.95]);surf(toto,'EdgeColor','none');set(gca,'zlim',[-3 1]);
        axes('units','normalized','position',[0.5 0 0.5 1]);image(MotifImage*64);
    end
    
    score(index)=max(max(toto));
end

[foe,i]=max(score);
Room=cell2mat(ListMotif(i,4));