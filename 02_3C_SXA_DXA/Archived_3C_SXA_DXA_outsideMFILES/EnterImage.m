%EnterImage
%fill the fields of the Image structure, compute background and draw it
function Image=EnterImage(InputImage);
global ctrl Analysis

Image.image=InputImage;
Image.OriginalImage=Image.image;     
[Image.rows,Image.columns] = size(Image.image);
Image.maximage=max(max(Image.image));
set(ctrl.Cor,'value',false);
ResizeWindow; %fit to the screen
Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background if it has not been already done
recomputevisu;DrawEverything;
funcActivateDeactivateButton;
