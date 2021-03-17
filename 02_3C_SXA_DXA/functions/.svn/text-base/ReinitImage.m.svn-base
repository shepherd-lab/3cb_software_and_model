function ReinitImage(InputImage,option);
%Lionel HERVE
%11-23-04

global Image Hist Info ctrl Analysis flag

if ~exist('option')
    option='none';
end

Image.image=InputImage;
Image.OriginalImage=InputImage; 
Image.maximage=max(max(InputImage));
Image.minimage=min(min(InputImage));
Image.maxOriginalImage=Image.maximage;
Image.minOriginalImage=Image.minimage;
%figure;
%imagesc(Image.image); colormap(gray); 
[Image.rows,Image.columns]=size(InputImage);
if Image.columns > 1350
    flag.small_paddle = false;
else
    flag.small_paddle = true;
end
%Background
%%%28 August commented
%{  
if ~Info.DXAModeOn
    Analysis.BackGroundComputed=false; %say the background has not been computed yet
    Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background
    %bkgr = background_phantomdigital(InputImage);
    %figure; imagesc(Analysis.BackGround); colormap(gray);
else
    Analysis.BackGroundComputed=true;  %DXA background
    %Analysis.BackGround=mask;
end
%}
if ~Info.DXAModeOn
    Analysis.BackGroundComputed=false; %say the background has not been computed yet
    Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background
else
    Analysis.BackGroundComputed=true;  %DXA background
    %Analysis.BackGround=mask;
end

%Analysis.BackGroundComputed=true;
HistogramManagement;
if strcmp(option,'OPTIMIZEHIST')
    [maxi,Hist.x0]=max(Hist.values(1:floor(length(Hist.values)/2)));
end



        