% function  BD=BlockComputeBDDXA()
global Image ROI Analysis Threshold slice newcoordv newcoordh

% slice=linkblocksslice(); %file with the slice and related block numbers

%open the file in which to write the results for BD:
myfile=fopen('aaTT002resultsBlockBD.txt', 'at');



for k=1:4;
    for m=1:size(slice,2)
        i=slice(k,m,1);
        j=slice(k,m,2);

        if i~=0

            % save LE and HE blocks:
            
%               figure;
%             imagesc(Image.LE); colormap(gray);
%             

            maxLE=max(max(Image.LE(400:1900,20:1500)))
            blockLE=funcclim(positiveLE(newcoordh(length(newcoordh)-i):newcoordh(length(newcoordh)-i+1),...
                                   newcoordv(j):newcoordv(j+1)),1,maxLE);
            blockLE = flipdim(max(blockLE,0),1);
            blockLE = flipdim(blockLE,2);
            blockLE = uint16(blockLE*65535/maxLE);

             filename=sprintf('TT002.BPR.LE.ES%d.BLA%d.BLB%d.tif',k,i,j);
            imwrite(blockLE,filename,'tif');
            
        end
    end
end