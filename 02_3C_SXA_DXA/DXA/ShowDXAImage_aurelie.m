function ShowDXAImage(ImageType)
global Image Info Result X
global buttonPressed;

flag.ShowMaterial=false;

if strcmp(ImageType,'LE')
    Image.OriginalImage=Image.LE;
    Image.maximage=max(max(Image.image));    
elseif strcmp(ImageType,'HE')
    Image.OriginalImage=Image.HE;
    Image.maximage=max(max(Image.image));    
elseif strcmp(ImageType,'RST')
    Image.OriginalImage=Image.RST;
    Image.image=Image.RST;
    Image.OriginalImage=funcclim(Image.image,0.1,10);
    Image.maximage=max(max(Image.OriginalImage)) 
   % figure;
   % imagesc(Result.RST); colormap(gray);
elseif strcmp(ImageType,'THICKNESS')
     if  Result.DXASeleniaCalculated   % Result.DXASelenia
           
coef2=X(:,1);
coef=X(:,2);

                %Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
            Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
     end
     Image.OriginalImage=Image.thickness;
     Image.thickness=Image.OriginalImage; 
     Image.image=Image.thickness;
     Image.OriginalImage=funcclim(Image.OriginalImage,-5,20);
     Image.maximage=max(max(Image.OriginalImage));   
    
    %flag.ShowMaterial=true;
elseif strcmp(ImageType,'MATERIAL')
    
if  Result.DXASeleniaCalculated   % Result.DXASelenia
       
        coef2=X(:,1);
        coef=X(:,2);

            Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
            Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
            % Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST)+coef(7)*Image.RST.^3+coef(8)*(Image.HE/1000).^3;%+50;
            %Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST)+coef2(7)*Image.RST.^3+coef2(8)*(Image.HE/1000).^3;;%-0.5;%-0.73; 
    
    elseif strcmp(Info.DXACalibration,'lateral')     %calibration Lateral
        %Calibration p161lh1
        Image.material=-1521.113402+822.6224304*Image.RST-1625.480798*(Image.HE/1000)+363.8522675*Image.RST.^2+20.92057283*(Image.HE/1000).^2+1409.539624*(Image.HE/1000.*Image.RST)+50;
    else
        %Calibration p161lh1
        Image.material=1522.437597-4087.17244*Image.RST-2065.65348*(Image.HE/1000)+2355.784874*Image.RST.^2+29.75419467*(Image.HE/1000).^2+1777.450806*(Image.HE/1000.*Image.RST)+50;
    
    end
   %
   Image.OriginalImage=Image.material;
   Image.material=Image.OriginalImage;    
   Image.image=Image.material;
    %}
   %Image.OriginalImage=Image.RST;
   %Image.RST=Image.OriginalImage;    
   %Image.image=Image.RST;
   %{
   Image.OriginalImage=Image.thickness;
   Image.thickness=Image.OriginalImage; 
   Image.image=Image.thickness;
    %}
    Image.OriginalImage=funcclim(Image.OriginalImage,-50,200);
    Image.maximage=max(max(Image.OriginalImage));   
    
    flag.ShowMaterial=true;
end
%Image.image=Image.OriginalImage;
ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
%figure;
%imagesc(Image.OriginalImage); colormap(gray)
Info.DigitizerDescription='Hologic';
%buttonProcessing('CorrectionAsked');
%HistogramManagement('ComputeHistogram');
draweverything;
