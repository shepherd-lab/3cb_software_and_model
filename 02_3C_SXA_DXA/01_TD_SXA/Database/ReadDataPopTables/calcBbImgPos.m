function X = calcBbImgPos(params, posInPh)
%params has 5 elements: phan_x0, phan_y0, theta, srcH, buckyD

x0 = params(1);
y0 = params(2);
theta = params(3);
H = params(4);
tc = params(5);

n = length(posInPh);
xPh = zeros(1, n);
yPh = zeros(1, n);
zPh = zeros(1, n);
for i = 1:n
    xPh(i) = posInPh(i).x;
    yPh(i) = posInPh(i).y;
    zPh(i) = posInPh(i).z;
end

X(n) = struct('x', [], 'y', []);

posWorld = zeros(3, n);
posWorld(1, :) = xPh.*cos(theta) - yPh.*sin(theta) + x0;
posWorld(2, :) = xPh.*sin(theta) + yPh.*cos(theta) + y0;
posWorld(3, :) = zPh + tc;

for i = 1:n
    X(i).x = H/(H - posWorld(3, i))*posWorld(1, i);
    X(i).y = H/(H - posWorld(3, i))*posWorld(2, i);
end