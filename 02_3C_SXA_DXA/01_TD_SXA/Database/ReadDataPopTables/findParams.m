function [H, tc] = findParams(H0, tc0, posInPh, posOnImg)

delta = 1;

x0_0 = (H0 - delta - tc0)/H0 * posOnImg(1).x - posInPh(1).x;
y0_0 = (H0 - delta - tc0)/H0 * posOnImg(1).y - posInPh(1).y;
params0 = [x0_0, y0_0, 0, H0, tc0];

params = fminsearch(@(params) chiSqrDist(params, posInPh, posOnImg), params0, optimset('TolX', 1e-8, 'MaxFunEvals', 5000));
H = params(4);
tc = params(5);
