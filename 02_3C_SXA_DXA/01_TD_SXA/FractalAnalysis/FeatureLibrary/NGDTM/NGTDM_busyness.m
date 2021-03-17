function output=NGTDM_busyness(calcParam,inputParam) %#ok<INUSD>
fbusy = 0;
for i=1:calcParam.Ng
    fbusy = fbusy + sum((calcParam.grv(i)*calcParam.p(i)-calcParam.grv.*calcParam.p).^2/(calcParam.e+sum(calcParam.s)));
end
output = sum(calcParam.p.*calcParam.s)/fbusy;
end
