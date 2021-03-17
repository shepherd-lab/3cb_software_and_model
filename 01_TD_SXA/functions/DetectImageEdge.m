function result=DetectImageEdge(Image,direction)
%Lionel HERVE
%6-17-04
%find where the saturated part of the image stops

if strcmp(direction,'TOP')
    Part=Image(1:round(size(Image,1)/6),round(size(Image,2)/3):round(2*size(Image,2)/3));  %take a little part of the image top
    Part=(Part>0.9*max(max(Part)))|(Part==0);
    [mini,result]=min(min(Part'));
elseif strcmp(direction,'BOTTOM')
    ymin=round(5*size(Image,1)/6);
    Part=flipdim(Image(ymin:end,round(size(Image,2)/3):round(2*size(Image,2)/3)),1);  %take a little part of the image bottom
    Part=(Part>0.9*max(max(Part)))|(Part==0);
    [maxi,result]=min(min(Part'));
    result=size(Part,1)-result+ymin;
elseif strcmp(direction,'RIGHT')
    xmin=round(5*size(Image,2)/6);
    Part=flipdim(Image(round(size(Image,2)/3):round(size(Image,1)/2),xmin:end),2);  %take a little part of the right of image 
    Part=(Part>0.9*max(max(Part)))|(Part==0);
    [maxi,result]=min(sum(Part)>(size(Part,1)*0.9));
    result=size(Part,2)-result+xmin;
elseif strcmp(direction,'LEFT')
    Part=Image(round(size(Image,2)/3):round(2*size(Image,1)/3),1:round(size(Image,2)/6));  %take a little part of the image
   % figure('Name', 'Part');
   % imagesc(Part); colormap(gray);
    Part=(Part>0.9*max(max(Part)))|(Part==0);
  %  BW = im2bw(Part,0.03)
   % figure('Name', 'Part2');
   % imagesc(BW); colormap(gray);
    [mini,result]=min(min(Part));
    else
    Part=(Part>0.9*max(max(Part)))|(Part==0);
    [maxi,result]=min(max(Part));
end