function Phantom=funcPhantomDetection2(Image,figuretodraw);
global Correction DEBUG Analysis
%phantom detection
%Lionel HERVE
%10-2-03
%%% to add: erase the breast in the image
% 4-12-04 coefficient adpated for CPMC phantom
LINES =0;
% initial check for phantom
type = phantom_type(Image.OriginalImage);

Phantom.AngleHoriz = [];
Analysis.AngleHoriz = [];
if strcmp(type, 'NO') 
    stop;

elseif strcmp(type, 'STEP')
   % Message('Step phantom');
     Analysis.PhantomID = 7;
    % stop;
    %AddDatabase = 

else
   
    Message('Detect phantom lines...')

    PlotLine=1;
    DEBUG = 0;
    Phantom.AngleHoriz = [];

    %% Original Image
    if DEBUG figuretodraw=figure;imagesc(Image.image);title('PhantomDetection2: Original Image');colormap(gray);hold on;end

    %% Right edge of the search box for the phantom = right edge of the image
    maxX=size(Image.image,2);

    %% maximum value for the bottom of the phantom (to accelerate edge function)
    maxY=500;

    %% find the top of the image
    %take the mid band of the image
    %find where the image is saturated

    ExtractedImage=+(Image.OriginalImage(1:maxY,round(size(Image.OriginalImage,2)/4):round(3*size(Image.OriginalImage,2)/4)));
    ExtractedImage=(ExtractedImage<Correction.SaturatedThreshold)&(ExtractedImage~=0);
    if DEBUG figure;imagesc(ExtractedImage);title('PhantomDetection2: Extracted Image');colormap(gray); end

    %eliminate saturated islands (lead wires)
    [mini,minY]=max(sum(ExtractedImage')>400); minY=minY+10;  %minY corresponds to the first line more than 200 non saturated pixels
    if DEBUG display(['TOP OF THE IMAGE:',num2str(minY)]); end

    %% Left edge of the analysis box - Analyze the Image for y=minY+20:minY+50 (this line should cross the phantom)
    %the problem comes from the lag at the top of the image that screws the
    %bakground detection!!
    signal=mean(Image.OriginalImage(minY+20:minY+50,1:end));
    %the background is defined here when a third of the pixels are above a
    %threshold
    bin=[0:100]/100*max(signal);
    workinghist=histc(signal,bin);
    [maxi,index]=max(cumsum(workinghist)>(sum(workinghist)/3));
    threshold=bin(index);
    signal=signal<threshold;
    MinPhantomSize=200;
    signal=conv2(+signal,ones(1,MinPhantomSize),'same')==0;    %find were more than 200 consecutives pixels are over the background
    signal(1:round(length(signal)/3))=0;  %put the first value of the line to 0 to prevent the left lag to bother the computations
    [foe,minX]=max(signal); %the left corner is the lefter 200 pixels which don't belong to the background
    minX=minX-200;
    minXfix = 300;
    minxx = [minX minXfix]
    minX = max(minxx)
    corner1=[minX minY maxX maxY]
    if DEBUG display(corner1);end

    %% find the first horizontal line
    tempImage=Image.OriginalImage(corner1(2):corner1(4),corner1(1):corner1(3));
    tempBackGround=(1-Analysis.BackGround(corner1(2):corner1(4),corner1(1):corner1(3)));
    tempImage=tempImage.*(tempBackGround);   %keep just the image outside of the background
   
    %htemp  = figure;imagesc(tempImage); colormap(gray); title('TempImage')
    %sz = size(tempImage)
    %h = ones(5,5 )/25 ;% / 25;
    %h = fspecial('unsharp');
    %h = [-1 0 1];

    tempImage = medfilt2(tempImage, [3 3]); % wiener2(J,[5 5])

    %figure;imagesc(tempImage); colormap(gray); title('Wernier TempImage')
    %tempImage = imfilter(tempImage,h);
    %[BW,thresh] = edge(tempImage,'zerocross');

    %[BW,thresh] = edge(tempImage,'canny', [ 0.0255    0.0613], 3);%,300, 2.1);  0.0125    0.0313

    %[BW,thresh] = edge(tempImage,'log',300, 2.1);
    %thr = thresh
    BW = edge(tempImage,'sobel');  %edge detection with sobel filter
    %[BW,thresh] = edge(tempImage,'canny',[ ],2.3);
    if DEBUG; figure;imagesc(BW); colormap(gray); title('PhantomDetection2:edge detection');end

    %I want to have 2 0 under the line but some other 1 soon (because a lead wire is made by to edges)
    BW(end-10:end,end)=0; % to prevent to reach forbidden indexes
    OnesIndexes=find(BW==1);
    BW(OnesIndexes)=(BW(OnesIndexes+1)==0)&(BW(OnesIndexes+2)==0)&(BW(OnesIndexes+3)|BW(OnesIndexes+4)|BW(OnesIndexes+5)|BW(OnesIndexes+6)|BW(OnesIndexes+7)|BW(OnesIndexes+8)|BW(OnesIndexes+9)|BW(OnesIndexes+10));
    if DEBUG; figure;imagesc(BW); colormap(gray);title('PhantomDetection2:detection of first horizontal lead wire'); end

    %h1 = figure;imagesc(BW); colormap(gray); title('Line1');

    theta = 80:0.3:100;  %Radon transform
    [Line1,R]=funcRadonDetectMax(BW,theta,DEBUG,'first');

    if DEBUG display(Line1); end
    Line1=funcComputeLine(size(tempImage),Line1)

    %if LINES
    %h1 = figure;imagesc(BW); colormap(gray); title('Line1');
    %figure(htemp);imagesc(tempImage); colormap(gray); title('Line1');
    % hold on; plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');
    %end

    Phantom.Line1=[minX+[Line1.x1 Line1.x2]' minY+[Line1.y1 Line1.y2]'];

    %pixel values of the horizontal line
    for index=1:30
        c(index,:)=improfile(tempImage,[Line1.x1 Line1.x2],[Line1.y1+index-10 Line1.y2+index-10]);
    end
    signal=conv2(max(c),ones(1,40),'same')/40;    %convolution to eliminate little spikes that can mess the detection

    %% find the first vertical line (it is when the bottom line end)
    %%find left edges - consider just the point above max/4
    leftEdge=diff(signal).*(signal(1:end-1)>max(signal)/3);
    leftEdge=leftEdge>(max(leftEdge)*0.1);
    [Lboolean,leftPoints]=sort(leftEdge);
    [maxi,pos]=max(Lboolean);
    leftPoints=leftPoints(pos:length(leftPoints));
    if DEBUG display(leftPoints); end   %There are a lot of left edges. Need to find the good one
     display(leftPoints);
    %find the Left edge of the left wedge = no left edge between the correct
    %point and it + 60 at its right
    [maxi,indexLeftPoint]=max(diff(leftPoints)>60);
    %{
    if maxi==0
        stop
        return; 
    end
    %}
    if DEBUG  %plot a graph if asked
        littlegraph=figure;
        plot(signal);hold on;
        plot(leftPoints,signal(leftPoints),'ro','markersize',5,'markerfacecolor','r');    
        plot(leftPoints(indexLeftPoint),signal(leftPoints(indexLeftPoint)),'ro','markersize',10,'markerfacecolor','y');
    end

    segment1.x1=round(leftPoints(indexLeftPoint));
    segment1.x2=Line1.x2;
    segment1.y1=round(Line1.y1+(segment1.x1-Line1.x1)/(Line1.x2-Line1.x1)*(Line1.y2-Line1.y1));
    segment1.y2=round(Line1.y2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    %corner2=[corner1(1)+leftPoints(indexLeftPoint)-50,corner1(1)+leftPoints(indexLeftPoint)+20, 1,corner1(2)+max(segment1.y1,segment1.y2)+10];
    corner2=[corner1(1)+leftPoints(indexLeftPoint)-50,corner1(1)+leftPoints(indexLeftPoint)+20, 1,corner1(2)+max(segment1.y1,segment1.y2)+10];
    tempImage2=Image.OriginalImage(corner2(3)+7:corner2(4)+50,corner2(1)+7:corner2(2)+7);
    %tempImage2=Image.OriginalImage(corner2(3):corner2(4),corner2(1):corner2(2));

    %[BW,thresh] = edge(tempImage2,'canny',[ ],2.1);%, [ 0.0255    0.0613], 3);%,300, 2.1);  0.0125    0.0313
    %figure;imagesc(tempImage2); colormap(gray); title('TempImage2')

    %h2 = figure;imagesc(edge(tempImage2)); colormap(gray); title('Line2');
    theta = -5:0.2:5;
    [Line21,Line2]=funcRadonDetectTwoMax1(edge(tempImage2,'sobel'),theta,DEBUG,'last');
    Line2_diff = abs(Line2.x - Line21.x);
    %Line21=funcRadonDetectMax5(edge(tempImage2,'sobel'),theta,DEBUG,'last');
    %Phantom.Distance221= Line2.x - Line21.x;

    %if DEBUG display(Line2); end
    Line2=funcComputeLine(size(tempImage2),Line2);
    Line21=funcComputeLine(size(tempImage2),Line21);

    theta = 90:0.3:100;
    [Line2h, Line21h] =funcRadonDetectTwoMax1(edge(tempImage2,'sobel'),theta,DEBUG,'first');

    %Line21h=funcRadonDetectMax(edge(tempImage2,'sobel'),theta,DEBUG,'first');
    %Phantom.Distance221= Line2.x - Line21.x;

    if DEBUG display(Line2); end
    Line2h=funcComputeLine(size(tempImage2),Line2h);
    Line21h=funcComputeLine(size(tempImage2),Line21h);
    Line2h_diff = abs(Line2h.x - Line21h.x);

    if LINES
    h2 = figure;imagesc(edge(tempImage2)); colormap(gray); title('Line2');
    figure(h2); hold on; plot([Line2.x1 Line2.x2],[Line2.y1 Line2.y2],'Linewidth',1,'color','b');
    hold on;plot([Line21.x1 Line21.x2],[Line21.y1 Line21.y2],'Linewidth',1,'color','r');
     hold on; plot([Line2h.x1 Line2h.x2],[Line2h.y1 Line2h.y2],'Linewidth',1,'color','b');
    hold on;plot([Line21h.x1 Line21h.x2],[Line21h.y1 Line21h.y2],'Linewidth',1,'color','r');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %}
    %line 2 computation
    corner2=[corner1(1)+leftPoints(indexLeftPoint)-50,corner1(1)+leftPoints(indexLeftPoint)+20, 1,corner1(2)+max(segment1.y1,segment1.y2)+10];
    tempImage2=Image.OriginalImage(corner2(3):corner2(4),corner2(1):corner2(2));

    theta = -4:0.2:4;
    Line2=funcRadonDetectMax(edge(tempImage2,'sobel'),theta,DEBUG,'first');
    if DEBUG display(Line2); end
    Line2=funcComputeLine(size(tempImage2),Line2);

    if LINES
    h2 = figure;imagesc(edge(tempImage2)); colormap(gray); title('Line2');
    figure(h2); hold on; plot([Line2.x1 Line2.x2],[Line2.y1 Line2.y2],'Linewidth',1,'color','b');
    end

    %return in Original Image Referential
    Line1.x1=Line1.x1+corner1(1)-1;Line1.x2=Line1.x2+corner1(1)-1;
    Line1.y1=Line1.y1+corner1(2)-1;Line1.y2=Line1.y2+corner1(2)-1;
    segment1.x1=segment1.x1+corner1(1)-1;segment1.x2=segment1.x2+corner1(1)-1;
    segment1.y1=segment1.y1+corner1(2)-1;segment1.y2=segment1.y2+corner1(2)-1;
    Line2.x1=Line2.x1+corner2(1)-1;Line2.x2=Line2.x2+corner2(1)-1;
    Line2.y1=Line2.y1+corner2(3)-1;Line2.y2=Line2.y2+corner2(2)-1;

    %compute the intersection of Line1 and Line2
    I12=round(funcComputeIntersection(Line1,Line2));
    if DEBUG display(I12); end

    %% find the second vertical line
    corner3=[I12(1)+20,1];

    %try to find the line in a vertical window
    tempImage3=Image.OriginalImage(corner3(2):I12(2),corner3(1):min(corner3(1)+200,size(Image.OriginalImage,2)-100));
    BW = edge(tempImage3,'log');

    if DEBUG figure;imagesc(BW); end
    BW4=conv2(+BW,[1 1 1 -2 -2 -2 1 1 1],'same')>1;
    if DEBUG figure;imagesc(BW4); end

    %[BW4,thresh] = edge(tempImage3,'canny',[ ],2.1);

    %h3 = figure;imagesc(BW4); colormap(gray); title('Line3');
    theta = -4:0.2:4;
    [Line3, Line31] = funcRadonDetectTwoMax1(BW4,theta,DEBUG,'last');
    %Line31=funcRadonDetectMax15(BW4,theta,DEBUG,'first');
    Line3_diff = abs(Line3.x - Line31.x);

    if DEBUG display(Line3); end
    Line3=funcComputeLine(size(tempImage3),Line3);
    Line31=funcComputeLine(size(tempImage3),Line31);

    if LINES
    h3 = figure;imagesc(BW4); colormap(gray); title('Line3');
    figure(h3); hold on; plot([Line3.x1 Line3.x2],[Line3.y1 Line3.y2],'Linewidth',1,'color','b');
    hold on; plot([Line31.x1 Line31.x2],[Line31.y1 Line31.y2],'Linewidth',1,'color','r');
    end

    %return in Original Image Referential
    Line3.x1=Line3.x1+corner3(1)-1;Line3.x2=Line3.x2+corner3(1)-1;
    Line3.y1=Line3.y1+corner3(2)-1;Line3.y2=Line3.y2+corner3(2)-1;


    figure(figuretodraw);hold on;
    plot([Line3.x1 Line3.x2],[Line3.y1 Line3.y2],'Linewidth',1,'color','b');
    plot([Line2.x1 Line2.x2],[Line2.y1 Line2.y2],'Linewidth',1,'color','r');

    l3 = Line3
    l2 = Line2
    %% First check: the two vertical lines should have some minimum distance
    %{
    if abs(Line3.x1-Line2.x1)<50 
        stop;
    end
    %}


    %% find the 3rd vertical line (translation from line2)
      if Analysis.PhantomID == 3 | Analysis.PhantomID == 1  | Analysis.PhantomID == 2
        translation1=240;  %from left lead in fat region to left lead wire in lean region
        translation2=220;  %from right lead in fat region to right lead wire in lean region
        translation=200;
      else
        translation1=325;  %from left lead in fat region to left lead wire in lean region
        translation2=280;  %from right lead in fat region to right lead wire in lean region
        translation=300;
      end

    Line4.x1=Line2.x1+translation1;Line4.x2=Line2.x2+translation1;
    Line4.y1=Line2.y1;Line4.y2=Line2.y2;


    %% find the 4th vertical line (translation from line3)


    Line5.x1=Line3.x1+translation2;Line5.x2=Line3.x2+translation2;
    Line5.y1=Line3.y1;Line5.y2=Line3.y2;

    %% try to detect second horizontal line
    %search below the first horizontal line
    corner4=round([corner1(1),min(Line1.y1,Line1.y2),corner1(3),corner1(4)]);
    tempImage=Image.OriginalImage(corner4(2):corner4(4),corner4(1):corner4(3)); 
    %remove film right lag (average on the 100 last horizontal lines)
    tempImage2=tempImage(end-100:end,:);    %manage possible lead markers ...
    tempImage2=(tempImage2<30000).*tempImage2;
    LagSignal=sum(tempImage2)./max(sum(tempImage2>0),1);
    tempImage=tempImage-repmat(LagSignal,size(tempImage,1),1);
    %tempImage = medfilt2(tempImage,[3 5]);  %use median filter to improve the contrast between background and line 
    %FlatImage=reshape(tempImage,1,prod(size(tempImage)));
    %bins=min(FlatImage):(max(FlatImage)-min(FlatImage))/1000:max(FlatImage);
    %Hist=histc(FlatImage,bins);
    %[maxi,pos]=max(Hist);
    %ConvSize=10;ForeGround=conv2(+(tempImage>bins(pos)),ones(1,ConvSize),'same')==ConvSize;  
    %tempImage=ForeGround.*tempImage;
    %DEBUG = 1;
    if DEBUG figure;imagesc(tempImage);colormap(gray);end
    BW = edge(tempImage,'log');
    if DEBUG figure;imagesc(BW); end
    BW(end-10:end,end)=0; % to prevent to reach forbidden indexes
    OnesIndexes=find(BW==1);
    BW(OnesIndexes)=(BW(OnesIndexes+1)==0)&(BW(OnesIndexes+2)==0)&(BW(OnesIndexes+3)|BW(OnesIndexes+4)|BW(OnesIndexes+5)|BW(OnesIndexes+6)|BW(OnesIndexes+7)|BW(OnesIndexes+8)|BW(OnesIndexes+9)|BW(OnesIndexes+10));

    [BW,thresh] = edge(tempImage(:,1:end-100),'canny',[ ],2.1);%, [ 0.0255    0.0613], 3);%,300, 2.1);  0.0125    0.0313
    %h6 = figure;imagesc(BW); colormap(gray); title('Edge detection, Line 6')


    theta = 85:0.3:95;  %Radon transform
    [Line61,Line6] =funcRadonDetectTwoMax1(BW,theta,0,'last');
    Line6_diff = abs(Line6.x - Line61.x);

    %Line61=funcRadonDetectMax15(BW,theta,0,'last');
    %Phantom.Distance661= Line6.y - Line61.y;
    %Ln2 = Line2_diff
    %Ln2h = Line2h_diff
    %Ln3 = Line3_diff
    %Ln6 = Line6_diff

    %if ~( (Line2_diff <= 8 & Line2_diff >= 5) | (Line2h_diff <= 9 & Line2h_diff >= 5) | (Line3_diff <= 9 & Line3_diff >= 6) | (Line6_diff <= 9 & Line6_diff >= 6))  
    %    stop;
    %end

    if DEBUG display(Line6); end
    Line6=funcComputeLine(size(tempImage),Line6);
    Line61=funcComputeLine(size(tempImage),Line61);
    %figure; imagesc(tempImage); colormap(gray);


    if LINES
    h6 = figure;imagesc(BW); colormap(gray); title('Edge detection, Line 6')
    %h6 = figure;imagesc(tempimage); colormap(gray); title('Edge detection, Line 6')
    figure(h6); hold on;
    plot([Line6.x1 Line6.x2],[Line6.y1 Line6.y2],'Linewidth',1,'color','b');
    hold on; 
    plot([Line61.x1 Line61.x2],[Line61.y1 Line61.y2],'Linewidth',1,'color','r');
    end

    %figure(htemp);hold on;
    %plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');
    %plot([Line6.x1 Line6.x2],[Line6.y1 Line6.y2],'Linewidth',1,'color','r');

    %Go to original referential
    Line6.x1=Line6.x1+corner4(1)- corner1(1)-1;Line6.x2=Line6.x2+corner4(1)- corner1(1)-1;
    Line6.y1=Line6.y1+corner4(2)- corner1(2)-1;Line6.y2=Line6.y2+corner4(2)- corner1(2)-1;
    %figure(h1); hold on; plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');

    %translationY = 100;
    %Line6a.y1 = Line6.y1+translationY;Line6a.y2=Line6.y2+translationY;
    %Line6a.x1=Line6.x1;Line6a.x2=Line6.x2;

    %plot([Line6a.x1 Line6a.x2],[Line6a.y1 Line6a.y2],'Linewidth',1,'color','y');
    %figure(htemp);hold on;
    %plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');
    %plot([Line6.x1 Line6.x2],[Line6.y1 Line6.y2],'Linewidth',1,'color','r');

    Line6.x1=Line6.x1 + corner1(1);Line6.x2=Line6.x2+ corner1(1);
    Line6.y1=Line6.y1 + corner1(2);Line6.y2=Line6.y2+ corner1(2);


    figure(figuretodraw);hold on;
    plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');
    plot([Line6.x1 Line6.x2],[Line6.y1 Line6.y2],'Linewidth',1,'color','r');
    %plot([Line6a.x1 Line6a.x2],[Line6a.y1 Line6a.y2],'Linewidth',1,'color','y');

    figure(figuretodraw);hold on;
    plot([Line4.x1 Line4.x2],[Line4.y1 Line4.y2],'Linewidth',1,'color','y');
    plot([Line5.x1 Line5.x2],[Line5.y1 Line5.y2],'Linewidth',1,'color','m');

    %% Compute Intersections
    I13=funcComputeIntersection(Line1,Line3);
    I14=funcComputeIntersection(Line1,Line4);
    I15=funcComputeIntersection(Line1,Line5);

    %% output of the function
    Phantom.Point1=round(I12);
    Phantom.Point2=round(I15);
    Phantom.Point3=round([Line2.x1 Line2.y1]);
    Phantom.Point4=round([Line3.x1 Line3.y1]);
    Phantom.Point5=round(I13);
    Phantom.Point6=round([Line4.x1 Line4.y1]);
    Phantom.Point7=round(I14);
    Phantom.Point8=round([Line5.x1 Line5.y1]);
    Phantom.Point9=round([Line6.x1 Line6.y1]);
    Phantom.Point10=round([Line6.x2 Line6.y2]);
    Phantom.Top=minY;

    ln1angle = abs(Line1.angle - 90)
    ln6angle = abs(Line6.angle - 90)

    diffangle = Line1.angle-Line6.angle
    diffangle32 = Line2.angle-Line3.angle
    diffangle26 =  abs((Line2.angle-Line6.angle))
    diffangle21 = abs((Line2.angle-Line1.angle))

    if (((ln1angle < ln6angle) | (diffangle26 < diffangle21)) & (diffangle > 0)) & diffangle32 <= 0
        Phantom.AngleHoriz=-(Line1.angle-Line6.angle);
    else
         Phantom.AngleHoriz= Line1.angle-Line6.angle;
    end
    Analysis.AngleHoriz = Phantom.AngleHoriz;
    %Phantom.AngleHoriz=Line1.angle-Line6.angle

    Phantom.AngleVert=Line2.angle-Line3.angle;
    % p1_fat = round(min(point1,point2));             % calculate locations
    % offset_fat = round(abs(point1-point2));         % and dimensions
    % Analysis.coordXFatcenter =   p1_fat + offset_fat/2


    figure(figuretodraw);hold on;
    plot([Phantom.Point1(1) Phantom.Point2(1)],[Phantom.Point1(2) Phantom.Point2(2)],'Linewidth',1,'color','r');
    plot([Phantom.Point3(1) Phantom.Point1(1)],[Phantom.Point3(2) Phantom.Point1(2)],'Linewidth',1,'color','r');
    plot([Phantom.Point4(1) Phantom.Point5(1)],[Phantom.Point4(2) Phantom.Point5(2)],'Linewidth',1,'color','r');
    plot([Phantom.Point6(1) Phantom.Point7(1)],[Phantom.Point6(2) Phantom.Point7(2)],'Linewidth',1,'color','r');
    plot([Phantom.Point8(1) Phantom.Point2(1)],[Phantom.Point8(2) Phantom.Point2(2)],'Linewidth',1,'color','r');

    %% Compute the distance between Line1 and Line6 (two horizontal lines) 
    %Intersection (line3,line1) - Intersection (Line3,Line6)
    I31=funcComputeIntersection(Line3,Line1);
    I36=funcComputeIntersection(Line3,Line6);
    Phantom.Distance1=(sum((I31-I36).^2))^0.5 + 1;


    %Compute the distance between Line2 and Line3 (two vertical lines)
    %Intersection (lin3,line1) - Intersection (Line2,Line1)
    I21=funcComputeIntersection(Line2,Line1);
    Phantom.Distance2=(sum((I31-I21).^2))^0.5
    Phantom.Position=I21(1);

    % 
    translationFatRef =  Phantom.Distance2 / 2
    LineFatRef.x1=Line2.x1+translationFatRef;LineFatRef.x2=Line2.x2+translationFatRef;
    LineFatRef.y1=Line2.y1;LineFatRef.y2=Line2.y2;
    Ifr1=funcComputeIntersection(LineFatRef,Line1);
    Ifr6=funcComputeIntersection(LineFatRef,Line6);
    %Phantom.Distance3 = (sum((Ifr1-Ifr6).^2))^0.5 - 7
    Phantom.Distance3 = (sum((Ifr1-Ifr6).^2))^0.5 +1;

    %Phantom.AngleHoriz= - Phantom.AngleHoriz

    figure(figuretodraw);hold on;
    plot([LineFatRef.x1 LineFatRef.x2],[LineFatRef.y1 LineFatRef.y2],'Linewidth',1,'color','b');


    %DEBUG = 0;
end