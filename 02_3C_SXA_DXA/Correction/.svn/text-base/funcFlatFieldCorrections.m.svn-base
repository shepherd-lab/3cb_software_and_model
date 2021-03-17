%funcFlatFieldCorrection.m
%correct cosine effect and flatfielcorrection from 'Correction' record data
%Lionel HERVE
%creation date 5-15-03
% former funcVidarCorrection.m and funcKodakCorrection.m have been merged
% 5-19-03 some speed optimization
% 7-8-03 management of the correction from database

function [Image,Analysis]=funcFlatFieldCorrection(Image,mAs,kVp,Analysis,FlatFieldCorrectionAsked,ctrl,option);
global Info Correction ReportText Error Recognition DEBUG params
%DEBUG = 1
%Info.PhantomComputed = true;
Analysis.PhantomHeight=-1;
Analysis.ThicknessUsed=0; %there are 3 kind of thickness measurement 0=error 1=D1 2=D2 3=Tag reading
%mincorrint = min(min(Correction.InterpolatedImage1))
%maxcorrint = max(max(Correction.InterpolatedImage1))
a1 = ReportText 
b1 = Error 
c1 = Recognition
%Correction.Digitizer = 1;
Correction.Blank = 0;
if ~exist('option')
    option='none';
end
%figure('Name', 'InterpolatedImage1');
% imagesc(Correction.InterpolatedImage1); colormap(gray);
 %figure('Name', 'CosImage');
 %imagesc(Correction.CosImage); colormap(gray);
 %Correction.InterpolatedImage1 = [];
Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background if it has not been already done

RetrieveInDatabase('CORRECTION');  %retrieve all the correction coefficients from the database
Correction.FlatField = 0;
corr = Correction;
%mincorrint = min(min(Correction.InterpolatedImage1))
%maxcorrint = max(max(Correction.InterpolatedImage1))
%Correction.InterpolatedImage1 = (Correction.InterpolatedImage1>0).*Correction.InterpolatedImage1;
 %figure('Name', 'InterpolatedImage1');
 %imagesc(Correction.InterpolatedImage1); colormap(gray);
 set(ctrl.text_zone,'String','Computing The Flat Field Correction...');drawnow;

if (mAs==0)&(kVp==0)  %if the mAs and kVp of the image is not known, apply a medium correction
    mAs=80;kVp=25;
end
%Correction.Digitizer = 0;
sIm = size(Image.OriginalImage)

if (sIm(1) > 1900 & Info.DigitizerId==3) |  (sIm(1) > 1600 & Info.DigitizerId~=3)
    Correction.small_film = 0;
else;
    Correction.small_film = 1;
end

%{
if (sIm(1) > 1900 & Info.DigitizerId==3) |  (sIm(1) > 1600 & Info.DigitizerId~=3)
    Correction.small_film = 0
else
    Correction.small_film = 1
end
%}
%Info.Correctiontype=4;
%Correction.Type = 4;
if get(ctrl.Cor,'value')
    if (Info.Correctiontype==1)||(Info.Correctiontype==5)
       
        CorrectedImage=FilmResponseCorrection(Image,Correction,Analysis,option,0);
        imFilm = max(max(CorrectedImage))
        %apply the transform of the image to obtain thickness images
       % CorrectedImage=((CorrectedImage-Correction.Z+Correction.K*log(mAs*(kVp-Correction.kVp0)^2))/Correction.Kmu); %coef are obtain for study p76lh1-pixelLaw
        imThick = max(max(CorrectedImage))
        %flat field correction + cosine effect
        if FlatFieldCorrectionAsked
            tempimage=CorrectedImage;
            CorrectedImage=funcAddImage(funcMulImage(CorrectedImage,Correction.CosImage),-Correction.InterpolatedImage1);
            imFF = max(max(CorrectedImage))
            if strcmp(option,'none')
             %   CorrectedImage=CorrectedImage+Analysis.BackGround.*(tempimage-CorrectedImage);   %do not apply correction on background pixels
                imFF2 = max(max(CorrectedImage))  
            end
        end
        Error.Correction=false;
    elseif Info.Correctiontype==2 %just add a correction image; don't care of cosine effect
        CorrectedImage=funcAddImage(Image.OriginalImage,-Correction.InterpolatedImage1);
    elseif (Info.Correctiontype==3)|(Info.Correctiontype==4)
        %%% phantom used to compute the thickness
     
      %  
        if Info.PhantomComputed==0
            message('!!!Phantom need to be computed to do the image correction!!!');
            for i=1:10 beep; pause(0.1);end
            return
        end
      %}
        
      %  figure('Name', 'PhantomImage');
       % imagesc(Image.OriginalImage); colormap(gray);
       CorrectedImage=FilmResponseCorrection(Image,Correction,Analysis,option,20000);
       % CorrectedImage = Image.OriginalImage;
       
       % figure('Name', 'PhantomImagewithFilmResponse');
       % imagesc(CorrectedImage); colormap(gray);
        
        
        imFFmax = max(max(CorrectedImage))      
        %CorrectedImage=(CorrectedImage>0).*CorrectedImage; %22 sept 2006
        %imFF4 = max(max(CorrectedImage))
        imFFmin = min(min(CorrectedImage))
        if true%Info.PhantomComputed
            if Analysis.PhantomID ~= 7 & Analysis.PhantomID ~= 6
                Analysis.Height1=Analysis.PhantomD1*25.4/169+27;
                Analysis.Height2=(225*25.4/169-Analysis.PhantomD2*25.4/169)/0.1959/Analysis.PhantomPosition*800;
                thickness1  = Analysis.Height1
                thickness2 = Analysis.Height2
                if abs((Analysis.Height2/Analysis.Height1)-1)<0.2           %When D1 and D2 are close, take D1
                    %   'Compatible heigth'
                    Analysis.PhantomHeight=Analysis.Height1;
                    Analysis.ThicknessUsed=1;
                else
                    Error.HEIGHT=true;
                    if Analysis.Height1<32                                  %When D1 is less than 32, take D1
                        [Analysis.PhantomHeight,index]=max([Analysis.Height1,Analysis.Height2])
                        Analysis.ThicknessUsed=index;
                    else
                        Analysis.PhantomHeight=Analysis.Height1
                        Analysis.ThicknessUsed=1;
                    end
                end
                         
            
                if ~Error.MM
                    Analysis.PhantomHeight=Recognition.MM;
                    Analysis.ThicknessUsed=3;
                    Error.ThicknessDiscrepancy=(abs(Analysis.Height1-Recognition.MM)>5)&&(abs(Analysis.Height2-Recognition.MM)>5); %if D1 and D2 have more then 5 mm of difference with the Tag distance, add this alert
                end

                if strcmp(Analysis.SXAMode,'Auto')  %dont change this value in Manual Mode
                    Error.HEIGHT=Analysis.PhantomHeight>70 
                end
            
            end
          %    figure('Name', 'CosImage');
          %  imagesc(Correction.CosImage); colormap(gray);
            
            GL50OverFatRatio=1.23;            
            %1.23 is the nominal value
            Correction.FlatField = 1;
            maxff = max(max(Correction.InterpolatedImage1))
            minff = min(min(Correction.InterpolatedImage1))
        
            %for cpmc database FF images
          % CurrentImage=FilmResponseCorrection(Image,Correction,Analysis,'none',0); %Correction.InterpolatedImage1
          %  CurrentImage = funcGradientGauss(CurrentImage,10);
            CurrentImage = Correction.InterpolatedImage1;
           % figure('Name', 'InterpolatedImage1');
            % imagesc(Correction.InterpolatedImage1); colormap(gray);   
            
            %clear CurrentImage
            %Correction.InterpolatedImage1=CosImage.*CurrentImage;
           % FFImage = CurrentImage .* Correction.CosImage;
           % if Correction.Blank == 1
               %FFImage = CurrentImage;% .* Correction.CosImage;
            %else
               FFImage = CurrentImage.* Correction.CosImage;
            %end
            %figure('Name', 'CosImage');
             %   imagesc(Correction.CosImage); colormap(gray);   
            
           % figure('Name', 'FFImage');
           % imagesc(FFImage); colormap(gray);
            
                
                
            clear CurrentImage
            addImage = funcAddImage(CorrectedImage,-FFImage)  + 45000;
            imFFadd = max(max(addImage))
          %  cb = Correction.Blank
            
           %figure('Name', 'CorrectedImage-FFImage+40000');
           %imagesc(addImage); colormap(gray);
            
          %  figure('Name', 'CosImage');
          %  imagesc(Correction.CosImage); colormap(gray);
            %if Correction.Blank == 0
              CorrectedImage=funcMulImage(addImage,Correction.CosImage);%/2700*GL50OverFatRatio;
            %else
            % CorrectedImage2=addImage;  
            %end
            % CorrectedImage=funcMulImage(addImage,Correction.CosImage)/2700*GL50OverFatRatio;
            %CorrectedImage=funcMulImage(funcAddImage(CorrectedImage,-Correction.InterpolatedImage1),Correction.CosImage)/2700*GL50OverFatRatio;
            imFF6 = max(max(CorrectedImage))
             clear  addImage;
             
            %FatValue=ValidMean(CorrectedImage(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2)));
   
            %FatValue=nanmean(nanmean(CorrectedImage(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
           %{
            MeanCosFat=mean(nanmean(Correction.CosImage(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
            RefValueFat=Analysis.PhantomHeight;
            
            Kappa=(RefValueFat-FatValue-GL50OverFatRatio*40)/MeanCosFat;
                        
            CorrectedImage=funcAddImage(CorrectedImage,Kappa*Correction.CosImage)+GL50OverFatRatio*40;
            %}
            %CorrectedImage = CorrectedImage2;
            %clear CorrectedImage2;
           
           % figure('Name', 'CorrectedImage_CorrInterp1Cos');
           %imagesc(CorrectedImage); colormap(gray);
            
          %  imFF7 = max(max(CorrectedImage))
            %figure('Name', 'CorrectedImageKappa');
            %imagesc(CorrectedImage); colormap(gray);
           % CorrectedImage=CorrectedImage+(CorrectedImage>150).*(150-CorrectedImage);
           % imFF8 = max(max(CorrectedImage))
            %figure('Name', 'CorrectedImage150');
            %imagesc(CorrectedImage); colormap(gray);
            Error.Correction=false;
        end
    end
    Image.image=CorrectedImage;
    Image.maximage=max(max(CorrectedImage));
else
    Image.image=Image.OriginalImage;
    Image.maximage=max(max(Image.image));
end;

