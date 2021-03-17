% funcFindStuffOnOutline
% 
%       Author Lionel HERVE 2/03

%  revision history
%       19-2-03 don't try to calculate analytic derivative = more changeable
%       5-03 get rid of snake algorithm 
%       5-13-03 transform the code to a function
%       8-11-03 change the algorithm to find the outline from the polynomial 
%       9-18-03 optimize skin detection algorithm
function [PreciseOutline,Surface,midcurve_p,midpoint]=funcFindStuffOnOutline(Outline)
 global  ROI  Outline Info Image
    %filter Outline
    
    res = 0.014;
    sizeFiltrationWindow=11;
    filteredOutline=round(conv(Outline.y,ones(1,sizeFiltrationWindow))/sizeFiltrationWindow);  
    Outline.y(ceil(sizeFiltrationWindow/2):size(Outline.y,2)-floor(sizeFiltrationWindow/2))=filteredOutline(sizeFiltrationWindow:size(filteredOutline,2)-sizeFiltrationWindow+1);
    
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
    
      %nipple removing
    xt = Outline.x';
    yt = Outline.y';
    sz = size(Image.image);
   % figure; plot(yt,xt,'b'); hold on;
    if ~isempty(strfind(Info.view, 'ML'));
    xyt = [xt;yt];
    ind = find(yt> 0.2*sz(1) & yt < 0.8*sz(1));
    Outline.x = xt';
    Outline.x(ind)  = round(nipple_removing(xt(ind),yt(ind)));     
    else    
    Outline.x = round(nipple_removing(xt,yt));
    end
    
    %find precise outline
    [PreciseOutline.x,PreciseOutline.y]=funcfindPreciseOutline(Outline.x,Outline.y);
     
     %Angle = new parameter    
    Npoint=181;    
    Sampling_x(Npoint)=0;
    Sampling_y(Npoint)=0;
    theta=round(atan((PreciseOutline.y-midpoint)./PreciseOutline.x)*180/pi);
    for index=1:size(theta,2);
        Sampling_x(theta(index)+91)=PreciseOutline.x(index);
        Sampling_y(theta(index)+91)=PreciseOutline.y(index);    
    end
    
    %find an analytic expression for all the breast
    tempvect=[0:Npoint-1]/(Npoint-1);
    degre=12;
    matrix=zeros(Npoint,degre+1);
    for index=0:Npoint-1
         matrix(index+1,:)=tempvect(index+1).^[degre:-1:0];
    end
    Outline.Px=matrix\(Sampling_x');
    v0=polyval(Outline.Px,0);
    v1=polyval(Outline.Px,1);
    Outline.Px(size(Outline.Px,1))=1;  %order 0 coefficient of Px put at 1
    Outline.Px(size(Outline.Px,1)-1)=Outline.Px(size(Outline.Px,1)-1)-v1+v0; %correction on order 1
    Outline.Py=matrix\(Sampling_y');    
  

method=2;
%find the coordinate of outline and preciseoutline points
if method==1  %former method
    %we go from parameter=0 to 1 in order that x increase or decrease by 1;
    parameter=0;
    index=1;
    Outline.x=0;
    Outline.y=0;
    currentx=round(polyval(Outline.Px,parameter));
    Outline.x(1)=currentx;
    Outline.y(1)=round(polyval(Outline.Py,parameter));
    while round(polyval(Outline.Px,parameter))>=1
        flagcontinue=true;
        dparameter=0.001;
        while flagcontinue
            tempparameter=parameter+dparameter;        
            tempx=round(polyval(Outline.Px,tempparameter));
            if abs(tempx-currentx)>1
                dparameter=dparameter/2;
            elseif abs(tempx-currentx)==0
                dparameter=dparameter*1.5;
            else 
                flagcontinue=false;
            end
        end
        parameter=tempparameter;
        currentx=tempx;
        index=index+1;
        Outline.x(index)=currentx;
        Outline.y(index)=round(polyval(Outline.Py,parameter));
    end
else %new method 8-11-2003
    %refine the outline until x vary less than 1 between each adjacent points
    step=0.001;raison=0.2;
    parameterlist=[0:step:1];
    Outline.x=round(polyval(Outline.Px,parameterlist));
    Outline.y=round(polyval(Outline.Py,parameterlist));
    count1 = 0;
    while sum(abs(diff(Outline.x))>1)>0
        step=step*raison;
        parameterlist=[0:step:1];
        Outline.x=round(polyval(Outline.Px,parameterlist));
        Outline.y=round(polyval(Outline.Py,parameterlist));
        count1 = count1+1;
        if count1 > 2000
            stop;
            return;
        end
    end
    
    %get rid of equivalent point;
    sizetab=size(Outline.x,2);
    for index=sizetab:-1:2
        if Outline.x(index)==Outline.x(index-1)
            Outline.x(index)=[];
            Outline.y(index)=[];        
        end
    end
    %get rid of points going backward
    [maxi,I]=max(Outline.x);
    i=2;
    count2 = 0; 
    %%%%% for DREAM
%     while i<I 
%         if Outline.x(i-1)>Outline.x(i)
%             while Outline.x(i)<=Outline.x(i-1)
%                 Outline.x(i)=[];
%                 Outline.y(i)=[];
%                 I=I-1;
%             end
%         end
%         i=i+1;
%         count2 = count2 + 1;
%         if count2 > 2000
%             stop;
%             return;
%         end
%     end
    %the Same in the other direction
%     i=I+1;
%     I=length(Outline.x);
%     count3 = 0;
%     while i<I
%         if Outline.x(i-1)<Outline.x(i)
%             while Outline.x(i)>Outline.x(i-1)
%                 Outline.x(i)=[];
%                 Outline.y(i)=[];
%                 I=I-1;
%                 if i>I
%                     break;
%                 end
%             end
%         end
%         i=i+1;
%         count3 = count3 + 1;
%         if count3 > 2000
%             stop;
%             return;
%         end
%     end
end

%  c2 = [count1;count2;count3]
%%%%%%%%%%%% end DREAM
%force the result to be in the box 0-ymax
Outline.y=Outline.y+(Outline.y>maxy).*(maxy-Outline.y);
Outline.y=Outline.y+(Outline.y<miny).*(miny-Outline.y);
    
[PreciseOutline.x,PreciseOutline.y]=funcfindPreciseOutline(Outline.x,Outline.y);

%compute the breast area
Surface=funcfindsurface(Outline);
   

function RefinedOutlinePart=funcrefine(Outline,param,step);

list=[param(1):(param(2)-param(1))*step:param(2)];
RefinedOutlinePart.p=list(2:size(list,2)-1);
RefinedOutlinePart.x=round(polyval(Outline.Px,RefinedOutlinePart.p));
RefinedOutlinePart.y=round(polyval(Outline.Py,RefinedOutlinePart.p));


