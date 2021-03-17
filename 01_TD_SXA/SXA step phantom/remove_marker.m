function remove_marker()
        global ctrl Image Analysis
         bkgr = background_phantomdigital(Image.image);
        set(ctrl.text_zone,'String','Drag a box');
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = round(min(point1,point2));             % calculate locations
        offset = round(abs(point1-point2));         % and dimensions
        %funcBox(p1(1),p1(2),p1(1)+offset(1),p1(2)+offset(2),'blue');
        Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1)) = bkgr;
        draweverything;
        