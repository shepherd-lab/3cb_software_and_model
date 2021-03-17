%Correct background variations
%Lionel HERVE
%7-20-04

function Answer=CorrectBackGroundVariations(Image,Mask)


UnderSamplingFactor=10;

LittleImage=undersamplingN(Image,UnderSamplingFactor);
LittleMask=(undersamplingN(Mask,UnderSamplingFactor)==1);
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

[X,Y]=meshgrid(1:size(Image,2),1:size(Image,1));
X=X/ScalingFactor/UnderSamplingFactor;Y=Y/ScalingFactor/UnderSamplingFactor;
Interpol1=zeros(size(Image));
index=0;
for i1=0:Degre
    for i2=0:Degre-i1
        index=index+1;
        Interpol1=Interpol1+CoefInter1(index)*X.^i1.*Y.^i2;
    end
end

Answer=Image-Interpol1;

