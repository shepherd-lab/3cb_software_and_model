% ComputeDXAGlandular
%author Lionel HERVE
%  date 8-22-03; Compute the glandular percentage in the DXA roi

DXA.area=0;
densitysum=0;
for indexx=-floor(DXA.r(1)/4)+1:floor(DXA.r(1)/4)
    dy=sin(acos(indexx/DXA.r(1)*4))*DXA.r(2)/4;
    x=round(DXA.middle(1)+indexx);
    y1=round(DXA.middle(2)-dy);
    y2=round(DXA.middle(2)+dy);
    %plot([x,x],[y1,y2]);
    densitysum=densitysum+sum(Image.material(y1:y2,x));
    DXA.area=DXA.area+y2-y1+1;
end    

densitysum/DXA.area-50
    
clear indexx;clear dy;clear densitysum;clear y1;clear y2;
        
    
