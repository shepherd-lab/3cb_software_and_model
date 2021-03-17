%Lionel HERVE
%2-23-4

function redraw
global flag Hist Image;

flag.Debug=true;
%recomputevisu;
 %Hist.imagemin2 = Image.immin ;
% Hist.imagemax2 = Image.maximage;
 
draweverything;
flag.Debug=false;