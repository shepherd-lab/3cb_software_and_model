%Threshold Contour
%creation date 5-28-03
%author Lionel HERVE
%modification
%10-29-03 use Matlab imerode and imdilate

function funcThresholdContour
global Threshold visu ROI Outline Image Error ChestWallData Analysis Database 

try
    %clean the ROI image. Put zeros outside the outline.
    tempimage=zeros(ROI.rows,ROI.columns);
    breast_mask=zeros(ROI.rows,ROI.columns);
    breast_maskMuscle=zeros(ROI.rows,ROI.columns);
    [C,I]=max(Outline.x);
    for index=1:I
        miny=Outline.y(index);
        maxy=Outline.y(size(Outline.x,2)-index+1);
        tempimage(miny:maxy,index)=visu(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
        tempimage(miny:maxy,index)=Image.image(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
        breast_mask(miny:maxy,index) = 1; 
    end
  
    if ChestWallData.Valid > 0      
         OutlineMuscle= outline_muscle(breast_mask);
        [Cm,Im]=max(OutlineMuscle.x);
        for index=1:Im
            minym=OutlineMuscle.y(index);
            maxym=OutlineMuscle.y(size(OutlineMuscle.x,2)-index+1);
            tempimagem(minym:maxym,index)=visu(ROI.ymin+minym-1:ROI.ymin+maxym-1,ROI.xmin+index-1);
            tempimagem(minym:maxym,index)=Image.image(ROI.ymin+minym-1:ROI.ymin+maxym-1,ROI.xmin+index-1);
            breast_maskMuscle(minym:maxym,index) = 1; 
        end
    
        breast_mask =  breast_mask - breast_maskMuscle;
    else
        Analysis.SurfaceMuscle = 0;
    end  
    %BW=(tempimage/max(max(Image.maximage))*Image.colornumber+0)>Threshold.value*Image.colornumber+0;
    % [Outline.x,Outline.y]=funcfindOutline(1-ROI.BackGround);
    % figure;
    %imagesc(breast_mask); colormap(gray);
    %figure;
    %imagesc(breast_mask); colormap(gray);
    swing = max(max(tempimage)) - min(min(tempimage))
    thresh_image = ((tempimage - Threshold.Ref0) / (Threshold.Ref100-Threshold.Ref0)* 100).*breast_mask; 
   % Threshold.value=(Ref0+PercentThreshold*(Ref100-Ref0))/ (Ref100-Ref0) ;   
    thresh_image=(thresh_image>0).*thresh_image;
    % figure;
    %imagesc(thresh_image); colormap(gray);
    %Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    thresh_image1 =(WindowFiltration2D(thresh_image,3)>0); 
    [Densityline.x,Densityline.y]=funcfindOutline(thresh_image1);
    Analysis.Densityline = Densityline;
    Threshold.DensitySurface=funcfindsurface(Densityline);
    
   % figure;
     thr =  Threshold.PercentThreshold * 100
   %  imagesc(thresh_image); colormap(gray);
    % BW = im2bw(thresh_image,Threshold.PercentThreshold);
     BW=(thresh_image*Image.colornumber+0)> thr*Image.colornumber+0;
      %         figure;
      %       imagesc(BW); colormap(gray);
    %eliminate little islands
    windowsize=4;
    [X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
    se=((X.^2+Y.^2)<=(windowsize/2)^2);
    OnesNumber=sum(sum(se));
    BW=(conv2(+BW,+se,'same')==OnesNumber);
              
    BW=(conv2(+BW,+se,'same')>0);
             % figure;
             % imagesc(BW); colormap(gray);
    [ry,rx]=size(BW);
    
    BW2=(conv2(+BW,+ones(3),'same')>0);
             % figure;
              %imagesc(BW2); colormap(gray);
    boundary=BW2-BW;
             % figure;
             % imagesc(boundary); colormap(gray);
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
    switch  int8(thr)
        case  15
            Threshold.boundary15 = Threshold.boundary
        case  30
            Threshold.boundary30 = Threshold.boundary
        case  45
            Threshold.boundary45 = Threshold.boundary
        otherwise
             disp('NOt used threshold.')
           %  Threshold.boundary30 = Threshold.boundary
    end
    
    Threshold.pixels=sum(sum(BW));
    Threshold.Computed=true;       %Threshold.Computed is put to false when ROI is changed

catch
    Error.AutoBDMD=true;
end