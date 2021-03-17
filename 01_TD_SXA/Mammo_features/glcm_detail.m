function [cooc_matrix] = glcm_detail(img, d_x, d_y,levels);
% [cooc_matrix] = glcm (img, d_x, d_y);
% 
% Calculation  of the normalized cooccurrence matrix
% asbjorb@ifi.uio.no 2/9/2003
% 
% Note: img must be cast to double to use + in Matlab
img_d=double(img);
siz = size(img_d);
cooc_matrix = zeros( levels);

for row = 1:siz(1) - d_x
   for col = 1:siz(2) - d_y
      i = img_d(row, col) + 1;
      j = img_d(row + d_x, col + d_y) + 1;
      cooc_matrix(i,j) = cooc_matrix(i,j) + 1;
   end
end

% normalize matrix
cooc_matrix = cooc_matrix / sum(sum(cooc_matrix));

%
