function [gradiant,gradiantImage] = myGradiant(image)
%
% Description:  This function will 
%
%               
%       Return Vals         Description
%       -----------------------------------------------------------------------
%                               
%   Author: Chris Pack  6-03 
%   Revision History:
%   Lionel HERVE 10-6-03   recoded in matlab spirit
% ------------------------------------------------------------------------------

%create the 9 neighbour images
image0=image(2:size(image,1)-1,2:size(image,2)-1);
image1=image(1:size(image,1)-2,2:size(image,2)-1);
image2=image(3:size(image,1)-0,2:size(image,2)-1);        
image3=image(2:size(image,1)-1,1:size(image,2)-2);                
image4=image(2:size(image,1)-1,3:size(image,2)-0);                        
image5=image(1:size(image,1)-2,1:size(image,2)-2);                                
image6=image(3:size(image,1)-0,1:size(image,2)-2);                                        
image7=image(1:size(image,1)-2,3:size(image,2)-0);                                
image8=image(3:size(image,1)-0,3:size(image,2)-0);                                        

gradiantImage=abs(image1-image0)+abs(image2-image0)+abs(image3-image0)+abs(image4-image0)+abs(image5-image0)+abs(image6-image0)+abs(image7-image0)+abs(image8-image0);
gradiant=sum(sum(gradiantImage));
end