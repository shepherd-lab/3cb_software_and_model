function [xmax,ymin,ymax,xmin] = edge_roi(BackGround)
               
        [rows,columns]=size(BackGround);
        %compel the column where the background is maximum to full
        %background  (to correct case ID343)
        [maxi,pos]=min(sum(BackGround));
    
        BackGround(:,pos)=0;  %%the minimum at 0
        convwindow=30;
        %find the shape of the breast
        [C,I]=min(transpose(BackGround));
        I=I+(C==1).*(size(BackGround,2)-I);  %when the line is completly without backgroud, to prevent the result to be equal to 1
        Iconv=WindowFiltration(I,convwindow);
        %if DEBUG==1 figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"'); end

        %figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"');

        %find the top of the ROI image
        [C,ymin]=min(Iconv(convwindow:round(rows/2)));
        %find the first point that reach the minimum value+10 (to be close of the edge of the breast)
        [C,ymin]=min(Iconv(round(rows/2):-1:convwindow)>(C+10));ymin=round(rows/2)-ymin;
        %ymin=max(ymin-50,50);

        %find the bottom of the ROI image
        [C,ymax]=min(Iconv(round(rows/2):rows-convwindow));
        %find the first point that reach the minimum value+10 (to be close of the edge of the breast)
        [C,ymax]=min(Iconv(round(rows/2):rows-convwindow)>(C+10));
        ymax=round(rows/2)+ymax;
        %ymax=min(ymax+50,size(BackGround,1)-50);

        %find the the right edge of the breast
        xmax=max(I(ymin:ymax));
        xmin = 1;