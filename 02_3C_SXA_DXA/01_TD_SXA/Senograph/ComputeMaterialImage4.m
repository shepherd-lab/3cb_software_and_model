%use a Flat Field Images
%divide the images by the corresponding flatfield as it should be.
%SenographFnc('OpenFlatLE');
%SenographFnc('OpenFlatHE');

global Senograph Image Info Analysis ctrl

Image.OriginalImage=Senograph.LE;
Analysis.BackGroundComputed=false; 
buttonProcessing('CorrectionAsked');

Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background
DrawEverything;

ImLE=-log(65536-Senograph.LE)+log(65536-Senograph.FlatLE);
ImHE=-log(65536-Senograph.HE)+log(65536-Senograph.FlatHE);
CalibrationData=DrawGrid(ImLE,ImHE);
CalibrationData(:,5)=CalibrationData(:,3);
CalibrationData(:,6)=CalibrationData(:,4);
DegreCalibration=2;
Calibration;

indextot=0;FinalImage=zeros(size(Senograph.LE));
FinalImage=zeros(size(ImHE));
ThicknessImage=zeros(size(ImHE));
for i1=0:DegreCalibration
    for i2=0:DegreCalibration-i1
        indextot=indextot+1;
        FinalImage=FinalImage+Coef(indextot)*(ImLE.^i1.*ImHE.^i2);
        ThicknessImage=ThicknessImage+Coef2(indextot)*(ImLE.^i1.*ImHE.^i2);
    end
end

GlandImage=FinalImage.*ThicknessImage;
GlandImageCorrected=CorrectBackGroundVariations(GlandImage,Analysis.BackGround);
FatImage=(100-FinalImage).*ThicknessImage;
FatImageCorrected=CorrectBackGroundVariations(FatImage,Analysis.BackGround);

CompositionImage=100*GlandImageCorrected./(GlandImageCorrected+FatImageCorrected);


Undersamplingfactor=1;
Image.OriginalImage=funcclim(CompositionImage+50,0,200);
Image.OriginalImage=undersamplingn(Image.OriginalImage,Undersamplingfactor);
Mask=Analysis.BackGround;
buttonProcessing('CorrectionAsked');
Analysis.BackGround=(undersamplingn(Mask,Undersamplingfactor)>0);
Image.image=Image.OriginalImage.*(1-Analysis.BackGround);
draweverything;
