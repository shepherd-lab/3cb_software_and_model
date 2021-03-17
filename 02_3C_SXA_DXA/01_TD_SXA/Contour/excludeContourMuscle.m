function chestwall_Mask = excludeContourMuscle(CurrentImage)
global ChestWallData ROI %Analysis Database  Info freeform_chestwall_id


            %ChestWallData.Points=(content(:,3:4));
           % Chestwall('FROMDATABASE');
            ChestWallData.Curve=funcComputeInterpolationCurve(ChestWallData);
            ChestWallData.Curve=[round(ChestWallData.Curve(:,1)-ROI.xmin+1) round(ChestWallData.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
            ChestWallData.Curve(1,1)=1;   %put the first and the last point to the edge of the ROI region
            ChestWallData.Curve(size(ChestWallData.Curve,1),1)=1;
            [ChestWallData.Curve(:,1),ChestWallData.Curve(:,2)]=funcclipping(ChestWallData.Curve(:,1),ChestWallData.Curve(:,2),ROI.rows,ROI.columns);       %clip to the ROI

            ChestWallDataY=ChestWallData.Curve(:,2);
            ChestWallDataX=ChestWallData.Curve(:,1);
            %figure;
            %imagesc(CurrentImage); colormap(gray);
            chestwall_Mask = (1 - roipoly(ROI.image,ChestWallDataX',ChestWallDataY'));
        