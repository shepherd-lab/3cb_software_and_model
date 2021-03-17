%find two first max

function [line,OutputRadon]=funcRadonDetectMax(BW3,theta,DrawBool,option)

[R,xp] = radon(BW3,theta);
OutputRadon=R;
if DrawBool
    figure, imagesc(theta, xp, R); colormap(hot);
    xlabel('\theta (degrees)'); ylabel('X\prime');
    title('R_{\theta} (X\prime)');
end
[maxi1,pos1]=max(R);
[maxi2,pos2]=max(maxi1);

if strcmp(option,'first')|strcmp(option,'last')
    %destroy first max to seek the second one
    R(pos1(pos2)-5:pos1(pos2)+5,:)=0;
    continu=true;
    while continu
        [maxi21,pos21]=max(R);
        [maxi22,pos22]=max(maxi21);
        %destroy first max to seek further
        R(max(pos21(pos22)-5,1):pos21(pos22)+5,:)=0;
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

line.angle=theta(pos2);
line.x=pos1(pos2)-floor((size(R,1)+1)/2);
