function xt_corr = mask_nipple_removing(xt,yt)

maxt = max(xt);
ymax_index = xt==maxt;
yc = yt(ymax_index);

range_index = find(yt<yc+70 & yt>yc-70);
minr = min(range_index);
maxr = max(range_index);
yfit = yt([minr-50:minr,maxr:maxr+50]);
xfit = xt([minr-50:minr,maxr:maxr+50]);
yfit_all = yt(minr-50:maxr+50);

results = polyfit(yfit, xfit,4);
a1 = results(1);
a2 = results(2);
a3 = results(3);
a4 = results(4);
a5 = results(5);

xfitdata = a1*yfit_all.^4 + a2*yfit_all.^3 + a3*yfit_all.^2 + a4*yfit_all + a5;
xt(minr-10:maxr+10) = xfitdata(41:end-40);
xt_corr = xt';
end