function threshold = optim_threshold(model_density)

       thresh_0 = 0.5;
%        for i = 1:2  
           [threshold,feval] = find_threshold(thresh_0,model_density) 
           thresh_0 = threshold;
%        end

end

