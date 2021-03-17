function [leanCurCoef, fatCurCoef] = computeLeanFatCurve(SXAcurCoef, kTable)

thicknesses = (1:9)';
kTable_H = kTable(:, 1)
kTable_lean = kTable(:, 2)
kTable_m = kTable(:, 3)

n = length(thicknesses);
leanCurve = zeros(n, 1);
fatCurve = zeros(n, 1);

for i = 1:n
    H = thicknesses(i)
    klean = interp1(kTable_H, kTable_lean, H, 'linear', 'extrap')
    km = interp1(kTable_H, kTable_m, H, 'linear', 'extrap')
    SXAfitVal = SXAcurCoef(1)*H^2 + SXAcurCoef(2)*H + SXAcurCoef(3)
    leanCurve(i) = klean * SXAfitVal
    fatCurve(i) = klean*(SXAfitVal + (1/km - 1)*(SXAcurCoef(1)*H^2 + SXAcurCoef(2)*H))
end

leanCurCoef = polyfit(thicknesses, leanCurve, 2);
fatCurCoef = polyfit(thicknesses, fatCurve, 2);