function [outline_x,outline_y,error] = funcfindOutline(image);

%
% Outline search 
%   
% 
% find outline 2 values of y per x
%       
%
%   Author: Lionel HERVE  2-03 
%   Revision History:
%   simple algorithm with min function. - doesn't give a beautifull curves   in chest wall
%   modification: work on background image
%   10-15-03: if there is no background in a column, take the previous
%   ordinate
%   10-15-03: eradicate some background pixel that can be in the middle of
%   the breast (p148lh1)
%--------------------------------------------------------------------

error=0;
[rows,columns]=size(image);

%find an ellipse of axes size X1=alpha.image_x Y1=alpha.image_y which is in
%the breast. Then convert the BackGround pixel there to true; (10-15-03)
alpha=0.9;
ellipsePointNumber=1000;
 angle=[0:ellipsePointNumber]/ellipsePointNumber*pi;
ok_continue=true;
tic;
loop_number = 0;
while ok_continue %& loop_number 
    ellipse.x=round(1+alpha*sin(angle)*columns);
    ellipse.y=round(rows/2+alpha*cos(angle)*rows/2);
    if min(diag(image(ellipse.y,ellipse.x)))==1;
        ok_continue=false;
        %erase the hole in the BackGround
        for abscisse=1:1+alpha*columns
            angle=asin((abscisse-1)/alpha/columns);    
            dy=alpha*cos(angle)*rows/2;
            image(round(rows/2-dy):round(rows/2+dy),abscisse)=1;
        end
    end
    alpha=alpha*0.9;t=toc;
    if (t>3)|(alpha<0.1)  %stop the process (faillure)
        ok_continue=false;
        outline_x=[];
        outline_y=[];
        error=1;
        return;
    end
    loop_number = loop_number +1;
    if loop_number > 2000
            stop;
            return;
    end
end
lp = loop_number
[C,I]=min(transpose(image));
[C2,I2]=max(conv2(I,ones(1,10),'same'));
% I2 = 1000;
%find the outline of the upper part of the breast
image2=rot90(rot90(image(1:I2,:)));
outline1_x=[columns:-1:1];
[offset1,outline1_y]=min(image2);
%detect some odd value: when there are no background in the region of
%interest, take the last point
for index=2:size(outline1_y,2)
    if offset1(index)==1
        outline1_y(index)=outline1_y(index-1);
    end
end
outline1_y=-outline1_y+I2+1;


%find the outline of the bottom of the breast
image2=image(I2+1:rows,1:columns-1);
outline2_x=[1:columns-1];
[offset2,outline2_y]=min(image2);

%detect some odd value: when there are no background in the region of
%interest, take the last point
for index=size(outline2_y,2)-1:-1:1
    if offset2(index)==1
        outline2_y(index)=outline2_y(index+1);
    end
end

outline2_y=outline2_y+I2;

%total outline
outline_x=[outline2_x outline1_x];
outline_y=[outline2_y outline1_y];
a = 1;

