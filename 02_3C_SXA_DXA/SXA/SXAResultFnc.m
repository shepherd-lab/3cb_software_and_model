%Lionel HERVE
%7-16-04
function SXAResultFnc(RequestedAction)

global ctrl Image Analysis ROI Info fredData

if strcmp(RequestedAction,'ShowDensityMap')
   %Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.DensityImage;
    %ReinitImage(Analysis.SXADensityImageTotal,'OPTIMIZEHIST');
    fredData.SXAImage=Analysis.SXADensityImageCrop;
    ReinitImage(Analysis.SXADensityImageCrop,'OPTIMIZEHIST');
    %{
     flag.Phantom=false;
     flag.ROI=false;
     HistogramManagement('ComputeHistogram',0);
     FuncActivateDeactivateButton;
     %}
    
    %draweverything;
elseif strcmp(RequestedAction,'ShowThicknessMap')
    %Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.ThicknessImage;
    ReinitImage(Analysis.SXAThicknessImageTotal,'OPTIMIZEHIST');
    %draweverything;
elseif strcmp(RequestedAction,'ShowOriginalImage')
    Image.OriginalImage=Image.OriginalImageInit;
    Image.image = Image.OriginalImageInit;
    if Info.Database == true      
            if  (~isempty(strfind(Info.orientation,'A\F')))
                if isempty(strfind(Info.orientation,'A\FR'))                 
                    ImageMenu('flipV');
                end
            elseif (~isempty(strfind(Info.orientation,'A\L')))
                ImageMenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\F')))
                if (~isempty(strfind(Info.orientation,'P\FL')))                 
                    ImageMenu('flipV');
                    ImageMenu('flipH');
                else
                    ImageMenu('flipH');
                end
            elseif (~isempty(strfind(Info.orientation,'P\H')))
                ImageMenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'P\L'))) 
                ImageMenu('flipH');
                ImageMenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\R')))
                ImageMenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                ;
            elseif (~isempty(strfind(Info.orientation,'A\R')))
                ;
            elseif (~isempty(strfind(Info.orientation,'film')))
                ;
            end  
        end   
    ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
   % draweverything;
end
 set(ctrl.text_zone,'String','Ok');

%figure;
%imagesc(Image.OriginalImage); colormap(gray)
%HistogramManagement('ComputeHistogram');
draweverything;
