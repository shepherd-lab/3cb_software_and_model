%VidarBLindTag
%creation date 4-9-2003
%author LIonel HERVE

%put the digitalized image

function TagImageBlinded=blindtag(AutomaticAttemptOn)
global Image ctrl file Analysis Info

if ~exist('AutomaticAttemptOn')
    AutomaticAttemptOn=false;
end

TagImageBlinded=false;

SavedImage=Image.OriginalImage;
Image.image=Image.OriginalImage;
Image.maximage=max(max(Image.image));
[Image.rows,Image.columns] = size(Image.image);
resizewindow;
draweverything;

error=0;
if AutomaticAttemptOn
    try 
        Image.OriginalImage=AutomaticBlindTag(Image.OriginalImage);
        Image.image=Image.OriginalImage;
    catch
        error=1;
    end
else
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
end

if error==0
    recomputevisu;draweverything;
    if ~AutomaticAttemptOn
        button = questdlg('Is this ok? Shall I replace the file?','Continue Operation','Yes','No','Yes');
    else
        button='Yes';
    end
    if strcmp(button,'Yes')
        SavedImage=uint16(Image.OriginalImage);        
        imwrite(SavedImage,Analysis.CompleteFileName,'tif');
        TagImageBlinded=true;
    else
        Image.OriginalImage=SavedImage;
        Image.image=SavedImage;
    end
    recomputevisu;draweverything;
end

set(ctrl.text_zone,'String','Ok');
