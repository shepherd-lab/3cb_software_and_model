%Threshold Contour
%creation date 5-28-03
%author Lionel HERVE
%modification
%10-29-03 use Matlab imerode and imdilate

function functhresholdcontour()
global Threshold visu ROI  Image Error Outline Analysis ChestWallData figuretodraw
global BreastMask
%thcnt = 1
%tic
%try
    %clean the ROI image. Put zeros outside the outline.
    %tempimage=Image.image(ROI.rows,ROI.columns);
    %{
    [C,I]=max(Outline.x);
    for index=1:I
        miny=Outline.y(index);
        maxy=Outline.y(size(Outline.x,2)-index+1);
        tempimage(miny:maxy,index)=visu(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
        tempimage(miny:maxy,index)=Image.image(ROI.ymin+miny-1:ROI.ymin+maxy-1,ROI.xmin+index-1);
    end
    %}
    %BW=(tempimage/max(max(Image.maximage))*Image.colornumber+0)>Threshold.value*Image.colornumber+0;
   %a = ChestWallData.Valid;
   temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
   %figure;imagesc(temproi);colormap(gray);
   %ROI.image=tempimage(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
  % x = ROI.image;
  % figure;imagesc(x);colormap(gray);
   if ChestWallData.Valid
     chestwall_Mask = excludeContourMuscle(temproi);
     BreastMask = BreastMask .* chestwall_Mask;
%    else
%      chestwall_Mask = excludeSXAmuscle(temproi);
   end
   %figure; imagesc(BreastMask); colormap(gray);
%    BreastMask = BreastMask .* chestwall_Mask;
   %figure; imagesc(BreastMask); colormap(gray);
   %figure;imagesc(chestwall_Mask); colormap(gray);
   %
   
   sz = size(temproi);
   BreastMask = imresize(BreastMask,[sz(1) sz(2)]);
   BW=((temproi/(max(max(Image.maximage)))*Image.colornumber+0)>Threshold.value*Image.colornumber+0).* BreastMask;
    clear temproi;
    %  I = imread('cameraman.tif');
   % bw_edge = edge(BW);%, 'canny');
    %  rgb = imoverlay(BW, bw_edge, [0 1 0]);
     %figure;imagesc(BW); colormap(gray);
     % imshow(rgb)
     %figure;imagesc(BW);colormap(gray);
     Image.ThresholdMask = zeros(size(Image.image));
     Image.ThresholdMask(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = BW;
% %      figure;imagesc(BW); colormap(gray);
     %figure;imagesc(Image.ThresholdMask); colormap(gray);
    %{
     windowsize=4;
    [X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
    se=((X.^2+Y.^2)<=(windowsize/2)^2);
    OnesNumber=sum(sum(se));
     BW=(conv2(+BW,+se,'same')==OnesNumber);
    BW=(conv2(+BW,+se,'same')>0);

    [ry,rx]=size(BW);
    BW2=(conv2(+BW,+ones(3),'same')>0);
    boundary=BW2-BW;
   % rgb = imoverlay(BW, boundary, [0 1 0]);
   % toc
    
    figure;
    imagesc(BW); colormap(gray);
    figure;
    imagesc(boundary); colormap(gray);
    
    figure(figuretodraw);
    imshow(rgb);
    
    
    boundary = bwboundaries(BW);
    bmat = cell2mat(boundary);
    clear boundary;
    figure; imagesc(BW);colormap(gray); 
    hold on;
    plot(bmat(:,2), bmat(:,1),'r','LineWidth',1);
    %[C,I] = imcontour(BW,3);
    tic
    %}
    %eliminate little islands
     %figure;imagesc(BW);colormap(gray); hold on;
% tic
%        imcontour(BW);
% t0 = toc

% tic
%      %BW2 = bwperim(BW);
%      
%      b = bwboundaries(BW);
%      t4 = toc
%     
%     figure;imagesc(BW2);colormap(gray);
%t1 = toc 
%tic
    
    windowsize=7;
    [X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
    se=((X.^2+Y.^2)<=(windowsize/2)^2);
%     BW2 = imerode(BW, se);
%     boundary = bwperim(BW2);
    OnesNumber=sum(sum(se));
    BW=(conv2(+BW,+se,'same')==OnesNumber);
    BW=(conv2(+BW,+se,'same')>0);

%     [ry,rx]=size(BW);
    BW2=(conv2(+BW,+ones(3),'same')>0);
    %Image.ThresholdMask(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = BW2;
    %boundary=BW2-BW;
   % figure;imagesc(boundary);colormap(gray);
    %find the coordinates of the boundary
    Threshold.boundary=[];
    Threshold.pixels = [];
    %toc
    %tic
    boundary=BW2-BW;
    
    
%     t2 = toc
%     tic
    
    
 
%imshow(bw);hold on
%figure(figuretodraw);hold on
% n = numel(b);
% for k = 1:numel(b)
%     plot(b{k}(:,2), b{k}(:,1), 'r', 'Linewidth', 1)
%     Threshold.boundary=[Threshold.boundary;]
% end


   % sz = size(boundary);
    for indexx=1:ROI.columns
        [temp,indexsort]=sort(boundary(:,indexx),1);
        [maxi,indexmax]=max(temp);
        if maxi
            NewPoints=indexsort(indexmax:end);
            NewPoints=[NewPoints ones(size(NewPoints,1),1)*indexx];
            Threshold.boundary=[Threshold.boundary;NewPoints];
        end
    end
    Threshold.boundary = Threshold.boundary;
    Threshold.plotflag = 0;
    %Threshold.pixels=sum(sum(BW));
    Threshold.pixels=sum(sum(Image.ThresholdMask));
    Threshold.Computed=true; 
    %thresh_contour = Threshold.value;
    Analysis.Threshold_density = Threshold.pixels/Analysis.ValidBreastSurface*100;
    %t1 = toc
%     t3 = toc 
    %Threshold.Computed is put to false when ROI is changed
%{
catch
    Error.AutoBDMD=true;
end
%}
%toc