function [output, outputFeature_id]=NGTDM(imageObj,maskObj,inputParam)
image=do_mask(imageObj.breastMask.*imageObj.imageRaw,maskObj);
d = str2num(inputParam.main_func.parameter_1); %#ok<ST2NM> %sampling neighborhood
im_size = size(image);
min_image = min(min(image));
image = round((image-min_image)/4) + round(min_image/4);
%reducing bit depth
max_image = max(max(image));
min_image = min(min(image));
fun=@neighAverage;
A=(1/((2*d+1)^2-1))*nlfilter(image,[2*d+1,2*d+1],fun);
A = A(d+1:im_size(1)-d,d+1:im_size(2)-d);
j = 0;
image_crop = image(d+1:im_size(1)-d,d+1:im_size(2)-d);
calcParam.num = (im_size(1)-2*d)*(im_size(2)-2*d);
num_levels = max_image-min_image+1;
%check whether or not the +1 should be there.
calcParam.s = zeros(1, num_levels);
calcParam.N = zeros(1, num_levels);
calcParam.p = zeros(1, num_levels);
calcParam.grv = zeros(1, num_levels);
for i=min_image:max_image
    index = find(image_crop==i);
    if ~isempty(index)
        j=j+1;
        calcParam.grv(j) = i-min_image;
        calcParam.s(j) = sum(abs(A(index)-i));
        calcParam.N(j) = length(index);
        calcParam.p(j) = (calcParam.N(j)/calcParam.num);
    end
end
calcParam.Ng = length(calcParam.s);
calcParam.e = 10e-12;
[output,outputFeature_id]=evaluatesubfunc(calcParam,inputParam);
%need to add call procedure for subfunctions
end

