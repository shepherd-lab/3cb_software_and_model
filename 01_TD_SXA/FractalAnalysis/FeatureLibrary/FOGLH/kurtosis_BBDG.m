function output=kurtosis(calcParam,inputParam) %#ok<INUSD>
Num = length(calcParam.Sorted_vect);
std_image = std(calcParam.Sorted_vect);
mean_image = mean(calcParam.Sorted_vect);
output = sum(((calcParam.Sorted_vect - mean_image)/std_image).^4)/(Num-1);
end
