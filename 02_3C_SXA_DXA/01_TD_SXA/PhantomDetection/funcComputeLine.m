%funcComputeline
%Lionel HERVE
%10-3-2003
%do show that the detection of the phantom works
%draw a line in the figure f1 of a line of angle 'angle' and position x

function line=funcComputeLine(sizeImage,line)

angle=line.angle*pi/180;   %radian conversion

midImage=sizeImage/2;
centreX=midImage(2)+line.x*cos(angle);
centreY=midImage(1)-line.x*sin(angle);

if ((line.angle)>80) & ((line.angle)<100)
    line.x1=1;line.x2=sizeImage(2);
    line.y1=centreY-(centreX-line.x1)/sin(angle)*cos(angle);line.y2=centreY+(line.x2-centreX)/sin(angle)*cos(angle);
else
    line.y1=1;line.y2=sizeImage(1);
    line.x1=centreX-(centreY-line.y1)/cos(angle)*sin(angle);line.x2=centreX+(line.y2-centreY)/cos(angle)*sin(angle);
end


