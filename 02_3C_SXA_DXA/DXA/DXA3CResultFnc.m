%Serghei Malkov
%11-20-08
function DXA3CResultFnc(RequestedAction)

global ctrl Image Analysis ROI MaskROIproj Tmaskones


Image.CHE= Image.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
MaskROIproj =Tmaskones(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
if strcmp(RequestedAction,'ShowWaterMap') %density in DXA notation
    %Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.DensityImage;
    %ReinitImage(Analysis.SXADensityImageTotal,'OPTIMIZEHIST');
    Image.material=funcclim(Image.material,-0.5,10);
    ReinitImage(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,'OPTIMIZEHIST');
    %{
     flag.Phantom=false;
     flag.ROI=false;
     HistogramManagement('ComputeHistogram',0);
     FuncActivateDeactivateButton;
     %}
    
    %draweverything;
elseif strcmp(RequestedAction,'ShowFatMap')
    %Image.BreastImage = Image.OriginalImage;
    %Image.OriginalImage=Analysis.ThicknessImage;
    Image.thickness=funcclim(Image.thickness,-0.5,10);
    ReinitImage(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,'OPTIMIZEHIST');
    %draweverything;
elseif strcmp(RequestedAction,'ShowProteinMap')
    %Image.OriginalImage=Image.OriginalImageInit;
    %Image.image = Image.OriginalImageInit;
    %ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
    Image.thirdcomponent=funcclim(Image.thirdcomponent,-0.5,10);
    ReinitImage(Image.thirdcomponent(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,'OPTIMIZEHIST');
   % draweverything;ShowLEROIImage
elseif strcmp(RequestedAction,'ShowLEROIImage')
    %Image.OriginalImage=Image.OriginalImageInit;
    %Image.image = Image.OriginalImageInit;
    %ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
    %Image.thirdcomponent=funcclim(Image.thirdcomponent,-0.5,10);
    ReinitImage(Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1),'OPTIMIZEHIST'); %.*MaskROIproj
   % draweverything;ShowLEROIImage
elseif strcmp(RequestedAction,'WaterProteinImage')
    Image.waterprotein=Image.material+Image.thirdcomponent;
      ReinitImage(Image.waterprotein(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,'OPTIMIZEHIST'); %.*MaskROIproj
elseif strcmp(RequestedAction,'PercentProteinImage')
    Image.percentProtein=Image.thirdcomponent./(Image.material+Image.thirdcomponent)*100;
      ReinitImage(Image.percentProtein(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,'OPTIMIZEHIST'); %.*MaskROIproj
   
end
 set(ctrl.text_zone,'String','Ok');

%figure;
%imagesc(Image.OriginalImage); colormap(gray)
%HistogramManagement('ComputeHistogram');
draweverything;
