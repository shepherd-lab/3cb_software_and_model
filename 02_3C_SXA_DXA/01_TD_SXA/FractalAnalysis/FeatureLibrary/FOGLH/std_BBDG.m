function output=std_BBDG(calcParam,inputParam) %#ok<INUSD>
std_image = std(calcParam.Sorted_vect);
output = std_image;
end
