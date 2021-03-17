%test correlation, convolution
%Lionel HERVE
%13-12-04

Filename='CharacterCPMC2';
load (Filename);

% create a image with a 7 somewhere
Imagette1=Character.Image{7};
Image1=zeros(49,49); Image1(24,20)=1;
Image1=conv2(Image1,Imagette1,'same');
figure;imagesc(Image1);colormap(gray);

%correlate with the 7
Imagette2=flipdim(flipdim(Imagette1,1),2);
Image2=conv2(Image1,Imagette2,'same');
figure;imagesc(Image2);colormap(gray);

[maxi,X1]=max(max(Image2))
[maxi,Y1]=max(Image2(:,X1))
