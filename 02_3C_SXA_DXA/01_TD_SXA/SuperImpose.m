%SuperImpose
function SuperImpose(Image1,Image2)

f=figure;imagesc(Image1);colormap(gray);
while (1)
    [x,y] = ginput(1);
    x=floor(x);y=floor(y);
    if (x>size(Image1,2))|(y>size(Image1,1))
        break;
    end
    displayedImage=+Image1;
    dx=min(size(Image2,2),size(Image1,2)-x+1);
    dy=min(size(Image2,1),size(Image1,1)-y+1);
    displayedImage(y:y+dy-1,x:x+dx-1)=+displayedImage(y:y+dy-1,x:x+dx-1)-Image2(1:dy,1:dx);
    imagesc(displayedImage);colormap(gray);
end
close(f);

