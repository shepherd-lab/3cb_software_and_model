function output=fractal_threshold(calcParam,inputParam)
%param1 is FractalThreshold*100
FractalThreshold=str2num(inputParam.parameter_1)/100; %#ok<ST2NM>
[maxi,thresholdindex]=max(calcParam.Histp>FractalThreshold); %#ok<ASGLU>
threshold=calcParam.bins(thresholdindex);
%compute fractal dimension (feature 1: FD_th_x%)
x=1:4;
for k=x
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Fractal dimension of thresholded image "FD_th"
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    image = (calcParam.FractalCurrentImage{k}>threshold);
    [gradiant,gradimage]=myGradiant(image); %#ok<NASGU>
    FD_Th(k)=log10(gradiant+1e-9); %#ok<AGROW>
end
%fractal analysis FD_TH
p = polyfit(x,FD_Th(:)',1);
output=-p(1)/log10(2);
end
