%Show LE
flag.ShowMaterial=false;

if flag.action==1
    Image.OriginalImage=Image.LE;
    Image.maximage=max(max(Image.image));    
elseif flag.action==2
    Image.OriginalImage=Image.HE;
    Image.maximage=max(max(Image.image));    
elseif flag.action==3
    Image.OriginalImage=Image.RST;
    Image.image=Image.RST;
    Image.OriginalImage=funcclim(Image.image,1,2);
    Image.maximage=max(max(Image.OriginalImage));    
elseif flag.action==4
    
    if strcmp(Info.DXACalibration,'lateral')     %calibration Lateral
%        RST100=(2.759+0.1628)./Image.HE+(1.21700+0.02600)-(28.065+10.027)/                         %degre=2
%        1000000*Image.HE;   
%        RST0=(2.759-1.3819)./Image.HE+(1.21700-0.02400)-(28.065-8.19)/1000000*Image.HE;

%        RST0=(-7.3934*(Image.HE/1000).^2-6.3805*(Image.HE/1000)+1187.20000+2.0663./(Image.HE/1000))/1000;
%        RST100=(11.954*(Image.HE/1000).^2-62.641*(Image.HE/1000)+1256.30000+1.0053./(Image.HE/1000))/1000;
%        Image.material=(Image.RST-RST0)./(RST100-RST0)*100+50;

    %Calibration p161lh1
    Image.material=-1521.113402+822.6224304*Image.RST-1625.480798*(Image.HE/1000)+363.8522675*Image.RST.^2+20.92057283*(Image.HE/1000).^2+1409.539624*(Image.HE/1000.*Image.RST)+50;
%    Image.material=22477.8841857560-5259.52569887939*Image.RST-1990.71462562353*(Image.HE/1000)+2814.93067966832*Image.RST.^2+25.90292490122*(Image.HE/1000).^2+1710.48038347093*(Image.HE/1000.*Image.RST)+50;
else
        %calibration PA
        %degre 2
        %RST100=(2.2715+0.3835)./Image.HE+(1.2080+0.02500)-(27.226+9.3360)/1000000*Image.HE;
        %RST0=(2.2715-1.5727)./Image.HE+(1.2080-0.0196)-(27.2260-5.52)/1000000*Image.HE;
    
        %degre3
        %RST100=(2.988*(Image.HE/1000).^2-42.6180*(Image.HE/1000)+1236.7000+1.5094./(Image.HE/1000))/1000;
        %RST0=(0.1295*(Image.HE/1000).^2-21.3610*(Image.HE/1000)+1187.6000+0.9892./(Image.HE/1000))/1000;        
        
        %Calibration p161lh1
        Image.material=1522.437597-4087.17244*Image.RST-2065.65348*(Image.HE/1000)+2355.784874*Image.RST.^2+29.75419467*(Image.HE/1000).^2+1777.450806*(Image.HE/1000.*Image.RST)+50;
       
    end
        
    Image.OriginalImage=Image.material;
    Image.material=Image.OriginalImage;    
    Image.image=Image.OriginalImage;
    Image.OriginalImage=funcclim(Image.image,0,200);
    Image.maximage=max(max(Image.OriginalImage));    
    flag.ShowMaterial=true;
end
flag.action=0;
buttonPressed=8;buttonProcessing;


draweverything;


%clear RST0; clear RST100;
clear tempImage;