
% % function [x0,feval, Xim_calc] = bbs_fitting(Xph,Xim,s)
% %           % create initial 
% %           %x0 = [thick, inten, diam]
% %           %calculate breast sinogramm
% %           %breast_sino = 
% %            for i = 1:10  
% %                [y,feval] = find_minsino(x0, breast_sino,extra_params); 
% %                rx0 = y(1);
% %                ry0 = y(2);
% %                rz0 = y(3);
% %                tz0 = y(4);
% %                tx0 = y(5);
% %                ty0 = y(6);
% %                R0 =  rotation_matrix(rx0, ry0, rz0); 
% %                [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
% %                du = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
% %                dv = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
% %                tx0 = tx0 - du * tz0/s;
% %                ty0 = ty0 - dv * tz0/s;
% %                x0 = [rx0, ry0, rz0, tz0,tx0, ty0];
% %            end
% % 
% % end


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
       calc_sino = calc_sinogram(thick,inten,diam);
       Q = breast_sino - calc_sino;
       L0 = trace(Q*Q');  
    end
end
  



