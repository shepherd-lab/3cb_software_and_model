function [output, outputFeature_id]=FOGLH(imageObj,maskObj,inputParam)
calcParam.CurrentImage=do_mask(imageObj.imageRaw.*imageObj.breastMask, maskObj);
min_CurrentImage = min(min(calcParam.CurrentImage));
if min_CurrentImage < 0 && abs(min_CurrentImage)< 10000
    calcParam.CurrentImage = (calcParam.CurrentImage - min_CurrentImage+1);
end
FlatImage=reshape(calcParam.CurrentImage,1,numel(calcParam.CurrentImage));
calcParam.Sorted_vect=sort(FlatImage,2);
[maxi,index]=max(calcParam.Sorted_vect>0); %#ok<ASGLU>
calcParam.Sorted_vect(1:index-1)=[];
[output,outputFeature_id]=evaluatesubfunc(calcParam,inputParam);
end