filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif'; 
Mammo=imread(filename);
figure;imagesc(Mammo);colormap(gray);
hold on;
% Width: 1408
% Height: 1757

tx=13.4290
ty=9.4943
tz=4.4956
rx=-0.0642
ry=-0.0334
rz=0

output=tx,ty,tz,rx,ry,rz;

% px=input('px')
% py=input('py')
% 
% dx=tx*pixelCm-px
% dy=size(Mammo,1)/2-ty*pixelCm-py
% dz=tz*pixelCm-pz
% 
% [px; py; pz; 1]=[1 0 0 0; 0 1 0 0; 0 0 1 0; tx ty tz 1]*[tx*pixelCm ty*pixelCm tz*pixelCm 1]
% pz=
% 
% 
% c=cos('theta');
% s=sin('theta');
% t=1-c;
% 
% R=[tx^2+c txy+sz txz-sy 0; txy-sz ty^2+c tyz+sx 0; txz+sy tyz-sx tz^2+c 0; 0 0 0 1]
