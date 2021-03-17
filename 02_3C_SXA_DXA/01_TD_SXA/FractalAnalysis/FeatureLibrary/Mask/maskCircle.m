function maskObj=maskCircle(imageObj,center,radius)
NOP=1000;
THETA=linspace(0,2*pi,NOP);
RHO=ones(1,NOP)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+center(2);
Y=Y+center(1);
maskObj=zeros(size(imageObj));
maskObj=roipoly(maskObj,X,Y);
end