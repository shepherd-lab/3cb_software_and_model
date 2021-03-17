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


function phantomType=getPhantomType_new();
global DEBUG Result Image
DEBUG = 1;

% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0cmDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-0.4cm(1cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.2cm(2cm)FatDo not know-1.tif'; 
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-2.2cm(3cm)FatDo not know-1.tif';  
%filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-4.4cm(5cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.2cm(6cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-6.2cm(7cm)FatDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)50-50Do not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.4cm(4cm)50-50Do not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)50-50Do not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-1.4cm(2cm)GlandDo not know-1.tif';
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-3.3cm(4cm)GlandDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-1.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.3cm(6cm)GlandDo not know-2.tif';  
% filename='P:\Vidar Images\test\Epsilon@3cm3cm-5.4cm(6cm)RachelDo not know-1.tif';

%Image=imread(filename);
%figure;imagesc(Image);colormap(gray);
%im = Result
%im1 = Result.image;

[x, y] = size(Image.OriginalImage);
ExtractedImage=imcrop(Image.OriginalImage,[y/2 0 3*y/8 x/2]);

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
    phantomType = 'WEDGE'; end
   