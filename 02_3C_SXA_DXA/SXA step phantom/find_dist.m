function  find_dist(xy) %dist =
X = xy(:,1);
Y = xy(:,2);
x = mean(xy(:,1));
y = mean(xy(:,2));
D = sqrt((X - x).^2 + (Y - y).^2);
[M idx] = sort(D);
X(idx(1:4))
Y(idx(1:4))