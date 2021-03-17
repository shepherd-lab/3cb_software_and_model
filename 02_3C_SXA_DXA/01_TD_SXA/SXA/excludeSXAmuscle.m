function chestwall_Mask = excludeSXAmuscle(CurrentImage)
global ChestWallData Analysis Database ROI Info freeform_chestwall_id

SQLstatement=['SELECT ALL commonanalysis.commonanalysis_id, commonanalysis.ChestWall_ID FROM acquisition,commonanalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.acquisition_id =', num2str(Info.AcquisitionKey)];  
chwall_ids=cell2mat(mxDatabase(Database.Name,SQLstatement));
if isempty(chwall_ids)
   chestwall_Mask = ones(size(CurrentImage));
   ;
else
    fnch = find(chwall_ids(:,2)~=0);
    if isempty(fnch)
        chestwall_Mask = ones(size(CurrentImage));
    else
         %fnch = find(chwall_ids(:,2)~=0);
        id_matrix = chwall_ids(fnch,:);
        data_chest = sortrows(id_matrix,1); %sortrows(A,column)
        real_chestwallid = data_chest(end,2);
        if real_chestwallid == 0
            chestwall_Mask = ones(size(CurrentImage));

        else

            SQLstatement=['select * from Chestwall where id=',num2str(real_chestwallid),' order by point_id'];
            freeform_chestwall_id = real_chestwallid;
            content=cell2mat(mxDatabase(Database.Name,SQLstatement));
            ChestWallData.Points=(content(:,3:4));
           % Chestwall('FROMDATABASE');
            ChestWallData.NumberPoints=size(ChestWallData.Points,1); 
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
           %  figure;
           % imagesc(chestwall_mask); colormap(gray);

        end
        %image_freeform=chestwall_Mask.*CurrentImage;
        %figure;
        %imagesc(image_freeform); colormap(gray);
        ;
    end
end