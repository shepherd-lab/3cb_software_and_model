function [threshold,feval] = find_threshold(thresh_0,model_density)         
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [threshold,feval] = fminsearch(@cost_function, thresh_0); %, options
      
    function L0 = cost_function(thresh) 
       calc_density = calc_MD(thresh);
       L0 = (model_density - calc_density)^2;  
    end
end
  
