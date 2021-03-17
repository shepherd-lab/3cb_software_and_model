%Fractal Dimension

% FRACTDIM Compute the fractal dimension of an image
%
% D = fractdim(IMAGE)
%
% Calculates the fractal dimenstion (box-counting method) of a black and

% white edge image.
function D=fractdim(IMAGE)
[M,N]=size(IMAGE);
i=mod(M,4); j=mod(N,4);
IMAGE(M+4-i,:)=zeros(1,N);
IMAGE(:,N+4-i)=zeros(M+4-i,1);
[i,j]=size(IMAGE);

if M > N
 r=M;
else
 r=N;
end

D=log(sum(reshape(IMAGE,i*j,1)))/log(r);