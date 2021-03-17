function  BD=BlockComputeBDDXA()
global Image ROI ctrl Analysis Threshold slice

slice=linkblocksslice(); %file with the slice and related block numbers

newcoordv = [346,568,793,1014,1227,1447,1661]; % grid coordinates
newcoordh = [3,178,366,549,733,923,1101,1292,1472,1658,1841,2045];

myfile=fopen('resultsBlockBD.txt', 'wt');

for k=1:4;
    for m=1:size(slice,2)
        i=slice(k,m,1);
        j=slice(k,m,2);

        if i~=0
            BDblock=Image.material(newcoordh(i):newcoordh(i+1),newcoordv(length(newcoordv)-j):newcoordv(length(newcoordv)-j+1));
            filename=sprintf('TT002.BPR.BD.ES%d.BLA%d.BLB%d.tif',k,i,j);
            imwrite(BDblock,filename); %'A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\BreastDensityBlocks\

            ROI.columns=newcoordv(length(newcoordv)-j+1)-newcoordv(length(newcoordv)-j);
            ROI.ymin = newcoordh(i);
            ROI.rows = newcoordv(length(newcoordv)-j)-newcoordh(i):newcoordh(i+1);
            ROI.xmin = newcoordv(length(newcoordv)-j);

            %% selection of ROI (corresponding to the block)
            temproi=Image.LE(newcoordh(i):newcoordh(i+1),...
                newcoordv(length(newcoordv)-j):newcoordv(length(newcoordv)-j+1));

            size_ROI = size(temproi);
            %res = 0.014; % resolution:
            res = Analysis.Filmresolution/10;
            % figure; imagesc(temproi); colormap(gray); %to check that the right ROI
            % has been selected.

            %% mask creation by background threshold in order to select only the breast or the slice
            bkgr = background_LEimage(temproi)+1000;%2000;
            MaskROI = temproi>bkgr;
            MaskROI=(WindowFiltration2D(MaskROI,3)>0);

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

            Threshold.DXAComputed=true;



            %% Breast density and thickness calculation on the selected ROI:
            roi_material = funcclim(Image.material(newcoordh(i):newcoordh(i+1),...
                newcoordv(length(newcoordv)-j):newcoordv(length(newcoordv)-j+1)).*MaskROI,-50,200);
            roi_thickness = funcclim(Image.thickness(newcoordh(i):newcoordh(i+1),...
                newcoordv(length(newcoordv)-j):newcoordv(length(newcoordv)-j+1)).*MaskROI,-0.5,20);

            %figure; imagesc(MaskROI);colormap(gray);
            %figure; imagesc(roi_thickness);colormap(gray);

            % Breast density calculation
            Analysis.DensityPercentage=nansum(nansum(roi_material.*roi_thickness))/sum(sum(roi_thickness));

            Analysis.Volume = sum(sum(roi_thickness*(res)^2)); % Breast volume calculation
            Analysis.Step = 1.5; % ??? % draweverything;

            % write the result in a text file
            fprintf(myfile, 'TT002.BPR.BD.ES%i.BLA%i.BLB%i.tif \t %i\n', k,i,j,Analysis.DensityPercentage);

        end



    end

end

fclose(myfile)