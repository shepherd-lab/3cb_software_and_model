function [image_flipped ] = flip_image(image,orientation )
if  (~isempty(strfind(orientation,'A\F')))
    if ~isempty(strfind(orientation,'A\FR'))
        image_flipped=flipdim(image,1); %vertical flip %imagemenu('flipV');
    else
        image_flipped=image;
    end
elseif (~isempty(strfind(orientation,'A\L')))
   image_flipped=flipdim(image,1); %vertical flip %imagemenu('flipV');
elseif (~isempty(strfind(orientation,'P\F')))
    if (~isempty(strfind(orientation,'P\FL')))
        image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
        image_flipped=flipdim(image2,2); %horizontal flip  %imagemenu('flipH');
    else
        image_flipped = image;
    end
elseif (~isempty(strfind(orientation,'P\H')))
    image_flipped=flipdim(image,2); %horizontal flip %imagemenu('flipH');
elseif (~isempty(strfind(orientation,'P\L')))
    image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
    image_flipped=flipdim(image2,2); %horizontal flip  %imagemenu('flipH');
elseif (~isempty(strfind(orientation,'P\R')))
    image_flipped=flipdim(image,2); %horizontal flip %imagemenu('flipH');
elseif (~isempty(strfind(orientation,'A\H'))) %A\H and A\R are not required any flipping
    image_flipped=image; % added 02/21/14
elseif (~isempty(strfind(orientation,'A\R')))
    image_flipped = image; % added 02/21/14
elseif (~isempty(strfind(orientation,'film')))
    image_flipped=image;
end

end

