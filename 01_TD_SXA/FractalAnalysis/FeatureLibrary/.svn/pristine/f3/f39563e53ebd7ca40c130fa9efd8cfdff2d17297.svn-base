function output=NGTDM_strength(calcParam,inputParam) %#ok<INUSD>
fstr = 0;
for i=1:calcParam.Ng
    fstr = fstr + sum((calcParam.p(i)+calcParam.p).*(calcParam.grv(i)-calcParam.grv).^2/(calcParam.e+sum(calcParam.s)));
end
output = fstr;
end
