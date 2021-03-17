function [ x_mask,y_mask ] = boundary_xy( BW )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global ROI
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
    boundary=[];
    pixels = [];
    %toc
    %tic
    boundary=BW2-BW;
    xy_mask = [];
    
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
            xy_mask=[xy_mask;NewPoints];
            
        end
    end
   x_mask  = xy_mask(:,1);
   y_mask  = xy_mask(:,2);
end

