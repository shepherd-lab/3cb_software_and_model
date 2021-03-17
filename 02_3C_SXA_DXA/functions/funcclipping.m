function [x1c,y1c]=funcclipping(x1,y1,rows,columns)
%funcClipping
%author lionel HERVE
%manage to have coordinates that stay in the image if operator draw things
%that are not allowed
%4-02-03
%9-19-03 can handle the tables
%9-19-03 0 is minimum

%x1c=max(x1,1);
%x1c=min(x1c,columns);
%y1c=max(y1,1);
%y1c=min(y1c,rows);

x1c=x1+((x1>columns).*(columns-x1));
x1c=x1c+((x1<1).*(1-x1));
y1c=y1+((y1>rows).*(rows-y1));
y1c=y1c+((y1<1).*(1-y1));