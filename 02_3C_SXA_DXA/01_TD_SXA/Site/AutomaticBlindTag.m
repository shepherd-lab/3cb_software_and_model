% automatic blind tag
% Lionel HERVE
% 6-17-04


function Image=AutomaticBlindTag(Image)
global figuretodraw


maxi=max(max(Image));

%Right edge
Xright=round(0.95*size(Image,2));
Ymin=round(0.1*size(Image,1));   %avoid corners
Ymax=round(0.9*size(Image,1));
RightPart=(Image(Ymin:Ymax,Xright:end)>0.9*maxi)|(Image(Ymin:Ymax,Xright:end)==0);
if sum(sum(RightPart))>size(RightPart,1)*5   %must have 5 saturated columns in the right part of the image
    EdgeRight=edge(RightPart,'sobel');
    theta = -10:0.3:10;  %Radon transform
    Line1=funcRadonDetectMax(EdgeRight,theta,0,'first');
    Line1=funcComputeLine(size(EdgeRight),Line1);
    Line1.x1=Line1.x1+Xright;Line1.x2=Line1.x2+Xright;
    Line1.y1=Line1.y1+Ymin;Line1.y2=Line1.y2+Ymin;    
else
    Line1.x1=size(Image,2);Line1.x2=size(Image,2);
    Line1.y1=1;Line1.y2=size(Image,1);    
end

%Bottom edge
YBottom=round(0.95*size(Image,1));
Xmin=round(0.1*size(Image,2));    %avoid corners
Xmax=round(0.9*size(Image,2));
BottomPart=(Image(YBottom:end,Xmin:Xmax)>0.9*maxi)|(Image(YBottom:end,Xmin:Xmax)==0);
if sum(sum(BottomPart))>size(BottomPart,2)*5   %must have 5 saturated rows in the bottom part of the image
    EdgeBottom=edge(BottomPart,'sobel');
    theta = 80:0.3:100;  %Radon transform
    Line2=funcRadonDetectMax(EdgeBottom,theta,0,'first');
    Line2=funcComputeLine(size(EdgeBottom),Line2);
    Line2.y1=Line2.y1+YBottom;Line2.y2=Line2.y2+YBottom;
    Line2.x1=Line2.x1+Xmin;Line2.x2=Line2.x2+Xmin;    
else
    Line2.y1=size(Image,1);Line2.y2=size(Image,1);
    Line2.x1=1;Line2.x2=size(Image,2);    
end


I12=round(funcComputeIntersection(Line1,Line2));
funcbox(I12(1)-30,I12(2)-80,I12(1)-60,I12(2)-520,'r');

Image(I12(2)-520:I12(2)-80,I12(1)-60:I12(1)-30)=65536;
figure(figuretodraw);hold on;
imagesc(Image);

if (1)
    figure(figuretodraw);
    plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'linewidth',2,'color','r'); hold on;
    plot([Line2.x1 Line2.x2],[Line2.y1 Line2.y2],'linewidth',2,'color','r');
end

