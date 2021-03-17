filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';
Mammo=imread(filename);
figure;imagesc(Mammo);colormap(gray);
hold on;
% Width: 1408
% Height: 1757

tx=13.4290;
ty=9.4943;
tz=4.4956;
rx=-0.0642;
ry=-0.0334;
rz=0;

pixelCm=150/2.54;

% filename2='P:\Vidar Images\test\epsilon1.tif';
% Epsilon=imread(filename2);
% TR = hgtransform('Parent',Epsilon);

T = makehgtform('translate',[tx*pixelCm ty*pixelCm tz*pixelCm]);
XR = makehgtform('xrotate',rx);
YR = makehgtform('yrotate',ry);
ZR = makehgtform('zrotate',rz);

C = T*XR*YR*ZR;
% set(hgtransform_handle,'Matrix',C)
% set(TR,'Matrix',C)

origin=[0 0 0 1]';

newposition=(C*origin)