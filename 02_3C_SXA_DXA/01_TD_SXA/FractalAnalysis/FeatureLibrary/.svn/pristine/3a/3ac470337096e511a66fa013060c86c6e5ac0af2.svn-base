function maskObj=maskCircle(imageObj,center,radius,NOP)
THETA=linspace(0,2*pi,NOP);
RHO=ones(1,NOP)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+center(1);
Y=Y+center(2);
maskObj=zeros(size(imageObj));
maskObj=roipoly(maskObj,X,Y);
end