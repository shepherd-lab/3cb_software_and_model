function CorrectedImage=FilmResponseCorrection(Image,Correction,Analysis,option,addvalue)
global Info Database
%Lionel HERVE
%7-7-04 the images must be positive to be correctly displayed (so addvalue)
%8-31-04 implement new film response correction with asymetric sygmoid curve
tic
sIm = size(Image.OriginalImage)

if (sIm(1) > 1900 & Info.DigitizerId==3) |  (sIm(1) > 1600 & Info.DigitizerId~=3)
    Correction.small_film = 0;
else
    Correction.small_film = 1;
end

if Correction.Type<4
    %film response correction top part
    imFF10 = max(max(Image.OriginalImage))
    MaskTop=Image.OriginalImage>Correction.zerox;
    totalmax=1.5*Correction.maxx;   %new value of top saturation
    MaskSat=(Image.OriginalImage-Correction.zerox)/(Correction.maxx-Correction.zerox)>1;      %detect value that go beyond will circle because of the tan behavior
    tempimage=Image.OriginalImage+MaskTop.*tan((Image.OriginalImage-Correction.zerox)/(Correction.maxx-Correction.zerox)*pi/2)*Correction.dilatation;
    imFF11 = max(max(tempimage))
    MaskSat=MaskSat|(tempimage>totalmax);
    CorrectedImage=tempimage+MaskSat.*(-tempimage+totalmax);
    imFF12 = max(max(CorrectedImage))
    %film response correction bottom part
    if (Correction.zerox2~=0)
        MaskBottom=CorrectedImage<Correction.zerox2;
        MaskSat=(Image.OriginalImage-Correction.zerox2)/(Correction.maxx2-Correction.zerox2)>1;      %detect value that go beyond will circle because of the tan behavior
        tempimage=CorrectedImage-MaskBottom.*tan((CorrectedImage-Correction.zerox2)/(Correction.maxx2-Correction.zerox2)*pi/2)*Correction.dilatation2;
        if strcmp(option,'none')
            if (Analysis.BackGroundThreshold>Correction.zerox2)
                totalmin=-tan((Analysis.BackGroundThreshold-Correction.zerox2)/(Correction.maxx2-Correction.zerox2)*pi/2)*Correction.dilatation2+Analysis.BackGroundThreshold;   %new value of bottom saturation
            else
                totalmin=0;
            end
            tempimage=tempimage+Analysis.BackGround.*(-tempimage+totalmin)+addvalue;
            CorrectedImage=tempimage+((tempimage<totalmin)|MaskSat).*(-tempimage+totalmin);
        else
            CorrectedImage=tempimage;
        end
    end
else
    method=2
    if method==1
        ValidityBegining=Correction.coef(5)+500;
        ValidityEnding=Correction.coef(1)-500;
        X=ValidityBegining:100:ValidityEnding;
        Y=Correction.coef(2)+Correction.coef(3)*log(((X-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
        CorrectedImage=funcclim(Image.OriginalImage,ValidityBegining+100,ValidityEnding-100);
        Xi=reshape(CorrectedImage,1,prod(size(Image.OriginalImage)));
        [maxi,i0]=max(diff(X)./diff(Y));
        Yi=interp1(X,(Y-Y(i0))*maxi+X(i0),Xi,'linear');   
        CorrectedImage=reshape(Yi,size(CorrectedImage,1),size(CorrectedImage,2));
    else
        ValidityBegining=Correction.coef(5)+500;
        ValidityEnding=Correction.coef(1)-500;
        X=1:65536;X(1:ValidityBegining)=ValidityBegining;X(ValidityEnding:end)=ValidityEnding;
        Y=Correction.coef(2)+Correction.coef(3)*log(((X-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
        [maxi,i0]=max(diff(X)./diff(Y));   %compute the slope of the linear part
       if Correction.small_film == 0   
           % maxcorr = max(max(Correction.InterpolatedImage1))
           % mincorr = min(min(Correction.InterpolatedImage1))
           %mtzion lorad film
          %{ 
           Correction.coef(1)= 61622;
            Correction.coef(2)=  30.09;%18.84;%27.05; % 28.05; % 18.84;
            Correction.coef(3)=  4.359;%2.8145%3.473; %4.121; % 2.8145;
            Correction.coef(4)=  0.57;%0.3467;%0.3537; %0.4479; % 0.34672;
            Correction.coef(5)= 12900; %10000;%8520;   %9950 ;% 13000; 
           %}
           
           %{
             parnassus film
             Correction.coef(1)=61622;
            Correction.coef(2)= 28.05; % 18.84;
            Correction.coef(3)= 4.121; % 2.8145;
            Correction.coef(4)= 0.4479; % 0.34672;
            Correction.coef(5)= 9950 ;% 13000; 
           %}
            
            %cpmc films
         if Info.DigitizerId==3
            Correction.coef(1)=62372;
            Correction.coef(2)=14.922;
            Correction.coef(3)=5.1665;
            Correction.coef(4)=0.90103;
            Correction.coef(5)=5500; 
         elseif Info.DigitizerId==1 
              % xm = strmatch('UKMarsden', Info.StudyID, 'exact');
               xm = strmatch('mammo_Marsden', Database.Name, 'exact');
              % Database.Name
               if xm > 0
                    Correction.coef(1)=61568;
                    Correction.coef(2)=11.664;
                    Correction.coef(3)=5.4986;
                    Correction.coef(4)=0.75715;
                    Correction.coef(5)=11957; 
                else
                    Correction.coef(1)=61622;
                    Correction.coef(2)=18.84;
                    Correction.coef(3)=2.8145;
                    Correction.coef(4)=0.34672;
                    Correction.coef(5)=13000;  
                end
           end         
           % b =  27.05  (25.39, 28.71)
           % c =  3.473  (2.732, 4.214)
           % d =  0.3537  (0.2348, 0.4725)
           % e =  8520  (fixed at bound)
                       
            if Correction.FlatField == 1
                imaxnt = max(max(Correction.InterpolatedImage1))
                iminnt = min(min(Correction.InterpolatedImage1))
                CorrectedImage=(Y(Correction.InterpolatedImage1+1)-Y(i0))*maxi + X(i0);
                Correction.FlatField = 0;
            else
                CorrectedImage=(Y(Image.OriginalImage+1)-Y(i0))*maxi +X(i0);   %+1 is to prevent the have the zeros
            end
        else 
            %maxcorr = max(max(Correction.InterpolatedImage1))
            %mincorr = min(min(Correction.InterpolatedImage1))
            
            %{
            Correction.coef(1)=61622;
            Correction.coef(2)= 28.05; % 18.84;
            Correction.coef(3)= 4.121; % 2.8145;
            Correction.coef(4)= 0.4479; % 0.34672;
            Correction.coef(5)= 9950 ;% 13000; 
             %}
            
            %{
            Correction.coef(1)=61622;
            Correction.coef(2)=  30.09;%18.84;%27.05; % 28.05; % 18.84;
            Correction.coef(3)=  4.359;%2.8145%3.473; %4.121; % 2.8145;
            Correction.coef(4)=  0.57;%0.3467;%0.3537; %0.4479; % 0.34672;
            Correction.coef(5)=  12900;%10000;%8520;   %9950 ;% 13000; 
            %} 
            
            %CPMC films
           if Info.DigitizerId==3 
            Correction.coef(1)=62372;
            Correction.coef(2)=14.922;
            Correction.coef(3)=5.1665;
            Correction.coef(4)=0.90103;
            Correction.coef(5)=5500;
           elseif Info.DigitizerId==1 
              % xm = strmatch('UKMarsden', Info.StudyID, 'exact');
                xm = strmatch('mammo_Marsden', Database.Name, 'exact');
                if xm > 0
                    Correction.coef(1)=61568;
                    Correction.coef(2)=11.664;
                    Correction.coef(3)=5.4986;
                    Correction.coef(4)=0.75715;
                    Correction.coef(5)=11957; 
                else
                    Correction.coef(1)=61622;
                    Correction.coef(2)=18.84;
                    Correction.coef(3)=2.8145;
                    Correction.coef(4)=0.34672;
                    Correction.coef(5)=13000; 
                end
           end
            i0v = i0
            xX = X(i0)
            yY = Y(i0)
            ysize = size(Y)
            xsize = size(X)
            %CorrectedImage=(Y(Correction.InterpolatedImage1+1)-Y(i0))*maxi * 1.0 +X(i0); 
            if Correction.FlatField == 1
                max_int = max(max(Correction.InterpolatedImage1))
                min_int = min(min(Correction.InterpolatedImage1))
                CorrectedImage=(Y(Correction.InterpolatedImage1+1)-Y(i0)) * maxi  + X(i0);% - 10000;
                maxinterp1 = max(max(CorrectedImage))
                mininterp1 = min(min(CorrectedImage))
                Correction.FlatField = 0;
            else
                CorrectedImage=(Y(Image.OriginalImage+1)-Y(i0))*maxi+X(i0);     %+1 is to prevent the have the zeros
            end
        end
	end
end

['film response correction time:',num2str(toc)]