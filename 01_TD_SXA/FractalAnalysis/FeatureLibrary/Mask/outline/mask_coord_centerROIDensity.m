function [X2,Y2] = mask_coord_centerROIDensity(imageObj)
 BreastROIMask = imageObj.imageThick>0.2;
 [Outline.x,Outline.y,error]=mask_funcfindOutline(BreastROIMask);
 if error
     error('mask_funcfindOutline:ELLIPSEFAILURE','Failure: enable to find inner ellipse');
 end
 [PreciseOutline,Analysis.Surface,midcurve_p,midpoint]=mask_funcFindStuffOnOutline(Outline); %#ok<NASGU>
 xmax = round(max(PreciseOutline.x));
 outline_xy = [PreciseOutline.x',PreciseOutline.y'];
 x_indexall = find(outline_xy(:,1) == xmax);
 len = round(length(x_indexall)/2);
 x_indexMax = x_indexall(len);
 ymax = PreciseOutline.y(x_indexMax);
 X2 = round(xmax/2);
 index_yskinup = outline_xy(:,1) == X2 & outline_xy(:,2)>(ymax +10);
 index_yskindown = find(outline_xy(:,1) == X2 & outline_xy(:,2)<(ymax -10));
 Y2 = round( mean((outline_xy(index_yskinup,2)) - mean(outline_xy(index_yskindown,2)))/2+ mean(outline_xy(index_yskindown,2)));
end
 