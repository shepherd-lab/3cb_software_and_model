%Erosion image processing function
%Lionel HERVE
%10-5-04

function Output=Dilatation(Image,SIZE,direction)

if ~exist('direction')
    direction='NULL';
end

if ~mod(SIZE,2)
    error('In Dilatation/Erosion. Size must be an odd number.');
end

%Image=[Image(1,:);Image;Image(end,:)];
if (SIZE-1)>0
    if strcmp(direction,'HORIZONTAL')
        Image0=[Image(:,1)*ones(1,(SIZE-1)/2) Image Image(:,end)*ones(1,(SIZE-1)/2)];
        for index=1:SIZE
            Image1=Image0(:,index:end+index-SIZE);
            Signal(index,:)=reshape(Image1,1,prod(size(Image1)));
        end
        Signal=max(Signal);
    end
    
    Output=reshape(Signal,size(Image,1),size(Image,2));
else
    Output=Image;
end
