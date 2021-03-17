%**************dectection of the grid on images with the slices

% clear all;


mAs = 100;
kVp = 25;
[FileName,PathName] = uigetfile('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\TT006\TT006R_images\png_files\*.png', 'Choose your sheet');
I=double(imread([PathName,FileName]));
I=flipdim(I,2);I=flipdim(I,1);
%figure;imagesc(I);colormap(gray);

 %            ReinitImage(I,'OPTIMIZEHIST');
I = log_convertSXA(I,mAs, kVp)+1000;
image_size = size(I);
             if image_size(2) > 1350
                rect = [220,193,1279,1662];
                %figure;imagesc(Image.image); colormap(gray);
                %temp_image = imcrop(Image.image,rect);
                temp_image = I(200:1662,220:1279);               
                bkgr = background_phantomdigital(temp_image);
             else
                 bkgr = background_phantomdigital(temp_image);
             end
            
             BackGroundThreshold = bkgr+1000;
           
%figure;imagesc(I);colormap(gray);
% threshold to remove the slices and the phantom:
indices=find(I(:,:)>BackGroundThreshold); 
mask=ones(size(I));
mask(indices)=0;
%I(indices) = bkgr;
se = strel('disk',30);
mask2 = imerode(mask,se);

I(mask2==0) = bkgr;
 figure;imagesc(I);colormap(gray);
% I_imadjust = imadjust(I);
% I_histeq = histeq(I);

% figure;imagesc(I);colormap(gray);
%  figure;imagesc(I_imadjust);colormap(gray);
%  figure;imagesc(I_histeq);colormap(gray);
% 
% mask=ones(size(I));
% mask(indices)=0;
% figure;imagesc(mask);colormap(gray);
% se = strel('disk',30);
% mask2 = imerode(mask,se);
% figure;imagesc(mask2);colormap(gray);
% I=double(I).*mask;
% % figure;imshow(mask);
% % figure;imshow(mask2);

% imshow(I);
% cannyt=[0.004    0.015]
% [BW cannyt]= edge(I,'canny', cannyt);
BW= edge(I,'canny');

figure;imagesc(BW);colormap(gray);title('edge detection');

BW=BW.*mask2;


%figure;imagesc(BW); colormap(gray);title('edge detection * mask bck');

thetares=3;
rhores=1;
[H,theta,rho] = hough(BW,'ThetaResolution',thetares,'RhoResolution',rhores);

figure;
imshow(H,[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho'); title('All detected peaks');
axis on, axis normal, hold on;

P = houghpeaks(H,50,'threshold',ceil(0.01*max(H(:)))); 

x = theta(P(:,2)); 
y = rho(P(:,1));
plot(x,y,'s','color','white');


% remove bad values in P matrix
A= find(abs((P(:,2)-1)*thetares-90+90) < 2); 
B= find(abs((P(:,2)-1)*thetares-90- 0) < 2); 
C= find(abs((P(:,2)-1)*thetares-90-90) < 2); 
% D= find(P(:,1)==1721);
indexes=[A;B;C];
P=P(indexes,:);


% plot the new figure with the selected values:
figure;
imshow(H,[],'XData',theta,'YData',rho,...
        'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho'); title('Selected peaks');
axis on, axis normal, hold on;
x = theta(P(:,2)); 
y = rho(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BW,theta,rho,P,'FillGap',20,'MinLength',100);%'FillGap',800,

figure; imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
title('detected lignes from selected peaks');

%%%%%%%%%% display theta rho
rhotheta=[];
for k = 1:length(lines)
   rhotheta = [rhotheta; lines(k).rho lines(k).theta];
   end

%%%%%%%%% new P
PP=[];
for k = 1:length(lines)
    PP = [PP; find(rho==lines(k).rho) , find(theta==lines(k).theta) ];
end

lines = houghlines(BW,theta,rho,PP,'FillGap',1000,'MinLength',50);

figure; imshow(I), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
title('Found lines thanks to New line detection');

%% previous blockregistration3

% separate horizontals and vertical lines
i=1;j=1;
for k = 1:length(lines)
    if abs(lines(k).theta)<45 % theta =0 :vertical
        linesv(1,i)=lines(1,k);
        i=i+1;
    else
        linesh(1,j)=lines(1,k);
        j=j+1;
    end
end

% calculate mean theta horizontal and stick to this value
thetah=[];
for k = 1:length(linesh)
    thetah = [thetah; linesh(k).theta];
end
meanthetah= mean(thetah)
for k = 1:length(linesh)
    linesh(k).theta=meanthetah;
end

% calculate mean theta vertical and stick to this value
thetav=[];
for k = 1:length(linesv)
    thetav = [thetav; linesv(k).theta];
end
meanthetav= mean(thetav); %%%% !!!!wrong value
for k = 1:length(linesv)
    linesv(k).theta=meanthetav;
end

% find horizontal coordinates
coordh=[];
for k = 1:length(linesh)
   coordh = [coordh; linesh(k).point1(2)];
end
coordh=sort(coordh);
% find vertical coordinates
coordv=[];
for k = 1:length(linesv)
   coordv = [coordv; linesv(k).point1(1)];
end
coordv=sort(coordv);

% remove the doublons in coordh
newcoordh=[];
kk=1;
for k = 1:length(coordh)-1
    if coordh(k)~=coordh(k+1)
        newcoordh(kk)=coordh(k);
        kk=kk+1;
    end
end
newcoordh=[newcoordh coordh(length(coordh))]';
% remove the doublons in coordv
newcoordv=[];
kk=1;
for k = 1:length(coordv)-1
    if coordv(k)~=coordv(k+1)
        newcoordv(kk)=coordv(k);
        kk=kk+1;
    end
end
newcoordv=[newcoordv coordv(length(coordv))]';


