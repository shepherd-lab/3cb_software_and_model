% Load acquisitions 139,140,141,164,165,166,167 = flat field image of QA
% study-2 and compute de variance on the corrected image
global Image Info;

Sum2=zeros(1800,1500);
Sum1=zeros(1800,1500);
for index=[139 140 141 142 164 165 166 167];
    Info.AcquisitionKey=index;
    RetrieveInDatabase('ACQUISITION');
    MinY=round(size(Image.image,1)/2-850);MaxY=MinY+1700;
    MinX=10;MaxX=1250;    
    TempImage=Image.image(MinY:MaxY,MinX:MaxX);
    TempImage2=Image.image;
    TempImage=TempImage2-mean(mean(TempImage));
    Sum1=funcAddImage(Sum1,TempImage);
    Sum2=funcAddImage(Sum2,TempImage.^2);
end

Sum1=Sum1/8;
Sum2=Sum2/8;

stdImage=(Sum2-Sum1.^2).^0.5;
Image.OriginalImage=stdImage;
