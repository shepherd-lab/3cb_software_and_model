% test convolution image processing for bbs auto-detect

filename1='P:\Vidar Images\test\bb4.tif';
filename2='P:\Vidar Images\test\epsilon4.tif';
A = imread(filename1);
B = imread(filename2);
% figure;imagesc(B);colormap(gray);
C = conv2(double(A),double(B));
% C = filter2(double(A),double(B),'same');
figure;imagesc(C);colormap(gray);
% D = dither(C);
% D = imadjust(C,stretchlim(C),[]);

% threshold = graythresh(D);
% BW = im2bw(D,threshold);
% figure;imagesc(D),title('bw image');

[maxi,X1]=max(max(C))   % max position (X1,Y1) and value at that point
[maxi,Y1]=max(C(:,X1))