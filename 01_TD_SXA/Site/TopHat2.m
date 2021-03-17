function result=TopHat2(image,param)
if ~exist('param')
    param=0;
end


    signal=[];
    Imagette=[];

    
    %first take median value
    WindowSizeX=2;
    WindowSizeY=2;
    for dx=-WindowSizeX:WindowSizeX
        for dy=-WindowSizeY:WindowSizeY
            index=(dy+WindowSizeY)*(WindowSizeX*2+1)+dx+WindowSizeX+1;
            tempImage=+image(dy+WindowSizeY+1:end+dy-WindowSizeY,dx+WindowSizeX+1:end+dx-WindowSizeX);
            tempImage(end+1:end+2*WindowSizeY,:)=2^16;%add some borders
            tempImage(:,end+1:end+2*WindowSizeX)=2^16;%add some borders
            tempImage=circshift(tempImage,[WindowSizeY WindowSizeX]);
            Imagette(index,:,:)=tempImage;
            signal(index,:)=squeeze(reshape(tempImage,1,prod(size(tempImage))));
        end
    end
    signal=median(signal);
    image=reshape(signal,size(image,1),size(image,2));
    
    %second take top hat
    WindowSizeX=2;
    WindowSizeY=2;
    for dx=-WindowSizeX:WindowSizeX
        for dy=-WindowSizeY:WindowSizeY
            index=(dy+WindowSizeY)*(WindowSizeX*2+1)+dx+WindowSizeX+1;
            tempImage=+image(dy+WindowSizeY+1:end+dy-WindowSizeY,dx+WindowSizeX+1:end+dx-WindowSizeX);
            tempImage(end+1:end+2*WindowSizeY,:)=2^16;%add some borders
            tempImage(:,end+1:end+2*WindowSizeX)=2^16;%add some borders
            tempImage=circshift(tempImage,[WindowSizeY WindowSizeX]);
            Imagette(index,:,:)=tempImage;
            signal(index,:)=squeeze(reshape(tempImage,1,prod(size(tempImage))));
        end
    end
    MainImage=squeeze(Imagette((size(Imagette,1)+1)/2,:,:));
    TotalSize=prod(size(MainImage));
    signalMain=squeeze(reshape(MainImage,1,TotalSize));
    signal=(signalMain-min(signal));
    
    if (param>0)&(param<2000)
        SortSignal=sort(signal);
        threshold=SortSignal(end-param-1);
    else
        threshold=param;
    end
    
    signal=signal>threshold;
    result=reshape(signal,size(image,1),size(image,2));
       
    
    