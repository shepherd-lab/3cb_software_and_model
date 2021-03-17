function angle_thickness_plot(X,Y)
    
    bin_a = 0:0.1:8;
    bin_h = 0:0.1:8;
    [X,Y] = meshgrid(bin_h, bin_v);
    %
    max_thick = max(max(thickness_mapproj));
    max_roi = max(max(temproi_proj));
    min_roi = min(min(temproi_proj));
    %}
   
    Z = zeros(length(bin_a),length(bin_h));
    for i = 1:length(bin_a)
        index_v = find(temproi_projnorm>(i-1)*500 & temproi_proj<i*500);
        thickness_bin = thickness_mapproj(index_v);
        if isempty(thickness_bin)
            colv = zeros(length(bin_h),1);
        else
            colv = histc(thickness_bin,bin_h);
        end
        Z(i,:) = colv';
    end
    ;