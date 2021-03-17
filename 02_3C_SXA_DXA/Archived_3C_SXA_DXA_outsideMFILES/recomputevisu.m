%recomputevisu
%to prevent from computing the visualization image everytime drawevrything
%is called
%in order to optimize the speed
% Lionel HERVE
% 9-19-03

function recomputevisu
global Image Analysis visu ctrl

%show the breastimage     
visu=Image.image;
%max_visuinit = max(max(visu))
%min_visuinit = min(min(visu))

%figure;
%imagesc(visu); colormap(gray);
%compute the visualization image (indexed image that goes from 1 to Image.colornumber, Image.color0 and Image.colormax vary from 0 to 63)
visu=visu/Image.maximage2;%Image.maximage;
if (Image.colormax-Image.color0)>0.01
    visu=(visu-Image.color0/63)/(Image.colormax/63-Image.color0/63)*(Image.colornumber-1)+1;    %normal case
else   %when bar- and bar+ are one over the second
    visu=+(visu>Image.colormax/63)*(Image.colornumber-2)+1;          %2 values    1 for < threshold Image.colornumber-1 for > threshold 
end;

 %figure;
 %imagesc(visu); colormap(gray);
 
if get(ctrl.ShowBackGround,'value')  %apply background if asked     
     visu=visu+Analysis.BackGround.*(Image.colornumber+0.5-visu);  %visu = Image.colornumber +0.5 in background      
end
%max_visuend = max(max(visu));
%min_visuend = min(min(visu));

%imagesc(visu); colormap(gray);
%visu=uint8(visu);
