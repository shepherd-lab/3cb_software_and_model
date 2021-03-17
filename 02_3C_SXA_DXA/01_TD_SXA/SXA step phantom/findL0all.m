function [y,feval] = findL0_all(x0, Xim, Xph,s)         %rx0, ry0,rz0,tz0,
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [y,feval] = fminsearch(@projection, x0); %, options
   % rx0 = x0(1);
   % ry0 = x0(2);
   % rz0 = x0(3);
   % tz0 = x0(4);
    
    function L0 = projection(x) % Compute the polynomial.
       rx = x(1);
       ry = x(2);
       rz = x(3);
       tz = x(4);
       tx = x(5);
       ty = x(6);
     %  x0corr = x(7);
     %  y0corr = x(8);
       R0 =  rotation_matrix(rx, ry, rz); 
       [Xim_calc]=bbProjector(Xph,tx,ty,tz,R0,s); 
      % Xim(:,2) = Xim(:,2) + y0corr;
      % Xim(:,1) = Xim(:,1) + x0corr;
       Q = Xim(:,1:2) - Xim_calc(:,1:2);
       L0 = trace(Q*Q');  
    end
end
  

