%use a Flat Field Images
%SenographFnc('OpenFlatLE');
%SenographFnc('OpenFlatHE');

global Senograph Image Info Analysis ctrl

Image.OriginalImage=Senograph.LE-Senograph.FlatLE;
Analysis.BackGroundComputed=false; 
buttonProcessing('CorrectionAsked');

Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background
DrawEverything;

CalibrationData=DrawGrid(Senograph.LE-Senograph.FlatLE,Senograph.HE-Senograph.FlatHE);
DegreCalibration=2;
Calibration;

indextot=0;FinalImage=zeros(size(Senograph.LE));
ImLE=log(65536-(Senograph.LE-Senograph.FlatLE));
ImHE=log(65536-(Senograph.HE-Senograph.FlatHE));
FinalImage=zeros(size(ImHE));
for i1=0:DegreCalibration
    for i2=0:DegreCalibration-i1
        indextot=indextot+1;
        FinalImage=FinalImage+Coef(indextot)*(ImLE.^i1.*ImHE.^i2);
    end
end


BackGroundCorrected=CorrectBackGroundVariations(FinalImage,Analysis.BackGround);
Image.OriginalImage=funcclim(BackGroundCorrected+50,0,200);
Image.OriginalImage=undersamplingn(Image.OriginalImage,5);
Mask=Analysis.BackGround;
buttonProcessing('CorrectionAsked');
Analysis.BackGround=(undersamplingn(Mask,5)>0);
Image.image=Image.OriginalImage.*(1-Analysis.BackGround);
draweverything;
