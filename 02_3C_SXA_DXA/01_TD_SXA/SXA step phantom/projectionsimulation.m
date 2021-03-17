function [xf,yf]=projectionsimulation(Phantom,tx,ty,tz,rx,ry,rz,s)

for index=1:size(Phantom,2)
    [xf(index),yf(index)]=Projector2(Phantom(index).x,Phantom(index).y,Phantom(index).z,tx,ty,tz,rx,ry,rz,s);
end