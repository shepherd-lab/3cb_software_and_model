function [inner_outline_x,inner_outline_y] = internal_SkinDetection_first(outline_x, outline_y,mid_point)
    global thickness_ROI MachineParams
    y0 = mid_point;
    S = 66.3;
    res = 0.014;
    h = MachineParams.bucky_distance;
    %len = size(outline_x);
    %index = 1:length(outline_y);
    for i = 1:length(outline_y)
        y = outline_y(1):outline_y(end);
        upper_y = outline_y(outline_y<=y0);
        low_y = outline_y(outline_y>y0);
        tng_alfa = outline_x(i) / abs(outline_y(i) - y0);
               
        if outline_y(i) <= y0
            xlin = upper_y * tng_alfa;
            xx = [outline_x(i) 0 ];
            yy = [ouline_y(i) y0 ];
            Lim = sqrt(xlin(i:length(xlin)).^2 + outline_y(i:length(xlin)).^2);
            h_profile = improfile(thickness_map, xx, yy);
        else
            xlin = low_y * tng_alfa;
            xx = [0 outline_x(i)];
            yy = [y0 outline_y(i)];
            Lim = sqrt(xlin^.2 + (outline_y-y0).^2);
            h_profile = improfile(thickness_ROI, xx, yy);
            h_profile(1) = [];
         end
        A_im = sqrt(xx^2 + yy^2)*res;
        beta = atan(S / A_im);
        len_diff = h * tan((90 - beta)*pi/180);
        len_prof = length(h_profile);
        L = Lim - len_diff;
        Hcalc =  2* L(1:len_prof) /tan(beta)*180/pi;
        diff_func = (Hcalc - h_profile).^2;
        num_column = (1:len_prof)';
        matr_data = [diff_finc', num_column];
        matr_datasort = sortrows(matr_data,1);
        index = matr_datasort(1,2);
        inner_outline_x(i) = outline_x(i)-xlim(index);
        inner_outline_y(i) = outline_y(i)+ round(xlim(index)/tng_alfa);
    end
        