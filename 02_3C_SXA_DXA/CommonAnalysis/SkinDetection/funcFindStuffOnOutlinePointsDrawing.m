% funcfindstuffOnOutlinePointsDrawing
% slight modification form funcfindstuffOnOutline
% the skin edge is obtained by spline and not by polynomial interpolation
% Lionel HERVE
%9-19-03

function [Outline,PreciseOutline,Surface,midcurve_p,midpoint]=funcFindStuffOnOutline(Outline)
    %invert, if needed, the sens of the points in order the curve go form the bottom to
    %the top
    if Outline.y(1)<Outline.y(size(Outline.y)) 
        Outline.x=flipdim(Outline.x,1);
        Outline.y=flipdim(Outline.y,1);    
    end
    miny=min(Outline.y);
    maxy=max(Outline.y);
    
    %find midpoint
    [midpoint,midcurve_p]=funcFindMidPoint(Outline.x,Outline.y);
    
    %find precise outline
    [PreciseOutline.x,PreciseOutline.y]=funcfindPreciseOutline(Outline.x,Outline.y);
    
%compute the breast area
Surface=funcfindsurface(Outline);
