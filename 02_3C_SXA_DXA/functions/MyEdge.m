%% create to replace BW = edge(tempImage,'log'); which does not work at
%% compilatiom

function Zeros=MyEdge(Image)

sigma=2;
[X,Y]=meshgrid(-sigma*3:sigma*3);
kernel=(X.^2+Y.^2-2*sigma^2)/sigma^4.*exp(-(X.^2+Y.^2)/2/sigma^2);
kernel=kernel-mean(mean(kernel));

tempImage=conv2(Image,kernel,'same');

SquarreSum=zeros(size(Image));
MeanImage=zeros(size(Image));
%detection of zero crossing
LocalSize=1;
for dx=-LocalSize:LocalSize
    for dy=-LocalSize:LocalSize
        SquarreSum=SquarreSum+circshift(Image,[dx dy]).^2;
        MeanImage=MeanImage+circshift(Image,[dx dy]);
    end
end
VarianceImage=SquarreSum/(2*LocalSize+1)^2-(MeanImage/(2*LocalSize+1)^2).^2;
VarianceHist=histc(reshape(VarianceImage,1,prod(size(VarianceImage))),[0:1000]/1000*max(max(VarianceImage))/10);
%search threshold of the Laplacian of gaussian method
MyDiff=conv2(diff(VarianceHist),ones(1,10),'same');
[foe,Threshold]=max(MyDiff>0);
Threshold=Threshold*max(max(VarianceImage))/10/1000;

Zeros=(conv2(+(tempImage<0),ones(3),'same').*tempImage>0).*(VarianceImage>Threshold);



