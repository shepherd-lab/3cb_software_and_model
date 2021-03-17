function [output, outputFeature_id]=CONTDIM(imageObj,maskObj,inputParam) 
CurrentImage=do_mask(imageObj.imageRaw.*imageObj.breastMask, maskObj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Continuous dimension %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CdYintX=1:5;
for k=CdYintX
    S=4*k+1;
    %Prolongate Image to avoid border effect
    ImageYint2=[CurrentImage(:,1)*ones(1,2*k) CurrentImage CurrentImage(:,end)*ones(1,2*k)];
    ImageYint2=[ones(2*k,1)*ImageYint2(1,:); ImageYint2; ones(2*k,1)*ImageYint2(end,:)]; %#ok<AGROW>
    filter=ones(S)/S^2;
    ConvImage=conv2(ImageYint2,filter,'valid');
    ImageYint3=CurrentImage-ConvImage;
    [gradiant,imageGrad]=MyGradiant(ImageYint3); %#ok<NASGU>
    GradYint(k)=log10(gradiant); %#ok<AGROW>
end
%continuous dimension
calcParam.p = polyfit(log10(CdYintX),GradYint,1);
[output,outputFeature_id]=evaluatesubfunc(calcParam,inputParam);
end