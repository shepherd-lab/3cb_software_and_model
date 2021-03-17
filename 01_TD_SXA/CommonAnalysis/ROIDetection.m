% ROI detection
% 
% version 2h
% find ROI
%
%       Author Lionel HERVE 2/03

function ROIDetection(RequestedAction)
global Analysis Image Threshold ctrl Info ROI flag f0 DEBUG Result Error %#ok<NUSED>

DEBUG = 0;
%% explainations
% this program assume we are working on a breast image oriented with the
% breast on the left side. It will draw a box that contains the breast in
% order to limit further computation to this ROI (Region Of Interest).
LINEPLOTSIZE=3;
set(ctrl.CheckBreast,'value',true);

 if Analysis.BackGroundComputed==false
        set(ctrl.text_zone,'String','Computing Background...');   
        Analysis.BackGround=[];
      Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);
 end
%% Management of the mode = Manual/Automatic/Imposed by the outside
%work on image with constant background %put background pixels to a
%constant value which is Analysis.BackGroundThreshold

switch RequestedAction
    case 'FROMOUTSIDE' %when the ROI parameters are retrieved from the database, don't recompute. 
        tempimage=funcCleanBackGround(Image);
        ROI.image=tempimage(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        ROI.BackGround=Analysis.BackGround(ROI.ymin:ROI.ymin+size(ROI.image,1)-1,ROI.xmin:ROI.xmin+size(ROI.image,2)-1);
    case 'FROMGUI'
        Info.CommonAnalysisKey=0;
        ROIDetection('ROOT');
    case 'ROOT'
        tempimage=funcCleanBackGround(Image);
%        figure('Name', 'tempimage');imagesc(tempimage); colormap(gray);
%          figure('Name', 'BackGround');
%         imagesc(1-Analysis.BackGround); colormap(gray);
        Threshold.Computed=false;    
        if get(ctrl.CheckAutoROI,'value')&get(ctrl.CheckBreast,'Value');
            %automatic mode. 
            set(ctrl.text_zone,'String','Computing ROI...');    
           %  figure;imagesc(Analysis.BackGround);colormap(gray);               
            [ROI.xmax,ROI.ymin,ROI.ymax,ROI.xmin] = funcROI(1-Analysis.BackGround,tempimage,Info); %Image.OriginalImage
            %%comment for smaller ROI 
              if Info.ViewId == 4 | Info.ViewId == 5
                  ROI.ymin = 1;                  
                  sz = size(tempimage);
                  ROI.ymax = sz(1) - 1;  
              end

%           if  Info.ViewId == 5
%                   ROI.ymin = 50;
%                   sz = size(tempimage);
%                   
%           elseif Info.ViewId == 4 
%                   sz = size(tempimage);
%                   ROI.ymax = sz(1) - 50; 
%           else
%               ;
%               end
        else             
            %manual mode. The operator is asked to draw the box by oneself            
            set(ctrl.text_zone,'String','Drag on the ROI');
            FreezeButtons(ctrl,f0,Info);
            k = waitforbuttonpress;
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = round(min(point1,point2));             % calculate locations
            offset = round(abs(point1-point2));         % and dimensions
            ROI.xmin=p1(1);ROI.ymin=p1(2);ROI.xmax=p1(1)+offset(1);ROI.ymax=p1(2)+offset(2);
            [ROI.xmin,ROI.ymin]=funcclipping(ROI.xmin,ROI.ymin,Image.rows,Image.columns);
            [ROI.xmax,ROI.ymax]=funcclipping(ROI.xmax,ROI.ymax,Image.rows,Image.columns);
           
            if get(ctrl.CheckBreast,'Value');
                tempimage2=tempimage(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax);
                tempbackground=Analysis.BackGround(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax);
            end
        end
        
        %move the left edge of the ROI so as there are no 0-value pixels in the ROI
        if ~(Info.DigitizerId == 9 | Info.centerlistactivated == 88)
            while min(Image.OriginalImage(ROI.ymin:ROI.ymax,ROI.xmin))==0
                ROI.xmin=ROI.xmin+1
            end
        end
        if Info.ViewId == 4 | Info.ViewId == 5
            ;
        else
            if ROI.xmin == 1
                ROI.xmin=ROI.xmin+1
            end
        end
        ROI.rows=ROI.ymax-ROI.ymin+1;
        ROI.columns=ROI.xmax-ROI.xmin+1;        
        ROI.image=tempimage(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        ROI.BackGround=Analysis.BackGround(ROI.ymin:ROI.ymin+size(ROI.image,1)-1,ROI.xmin:ROI.xmin+size(ROI.image,2)-1);
        
        %ctrl.roi = figure;
        %imagesc(ROI.image); colormap(gray);
end 
    
    
if get(ctrl.CheckBreast,'Value');
     Analysis.Step=1.5;   % analysis.Step keeps track 
    
else
     Analysis.Step=5;
end
 Result.DXAProdigyBreastCalculated = false;
%if  Result.DXAProdigyCalculated   
%    xmin=ROI.xmin;xmax=ROI.xmin+ROI.columns-1;ymin=ROI.ymin;ymax=ROI.ymin+ROI.rows-1;
    %if get(ctrl.ShowAL,'value')
 %   if ~exist('Undersamplingfactor')
 %   Undersamplingfactor=1;
  %  end
   % funcBox(xmin/Undersamplingfactor,ymin/Undersamplingfactor,xmax/Undersamplingfactor,ymax/Undersamplingfactor,'b',LINEPLOTSIZE);
    %end %dr
%else  

%Added by Am 11222013 to prevent Freezing 
p=ROI.ymax-ROI.ymin;
if (ROI.ymax-ROI.ymin)<150
Message('ROI Failed...');
Error.ROIFailed=true;  
stop;
end;     
    
[rows1,columns1]=size(Analysis.BackGround);
if Info.study_3C == false
Z=0.9*(columns1);
%% Commented by SM 031716
% % % if ROI.xmax> 0.9*(columns1);
% % % Message('ROI Failed...');
% % % Error.ROIFailed=true;  
% % % stop;
% % % end;

end;  
% ROI2 = ROI;
    draweverything;
%end
FuncActivateDeactivateButton;
set(ctrl.text_zone,'String','OK');


function Output=funcCleanBackGround(Image)
    global ctrl DEBUG Info Analysis Result
    
    set(ctrl.text_zone,'String','Cleaning background...');    
    if isfield(Image,'LE')
       Output=Image.LE+(Analysis.BackGroundLE|(Image.LE<Analysis.BackGroundThresholdLE)).*(-Image.LE+Analysis.BackGroundThresholdLE); 
       Analysis.BackGround = Analysis.BackGroundLE;
    else
       Output=Image.OriginalImage+(Analysis.BackGround|(Image.OriginalImage<Analysis.BackGroundThreshold)).*(-Image.OriginalImage+Analysis.BackGroundThreshold); 
    end

    %figure; imagesc(Output); colormap(gray);
    if DEBUG==1;figure;imagesc(Analysis.BackGround);title('ROIDetection:"Image with the background put to a constant"');colormap(gray);end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xmax,ymin,ymax,xmin] = funcROI(BackGround,Image,Info);
global Correction DEBUG Error
%
% ROI research
%   
%  find ROI with convolution and min/max method
%       
%
%   Author: Lionel HERVE  2-03 

Error.NoBreast=false;
Error.FeaturesFailed = false;
Error.NoBreast=false;

[rows,columns]=size(BackGround);

%compel the column where the background is maximum to full
%background  (to correct case ID343)
sm = sum(BackGround);
sm_index = find(sm~=0);
xmin = min(sm_index);
[maxi,pos]=min(sm(xmin:end));

if DEBUG==1 figure;plot(sum(BackGround));title('ROIDetection:"vertical projection of the background image"'); end

%figure;plot(sum(BackGround));title('ROIDetection:"vertical projection of the background image"');

BackGround(:,pos)=0;  %%the minimum at 0

  %      figure('Name', ' New BackGround');
   %     imagesc(BackGround); colormap(gray);

        convwindow=30;
%find the shape of the breast
[C,I]=min(transpose(BackGround(:,xmin:end)));
I=I+(C==1).*(size(BackGround,2)-I);  %when the line is completly without backgroud, to prevent the result to be equal to 1
Iconv=WindowFiltration(I,convwindow);
if DEBUG==1 figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"'); end

%figure;plot(Iconv);title('ROIDetection:"horizontal projection of position of the first background pixel"');

%find the top of the ROI image
[C,ymin]=min(Iconv(convwindow:round(rows/2)));
%find the first point that reach the minimum value+10 (to be close of the edge of the breast)
[C,ymin]=min(Iconv(round(rows/2):-1:convwindow)>(C+10));
ymin=round(rows/2)-ymin;
ymin=max(ymin-50,50);

%find the bottom of the ROI image
[C,ymax]=min(Iconv(round(rows/2):rows-convwindow));
%find the first point that reach the minimum value+10 (to be close of the edge of the breast)
[C,ymax]=min(Iconv(round(rows/2):rows-convwindow)>(C+10));
ymax=round(rows/2)+ymax;
ymax=min(ymax+50,size(Image,1)-50);

%find the the right edge of the breast
xmax=max(I(ymin:ymax));

% check to see there is a breast or not  %%Added by Am 11152013
if xmax <5   
Message('There is no Breast...');
Error.NoBreast=true;
stop;
end;

if xmax==rows
Message('ROI Failed...');
Error.ROIFailed=true;  
stop;
end;   


    
%look at top and bottom part of the left side of the image to find where the
%film begins
if Info.DigitizerId >= 4
    %xmin = 1;
else
    SaturatedImage=(Image>Correction.SaturatedThreshold)|(Image==0);
    [toto,xmin1]=min(sum(SaturatedImage(1:200,1:xmax))>160);
    [toto,xmin2]=min(sum(SaturatedImage(end-200:end,1:xmax))>160);
    xmin=max(xmin1,xmin2)+1;
end



