function maskDef=mask_circle_film(center,radius,NOP, image)

THETA=linspace(0,2*pi,NOP);
RHO=ones(1,NOP)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+center(1);
Y=Y+center(2);

sz_image = size(image);
xx=sz_image(1);
yy=sz_image(2);
a=zeros(xx,yy);

H=roipoly(a,X,Y);
maskDef.xmin=1;
maskDef.ymin=1;
maskDef.xmax=xx;
maskDef.ymax=yy;
maskDef.roiMask=H;
%being lazy, mask could be smaller.
end