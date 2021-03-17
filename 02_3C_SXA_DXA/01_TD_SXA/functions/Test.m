I1 = imread('Breast.jpg');
% % % h=A;
% % % h(:,end)=[];
% % % figure;imshow(A);
% % I2 = imrotate(I1,10,'bicubic','crop');



I2 = imread('Breast-2.jpg');


nrows = max(size(I1,1), size(I2,1));
ncols = max(size(I1,2), size(I2,2));
nchannels = size(I1,3);

extendedI1 = [ I1, zeros(size(I1,1), ncols-size(I1,2), nchannels); ...
  zeros(nrows-size(I1,1), ncols, nchannels)];

extendedI2 = [ I2, zeros(size(I2,1), ncols-size(I2,2), nchannels); ...
  zeros(nrows-size(I2,1), ncols, nchannels)];

I1=extendedI1;
I2=extendedI2;

Overlaping=I1&I2;
% % % figure;imshow(Overlaping);
NOverlaping= nnz(Overlaping);



I3=nnz(I1);
I4=nnz(I2);
Diff=abs(I3-I4);

PercentageOverlapingRef=(NOverlaping/I3)*100;  % how many percentage is overlaping with Refernce
PercentageOverlapingRef_test=(NOverlaping/((I3+I4)/2))*100;


DiffRefrence=I3-NOverlaping; % Diff from Reference image
PercentageDiffRef=(DiffRefrence/I3)*100; %how many percentage is Diff ref
PercentageDiffRef_Test=(abs(I3-I4)/((I3+I4)/2))*100;
PercentageOverlapingTarget=(NOverlaping/I4)*100;
DiffTarget=I4-NOverlaping; % Diff from Target image
PercentageDiffTarget=(DiffTarget/I4)*100; %how many percentage is Diff

min=abs(I3-I4)/I3

C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % imwrite(C,'my_blend_overlay.png');
figure;imshow(C);
J=1
fname = [num2str(J) '.png' ];   

archiveDir = fileparts(which('Test'));

thumbdir = [archiveDir filesep 'Density_Results' ];

% Create an unique Folder



if ~exist(thumbdir,'dir')
    mkdir(thumbdir);
end


 imwrite(C,[thumbdir filesep fname]);


[hd D] = HausdorffDist(I1,I2,[],'visualize');
clear hd;
clear D;
clear I1;
clear I2;
clear extendedI1;
clear extendedI2;