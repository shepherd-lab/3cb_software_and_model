%put color to the graph
%Lionel HERVE
%9-1-04
global Image Analysis Outline ROI f0 ctrl
Analysis.ImageFatLean=100+(Image.image-Analysis.Ref0)/(Analysis.Ref100-Analysis.Ref0)*100;
CurrentImage=Analysis.ImageFatLean;

%determine the breast position
[C,I]=max(Outline.x);
Npoint=size(Outline.x,2);
innerline1_x=Outline.x(1:I-1);
innerline1_y=Outline.y(1:I-1);
innerline2_x=Outline.x(Npoint:-1:Npoint-I+2);
innerline2_y=Outline.y(Npoint:-1:Npoint-I+2);
        
y1=min(innerline2_y,innerline1_y);
y2=max(innerline2_y,innerline1_y);

MaskROI=zeros(size(CurrentImage));
for x=1:I-1
    MaskROI(ROI.ymin+y1(x)-1:ROI.ymin+y2(x)-1,ROI.xmin+x-1)=1;
end
%figure;imagesc(MaskROI);

%substract 15% in the breast 
CurrentImage=CurrentImage-MaskROI*15;

%limit between 100 and 200 on the remaining of the image
CurrentImage=funcclim(CurrentImage,100,199).*(1-MaskROI)+funcclim(CurrentImage,0,299).*MaskROI;

%background
CurrentImage=CurrentImage+Analysis.BackGround.*(100-CurrentImage);

%put to fake pixels to set the image dynamic between 0 and 299
CurrentImage(1,1)=1;
CurrentImage(1,2)=299;

X=[0:99]'/100;
MyColorMap=[0.5-0*X 0.5-0*X X*0;X X X;X*0+1 X*0 X*0];%((1-2*X)>0).*(1-2*X) ((1-2*X)>0).*(1-2*X)];
MyColorMap(1,:)=[1 1 0];
MyColorMap(100,:)=[0 0 0];
%figure;imagesc(CurrentImage);colormap(MyColorMap);

axis(f0.axisHandle);imagesc(CurrentImage);colormap(MyColorMap);


%delete(totocontrol) %totocontrol=uicontrol('style','slider','units','normalized','position',[0.5 0.1 0.05 0.8]);
%set(totocontrol,'position',[0.77 0.05 0.02 0.87],'background',[0.5 0.5 0.5],'foreground',[0.8 0.1 0.1]);

%drawcolor bar
%NewAxes=axes;
set(NewAxes,'units','normalized','position',[0.80 0.05 0.02 0.87],'XTick',[],'YTick',[]);
axes(NewAxes);
[X,Y]=meshgrid(1:10,1500:-1:-500);
risk=29*10;
for index=1:10
    Y(1500-risk-round(index):1500-risk+round(index),index+1)=-1000;
end
%Y(495:505,:)=-1000;Y(1495:1505,:)=-1000;
Y(1,1)=2000;Y(1,2)=-1000;
hold off;
imagesc(Y);
hold on;
set(NewAxes,'XTick',[],'YTick',[]);


draweverything(1,'DONTCHANGE');
set(f0.axisHandle,'xtick',[],'ytick',[]);
set(f0.UCSFhandle,'xtick',[],'ytick',[]);
