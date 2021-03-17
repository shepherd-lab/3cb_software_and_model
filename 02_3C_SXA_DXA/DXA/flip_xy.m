function [xy] = flip_xy( xy_orig, imsize, dim )
%dim = 1 x coordinates flipH
%dim = 2 y coordinates flipV
y_max = imsize(1);
x_max = imsize(2);
xy = zeros(size(xy_orig));

if ~isempty(strfind(dim,'flipH'))
    xy(:,1) = x_max - xy_orig(:,1);
    xy(:,2) = xy_orig(:,2);
elseif ~isempty(strfind(dim,'flipV'))
    xy(:,2) = y_max - xy_orig(:,2);
    xy(:,1) = xy_orig(:,1);
else
    stop;
end



