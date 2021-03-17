Image.OriginalImage=Senograph.HE;
buttonProcessing('CorrectionAsked');
DrawEverything;
Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background


indextot=0;FinalImage=zeros(size(Senograph.LE));
ImLE=-log(65536-Senograph.LE);
ImHE=-log(65536-Senograph.HE);
Degre=1;
FinalImage=zeros(size(ImHE));
for i1=0:Degre
    for i2=0:Degre-i1
        indextot=indextot+1;
        FinalImage=FinalImage+Coef(indextot)*(ImLE.^i1.*ImHE.^i2);
    end
end

Image.OriginalImage=FinalImage;
buttonProcessing('CorrectionAsked');


UnderSamplingFactor=3;
LittleImage=undersamplingN(Image.image,UnderSamplingFactor);
LittleMask=(undersamplingN(Analysis.BackGround,UnderSamplingFactor)==1);

ScalingFactor=max(size(LittleMask));
[X,Y]=meshgrid(1:size(LittleMask,2),1:size(LittleMask,1));
X=X/ScalingFactor;Y=Y/ScalingFactor;
X=nonzeros(reshape(X.*LittleMask,1,prod(size(LittleMask))));
Y=nonzeros(reshape(Y.*LittleMask,1,prod(size(LittleMask))));
Z1=nonzeros(reshape(LittleImage.*LittleMask,1,prod(size(LittleMask))));

Degre=4;
M=[];
for i1=0:Degre
    for i2=0:Degre-i1
        M=[M X.^i1.*Y.^i2];
    end
end
CoefInter1=M\Z1;

[X,Y]=meshgrid(1:size(LittleMask,2),1:size(LittleMask,1));
X=X/ScalingFactor;Y=Y/ScalingFactor;

Interpol1=zeros(size(LittleMask));index=0;
Interpol2=zeros(size(LittleMask));index=0;
for i1=0:Degre
    for i2=0:Degre-i1
        index=index+1;
        Interpol1=Interpol1+CoefInter1(index)*X.^i1.*Y.^i2;
    end
end

Image.OriginalImage=funcclim(LittleImage-Interpol1+50,0,200);
buttonProcessing('CorrectionAsked')

