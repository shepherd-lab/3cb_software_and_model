%% DXApointcloud
% draw a Square ROI then put all the 50*50 HE,RST values in matrix CLOUD
clear tempimageHE;clear tempimageHE3;clear tempimageHE4;clear tempimageHE2;
clear tempimageRST;clear tempimageRST3;clear tempimageRST4;clear tempimageRST2;
set(ctrl.text_zone,'String','Drag a box');
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = round(min(point1,point2));             % calculate locations
offset = round(abs(point1-point2));         % and dimensions
funcBox(p1(1),p1(2),p1(1)+offset(1),p1(2)+offset(2),'blue');
tempimageHE=Image.HE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
tempimageRST=Image.RST(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
tempimageHE2=conv2(tempimageHE,ones(floor(offset(2)/50),floor(offset(1)/50)))/sum(sum(ones(floor(offset(2)/50),floor(offset(1)/50))));
tempimageRST2=conv2(tempimageRST,ones(floor(offset(2)/50),floor(offset(1)/50)))/sum(sum(ones(floor(offset(2)/50),floor(offset(1)/50))));
%create a 50*50 image
for y=1:48
    tempimageHE3(y,:)=tempimageHE2(round(offset(2)/2/50+(y)*size(tempimageHE,1)/49),:);
    tempimageRST3(y,:)=tempimageRST2(round(offset(2)/2/50+(y)*size(tempimageHE,1)/49),:);    
end
for x=1:48
    tempimageHE4(:,x)=tempimageHE3(:,round(offset(1)/2/50+(x)*size(tempimageHE,2)/49));
    tempimageRST4(:,x)=tempimageRST3(:,round(offset(1)/2/50+(x)*size(tempimageHE,2)/49));    
end
CLOUD=[reshape(tempimageHE4,prod(size(tempimageHE4)),1) reshape(tempimageRST4,prod(size(tempimageHE4)),1)];  
figure;imagesc(tempimageHE);colormap(gray);
figure;imagesc(tempimageHE4);colormap(gray);
clear x;clear y;
