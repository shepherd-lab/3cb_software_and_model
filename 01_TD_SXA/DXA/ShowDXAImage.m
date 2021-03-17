function ShowDXAImage(ImageType)
global Image Info Result X flag
global buttonPressed;

flag.ShowMaterial=false;
flag.ShowThickness=false;

if strcmp(ImageType,'LE')                     % Show LE
    Image.OriginalImage=Image.LE;
    Image.image=Image.LE;
    %figure;imagesc(Image.image);colormap(gray);
    Image.maximage=max(max(Image.image));
elseif strcmp(ImageType,'HE')                 % Show HE
    Image.OriginalImage=Image.HE;
    Image.image=Image.HE;
    Image.maximage=max(max(Image.image));
elseif strcmp(ImageType,'RST')                % Show RST
    Image.OriginalImage=Image.RST;
    Image.image=Image.RST;
    Image.OriginalImage=funcclim(Image.image,0.1,10);
    Image.maximage=max(max(Image.OriginalImage))

elseif strcmp(ImageType,'THICKNESS')          % Show THICKNESS

    if Result.DXAProdigyCalculated

        Image.thickness=-6.647976+ 9.886754*Image.RST+6.409571*(Image.HE/1000)-3.802842*Image.RST.^2+ 0.011835*(Image.HE/1000).^2-3.047368*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;

    elseif  Result.DXASeleniaCalculated      % Result.DXASelenia

        coef2=X(:,1);  %caution to the order
        coef=X(:,2);

        %Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
        Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
    end
    Image.OriginalImage=Image.thickness;
    Image.thickness=Image.OriginalImage;
    Image.image=Image.thickness;
    Image.OriginalImage=funcclim(Image.OriginalImage,-5,25);
    Image.maximage=max(max(Image.OriginalImage));
    flag.ShowThickness=true;
elseif strcmp(ImageType,'MATERIAL')           % Show MATERIAL

    if Result.DXAProdigyCalculated            %Result.DXAProdigy

        Image.material= -547.138189+299.085376*Image.RST-20.057537*(Image.HE/1000)+148.275575*Image.RST.^2+1.185130*(Image.HE/1000).^2+4.791195*(Image.HE/1000.*Image.RST);%+50;
        Image.thickness=-6.647976+ 9.886754*Image.RST+6.409571*(Image.HE/1000)-3.802842*Image.RST.^2+ 0.011835*(Image.HE/1000).^2-3.047368*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;

    elseif  Result.DXASeleniaCalculated       % Result.DXASelenia

        coef2=X(:,1);
        coef=X(:,2);

        Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
        Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;

    elseif strcmp(Info.DXACalibration,'lateral')     %calibration Lateral ?
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
%figure;imagesc(Image.image);colormap(gray);
%figure;
%imagesc(Image.OriginalImage); colormap(gray)
Info.DigitizerDescription='Hologic';
%buttonProcessing('CorrectionAsked');
%HistogramManagement('ComputeHistogram');
draweverything;
%figure;imagesc(Image.image);colormap(gray);
a = 1;

