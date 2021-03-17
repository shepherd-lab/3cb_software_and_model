function Ibkg = background_phantomdigital(image)
%background_phantomdigital - calculates a ?background? image (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [Ibkg] = background_phantomdigital(image)
%
% Inputs:
%    image - 
% Outputs:
%    Ibkg - Description
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Lionel Herve - Modified by Fred Duewer
% UCSF Radiology - BBDG
% email: fwduewer@radiology.ucsf.edu
% Website: http://www.ucsf.edu
% May 2004; Last revision: 12-May-2004

%------------- BEGIN CODE --------------
      H = fspecial('disk',5);
      %Create a disk of radius 5.
      image1 = imfilter(image,H,'replicate');
      %Convolve with disk, edge-padding with nearest value.
      image_smooth =image1;
      sz = size(image_smooth);
      %Get the dimensions of the convolved image.
      min_image = min(min(image1));
      %Get the smallest value in the image.  This value is used directly in
      %background computation.  So, this is not robust.
      init = 0;
      init1 = 2000;
      C = 1;
      count = 20;
      %Create a 1-d array containing the convolved image.
      while C < 200
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),min_image:15000); %15000
         %Create a histogram between min_image and 15000, 15000 is
         %well-above background in most cases, below breast - maybe??.
         if ~isempty(histogram)
            [C,I]=max(histogram(2:round(size(histogram,2)/2)));
            %C is the max value, I is the index of the max value, evaluated
            %over only the lower half of the histogram WTF
        else
            init = 1;
            break;
        end
         [C,I]=max(histogram(2:round(size(histogram,2)/2)));
         init = init + I + 50;
         count = count -1;  
          if count < 0
              break;
          end
          if init > 14000
              init = init1 - 1000;
              if init == 0
                  Ibkg = 1000;
                  init = 1000;
                  break;
              end
              init1 = 1000;
              count = 20;
          end
      end     
      Ibkg = init+min_image;
      %Basically does a lot of funky stuff to get a single background
      %value.

     
      
      