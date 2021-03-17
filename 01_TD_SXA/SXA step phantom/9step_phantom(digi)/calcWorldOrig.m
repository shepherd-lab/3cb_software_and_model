function origDiff = calcWorldOrig(groups)

%the function returns the origin displacement from the image mid-point
%in terms of pixels
%function equivalent to QCbbs_sorting except passing-in parameters are
%grouped BBs (see Song Note p.14 and p.70 for the order of groups)

global Analysis ROI figuretodraw Image

%re-assign the middle four groups to group 1 to 4
group1_coord = groups(3).coord;
group2_coord = groups(5).coord;
group3_coord = groups(4).coord;
group4_coord = groups(6).coord;

%calculate the center of each group
mean_gr1 = mean(group1_coord);
mean_gr2 = mean(group2_coord);
mean_gr3 = mean(group3_coord);

delta_x =  mean_gr2(1) - mean_gr1(1);

%create x- and y-shift values for converting coordinate from ROI to film
xShift = ROI.xmin - 1;
yShift = ROI.ymin - 1;

%crop a smaller ROI to the size of just density steps (no bookends);
Analysis.xmin = mean_gr1(1) - delta_x + xShift;
Analysis.xmax = mean_gr2(1) + delta_x - 30 + xShift;
Analysis.ymin = mean_gr1(2) + 100 + yShift; 
Analysis.ymax = mean_gr3(2) - 100 + yShift;


Line1.x1 = group1_coord(1, 1) + xShift; %coord(gr1_index(1), 1);
Line1.x2 = group1_coord(2, 1) + xShift; %coord(gr1_index(2), 1);
Line1.y1 = group1_coord(1, 2) + yShift; %coord(gr1_index(1), 2) + ROI.ymin;
Line1.y2 = group1_coord(2, 2) + yShift; %coord(gr1_index(2), 2) + ROI.ymin;

slope1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
Line1.x0 = 1;
Line1.y0 = (Line1.x2 - Line1.x0) * slope1 + Line1.y2;
figure(figuretodraw);
plot([Line1.x0 Line1.x2], [Line1.y0 Line1.y2], 'Linewidth', 1, 'color', 'b');
hold on;

Line2.x1 = group2_coord(1, 1) + xShift; %coord(gr2_index(1),1);
Line2.x2 = group2_coord(2, 1) + xShift; %coord(gr2_index(2),1);
Line2.y1 = group2_coord(1, 2) + yShift; %coord(gr2_index(1),2)+ROI.ymin;
Line2.y2 = group2_coord(2, 2) + yShift; %coord(gr2_index(2),2)+ROI.ymin;

slope2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
Line2.x0 = 1;
Line2.y0 = (Line2.x2 - Line2.x0) * slope2 + Line2.y2;
plot([Line2.x0 Line2.x2], [Line2.y0 Line2.y2], 'Linewidth', 1, 'color', 'b');

Line3.x1 = group3_coord(1, 1) + xShift; %coord(gr3_index(1),1);
Line3.x2 = group3_coord(2, 1) + xShift; %coord(gr3_index(2),1);
Line3.y1 = group3_coord(1, 2) + yShift; %coord(gr3_index(1),2)+ROI.ymin;
Line3.y2 = group3_coord(2, 2) + yShift; %coord(gr3_index(2),2)+ROI.ymin;

slope3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
Line3.x0 = 1;
Line3.y0 = (Line3.x2 - Line3.x0) * slope3 + Line3.y2;
plot([Line3.x0 Line3.x2], [Line3.y0 Line3.y2], 'Linewidth', 1, 'color', 'b');

Line4.x1 = group4_coord(1, 1) + xShift; %coord(gr4_index(1),1);
Line4.x2 = group4_coord(2, 1) + xShift; %coord(gr4_index(2),1);
Line4.y1 = group4_coord(1, 2) + yShift; %coord(gr4_index(1),2)+ROI.ymin;
Line4.y2 = group4_coord(2, 2) + yShift; %coord(gr4_index(2),2)+ROI.ymin;

slope4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
Line4.x0 = 1;
Line4.y0 = (Line4.x2 - Line4.x0) * slope4 + Line4.y2;
plot([Line4.x0 Line4.x2], [Line4.y0 Line4.y2], 'Linewidth', 1, 'color', 'b');



I12=funcComputeIntersection(Line1, Line2);
I13=funcComputeIntersection(Line1, Line3);
I14=funcComputeIntersection(Line1, Line4);
I23=funcComputeIntersection(Line2, Line3);
I24=funcComputeIntersection(Line2, Line4);
I34=funcComputeIntersection(Line3, Line4);

point_0 = [I12; I13; I14; I23; I24; I34];
mean_0 = mean(point_0);

plot(mean_0(1), mean_0(2), '.r', 'MarkerSize', 7);
xim_0 = mean_0(1);
yim_0 = mean_0(2);
sz_image = size(Image.image);
Analysis.x0cm_diff = xim_0 * Analysis.Filmresolution * 0.1;
Analysis.y0cm_diff = (sz_image(1)/2 - yim_0) * Analysis.Filmresolution * 0.1;

origDiff = [xim_0 sz_image(1)/2 - yim_0];

