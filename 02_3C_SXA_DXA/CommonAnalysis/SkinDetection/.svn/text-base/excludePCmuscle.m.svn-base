function image_freeform=excludePCmuscle(CurrentImage)
global ChestWallData Analysis Database ROI Info freeform_chestwall_id

SQLstatement=['SELECT ALL commonanalysis.commonanalysis_id, commonanalysis.ChestWall_ID FROM acquisition,commonanalysis WHERE acquisition.acquisition_id = commonanalysis.commonanalysis_id  AND commonanalysis.acquisition_id =', num2str(Info.AcquisitionKey)];  
chwall_ids=cell2mat(mxDatabase(Database.Name,SQLstatement));
if isempty(chwall_ids)
    image_freeform=CurrentImage;
else
    
    fnch = find(chwall_ids(:,2)~=0);
    if isempty(fnch)
        image_freeform=CurrentImage;
    else
        id_matrix = chwall_ids(fnch,:);
        data_chest = sortrows(id_matrix,1); %sortrows(A,column)
        real_chestwallid = data_chest(end,2);
        
        %data_chest = sort(chwall_ids(fnch,:),'ascend');
        %real_chestwallid = data_chest(end,1);
        SQLstatement=['select * from Chestwall where id=',num2str(real_chestwallid),' order by point_id'];
        freeform_chestwall_id = real_chestwallid;
        content=cell2mat(mxDatabase(Database.Name,SQLstatement));
        ChestWallData.Points=(content(:,3:4));
        Chestwall('FROMDATABASE');
        ChestWallData.Curve=funcComputeInterpolationCurve(ChestWallData);
        ChestWallData.Curve=[round(ChestWallData.Curve(:,1)-ROI.xmin+1) round(ChestWallData.Curve(:,2)-ROI.ymin+1)]; %convert from image to ROI
        ChestWallData.Curve(1,1)=1;   %put the first and the last point to the edge of the ROI region
        ChestWallData.Curve(size(ChestWallData.Curve,1),1)=1;
        [ChestWallData.Curve(:,1),ChestWallData.Curve(:,2)]=funcclipping(ChestWallData.Curve(:,1),ChestWallData.Curve(:,2),ROI.rows,ROI.columns);       %clip to the ROI

        ChestWallDataY=ChestWallData.Curve(:,2);
        ChestWallDataX=ChestWallData.Curve(:,1);
        %figure;
        %imagesc(CurrentImage); colormap(gray);
         i=1;
         [rows columns]=size(ChestWallData.Curve);

         chestwall_Mask = (1 - roipoly(ROI.image,ChestWallDataX',ChestWallDataY'));


         while (i<rows)
             Data.Points=[ChestWallDataX(i) ChestWallDataY(i);ChestWallDataX(rows) ChestWallDataY(rows)];
             Data.NumberPoints=2;
             curve=round(funcComputeInterpolationCurve(Data));
             curveSize=size(curve);
             curveX=curve(:,1);
             curveY=curve(:,2);
             i=i+1;
             rows=rows-1;
             %for index=1:curveSize
             %    CurrentImage(curveY(index),curveX(index))=0;
             %end
         end

        i=1;
        len = length(ChestWallData.Curve)

        %while (i<length(ChestWallData.Curve)) 
        %   CurrentImage(ChestWallData.Curve(i,2),1:ChestWallData.Curve(i,1))=0;
        %   i=i+1;
        %end


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
        image_freeform=chestwall_Mask.*CurrentImage;
        %figure;
        %imagesc(image_freeform); colormap(gray);
        ;
    end
end