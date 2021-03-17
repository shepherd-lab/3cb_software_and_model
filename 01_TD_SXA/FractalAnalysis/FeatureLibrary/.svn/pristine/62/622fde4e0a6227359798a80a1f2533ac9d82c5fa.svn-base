function output=balance_BBDG(calcParam,inputParam) %#ok<INUSD>
min_image = round(min(calcParam.Sorted_vect));
max_image = round(max(calcParam.Sorted_vect));
bin = min_image:0.5:max_image;
histogram=double(histc(reshape(calcParam.CurrentImage,1,numel(calcParam.CurrentImage)),bin));
sum100 = sum(histogram);
sum30 = sum100*0.3;
sum70 = sum100*0.7;
mean_image = mean(calcParam.Sorted_vect);
grmean = mean_image;
sum_hist = cumsum(histogram);
gr30_index = find(sum_hist>sum30);
gr30 = sum_hist(gr30_index(1)-1);
gr70_index = find(sum_hist>sum70);
gr70 = sum_hist(gr70_index(1)-1);
output = (gr70 - grmean)/(grmean - gr30);
end
