function  ComputeSliceBreastDensityDXA()
    global Image ROI ctrl Analysis Threshold
    
    %external ROI should be selected before in manual regime from GIU, 
    temproi=Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
%      ROI.ymin = 366;
%      ROI.rows = 549-366+1;
%      ROI.xmin = 793;
%      ROI.columns = 1014-793+1;
%      temproi=Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
% %     
    size_ROI = size(temproi);
    res = 0.014;
   % figure; imagesc(temproi); colormap(gray);
    bkgr = background_LEimage(temproi)+1000;%+15000;%-2000;%$-1000;%1000; 
    %mask creation by background threshold    
    MaskROI = temproi>bkgr;
    MaskROI=(WindowFiltration2D(MaskROI,3)>0); 
   
    windowsize=4;
    [X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
    se=((X.^2+Y.^2)<=(windowsize/2)^2);
    OnesNumber=sum(sum(se));
    MaskROI=(conv2(+MaskROI,+se,'same')==OnesNumber);
              
    MaskROI=(conv2(+MaskROI,+se,'same')>0);
%              figure;
%              imagesc(BW); colormap(gray);
    [ry,rx]=size(MaskROI);
    
    BW2=(conv2(+MaskROI,+ones(3),'same')>0);
%              figure;
%               imagesc(BW2); colormap(gray);
    boundary=BW2-MaskROI;
             
%     figure;imagesc(boundary); colormap(gray);
    %find the coordinates of the boundary
    Threshold.boundary=[];
    for indexx=1:ROI.columns
        [temp,indexsort]=sort(boundary(:,indexx),1);
        [maxi,indexmax]=max(temp);
        if maxi
            NewPoints=indexsort(indexmax:end);
            NewPoints=[NewPoints ones(size(NewPoints,1),1)*indexx];
            Threshold.boundary=[Threshold.boundary;NewPoints];
        end
    end
    
    Threshold.DXAComputed=true; 
    
    
    
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
%     roi_material = funcclim(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROI,-50,200); 
    roi_material = funcclim(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROI,0,100); 
    roi_thickness = funcclim(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROI,0,20);
        
    %figure; imagesc(MaskROI);colormap(gray);
    %figure; imagesc(roi_thickness);colormap(gray);
    
    Analysis.DensityPercentage=nansum(nansum(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROI.*Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1)))/sum(sum(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROI));
    
    A = nansum(nansum(roi_material.*roi_thickness));
    B = sum(sum(roi_thickness));
    Analysis.DensityPercentage=nansum(nansum(roi_material.*roi_thickness))/sum(sum(roi_thickness));
    % Analysis.BreastArea = sum(sum(MaskROI * (res)^2)); % in cm2
    Analysis.Volume = sum(sum(roi_thickness*(res)^2));
    Analysis.Step = 1.5;
%    draweverything;
    set(ctrl.text_zone,'String',strcat('Volume: ',num2str(Analysis.Volume),', Image Density: ',num2str(Analysis.DensityPercentage),'%'));
    
  