Image.OriginalImage=Senograph.HE;
buttonProcessing('CorrectionAsked');
Analysis.BackGroundComputed=false; 
Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background
DrawEverything;
Senograph.FlatHE=CorrectBackGroundVariations(Senograph.HE,Analysis.BackGround);
Senograph.FlatLE=CorrectBackGroundVariations(Senograph.LE,Analysis.BackGround);


DrawGrid();
DegreCalibration=3;
Calibration;

indextot=0;FinalImage=zeros(size(Senograph.LE));
ImLE=log(65536-Senograph.FlatLE);
ImHE=log(65536-Senograph.FlatHE);
FinalImage=zeros(size(ImHE));
for i1=0:DegreCalibration
    for i2=0:DegreCalibration-i1
        indextot=indextot+1;
        FinalImage=FinalImage+Coef(indextot)*(ImLE.^i1.*ImHE.^i2);
    end
end

Image.OriginalImage=funcclim(FinalImage+50,0,200);
imagemenu('undersampling');imagemenu('undersampling');
buttonProcessing('CorrectionAsked');

