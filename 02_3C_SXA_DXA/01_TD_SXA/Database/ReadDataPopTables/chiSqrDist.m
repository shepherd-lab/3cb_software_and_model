function chiSqr = chiSqrDist(params, posInPh, posOnImg)

n = length(posInPh);
posCal = calcBbImgPos(params, posInPh);
chiSqr = 0;

for i = 1:n
    chiSqr = (posCal(i).x - posOnImg(i).x)^2 +(posCal(i).y - posOnImg(i).y)^2 + chiSqr;
end
chiSqr;