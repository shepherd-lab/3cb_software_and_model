function [sxa10_bin,bv10_bin,dv10_bin] = mean_bin(sxa_10, bv_10, dv_10)
    k = 100;
    len = floor(length(sxa_10)/k );
    
    for i =1:len
         
        sxa10_bin(i) = mean(sxa_10((i-1)*k+1:i*k));
        bv10_bin(i) = mean(bv_10((i-1)*k+1:i*k));
        dv10_bin(i) = mean(dv_10((i-1)*k+1:i*k));
    end
    a = 1;
    