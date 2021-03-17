%function funccomputecolormap
%compatible with background and second threshold

%author Lionel HERVE
%creation date 5-9-2003

function Newcolormap=funccomputecolormap(Image,Threshold,boolBackground)

if boolBackground  %apply background if asked
     Newcolormap=Image.colormap;
     Newcolormap(Image.colornumber,:)=[0.5 0 0];
 else
    Newcolormap=Image.colormap;
end

if Threshold.bool&(~Threshold.Computed)
    tempseuil=Threshold.value*63;
    Newcolormap(1:Image.colornumber-1,2)=Newcolormap(1:Image.colornumber-1,2)+((([1:Image.colornumber-1]'-1)/(Image.colornumber-1).*(Image.colormax-Image.color0)+Image.color0)>tempseuil).*(0.1);    %add some green to the value over the Threshold
    Newcolormap(:,2)=Newcolormap(:,2)+(Newcolormap(:,2)>1).*(1-Newcolormap(:,2));  % put at 1 the value that exceed 1
end
    
clear tempseuil;
