function [output, outputFeature_id]=HZPROJ(imageObj,maskObj,param) 
CurrentImage=do_mask(imageObj.imageRaw.*imageObj.breastMask,maskObj);
%HZ_PROJ
signal=sum(CurrentImage'); %#ok<UDIM>
%find the row where the number of pixel id less than 10 and destroy them
pixels=sum(CurrentImage'>0);
RowsToKeep=pixels>=10;
[Sorted,indexSort]=sort(RowsToKeep);
[maxi,index]=max(Sorted); %#ok<ASGLU>
signal=signal./pixels;
signal(indexSort(1:index-1))=[];
output=(var(signal))^0.5/1000;
outputFeature_id=param.sub_func{1}.feature_id;
end