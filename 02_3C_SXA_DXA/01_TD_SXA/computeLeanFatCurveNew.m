function [leanCurCoef, fatCurCoef] = computeLeanFatCurveNew(SXARoi, kLeanTable, Gen3CoefOnH)
%not finished yet

thicknesses = SXARoi(:, 1);
SXAatnu = SXARoi(:, 2);
kTable_H = kLeanTable(:, 1);
kTable_lean = kLeanTable(:, 2);

leanCurve = zeros(9, 1);
fatCurve = zeros(9, 1);
SXAcoef = polyfit(thicknesses, SXAatnu, 2);
SXAfitCur = SXAcoef(1).*thicknesses.^2 + SXAcoef(2).*thicknesses + SXAcoef(3);
for i = 1:9
    H = thicknesses(i);
    kLean = interp1(kTable_H, kTable_lean, H, 'linear', 'extrap');
    leanCurve(i) = kLean * SXAfitCur(i);
    
    %get the fat reference curve
    dens = [0 50 100];
    atnuAtH = zeros(1, 3);
    for j = 1:3 %calculate attnuation for each density at H
        atnuAtH(j) = Gen3CoefOnH(j, 1)*H^2 + Gen3CoefOnH(j, 2)*H + Gen3CoefOnH(j, 3);
    end
    polyCoefAtH = polyfit(dens, atnuAtH, 2);
    
    fatCurve(i) = klean*(SXAfitCur(i) + (1/km - 1)*(2*SXAcoef(1)*H^2 + SXAcoef(2)*H));
end

leanCurCoef = polyfit(thicknesses, leanCurve, 2);
fatCurCoef = polyfit(thicknesses, fatCurve, 2);