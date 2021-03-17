%Validation of the correction
global Correction Image Info Analysis

Thickness=40;
MyImage=Thickness*ones(1983,1577);

TempImage=MyImage;
%Heel
K=-35;
TempImage=K+(TempImage+(Correction.InterpolatedImage1-min(min(Correction.InterpolatedImage1)))/2700);
if 0  %show flat field correction surface
    titi=(Correction.InterpolatedImage1-min(min(Correction.InterpolatedImage1)))/2700;
    titi2=undersamplingN(titi,20);
    figure;surf(titi2);
    figure;imagesc(TempImage);figure;plot(TempImage(1000,:));
end

%Cosine
[X,Y]=meshgrid(1:size(TempImage,2),1:size(TempImage,1));
Y=Y-size(Y,1)/2;
CosImage=0.6./(0.6^2+(X.^2+Y.^2)*(0.15*10^-3)^2).^0.5;
TempImage=TempImage./CosImage/1.23;

%Film response %coefficeint from p25lh2-CPMCFilrmResponseCorrection.xls
TestFilmResponse=0;
if TestFilmResponse %check if inverse of the film response is working fine
    ThicknessValues=[5:0.1:60];
    TempImage=ThicknessValues;
end
TempImage=(TempImage)/60;
TempImage=(TempImage<0.35).*(-1626929*(TempImage).^3+1249851*(TempImage).^2-154278*TempImage+ 18345)+(TempImage>=0.35).*( 200665*TempImage.^3 - 475990*TempImage.^2 + 370850*TempImage - 32853); 
if TestFilmResponse
    figure;plot(ThicknessValues,TempImage);hold on;
    MaskTop=TempImage>Correction.zerox;
    TempImage=TempImage+MaskTop.*tan((TempImage-Correction.zerox)/(Correction.maxx-Correction.zerox)*pi/2)*Correction.dilatation;
    MaskBottom=TempImage<Correction.zerox2;
    TempImage=TempImage-MaskBottom.*tan((TempImage-Correction.zerox2)/(Correction.maxx2-Correction.zerox2)*pi/2)*Correction.dilatation2;
    plot(ThicknessValues,TempImage,'r');hold off;    
    
    figure,plot(ThicknessValues(1:300),TempImage(1:300));hold on;
    
end

Image.OriginalImage=TempImage;
Image.image=TempImage;

%simulate the phaantom Measured the thickness  %invert some formula
Height=40;
Info.PhantomComputed=true;
Analysis.PhantomPosition=1000;
Analysis.PhantomD1=(Height-27)*169/25.4;
Analysis.PhantomD2=-(Height/800*Position*0.1959-225*25.4/169)/25.4*169;
Analysis.BackGround=zeros(size(TempImage));

                