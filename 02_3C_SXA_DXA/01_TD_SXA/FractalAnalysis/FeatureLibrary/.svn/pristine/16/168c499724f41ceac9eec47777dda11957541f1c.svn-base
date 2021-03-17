function output=glcm_enthropy(calcParam, inputParam) %#ok<INUSD>
Flatglcm=reshape(calcParam.glcmroi_norm,1,numel(calcParam.glcmroi_norm));
Sorted_glcm=sort(Flatglcm,2);
[maxi,index]=max(Sorted_glcm>0); %#ok<ASGLU>
Sorted_glcm(1:index-1)=[];
output = sum(Sorted_glcm.*(-log(Sorted_glcm)));
end
