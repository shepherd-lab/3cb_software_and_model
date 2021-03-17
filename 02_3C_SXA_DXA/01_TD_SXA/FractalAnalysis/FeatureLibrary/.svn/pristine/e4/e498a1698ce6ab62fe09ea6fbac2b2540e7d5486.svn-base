function output=NGTDM_contrast(calcParam,inputParam) %#ok<INUSD>
fcon2 = 0;
sum_s = sum(calcParam.s)/calcParam.num;
for i=1:calcParam.Ng
    fcon2 = fcon2 + sum(calcParam.p(i)*calcParam.p.*(calcParam.grv(i)-calcParam.grv).^2/((calcParam.Ng*calcParam.Ng-1)*sum_s));
end
output = fcon2;
end