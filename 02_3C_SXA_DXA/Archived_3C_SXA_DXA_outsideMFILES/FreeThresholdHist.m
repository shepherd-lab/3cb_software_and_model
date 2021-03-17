function FreeThresholdHist()
     global Image Outline ROI visu
       
        tempimage=zeros(ROI.rows,ROI.columns);
        [C,I]=max(Outline.x);
        for index=1:I
            miny=Outline.y(index);
            maxy=Outline.y(size(Outline.x,2)-index+1);
            tempimage(miny:maxy,index)=visu(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
            tempimage(miny:maxy,index)=Image.image(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
        end
       % BW=(tempimage/max(max(Image.maximage))*Image.colornumber+0)>Threshold.value*Image.colornumber+0;
       A = uint8(tempimage/256);
      figure;
       imagesc(A); colormap(gray);
       
       %figure; imhist(A);
       [counts,x] = imhist(A);
       hdata = [counts x];
       htemp = hdata((hdata(:,2)>1)&(hdata(:,2)<256) ,:);
       %yy = smooth(htemp(:,1),15,'moving');
       %yy = htemp(:,1);
       % xx = htemp(:,2);
       % fresult = gauss_fit(xx,yy)
       %yy = uint16(yy);
       %ym = max(yy)
       %szc = size(yy)
       %szx = size(htemp)
       figure;
       plot(htemp(:,2), htemp(:,1)); hold on; %, '-bo'
       figure;
       plot(htemp(:,2), gradient(htemp(:,1))); hold on; %, '-bo'
       %plot(fresult,'fit',0.95);

