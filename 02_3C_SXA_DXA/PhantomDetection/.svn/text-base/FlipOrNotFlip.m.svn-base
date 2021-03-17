function FlipResult=FlipOrNotFlip(Image);
%Tag and phantom detection
%The image is analysed at its farthest 1/6th. 
%It is the cut into 2 half: the up and bottom part.
%The tag is in the half were there are more high value pixels.

WorkingImage=Image(:,round(5/6*size(Image,2)):end);
threshold=max(max(WorkingImage))/2;
signal=(mean(WorkingImage'));
FlipResult=sum(signal(1:round(length(signal)/2)))>sum(signal)/2;

