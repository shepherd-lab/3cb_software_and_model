% Program used to copy the first 200 image files from the cpmc images which
% have received on SXA analysis on the local drive.
% This is to measure the time of reanalysis depending on if the files are
% locally or networkally stored.

global Database
AcqList=mxDatabase(Database.Name,'select filename from acquisition, commonanalysis, sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id',200);
for index=1:size(AcqList)
   originFilename=deblank(AcqList{index});
   DestinationFilename=originFilename;DestinationFilename(1)='C';
   copyfile(originFilename,DestinationFilename);
end