function percent=funcComputeDXAcontour(current_image,xy,weight)
%create a bitmap of the contour area
%save the bitmap
%and use the b[itmap to find which part has been contoured


%create the fill surface
    minx=min(xy(:,1));
    miny=min(xy(:,2));
    maxx=max(xy(:,1));
    maxy=max(xy(:,2));
    

    ttt=figure('visible','off');axes('box','off','XTick',[],'YTick',[],'Xlim',[minx maxx],'Ylim',[miny maxy],'visible','off');
    h=patch(xy(:,1),xy(:,2),'black');

    %export the fill surface in a bitmap structure and import it
    print -dbmp16m 'toto.bmp';
    delete (ttt);
    tempimage=imread('toto.bmp');
    tempimage=tempimage(:,:,2)<10;
    [rows,columns]=size(tempimage);
    [k,minx2]=max(max(tempimage));
    tempimage2=rot90(tempimage);
    [k,miny2]=max(max(tempimage2));
    tempimage2=rot90(tempimage2);
    [k,maxx2]=max(max(tempimage2));maxx2=columns-maxx2+1;
    tempimage2=rot90(tempimage2);
    [k,maxy2]=max(max(tempimage2));maxy2=rows-maxy2+1;
    
%figure;imagesc(Image);hold on;
w = [0 0];
i =1;
%conmpute the material density
area=0;density=0;
for x=minx:maxx
    for y=miny:maxy
        fx2=(x-minx)/(maxx-minx);
        x2=round(minx2+fx2*(maxx2-minx2));
        fy2=1-(y-miny)/(maxy-miny);
        y2=round(miny2+fy2*(maxy2-miny2));        
        if tempimage(y2,x2)==1
 %           plot(x,y,'x');drawnow;
            area=area+weight(y,x);
           i = i+1;
            w(i,:) = [weight(y,x) current_image(y,x)];
           % w(:,i) = current_image(y,x);
           
            density=density+weight(y,x)*current_image(y,x); %
        end
    end
end

percent=density/area


