function [r] = correl(x,y)

    % Pearson's coefficient of correlation.

    cov_xy = mean(x.*y) - mean(x)*mean(y);
    sd_x   = std(x, 1);
    sd_y   = std(y, 1);

    r = cov_xy/(sd_x * sd_y);
    