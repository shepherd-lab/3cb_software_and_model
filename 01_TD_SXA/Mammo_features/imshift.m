%%
%%% IMSHIFT: shift an image horizontally and/or vertically with wraparound
%%%   res = imshift( im, offset )
%%%     im: grayscale or color image
%%%     offset: [dY dX]
%%%   Hany Farid; Image Science Group; Dartmouth College
%%%   10.13.06
%%%

function[ res ] = imshift( im, offset )

   dims = size(im);
   offset = mod(-offset,dims(1:2));
   res = zeros( dims );

   for z = 1 : size(im,3)
      res(:,:,z) = [ im(offset(1)+1:dims(1), offset(2)+1:dims(2), z),  ...
                     im(offset(1)+1:dims(1), 1:offset(2), z); ...
                     im(1:offset(1), offset(2)+1:dims(2), z), ...
                     im(1:offset(1), 1:offset(2), z) ];
   end