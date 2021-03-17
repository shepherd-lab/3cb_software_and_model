function spot_mask = find_rectspot(br_3)

im_size = size(br_3);
xm = im_size(2);
ym = im_size(1);
xpr = round([xm/4,xm/4]);
ypr = round([100,ym-100]);
ln1 =  improfile(br_3,xpr,ypr);
maxln = max(ln1);
minln = min(ln1);
thresh = (maxln - minln)/2;
ln2= ln1>thresh;
ind = find(ln2==1);
ids = kmeans(ind,2);
ln1 = [ind,ids];
ids_1 = find(ln1(:,2) == 1);
ids_2 = find(ln1(:,2) == 2);
y_1 = mean(ind(ids_1));
y_2 = mean(ind(ids_2));

if y_1 > y_2
    ymax_roi = y_1-50 +100;
    ymin_roi = y_2+50 +100;
else
    ymax_roi = y_2-50 +100;
    ymin_roi = y_1+50 +100;
end

% % figure;imagesc(br_3);colormap(gray);hold on;
% % plot(xpr,ymax_roi, 'b*',xpr, ymin_roi,'r*');

rows = [ymin_roi ymin_roi ymax_roi ymax_roi];
cols = [1 xm xm 1];
spot_mask = roipoly(br_3, cols, rows);
% breast_spot = Image.image.*spot_mask;
% figure;imagesc(breast_spot);colormap(gray);

a = 1;


