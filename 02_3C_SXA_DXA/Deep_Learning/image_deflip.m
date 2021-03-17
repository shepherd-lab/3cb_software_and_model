function image2 = image_deflip(image,orientation)
  if ~isempty(orientation)
                
                if  (~isempty(strfind(orientation,'A\F')))
                    if ~isempty(strfind(orientation,'A\FR'))
%                         imagemenu('flipV');
                        image2=flipdim(image,1);
                    elseif ViewId ==4 | ViewId ==29 | ViewId ==35  | ViewId==1
                        image2=flipdim(image,1);
                    else
                    image2=image;
                end
                elseif (~isempty(strfind(orientation,'A\L')))
                    image2=flipdim(image,1);
                elseif (~isempty(strfind(orientation,'P\F')))
                    if (~isempty(strfind(orientation,'P\FL')))
                       image2=flipdim(image,1);
                       image2=flipdim(image2,2);                    
                    else
                        image2=flipdim(image,2);
                        if ViewId ==4
                            image2=flipdim(image2,1);
                        end
                    end
                elseif (~isempty(strfind(orientation,'P\H')))
                    image2=flipdim(image,2);
%                     flag.HorizontalFlip=true;
                elseif (~isempty(strfind(orientation,'P\L')))
                    image2=flipdim(image,2);
                    flag.HorizontalFlip=true;
                    image2=flipdim(image2,1);
                elseif (~isempty(strfind(orientation,'P\R')))
                    image2=flipdim(image,2);
%                     imagemenu('flipH');
%                     flag.HorizontalFlip=true;
                elseif (~isempty(strfind(orientation,'A\H'))) %A\H and A\R are not required any flipping
                    image2=image;
                elseif (~isempty(strfind(orientation,'A\R')))
                    image2=image;
                elseif (~isempty(strfind(orientation,'film')))
                    image2=image;
                else
                     image2=image;
                end

% %  if  (~isempty(strfind(orientation,'A\')))
% %         if ~isempty(strfind(orientation,'A\FR'))
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %         else
% %               image2=image;
% %         end
% %     elseif (~isempty(strfind(orientation,'A\L')))
% %         image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %     elseif (~isempty(strfind(orientation,'P\F')))
% %         if (~isempty(strfind(orientation,'P\FL')))
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %             image2=flipdim(image2,1); %horizontal flip  %imagemenu('flipH');
% %         else
% % % % %             image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %             image2=flipdim(image2,1); %horizontal flip  %imagemenu('flipH');
% %         end
% %     elseif (~isempty(strfind(orientation,'P\H')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %     elseif (~isempty(strfind(orientation,'P\L')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %         image2=flipdim(image2,2); %vertical flip  %imagemenu('flipV');
% %     elseif (~isempty(strfind(orientation,'P\R')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %     elseif (~isempty(strfind(orientation,'A\H'))) %A\H and A\R are not required any flipping
% %         image2=image;; % added 02/21/14
% %     elseif (~isempty(strfind(orientation,'A\R')))
% %         image2=image;; % added 02/21/14
% %     elseif (~isempty(strfind(orientation,'film')))
% %         image2=image;
% %     end


end

