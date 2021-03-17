%VidarBLindTag
%creation date 6-9-2003
%author LIonel HERVE


%put the digitalized image
Image.OriginalImage=double(vidar.DigitalizedImage);
Image.image=double(vidar.DigitalizedImage);
Image.maximage=max(max(Image.image));
[Image.rows,Image.columns] = size(Image.image);
resizewindow;
draweverything;

set(ctrl.text_zone,'String','Drag a box on the tag');
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = round(min(point1,point2));             % calculate locations
offset = round(abs(point1-point2));         % and dimensions

Image.OriginalImage(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1))=max(max(Image.OriginalImage));   %blind the drag region
Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1))=max(max(Image.image));   %blind the drag region
recomputevisu;draweverything;

button = questdlg('Is this ok?','Continue Operation','Yes','No','Yes');
if strcmp(button,'Yes')
    vidar.DigitalizedImage=uint16(Image.OriginalImage);
else
    Image.OriginalImage=double(vidar.DigitalizedImage);
    Image.image=double(vidar.DigitalizedImage);
end
recomputevisu;draweverything;

set(ctrl.text_zone,'String','Ok');



%clear unnecessary variables
clear k;clear point1;clear point2;
clear tempimage;clear finalRect;clear p1;clear offset;clear pointx;clear pointy;clear message;