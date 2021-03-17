function output=fractal_rms(calcParam,inputParam) %#ok<INUSD>
x=1:4;
for k=x
    FlatImage=reshape(calcParam.FractalCurrentImage{k},1,numel(calcParam.FractalCurrentImage{k}));
    Sorted=sort(FlatImage,2);
    [maxi,index]=max(Sorted>0); %#ok<ASGLU>
    Sorted(1:index-1)=[];
    resultVar(k)=log10(var(Sorted))/2; %#ok<AGROW>
end
p = polyfit(x,resultVar,1);
output=-p(1)/log10(2);
end
