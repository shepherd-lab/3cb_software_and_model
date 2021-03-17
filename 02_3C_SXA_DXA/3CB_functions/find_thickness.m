function [thickness,feval] = find_thickness(thick_0,model_volume,xdir_angle)         
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    [thickness,feval] = fminsearch(@cost_function, thick_0); %, options
      
    function L0 = cost_function(thick) 
       calc_volume = volume_calculation(thick,xdir_angle);
       L0 = (model_volume - calc_volume)^2;  
    end
end
  
