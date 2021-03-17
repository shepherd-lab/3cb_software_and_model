function OutputImage=UnderSamplingN(image,factor);

if factor>1
    maxIndexX=floor(size(image,2)/factor)-1;
    maxIndexY=floor(size(image,1)/factor)-1;
    indexX=floor((1:maxIndexX)*factor);
    indexY=floor((1:maxIndexY)*factor);
    for index=0:factor-1;
        tempImage(index+1,:,:)=image(indexY+index,:);
    end
    tempImage=mean(tempImage);
    
    for index=0:factor-1;
        OutputImage(index+1,:,:)=tempImage(1,:,indexX+index);
    end
    OutputImage=mean(OutputImage);
    OutputImage=squeeze(OutputImage(1,:,:));
else
    OutputImage=image;
   
end