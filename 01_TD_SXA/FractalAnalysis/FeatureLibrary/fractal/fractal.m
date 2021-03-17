function [output, outputFeature_id]=fractal(imageObj,maskObj,inputParam) 
CurrentImage=do_mask(imageObj.imageRaw.*imageObj.breastMask, maskObj);
dynamic=str2num(inputParam.main_func.parameter_1); %#ok<ST2NM>
minimum=1;
bins=(0:1000)*(dynamic-imageObj.backGround)/1000;
%Choice to use overall background is highly questionable, perhaps use a
%local background?  But, that makes it less comparable to whole breast...
FlatImage=reshape(CurrentImage,numel(CurrentImage),1);
Histc = histc(FlatImage,bins);
Histc(1)=0;   %erase background from calculation
calcParam.Histp=cumsum(Histc);
calcParam.Histp=calcParam.Histp/(calcParam.Histp(end)+1e-9);
FractalCurrentImage{1}=CurrentImage;
for i=2:4
    FractalCurrentImage{i}=UnderSamplingN(FractalCurrentImage{i-1},2); %#ok<AGROW>
end
calcParam.FractalCurrentImage=FractalCurrentImage;
calcParam.bins=bins;
[output,outputFeature_id]=evaluatesubfunc(calcParam,inputParam);
end