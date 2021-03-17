function OutlineMuscle=outline_muscle(CurrentImage)
global ChestWallData Analysis Database ROI
%SQLstatement=['select * from Chestwall where id=',num2str(Analysis.ChestWallID),'order by point_id'];
%content=cell2mat(mxDatabase(Database.Name,SQLstatement));
%ChestWallData.Points=(content(:,3:4));
%Chestwall('FROMDATABASE');
%ChestWallData.Curve=funcComputeInterpolationCurve(ChestWallData);
%ChestWallData.Curve=[round(ChestWallData.Curve(:,1)-ROI.xmin+1) round(ChestWallData.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
%ChestWallData.Curve(1,1)=1;   %put the first and the last point to the edge of the ROI region
%ChestWallData.Curve(size(ChestWallData.Curve,1),1)=1;
%[ChestWallData.Curve(:,1),ChestWallData.Curve(:,2)]=funcclipping(ChestWallData.Curve(:,1),ChestWallData.Curve(:,2),ROI.rows,ROI.columns);       %clip to the ROI

ChestWallDataY=ChestWallData.Curve(:,2);
ChestWallDataX=ChestWallData.Curve(:,1);
%figure;
%imagesc(CurrentImage); colormap(gray);
% i=1;
% [rows columns]=size(ChestWallData.Curve);
% while (i<rows)
%     Data.Points=[ChestWallDataX(i) ChestWallDataY(i);ChestWallDataX(rows) ChestWallDataY(rows)];
%     Data.NumberPoints=2;
%     curve=round(funcComputeInterpolationCurve(Data));
%     curveSize=size(curve);
%     curveX=curve(:,1);
%     curveY=curve(:,2);
%     i=i+1;
%     rows=rows-1;
%     for index=1:curveSize
%         CurrentImage(curveY(index),curveX(index))=0;
%     end
% end
 clear xy;
        %xy=[round(ChestWallData.Curve(:,1)-ROI.xmin+1) round(ChestWallData.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
        xy = [round(ChestWallData.Curve(:,1)) round(ChestWallData.Curve(:,2))]; %convert from image to ROI
        xy(1,1)=1;   %put the first and the last point to the edge of the ROI region
        xy(size(xy,1),1)=1;
        [xy(:,1),xy(:,2)]=funcclipping(xy(:,1),xy(:,2),ROI.rows,ROI.columns);       %clip to the ROI
        
        %modify the curve in order there just remain 2 points per abscisse
        OutlineMuscle1=funcSemiEdgeComputation(xy);  %find the first part of the curve (increasing x)
        xy=flipdim(xy,1);
        OutlineMuscle2=flipdim(funcSemiEdgeComputation(xy),1); %find the second part of the curve (decreasing x)
        I=size(OutlineMuscle1,1);
        OutlineMuscle.x=[OutlineMuscle1(:,1)' OutlineMuscle2(1,1)+1 OutlineMuscle2(:,1)'];
        OutlineMuscle.y=round([OutlineMuscle1(:,2)' round((OutlineMuscle1(I,2)+OutlineMuscle2(1,2))/2)+1  OutlineMuscle2(:,2)']);
        [OutlineMuscle,PreciseOutlineMuscle,Analysis.SurfaceMuscle,Analysis.midcurve_pMuscle,Analysis.midpointMuscle]=funcFindStuffOnOutlinePointsDrawing(OutlineMuscle);

%{
i=1;
while (i<length(ChestWallData.Curve)) 
   CurrentImage(ChestWallData.Curve(i,2),1:ChestWallData.Curve(i,1))=0;
   i=i+1;
end
%}
% [sizeData column]=size(ChestWallData.Curve);
% maxData=max(ChestWallDataY);
% minData=min(ChestWallDataY);
% midPoint=(maxData+minData)/2;
% j=1;
% while (j<=sizeData)
%     Data.Points=[1 midPoint;ChestWallDataX(j) ChestWallDataY(j)];
%     Data.NumberPoints=2;
%     curve=round(funcComputeInterpolationCurve(Data));
%     curveSize=size(curve);
%     curveX=curve(:,1);
%     curveY=curve(:,2);
%     j=j+1;
%     for index=1:curveSize
%         CurrentImage(curveY(index),curveX(index))=0;
%     end
% end
% 
%  minXpoint=min(ChestWallDataX);
%  x=1;
%  while (x<=sizeData)
%      Data.Points=[minXpoint ChestWallDataY(x);ChestWallDataX(x) ChestWallDataY(x)];
%      Data.NumberPoints=2;
%      curve=round(funcComputeInterpolationCurve(Data));
%      curveSize=size(curve);
%      curveX=curve(:,1);
%      curveY=curve(:,2);
%      x=x+1;
%      for index=1:curveSize
%          CurrentImage(curveY(index),curveX(index))=0;
%      end
%  end
% 
%  q=1;
%  while(minData<=maxData)
%      while(q<=sizeData)
%          Data.Points=[minXpoint minData;ChestWallDataX(q) ChestWallDataY(q)];
%          Data.NumberPoints=2;
%          curve=round(funcComputeInterpolationCurve(Data));
%          curveSize=size(curve);
%          curveX=curve(:,1);
%          curveY=curve(:,2);
%          q=q+1;
%          for index=1:curveSize
%              CurrentImage(curveY(index),curveX(index))=0;
%          end
%      end
%      minData=minData+1;
%  end   
%imagefreeform=CurrentImage;
%figure;
%imagesc(imagefreeform); colormap(gray);