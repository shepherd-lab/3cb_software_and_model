%find two first max

function [line1,line2,OutputRadon]=funcRadonDetectTwoMax1(BW3,theta,DrawBool,option)

[R,xp] = radon(BW3,theta);
OutputRadon=R;
if DrawBool
    figure, imagesc(theta, xp, R); colormap(hot);
    xlabel('\theta (degrees)'); ylabel('X\prime');
    title('R_{\theta} (X\prime)');
end
[maxi1,pos1]=max(R);
[maxi2,pos2]=max(maxi1);
%pos = [pos1 pos2];

if strcmp(option,'first')|strcmp(option,'last')
    %destroy first max to seek the second one
    R(pos1(pos2)-4:pos1(pos2)+4,:)=0;
    continu=true;
     while continu
        [maxi21,pos21]=max(R);
        [maxi22,pos22]=max(maxi21);
        
        %destroy first max to seek further
        R(max(pos21(pos22)-4,1):pos21(pos22)+4,:)=0;
        if strcmp(option,'first')
            if ((maxi22/maxi2)>0.5)||(maxi22>80) %check which is the first peek
                if pos1(pos2)<pos21(pos22)
                    pos1=pos21;
                    pos2=pos22;
                end
            else
                continu=false;
            end
        else  %last case
            if (maxi22/maxi2)>0.5||(maxi22>80) %check which is the first peek
                if pos1(pos2)>pos21(pos22)
                    pos1=pos21;
                    pos2=pos22;
                                   
                end
            else
                continu=false;
            end
        end
      end

      pos1m = pos1;
      pos2m = pos2;
      line1.angle=theta(pos2m);
      line1.x=pos1m(pos2m)-floor((size(R,1)+1)/2);

      R = OutputRadon;
     [R,xp] = radon(BW3,theta);
     R(pos1m(pos2m)-4:pos1m(pos2m)+4,:)=0;
     [maxi1,pos1]=max(R);
     [maxi2,pos2]=max(maxi1);
       R(pos1(pos2)-4:pos1(pos2)+4,:)=0;
     continu=true;
     while continu
        [maxi21,pos21]=max(R);
        [maxi22,pos22]=max(maxi21);
        
        %destroy first max to seek further
        R(max(pos21(pos22)-4,1):pos21(pos22)+4,:)=0;
        if strcmp(option,'first')
            if ((maxi22/maxi2)>0.5)||(maxi22>80) %check which is the first peek
                if pos1(pos2)<pos21(pos22)
                    pos1=pos21;
                    pos2=pos22;
                end
            else
                continu=false;
            end
        else  %last case
            if (maxi22/maxi2)>0.5||(maxi22>80) %check which is the first peek
                if pos1(pos2)>pos21(pos22)
                    pos1=pos21;
                    pos2=pos22;
                                   
                end
            else
                continu=false;
            end
        end
     end
   
     
end
 pos21m = pos1;
 pos22m = pos2;
 R = OutputRadon;
%line1.angle=theta(pos2m);
%line1.x=pos1m(pos2m)-floor((size(R,1)+1)/2);
%{
  R = OutputRadon;
  R(pos1(pos2)-4:pos1(pos2)+4,:)=0;
  [maxi21,pos21]=max(R);
  [maxi22,pos22]=max(maxi21);
%}
line2.angle=theta(pos22m);
line2.x=pos21m(pos22m)-floor((size(R,1)+1)/2);

