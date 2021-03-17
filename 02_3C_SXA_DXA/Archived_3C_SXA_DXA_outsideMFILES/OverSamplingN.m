function OutputImage=UnderSamplingN2(image,factor);

factor =1/factor;
if factor>1  || factor <1
    maxIndexX=floor(size(image,2)/factor);
    maxIndexY=floor(size(image,1)/factor);
    indexX=floor((1:maxIndexX)*factor+0.5);
    indexY=floor((1:maxIndexY)*factor+0.5);
    for index=0:0;
        tempImage(1,:,:)=image(indexY,:);
    end
    %tempImage=mean(tempImage);
    
    for index=0:0;
        OutputImage(1,:,:)=tempImage(1,:,indexX);
    end
    %OutputImage=mean(OutputImage);
    OutputImage=squeeze(OutputImage(1,:,:));
else
    OutputImage=image;
   
end