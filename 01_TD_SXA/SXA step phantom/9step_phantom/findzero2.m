function y = findzero2(a, x0)
   options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [y,fval,exitflag,output] = fminsearch(@projection, x0, options)

    function f = projection(x) % Compute the polynomial.
           f = a(1) * x(1).*x(1) + a(2)*x(2).* x(2);   
        end
end
  

