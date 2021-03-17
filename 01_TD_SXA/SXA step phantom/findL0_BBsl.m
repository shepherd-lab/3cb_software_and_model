function [y,feval] = findL0_BBs(Xph0, Xim, xp,s)         %rx0, ry0,rz0,tz0,
    %global num_bbs num_thickness
%options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [y,feval] = fminsearch(@projection, Xph0); %, options
    xp = [R0, tz, tx0, ty0,num_bbs,num_thickness];
    R0 = xp(1);
    tz = xp(2);
    tx0 = xp(3);
    ty0 = xp(4);
    num_bbs = xp(5);
    num_thickness = xp(6);
     
    function L0 = projection(Xph) % Compute the polynomial.
            
       for k = 1:num_thickness
          Xim_calc((k-1)*num_bbs+1:k*num_bbs,:) = bbProjector(Xph((k-1)*num_bbs+1:k*num_bbs,:),tx0,ty0,tz(k),R0,s); 
       end       
       Q = Xim(:,1:2) - Xim_calc(:,1:2);
       L0 = trace(Q*Q');  
    end
end
  

