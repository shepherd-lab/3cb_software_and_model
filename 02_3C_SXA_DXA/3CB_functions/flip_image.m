function image = flip_image(image)
global flip_info
if flip_info(1) == true & flip_info(2) == true
    image=flipdim(image,2);  %Horizontal
    image=flipdim(image,1); %Vertical
elseif flip_info(1) == true & flip_info(2) == false
    image=flipdim(image,2);
elseif flip_info(1) == false & flip_info(2) == true
    image=flipdim(image,1);
elseif flip_info(1) == false & flip_info(2) == false
    ;
end

end

