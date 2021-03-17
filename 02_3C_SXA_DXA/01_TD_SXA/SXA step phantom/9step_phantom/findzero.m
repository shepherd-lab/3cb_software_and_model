function y = findzero(a, x0)
   options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [y,fval,exitflag,output] = fminsearch(@poly, x0, options)

        function y = poly(x) % Compute the polynomial.
           y = a(1) * x(1).*x(1) + a(2)*x(2).* x(2);   
        end
end
  

