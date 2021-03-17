function image2 = deflip_image(image)
global Info 

  if ~isempty(Info.orientation)
                
                if  (~isempty(strfind(Info.orientation,'A\F')))
                    if ~isempty(strfind(Info.orientation,'A\FR'))
%                         imagemenu('flipV');
                        image2=flipdim(image,1);
                    elseif Info.ViewId ==4 | Info.ViewId ==29 | Info.ViewId ==35  | Info.ViewId==1
                        image2=flipdim(image,1);
                    else
                    image2=image;
                end
                elseif (~isempty(strfind(Info.orientation,'A\L')))
                    image2=flipdim(image,1);
                elseif (~isempty(strfind(Info.orientation,'P\F')))
                    if (~isempty(strfind(Info.orientation,'P\FL')))
                       image2=flipdim(image,1);
                       image2=flipdim(image2,2);                    
                    else
                        image2=flipdim(image,2);
                        if Info.ViewId ==4
                            image2=flipdim(image2,1);
                        end
                    end
                elseif (~isempty(strfind(Info.orientation,'P\H')))
                    image2=flipdim(image,2);
%                     flag.HorizontalFlip=true;
                elseif (~isempty(strfind(Info.orientation,'P\L')))
                    image2=flipdim(image,2);
                    flag.HorizontalFlip=true;
                    image2=flipdim(image2,1);
                elseif (~isempty(strfind(Info.orientation,'P\R')))
                    image2=flipdim(image,2);
%                     imagemenu('flipH');
%                     flag.HorizontalFlip=true;
                elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                    image2=image;
                elseif (~isempty(strfind(Info.orientation,'A\R')))
                    image2=image;
                elseif (~isempty(strfind(Info.orientation,'film')))
                    image2=image;
                else
                     image2=image;
                end

% %  if  (~isempty(strfind(Info.orientation,'A\')))
% %         if ~isempty(strfind(Info.orientation,'A\FR'))
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %         else
% %               image2=image;
% %         end
% %     elseif (~isempty(strfind(Info.orientation,'A\L')))
% %         image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %     elseif (~isempty(strfind(Info.orientation,'P\F')))
% %         if (~isempty(strfind(Info.orientation,'P\FL')))
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %             image2=flipdim(image2,1); %horizontal flip  %imagemenu('flipH');
% %         else
% % % % %             image2=flipdim(image,2); %horizontal flip %imagemenu('flipH');
% %             image2=flipdim(image,2); %vertical flip %imagemenu('flipV');
% %             image2=flipdim(image2,1); %horizontal flip  %imagemenu('flipH');
% %         end
% %     elseif (~isempty(strfind(Info.orientation,'P\H')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %     elseif (~isempty(strfind(Info.orientation,'P\L')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %         image2=flipdim(image2,2); %vertical flip  %imagemenu('flipV');
% %     elseif (~isempty(strfind(Info.orientation,'P\R')))
% %         image2=flipdim(image,1); %horizontal flip %imagemenu('flipH');
% %     elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
% %         image2=image;; % added 02/21/14
% %     elseif (~isempty(strfind(Info.orientation,'A\R')))
% %         image2=image;; % added 02/21/14
% %     elseif (~isempty(strfind(Info.orientation,'film')))
% %         image2=image;
% %     end


end

