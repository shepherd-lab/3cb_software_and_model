function [x3,y3] = long_linedown(Line1, k);
    dy = abs(Line1.y2 - Line1.y1) * k;
    dx = abs(Line1.x2 - Line1.x1) * k;
    x3 = Line1.x1 - dx;
    y3 = Line1.y1 + dy;