function y = findL0(x0, Xim, Xph,s,tx0,ty0)         %rx0, ry0,rz0,tz0,
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [y,fval,exitflag,output] = fminsearch(@projection, x0) %, options
   % rx0 = x0(1);
   % ry0 = x0(2);
   % rz0 = x0(3);
   % tz0 = x0(4);
    
    function L0 = projection(x) % Compute the polynomial.
       rx = x(1);
       ry = x(2);
       rz = x(3);
       tz = x(4);
       R0 =  rotation_matrix(rx, ry, rz); 
       [Xim_calc]=bbProjector(Xph,tx0,ty0,tz,R0,s); 
       Q = Xim(:,1:2) - Xim_calc(:,1:2);
       L0 = trace(Q*Q');  
    end
end
  

