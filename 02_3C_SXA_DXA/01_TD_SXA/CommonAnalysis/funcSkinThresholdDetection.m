function funcSkinThresholdDetection()
    global Image ROI ctrl Analysis Threshold PreciseOutline BreastMask
    
    %external ROI should be selected before in manual regime from GIU, 
    temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
%      ROI.ymin = 366;
%      ROI.rows = 549-366+1;
%      ROI.xmin = 793;
%      ROI.columns = 1014-793+1;
%      temproi=Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% %     
    size_ROI = size(temproi);
    res = 0.014;
   % figure; imagesc(temproi); colormap(gray);
    bkgr = background_LEimage(temproi)+1500;%+15000;%-2000;%$-1000;%1000; 
    %mask creation by background threshold    
    MaskROI = temproi>bkgr;
    MaskROI=(WindowFiltration2D(MaskROI,3)>0); 
    BreastMask = MaskROI;
    %figure;imagesc(BreastMask);colormap(gray);
   
    windowsize=4;
    [X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
    se=((X.^2+Y.^2)<=(windowsize/2)^2);
    OnesNumber=sum(sum(se));
    MaskROI=(conv2(+MaskROI,+se,'same')==OnesNumber);
              
    MaskROI=(conv2(+MaskROI,+se,'same')>0);
             % figure;
             % imagesc(BW); colormap(gray);
    [ry,rx]=size(MaskROI);
    
    BW2=(conv2(+MaskROI,+ones(3),'same')>0);
             % figure;
              %imagesc(BW2); colormap(gray);
    boundary=BW2-MaskROI;
             
    %figure;imagesc(boundary); colormap(gray);
    %find the coordinates of the boundary
    Threshold.SkinBoundary=[];
    for indexx=1:ROI.columns
        [temp,indexsort]=sort(boundary(:,indexx),1);
        [maxi,indexmax]=max(temp);
        if maxi
            NewPoints=indexsort(indexmax:end);
            NewPoints=[NewPoints ones(size(NewPoints,1),1)*indexx];
            Threshold.SkinBoundary=[Threshold.SkinBoundary;NewPoints];
        end
    end
    %Analysis.Surface1 = polyarea(Threshold.SkinBoundary(:,2),Threshold.SkinBoundary(:,1));
    Analysis.Surface = sum(sum(BreastMask));
    Analysis.Step = 3;
    %line.x = Threshold.SkinBoundary(:,2);
    %line.y = Threshold.SkinBoundary(:,1);
    %Surface=funcfindsurface(line);
    %PreciseOutline.x = Threshold.SkinBoundary(:,2);
    %PreciseOutline.y = Threshold.SkinBoundary(:,1);
    Threshold.SkinBoundaryComputed=true; 
    %draweverything;
    
    
    
    %{
    [C,I]=max(Innerline.x);
    Npoint=size(Innerline.x,2);
    innerline1_x=Innerline.x(1:I-1);
    innerline1_y=Innerline.y(1:I-1);
    innerline2_x=Innerline.x(Npoint:-1:Npoint-I+2);
    innerline2_y=Innerline.y(Npoint:-1:Npoint-I+2);

    ImageDensity=0;
    y1=min(innerline2_y,innerline1_y);
    y2=max(innerline2_y,innerline1_y);

    MaskROI=zeros(size(ROI.image));
    for x=1:I-1
        MaskROI(y1(x):y2(x),x)=1;
    end
    %}
%  
  %  Analysis.Step = 1.5;
   % draweverything;
   % set(ctrl.text_zone,'String',strcat('Volume: ',num2str(Analysis.Volume),', Image Density: ',num2str(Analysis.DensityPercentage),'%'));
    
  