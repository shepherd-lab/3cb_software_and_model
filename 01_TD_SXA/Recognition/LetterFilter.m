%filter for the charcater recognition
%try to just highligh the letters

function [Tag,OriginalTag]=LetterFilter(image, Brand);

method=2;

UnderSamplingFactor=4;
TagSizeX=450;
TagSizeY=100;

%im1 = image(end-600:end,end-200:end);
%figure;
%imagesc(im1); colormap(gray);

tempImage=rot90(flipdim(image(end-600:end,end-200:end),1));
%figure;
%imagesc(tempImage); colormap(gray);


%search the tag in the region
tempImage2=edge(tempImage,'log');

%find where there are a lot of border in the bottom right corner
tempImage3=UnderSamplingN(tempImage2,UnderSamplingFactor);
tempImage3=conv2(tempImage3,ones(round(TagSizeY/UnderSamplingFactor),round(TagSizeX/UnderSamplingFactor)),'valid');
[maxiY,posY]=max(tempImage3);
[maxiX,posX]=max(maxiY);

posY=posY(posX)*UnderSamplingFactor;
posX=posX*UnderSamplingFactor;

SecurityBorder=10;
Y1=max(posY-SecurityBorder,1);
Y2=min(posY+TagSizeY+SecurityBorder,size(tempImage,1));
X1=max(posX-SecurityBorder,1);
X2=min(posX+TagSizeX+SecurityBorder,size(tempImage,2));
tempImage=tempImage(Y1:Y2,X1:X2);
OriginalTag=tempImage;

if method==1
    tempImage=TopHat(tempImage);

    tempImage2=edge(tempImage,'log');

    Threshold=0;
    for dx=-1:1
        for dy=-1:1
            FoeImage=circshift(tempImage,[dy,dx]).*tempImage2;
            Threshold=Threshold+sum(sum(FoeImage))/sum(sum(tempImage2));
            %figure;imagesc(FoeImage);colormap(gray)
        end
    end
   Threshold=Threshold/9+1000;
   Tag=+(tempImage>Threshold);
else
    if Brand == 1
      % tempImage =  +(tempImage> 56500);
       A = uint8(OriginalTag/256);
       %figure;imhist(A);
       [counts,x] = imhist(A);
       hdata = [counts x];
       htemp = hdata((hdata(:,2)<235&hdata(:,2)>100),:);
      %yy = smooth(htemp(:,1),15,'moving');
       yy = htemp(:,1);
       xx = htemp(:,2);
       fresult = gauss_fit(xx,yy)
       %yy = uint16(yy);
       %ym = max(yy)
       %szc = size(yy)
       %szx = size(htemp)
      % figure;
       %plot(htemp(:,2), yy, 'bo'); hold on;
       %plot(fresult,'fit',0.95);
      % index = find(yy==max(yy)) + 7;
      % h_index = htemp(index(1),2)
      h_index = fresult.b1% + 5;
      % h_index = 160
      h_edge = h_index/255 ;
       J = imadjust(A,[h_edge 1], [0 1]);
       %figure;
       %imagesc(J); colormap(gray);
       Tag = (J > 70);
       Tag = double(Tag);
       Tag=TopHat(Tag,'KERNEL',ones(2,6));
    end
    %tempImage5=TopHat(tempImage,'KERNEL',ones(1,3));
    %tempImage6=TopHat(tempImage,'KERNEL',ones(1,4));
    %tempImage7=TopHat(tempImage,'KERNEL',ones(1,5));
    %tempImage=TopHat(tempImage,'KERNEL',ones(1,3));
     
    %colormap(gray);
    %tempImage =  +(tempImage> 10000);
    tempImage2=edge(tempImage,'log');

    Threshold=0;
    for dx=-1:1
        for dy=-1:1
            FoeImage=circshift(tempImage,[dy,dx]).*tempImage2;
            Threshold=Threshold+sum(sum(FoeImage))/sum(sum(tempImage2));
        end
    end
    Threshold=Threshold/9+1000;
  %  Threshold = 55500;
 % tempImage =  +(tempImage> 56500);
 % se = strel('square',1);
    %se = strel('disk',1);
    if Brand == 1
     ;% Tag = imdilate(tempImage,se);  %tempImage;
    else
     Tag=+(tempImage>Threshold);
    % figure;
    % imagesc(Tag); colormap(gray);
      end
end