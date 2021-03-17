%Compute  the area of a close contour
%author Lionel HERVE
%creation date 5-16-03
%10-7-2003 use built in function

function pixels=funcComputeFreeFormArea(xy);
    pixels=polyarea(xy(:,1),xy(:,2));