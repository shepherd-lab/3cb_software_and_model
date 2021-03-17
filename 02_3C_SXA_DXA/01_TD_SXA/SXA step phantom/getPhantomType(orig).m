% The function that determines the phantom type.
% This function returns 'step' if it's a step phantom, 'wedge' if it's a
% wedge phantom.
% The basic idea is that wedge phantom always touches the side of the image. 
% Step phantom doesn't touch the upper side of the image. 
%
% getPhantomType.m
% 03-07-2005  Qin   created. The function simply check if the phantom
% touches the top of image. If it is, then it's wedge phantom. The function
% may be optimized.
%                  
%
%

function phantomType=getPhantomType(Image,backGround);
global DEBUG
DEBUG = 0;

[x, y] = size(Image);
ExtractedImage=imcrop(Image,[y/2 0 3*y/8 x/2]);

if DEBUG figure;imagesc(ExtractedImage);title('Extracted Image');colormap(gray); end

[BW,thresh] = edge(ExtractedImage,'sobel')
if DEBUG figure;imagesc(BW); end

se90 = strel('line', 3, 90); 
se0 = strel('line', 3, 0);
BWsdil = imdilate(BW, [se90 se0]);
if DEBUG figure, imshow(BWsdil), title('dilated gradient mask'); end

BWdfill = imfill(BWsdil, 'holes');
if DEBUG figure, imshow(BWdfill), title('binary image with filled holes'); end

BWnobord = imclearborder(BWdfill, 4);
if DEBUG figure, imshow(BWnobord), title('border object removed'); end

bw = bwareaopen(BWnobord,30);
if DEBUG figure, imshow(bw), title('small objects removed'); end

seD = strel('diamond',1);
BWfinal = imerode(bw,seD);
BWfinal = imerode(BWfinal,seD);
if DEBUG figure, imshow(BWfinal), title('segmented image'); end
total = sum(sum(BWfinal));

if(total > 10000)
    phantomType = 'STEP';
else
    phantomType = 'WEDGE';
    


    