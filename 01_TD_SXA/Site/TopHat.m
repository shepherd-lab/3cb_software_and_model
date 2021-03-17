%TOP HAT FILTER
% Lionel HERVE
% oct 2004
%syntax : TopHat(Image)
% or TopHat(Image,'KERNEL',ones(1,3))

function result=TopHat(image,varargin)
signal=[];
Imagette=[];


WindowSizeX=2;WindowSizeY=2;
for index=1:(length(varargin)/2)
    if strcmp(varargin{index*2-1},'KERNEL')
        KernelSIZE=size(varargin{index*2});
        WindowSizeX=KernelSIZE(2);
        WindowSizeY=KernelSIZE(1);
    end

end

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
result=reshape(signal,size(image,1),size(image,2));


