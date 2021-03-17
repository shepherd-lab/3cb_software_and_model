function output=fractal_caldwell(calcParam,inputParam) %#ok<INUSD>
x=1:4;
for k=x
    tempImage=abs(calcParam.FractalCurrentImage{k}(1:end-1,1:end-1)...
        -calcParam.FractalCurrentImage{k}(2:end,1:end-1))+...
        abs(calcParam.FractalCurrentImage{k}(1:end-1,1:end-1)-...
        calcParam.FractalCurrentImage{k}(1:end-1,2:end));
    CalwellSurface(k)=log10(sum(sum(tempImage))); %#ok<AGROW>
end
p = polyfit(x,CalwellSurface,1);
output=-p(1)/log10(2);
end
