function [image2 ] = flip_image(image,orientation )

             if  (~isempty(strfind(orientation,'A\F')))
                if ~isempty(strfind(orientation,'A\FR'))
                    image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
                else
                    image2=image;
                end
            elseif (~isempty(strfind(orientation,'A\L')))
                image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
            elseif (~isempty(strfind(orientation,'P\F')))
                if (~isempty(strfind(orientation,'P\FL')))
                    image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
                    image2=flipdim(image2,2); %horizontal flip  %imagemenu('flipH');
                else
                    % % %             image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
                    image2=flipdim(image,1); %vertical flip %imagemenu('flipV');
                    image2=flipdim(image2,2); %horizontal flip  %imagemenu('flipH');
                end
            elseif (~isempty(strfind(orientation,'P\H')))
                image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
            elseif (~isempty(strfind(orientation,'P\L')))
                image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
                image2=flipdim(image2,1); %vertical flip  %imagemenu('flipV');
            elseif (~isempty(strfind(orientation,'P\R')))
                image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
            elseif (~isempty(strfind(orientation,'A\H'))) %A\H and A\R are not required any flipping
                image2=image;; % added 02/21/14
            elseif (~isempty(strfind(orientation,'A\R')))
                image2=image;; % added 02/21/14
            elseif (~isempty(strfind(orientation,'film')))
                image2=image;
            end
end

