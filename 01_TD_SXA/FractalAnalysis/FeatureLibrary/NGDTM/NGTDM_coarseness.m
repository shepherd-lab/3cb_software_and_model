function output=NGTDM_coarseness(calcParam,inputParam) %#ok<INUSD>
output = 1/(calcParam.e + sum(calcParam.p.*calcParam.s));
end
