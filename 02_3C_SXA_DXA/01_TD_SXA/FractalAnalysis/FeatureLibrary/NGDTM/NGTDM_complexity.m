function output=NGTDM_complexity(calcParam,inputParam) %#ok<INUSD>
fcomp = 0;
for i=1:calcParam.Ng
    fcomp = fcomp + sum((calcParam.p(i)*calcParam.s(i) +...
        calcParam.p.*calcParam.s).*abs(calcParam.grv(i)-...
        calcParam.grv)/(calcParam.num*(calcParam.p(i)+calcParam.p)));
end
output = fcomp;
end
%This one looks wrong, wrong, wrong
%I fixed the function in the most obvious way, but haven't taken the time
%to rederive it from the paper.
%Amadasun and King, Textural Features Corresponding to Textural Properties
%IEEE Vol 19, No5, September/October 1989

