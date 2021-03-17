%Lionel HERVE
%7-16-04
function SXAResultFnc(RequestedAction)

global ctrl Senograph Image Analysis ROI

if strcmp(RequestedAction,'ShowDensityMap')
    Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.DensityImage;
    %ReinitImage(Analysis.SXADensityImageTotal,'OPTIMIZEHIST');
    ReinitImage(Analysis.SXADensityImageCrop,'OPTIMIZEHIST');
    %{
     flag.Phantom=false;
     flag.ROI=false;
     HistogramManagement('ComputeHistogram',0);
     FuncActivateDeactivateButton;
     %}
    
    %draweverything;
elseif strcmp(RequestedAction,'ShowThicknessMap')
    Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.ThicknessImage;
    ReinitImage(Analysis.SXAThicknessImageTotal,'OPTIMIZEHIST');
    %draweverything;
elseif strcmp(RequestedAction,'ShowOriginalImage')
    Image.OriginalImage=Image.OriginalImageInit;
    Image.image = Image.OriginalImageInit;
    ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
   % draweverything;
end
 set(ctrl.text_zone,'String','Ok');

%figure;
%imagesc(Image.OriginalImage); colormap(gray)
%HistogramManagement('ComputeHistogram');
draweverything;
