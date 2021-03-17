function  optim_thickness() %thickness = model_volume
  global Analysis Image thickness_mapreal
   
LASTN = maxNumCompThreads('automatic')
    model_volume = 957;
   Analysis.resolution_cm =  Analysis.Filmresolution/10;
     sz = size(Image.OriginalImage); % 1407 1408 
    Analysis.xmax_pixels = sz(2);
    Analysis.ymax_pixels = sz(1);
    Analysis.tx = 0.75*Analysis.xmax_pixels*Analysis.resolution_cm;    % tx /0.014); % 
    Analysis.ty = 0.25*Analysis.ymax_pixels*Analysis.resolution_cm;    % ty  /0.014);
    
       thick_0 = 4.5;
       xdir_angle = 1;
%        periph_Xgrad = periphery_gradient();
%        a_coef = 1;
%        b_coef = 0;
%        xdir_angle = a_coef*periph_Xgrad + b_coef;
       
%        for i = 1:2  
      tic
           [thickness,feval] = find_thickness(thick_0,model_volume,xdir_angle)
           thick_0 = thickness
%        end
      t1 = toc
    calc_volume = volume_calculation(thickness,xdir_angle)
    vol_diff = model_volume - calc_volume
    a = 1;
end

