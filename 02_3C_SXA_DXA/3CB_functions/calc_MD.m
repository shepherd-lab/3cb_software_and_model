function calc_density = calc_MD(thresh_0)
global Threshold visu ROI  Image Error Outline Analysis ChestWallData Info
global BreastMask 



temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1)-Analysis.Ibkg;
temproi2=temproi.*BreastMask;

Analysis.minvalue_Breast=nanmin(temproi2(:)); % min intensity for ROI
Analysis.maxvalue_Breast=nanmax(temproi2(:));      % max intensity for ROI

a = ChestWallData.Valid;
% temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
x = ROI.image;
% figure;imagesc(x);colormap(gray);
if ChestWallData.Valid
    chestwall_Mask = excludeContourMuscle(temproi2);
else
    chestwall_Mask = excludeSXAmuscle(temproi2);
end
%figure; imagesc(BreastMask); colormap(gray);
BreastMask = BreastMask .* chestwall_Mask;
%figure; imagesc(BreastMask); colormap(gray);
%figure;imagesc(chestwall_Mask); colormap(gray);
%
%BW_Test=((temproi/(max(max(Image.maximage)))*Image.colornumber+0)>thresh_0*Image.colornumber+0).* BreastMask;
BW_Test=((temproi2 - Analysis.minvalue_Breast) /(Analysis.maxvalue_Breast -Analysis.minvalue_Breast)*Image.colornumber>thresh_0*Image.colornumber).* BreastMask;
clear temproi;

%figure;imagesc(BW);colormap(gray);
Image.ThresholdMask_Test = zeros(size(Image.image));
Image.ThresholdMask_Test(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = BW_Test;
% %      figure;imagesc(BW); colormap(gray);
%figure;imagesc(Image.ThresholdMask_Test); colormap(gray);

windowsize=7;
[X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
se=((X.^2+Y.^2)<=(windowsize/2)^2);
OnesNumber=sum(sum(se));
BW_Test=(conv2(+BW_Test,+se,'same')==OnesNumber);
BW_Test=(conv2(+BW_Test,+se,'same')>0);

[ry,rx]=size(BW_Test);
BW_Test2=(conv2(+BW_Test,+ones(3),'same')>0);
%Image.ThresholdMask_Test(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = BW_Test2;
boundary=BW_Test2-BW_Test;
%find the coordinates of the boundary
Threshold.boundary_Test=[];
Threshold.pixels = [];

% % % 
% % % 
% % % %% Remve Muscle for all CC view
% % % if strfind(Info.SeriesDescription,'CC')
% % %     %% Remve Muscle for all CC view
% % %     [iy ix]=size(BreastMask);
% % %     cx=2;cy=iy/2%-iy/10;
% % %     r=iy/2;
% % %     X0=10;
% % %     Y0=20;
% % %     a=30; %  define how big width is
% % %     b=iy/4;
% % %     [x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
% % %     Muscle_mask=((x-X0)/a).^2+((y-Y0)/b).^2<=1;
% % %     % figure;imagesc(Muscle_mask); colormap(bone)
% % %     BW_Test=BW_Test.*(~Muscle_mask);
% % %     BW_Test2=BW_Test2.*(~Muscle_mask);
% % %     boundary=BW_Test2-BW_Test;
% % %     
% % % else
% % %     boundary=BW_Test2-BW_Test;;
% % % end
% % % 




for indexx=1:ROI.columns
    [temp,indexsort]=sort(boundary(:,indexx),1);
    [maxi,indexmax]=max(temp);
    if maxi
        NewPoints=indexsort(indexmax:end);
        NewPoints=[NewPoints ones(size(NewPoints,1),1)*indexx];
        Threshold.boundary_Test=[Threshold.boundary_Test;NewPoints];
    end
end
Threshold.plotflag = 0;
%Threshold.pixels=sum(sum(BW));
Threshold.pixels_Test=sum(sum(Image.ThresholdMask_Test));
Threshold.Computed=true;
%thresh_contour = Threshold.value;
Analysis.Threshold_density = Threshold.pixels_Test/Analysis.ValidBreastSurface*100;
calc_density = Threshold.pixels_Test/Analysis.ValidBreastSurface*100;
Threshold.value_Test = thresh_0;
a = 1;


end

