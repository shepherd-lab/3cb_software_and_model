%Compute RST

global Image Senograph

Image.OriginalImage=(log(65536-Senograph.LE)-log(65536-Senograph.FlatLE))./(log(65536-Senograph.HE)-log(65536-Senograph.FlatHE));
Image.OriginalImage=funcclim(Image.OriginalImage,0,3);
buttonProcessing('CorrectionAsked');

%Image.LE=-(log(65536-Senograph.LE)-log(65536-Senograph.FlatLE));
%Image.HE=-(log(65536-Senograph.HE)-log(65536-Senograph.FlatHE));
%Image.OriginalImage=funcclim((Image.HE-Image.LE*0.52)*200,0,100);
%buttonProcessing('CorrectionAsked');


