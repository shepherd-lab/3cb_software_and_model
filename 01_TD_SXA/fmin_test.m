function xout = fmin_test(x0,A,b)
    options = optimset('Display','iter','TolFun',1e-8);
    a = [A, b];
    xout = fminsearch(@myfun,x0,a) %fval,exitflag,output]
    %where myfun is an M-file function such as function f = myfun(x)
    

function f = myfun(x, a)
    f = a(1) * x(1).*x(1) + a(2)*x(2).* x(2);            % Compute function value at x