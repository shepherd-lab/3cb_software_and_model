%%% find the tag

TAG=flipdim(rot90(XX),2);
TAG=TAG(1:size(TAG,1)/6,1:size(TAG,2)/2.5);

theta=-91:0.1:-89;
[R,xp] = radon(TAG,theta);
figure, imagesc(theta, xp, R); colormap(hot);


figure;imagesc(TAG);colormap(gray);