function  funcAddTagArea()
  
global Database Info Image Analysis ctrl Threshold f0 

acquisitionkeyList=textread('P:\Temp\good films\mlocc_test.txt','%u');

%acquisitionkeyList=cell2mat(funcSelectInTable('retrieveAcq','Choose an acquisition',0,'Cancel'));%acquisitionkeyList=textread('P:\Temp\good films\clean_list2.txt','%u');
%SpaceBackground = zeros(2000,1600);
%Analysis.BackGround = zeros(2000,1600);
%SpaceBackground2 = zeros(2000,1600);
%Analysis.BackGround2 = zeros(2000,1600);

%count =0;
%count2 = 0;
%count3 = 0;
%for index=1:size(acquisitionkeyList)
    out = load('image_space3d.mat','SpaceBackground2','count2');
    version6;
  %   
    Info.AcquisitionKey = acquisitionkeyList(1);
    %Database.Step=2;    
%    figure(f0.handle);
    RetrieveInDatabase('ACQUISITION'); 
   
  %  if size(Image.OriginalImage,1)<1800 &  size(Image.OriginalImage,1)>1550 
       % Analysis.BackGroundThreshold = 35000;
       [xmax2,ymin2,ymax2,xmin2] = funcROI(1-Analysis.BackGround,Image.OriginalImage,Info);
        Analysis.BackGround = 1 - Analysis.BackGround;
        Analysis.BackGround(:,1:1260) = 0;  
        size_AnalBkgr2 = size(Analysis.BackGround);
        size_Bkgr2 = size(out.SpaceBackground2);
        size_min2 = min([size_AnalBkgr2;size_Bkgr2])
       % if size_min > 1174
         %   count = count + 1
            Message('Big Image');
            diff1 = size_AnalBkgr2(2) - size_Bkgr2(2);
            Analysis.BackGround = Analysis.BackGround(1:size_min2(1), diff1:size_min2(2)+diff1-1);
            sz = size(Analysis.BackGround)
            SpaceBackgroundTag = out.SpaceBackground2(1:size_min2(1), 1:size_min2(2));
            SpaceBackgroundTag =funcGradientGauss(SpaceBackgroundTag,30);
            sz_tag = size(SpaceBackgroundTag)
            SpaceBackgroundTag = SpaceBackgroundTag + Analysis.BackGround * 300;
       % end
       %figure(ctrl.f0);
       figure('Name', 'Free Space Small');
       imagesc(SpaceBackgroundTag); colormap(gray);
       k1 = floor(out.count2 / 100) + 1;
       k2 = floor(out.count2 / 50) + 1;
       k3 = floor(out.count2 / 20) +1;
       k4 = floor(out.count2 / 10)+1;
       k5 = out.count2 - 3;
       
       % v = [k4 k5];
      v = [k1 k2 k3 k4 k5]
      %save('image_space3.mat');
      figure('Name', 'withTag');
      imcontour(SpaceBackgroundTag,v);
      
     % save('image_space3d.mat');
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%___
function [xmax,ymin,ymax,xmin] = funcROI(BackGround,Image,Info);
global Correction DEBUG
%
% ROI research
%   
%  find ROI with convolution and min/max method
%       
%
%   Author: Lionel HERVE  2-03 

[rows,columns]=size(BackGround);

%compel the column where the background is maximum to full
%background  (to correct case ID343)
[maxi,pos]=min(sum(BackGround));
if DEBUG==1 figure;plot(sum(BackGround));title('ROIDetection:"vertical projection of the background image"'); end

%figure;plot(sum(BackGround));title('ROIDetection:"vertical projection of the background image"');

BackGround(:,pos)=0;  %%the minimum at 0

  %      figure('Name', ' New BackGround');
   %     imagesc(BackGround); colormap(gray);

        convwindow=30;
%find the shape of the breast
[C,I]=min(transpose(BackGround));
I=I+(C==1).*(size(BackGround,2)-I);  %when the line is completly without backgroud, to prevent the result to be equal to 1
Iconv=WindowFiltration(I,convwindow);
if DEBUG==1 figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"'); end

%figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"');

%find the top of the ROI image
[C,ymin]=min(Iconv(convwindow:round(rows/2)));
%find the first point that reach the minimum value+10 (to be close of the edge of the breast)
[C,ymin]=min(Iconv(round(rows/2):-1:convwindow)>(C+10));ymin=round(rows/2)-ymin;
ymin=max(ymin-50,50);

%find the bottom of the ROI image
[C,ymax]=min(Iconv(round(rows/2):rows-convwindow));
%find the first point that reach the minimum value+10 (to be close of the edge of the breast)
[C,ymax]=min(Iconv(round(rows/2):rows-convwindow)>(C+10));
ymax=round(rows/2)+ymax;
ymax=min(ymax+50,size(Image,1)-50);

%find the the right edge of the breast
xmax=max(I(ymin:ymax));

%look at top and bottom part of the left side of the image to find where the
%film begins
SaturatedImage=(Image>Correction.SaturatedThreshold)|(Image==0);
[toto,xmin1]=min(sum(SaturatedImage(1:200,1:xmax))>160);
[toto,xmin2]=min(sum(SaturatedImage(end-200:end,1:xmax))>160);
xmin=max(xmin1,xmin2)+1;

%{

    Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);
    tempimage=funcCleanBackGround(Image,Analysis);
       % figure('Name', 'tempimage');
       % imagesc(tempimage); colormap(gray);
    
    Background = 1-Analysis.BackGround;
            
    set(ctrl.text_zone,'String','Computing ROI...');    
    [xmax,ymin,ymax,xmin] = funcROI(Background,Image.OriginalImage,Info);
    Background(:,xmax+30:end) = 0;        
     
    figure('Name', 'BackGround');
    imagesc(BackGround); colormap(gray);
        
    
    nextpatient(0);
%}