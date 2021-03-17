function ShowDXAImage(ImageType)
global Image Info Result
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
     if Result.DXAProdigyCalculated
       
         %Image.material= -547.138189+299.085376*Image.RST-20.057537*(Image.HE/1000)+148.275575*Image.RST.^2+1.185130*(Image.HE/1000).^2+4.791195*(Image.HE/1000.*Image.RST);%+50;
         Image.thickness=-6.647976+ 9.886754*Image.RST+6.409571*(Image.HE/1000)-3.802842*Image.RST.^2+ 0.011835*(Image.HE/1000).^2-3.047368*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
    
     elseif  Result.DXASeleniaCalculated   % Result.DXASelenia
           %25kVp
            %{
            coef2 = [-25.279
                    22.525
                    0.97745
                    -5.0958
                    -0.0017524
                    -0.26684];
                    coef = [1995.5
                            -2050.9
                            -4.2051
                            532.45
                            0.41547
                            -2.6921];
              %} 

              %31kVp
              %   
coef2=[-0.26538;-0.76593;0.85724;0.085613;-0.055361;-0.041485];
coef=[-210.45;335.79;-135.44;114.46;39.74;-116.8];
   %}

             %{
         coef2 = [-15.488 
             13.785  
             0.99736
             -3.1341
             -0.00073777
             -0.28427];

           coef = [   
             2187.5
             -2286.8
              12.692
              603.46
              0.81494
              -13.025];
             %}
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
    
    if Result.DXAProdigyCalculated %Result.DXAProdigy
       
         Image.material= -547.138189+299.085376*Image.RST-20.057537*(Image.HE/1000)+148.275575*Image.RST.^2+1.185130*(Image.HE/1000).^2+4.791195*(Image.HE/1000.*Image.RST);%+50;
         Image.thickness=-6.647976+ 9.886754*Image.RST+6.409571*(Image.HE/1000)-3.802842*Image.RST.^2+ 0.011835*(Image.HE/1000).^2-3.047368*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
    
    elseif  Result.DXASeleniaCalculated   % Result.DXASelenia
       
           %25kVp
            %{
            coef2 = [-25.279
                    22.525
                    0.97745
                    -5.0958
                    -0.0017524
                    -0.26684];
                    coef = [1995.5
                            -2050.9
                            -4.2051
                            532.45
                            0.41547
                            -2.6921];
              %} 

              %31kVp
              %   
coef2=[-0.26538;-0.76593;0.85724;0.085613;-0.055361;-0.041485];
coef=[-210.45;335.79;-135.44;114.46;39.74;-116.8];


       %}

             %{
         coef2 = [-15.488 
             13.785  
             0.99736
             -3.1341
             -0.00073777
             -0.28427];

           coef = [   
             2187.5
             -2286.8
              12.692
              603.46
              0.81494
              -13.025];
             %}
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
