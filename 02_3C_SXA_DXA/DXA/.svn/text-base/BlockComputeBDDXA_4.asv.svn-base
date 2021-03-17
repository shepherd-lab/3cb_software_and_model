% function  BD=BlockComputeBDDXA()
global Image ROI Analysis Threshold slice newcoordv newcoordh

% slice=linkblocksslice(); %file with the slice and related block numbers

%open the file in which to write the results for BD:
myfile=fopen('aaTT002resultsBlockBD.txt', 'at');

% a=Image.material;
% 
% save fileimagematerial.m a 

for k=1:4;
    for m=1:size(slice,2)
%         i=slice(k,m,1);
%         j=slice(k,m,2);

i=3;j=6;

        if i~=0

            % save LE and HE blocks:
                       
            maxLE=max(max(Image.LE(400:1900,20:1500)));
        
            blockLE=funcclim(Image.LE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                                   newcoordv(j):newcoordv(j+1)),1,maxLE);
                     
            blockLE = flipdim(max(blockLE,0),1);
            blockLE = flipdim(blockLE,2);
            blockLE = uint16(blockLE*65535/maxLE);

            filename=sprintf('TT002.BPR.LE.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
            imwrite(blockLE,filename,'tif');
            
            maxHE=max(max(Image.HE(400:1900,20:1500)));
            blockHE=Image.HE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                                   newcoordv(j):newcoordv(j+1));
            blockHE = flipdim(max(blockHE,0),1);
            blockHE = flipdim(blockHE,2);
            blockHE = uint16(blockHE*65535/maxHE);
            filename=sprintf('TT002.BPR.HE.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
            imwrite(blockHE,filename,'tif');

           

            ROI.columns=newcoordv(j+1)-newcoordv(j);
            ROI.ymin = newcoordh(length(newcoordh)-i);
            ROI.rows = newcoordh(length(newcoordh)-i+1)-newcoordh(length(newcoordh)-i);
            ROI.xmin = newcoordv(j);

            %% selection of ROI (corresponding to the block)
            temproi=Image.LE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1));

            size_ROI = size(temproi);
            res = 0.014; % resolution:
            % figure; imagesc(temproi); colormap(gray); %to check that the right ROI has been selected.

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
            roi_material = funcclim(Image.material(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1)).*MaskROI,0,100);
            roi_thickness = funcclim(Image.thickness(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1)).*MaskROI,-0.5,20);

            %% save the blocks for BD and T:
%              maxBD=max(max(Image.material(400:1900,20:1500)));
%             blockBD=roi_material;
%             blockBD = flipdim(max(blockBD,0),1);
%             blockBD = flipdim(blockBD,2); % double flip to get the right orientation
% %             blockBD = uint16(blockBD*65535/100);
%               blockBD = uint16(blockBD);
%             filename=sprintf('TT002.BPR.BD.ES%d.BLA%d.BLB%d.tif',k,i,j);
%             filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
%             imwrite(blockBD,filename,'tif');

            maxBD = 100;
            blockBD=roi_material;         
%             blockBD(blockBD<0) = 0;
%             blockBD(blockBD>maxBD) = 0;
            blockBD = flipdim(blockBD,1);
            blockBD = flipdim(blockBD,2); % double flip to get the right orientation
            figure;imagesc(blockBD);
            blockBD = uint16(blockBD);
            figure;imagesc(blockBD);
            filename=sprintf('TT002.BPR.BD.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
            imwrite(blockBD,filename,'tif');
            
            
            
            
            maxT=max(max(Image.thickness(400:1900,20:1500)));
            blockT=roi_thickness;
            blockT = flipdim(blockT,1);
            blockT = flipdim(blockT,2); % double flip to get the right orientation
%             blockT = uint16(blockT*65535/maxT);
 figure;imagesc(blockT);
            blockT = im2int16(blockT);
            figure;imagesc(blockT);
            filename=sprintf('TT002.BPR.BT.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
            imwrite(blockT,filename,'tif');

            %figure; imagesc(MaskROI);colormap(gray);
            %figure; imagesc(roi_thickness);colormap(gray);

%             % Breast density calculation
%             Analysis.DensityPercentage=nansum(nansum(roi_material.*roi_thickness))/sum(sum(roi_thickness));
% 
%             Analysis.Volume = sum(sum(roi_thickness*(res)^2)); % Breast volume calculation
%             Analysis.Step = 1.5; % ??? % draweverything;
% 
% %             write the result in a text file
%             fprintf(myfile, 'TT002.BPR.BD.ES%i.BLA%i.BLB%i.tif \t %i\n', k,i,j,Analysis.DensityPercentage);
        end



    end

end

fclose(myfile)