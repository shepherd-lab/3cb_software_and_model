%-----------------------------------------------------------------
%  File: Gradient_modified2.m
%  This matlab program computes the gradient of a Gaussian of
%  an image. 
% Author Lionel HERVE 3-3
% use  to compute the correction Image
% called by AllProcess2
% 7-14-03 border effect treated

function  G=funcGradientGauss(Image,sigma)

[X,Y]=meshgrid(-7:7,-7:7);
kernel=exp(-(X.^2+Y.^2)/(sigma/2).^2);
kernel=kernel/sum(sum(kernel));
%num = getNumberOfComputationalThreads;
%setNumberOfComputationalThreads(8);
tic
ConvIm=conv2(Image,kernel,'same');
t4 = toc
%replace the borders by the original image values
G=Image;G(sigma+2:end-sigma-2,sigma+2:end-sigma-2)=ConvIm(sigma+2:end-sigma-2,sigma+2:end-sigma-2);

