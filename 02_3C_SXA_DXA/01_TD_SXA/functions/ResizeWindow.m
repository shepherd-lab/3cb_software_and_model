%Resize Window
%Allow the Image to keep its aspect ratio and to fit on the screen
% Author Lionel HERVE 3-03
% revision history

function resizewindow
global f0
global Image

screenaspectration=1.5;
windowheight=min([0.88 0.5*Image.rows/Image.columns*screenaspectration]);
windowwidth=windowheight*Image.columns/Image.rows/screenaspectration;
set(f0.axisHandle,'units','normalized','position',[0.3 0.05 windowwidth windowheight]);

