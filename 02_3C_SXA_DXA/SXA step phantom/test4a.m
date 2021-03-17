% test image processing for bbs auto-detect

filename1='P:\Vidar Images\test\bb4.tif';
Image1=imread(filename1);
Imagette1=flipdim(flipdim(Image1,1),2);
% Image1=conv2(Image1,Imagette1,'same');
% Image1=conv2(Image1,Imagette1,'same');
% figure;imagesc(Imagette1);colormap(cool);

filename2='P:\Vidar Images\test\epsilon.tif';
Image2=imread(filename2);
ConvImage=conv2(double(Image2),double(Image1));
figure;imagesc(Image2);colormap(cool);
figure;imagesc(ConvImage);colormap(cool);

% [maxi,X1]=max(max(Image2))
% [maxi,Y1]=max(Image2(:,X1))


% image contour/mesh plots
% mesh(Mammo);

% [X,Y] = meshgrid(-3:.125:3);
% Z = peaks(X,Y);
% meshc(X,Y,Z);

% contour3(Mammo)
% surface(X,Y,Z,'EdgeColor',[.8 .8 .8],'FaceColor','none')
% grid off
% view(-15,25)
% colormap cool