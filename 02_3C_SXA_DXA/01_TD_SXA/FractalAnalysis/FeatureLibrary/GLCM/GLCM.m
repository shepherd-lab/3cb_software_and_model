function [output, outputFeature_id]=GLCM(imageObj,maskObj,inputParam)
%%%%%%%%%%%%%%%%%%%%%%%%%  GRAY-LEVEL CO_OCCURRENCE MATRIX (GLCM)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create gray-level co-occurrence matrix from image
image=imageObj.imageRaw.*imageObj.breastMask;
min_image = min(min(image));
if min_image < 0 && abs(min_image)< 10000
    image = (image - min_image+1);
else 
    image=imageObj.imageRaw;
end
FlatImage=reshape(image,1,numel(image));
Sorted_vect=sort(FlatImage,2);
[maxi,index]=max(Sorted_vect>0); %#ok<ASGLU>
Sorted_vect(1:index-1)=[];
min_image = round(min(Sorted_vect));
max_image = round(max(Sorted_vect));
%use min and max determined by entire breast, not subregion
Ng = str2num(inputParam.main_func.parameter_1); %#ok<ST2NM>
image=do_mask(image, maskObj);
glcm_roi = graycomatrix(image,'NumLevels',Ng,'GrayLimits',[min_image max_image]);
calcParam.stats = graycoprops(glcm_roi);
calcParam.Ng=Ng;
N = sum(sum(glcm_roi));
calcParam.glcmroi_norm = glcm_roi/N;
mx = 0; my = 0;
for i = 1:Ng
    mx = mx + i*sum(calcParam.glcmroi_norm(i,:));
end

for j = 1:Ng
    my = my + j*sum(calcParam.glcmroi_norm(:,j));
end
calcParam.mx=mx;
calcParam.my=my;
[output,outputFeature_id]=evaluatesubfunc(calcParam,inputParam);
end