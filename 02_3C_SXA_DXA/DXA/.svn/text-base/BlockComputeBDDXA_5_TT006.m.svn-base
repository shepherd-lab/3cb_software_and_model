% function  BD=BlockComputeBDDXA()
global Image ROI Analysis Threshold sliceTT006 newcoordv newcoordh

% slice=linkblocksslice(); %file with the slice and related block numbers

%open the file in which to write the results for BD:
% % myfile=fopen('aaaTT006RresultsBlockBD.txt', 'at');
% % 
% % filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.BPR.LE.SH5.tif'];
% % imwrite(uint16(Image.LE),filename,'tif');
% % filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.BPR.HE.SH5.tif'];
% % imwrite(uint16(Image.HE),filename,'tif');
% % filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.BPR.BD.SH5.tif'];
% % imwrite(uint16(Image.material*100),filename,'tif');
% % filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.BPR.BT.SH5.tif'];
% % imwrite(uint16(Image.thickness*1000),filename,'tif');
% 
% filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.LE.SH1.png'];
% imwrite(uint16(Image.LE),filename,'png');
% filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.HE.SH1.png'];
% imwrite(uint16(Image.HE),filename,'png');
% 
% filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\Imagespecial.mat'];
% totalimage=Image;
% save(filename,'totalimage');
% 
% filename=['Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\TT006.BT.SH1.png'];
% imwrite(int16(Image.thickness),filename,'png');

slice=sliceTT006;

for k=12;
    for m=1:size(slice,2)
        i=slice(k,m,1);
        j=slice(k,m,2);

        if i~=0

%% save LE and HE blocks:

            maxLE=max(max(Image.LE(400:1900,20:1500)));

            blockLE=funcclim(Image.LE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1)),1,maxLE);
            blockLE = flipdim(max(blockLE,0),1);
            blockLE = flipdim(blockLE,2);
            blockLE = uint16(blockLE);
            filename=sprintf('TT006.BPR.LE.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\try\' filename];
            imwrite(blockLE,filename,'tif');

            maxHE=max(max(Image.HE(400:1900,20:1500)));
            blockHE=Image.HE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1));
            blockHE = flipdim(max(blockHE,0),1);
            blockHE = flipdim(blockHE,2);
            blockHE = uint16(blockHE);
            filename=sprintf('TT006.BPR.HE.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\try\' filename];
            imwrite(blockHE,filename,'tif');


%% creation of Mask ROI
            ROI.columns=newcoordv(j+1)-newcoordv(j);
            ROI.ymin = newcoordh(length(newcoordh)-i);
            ROI.rows = newcoordh(length(newcoordh)-i+1)-newcoordh(length(newcoordh)-i);
            ROI.xmin = newcoordv(j);

            %% selection of ROI (corresponding to the block)
            temproi=Image.LE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1));

            size_ROI = size(temproi);
      
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
            [ry,rx]=size(MaskROI);

            BW2=(conv2(+MaskROI,+ones(3),'same')>0);
            boundary=BW2-MaskROI;
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

     
%% Breast density and thickness calculation on the selected ROI:
            roi_material = funcclim(Image.material(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1)).*MaskROI,0,100);
            roi_thickness = funcclim(Image.thickness(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                newcoordv(j):newcoordv(j+1)).*MaskROI,0,2);


            % save the blocks for BD:
            maxBD=max(max(Image.material(400:1900,20:1500)));
            blockBD=roi_material;
            blockBD = flipdim(max(blockBD,0),1);
            blockBD = flipdim(blockBD,2); % double flip to get the right orientation
            blockBD = uint16(blockBD*100);
            filename=sprintf('TT006.BPR.BD.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\try\' filename];
            imwrite(blockBD,filename,'tif');

            % save the blocks for Thickness:
            maxT=max(max(Image.thickness(400:1900,20:1500)));
            blockT=roi_thickness;
            blockT = flipdim(blockT,1);
            blockT = flipdim(blockT,2); % double flip to get the right orientation
%             figure;imagesc(blockT);
            blockT = uint16(blockT*1000);
%             figure;imagesc(blockT);
            filename=sprintf('TT006.BPR.BT.ES%d.BLA%d.BLB%d.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\TT006\TT006R_tif_files\try\' filename];
            imwrite(blockT,filename,'tif');

%% Breast density calculation
            Analysis.DensityPercentage=nansum(nansum(roi_material.*roi_thickness))/sum(sum(roi_thickness));
            
            Analysis.DenseVolume = nansum(nansum(1/100*roi_material.*roi_thickness*(0.014)^2)); 
            Analysis.Volume = nansum(nansum(roi_thickness*(0.014)^2));                      
            
% % %%             write the result in a text file
% %           fprintf(myfile, 'TT006.BPR.BD.ES%i.BLA%i.BLB%i.tif \t %i\t %i\t %i\n', k,i,j,Analysis.DensityPercentage, Analysis.DenseVolume, Analysis.Volume );
        end



    end

end

% fclose(myfile)

%% QA: Rebuild the images from the slices:

