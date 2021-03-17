
function [y, feval] = findmin_sinoiterative()
          % create initial 
          %x0 = [thick, inten, diam]
          %calculate breast sinogramm
          %breast_sino = 
        %ten iterations  
          for i = 1:10  
               [y,feval] = findmin_sinogram(x0, breast_sino,extra_params); 
               x0 = y;
           end

end


%%

function [y,feval] = findmin_sinogram(x0, breast_sino,extra_params)       
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
   %x0 - initial parameters
    [y,feval] = fminsearch(@rmse_calc, x0); %, options
%   thick= x0(1); 
%   inten= x0(2);
%   diam = x0(3);
      
    function L0 = rmse_calc(x) % Compute the polynomial.
       thick = x(1);
       inten = x(2);
       diam = x(3);
       % function for calculation of sinogram vector
       calc_sino = calc_sinogram(thick,inten,diam);
       Q = breast_sino - calc_sino;
       L0 = trace(Q*Q');  
    end
end
  



