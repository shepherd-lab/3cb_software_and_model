%funcComputeBackGroundV2
%4-9-04 use the same algorithm for vidar and lumisys
%4-20-04 use the maximum value of the minumum value of each column

function Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);
global DEBUG Result Info
  kGE = 0.71;
    if Info.DigitizerId >= 5 & Info.DigitizerId <= 7%Info.DigitizerId == 5 | Info.DigitizerId == 6
        crop_coef = kGE;
    else
        crop_coef = 1;
    end

    if Analysis.BackGroundComputed==false
        set(ctrl.text_zone,'String','Computing Background...');   
        Analysis.BackGround=[];
        if Info.BackGround
           if Info.DigitizerId >= 4%Analysis.PhantomID == 8
             
             image_size = size(Image.OriginalImage);
             x_limit = 1350*crop_coef;
             if image_size(2) > x_limit
                %rect = [220,193,1279,1662];
                %figure;imagesc(Image.image); colormap(gray); 
               rect = [385,385,1270,1652];
               %              ymin = 385;
                ymin=50;
 %              ymax = image_size(1) - 385;
                ymax= image_size(1)-50;
 %              xmin = 385;
                xmin= 50;
 %              xmax = image_size(2) - 385;
                xmax=image_size(2)-50;
                %FD 11/17/2011 Prior limits failed for large breasts.  There may be
                %memory issues with the new limits - but they will
                %hopefully work on Ming.
               temp_image =Image.image(ymin:ymax,xmin:xmax);
               %temp_image = imcrop(Image.image,rect);
                bkgr_offset = 7000;
                %figure;imagesc(temp_image); colormap(gray);
                bkgr = background_phantomdigital(temp_image);
             else
                 bkgr = background_phantomdigital(Image.OriginalImage);
                  bkgr_offset = 5000;
             end
            
            % Analysis.BackGroundThreshold = bkgr+3000
             
             if Info.DigitizerId >= 8 &  Info.DigitizerId <= 10             
                Analysis.BackGroundThreshold = bkgr +100
             else
                Analysis.BackGroundThreshold = bkgr+bkgr_offset 
             end
            % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
             Analysis.BackGround = Image.OriginalImage<Analysis.BackGroundThreshold;
             if Result.flagLE == true
                 Analysis.BackGroundLE = Analysis.BackGround;
                 Analysis.BackGroundThresholdLE = Analysis.BackGroundThreshold;
             end
             % figure;imagesc(Analysis.BackGround);
             
             Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
              %figure;imagesc(Analysis.BackGround);colormap(gray);
              a = 1;
             % Analysis.BackGroundComputed=true; 
           else 
            
                %find the background.  the background threshold is defined by when more
                %than 1/4 of the image if less than the threshold. then add 1%
                immax = Image.maxOriginalImage;
                immin = min(min(Image.OriginalImage));

                  %  bin=[0:1000]/1000*Image.maxOriginalImage;
                    bin=  immin + [0:1000]/1000*(Image.maxOriginalImage-immin);
                   % figure;
                   %  imagesc(Image.OriginalImage); colormap(gray);
                    %compute the histogram
                    Hist.values=histc(reshape(Image.OriginalImage,1,prod(size(Image.OriginalImage))),bin);  
                    %find the threshold so as 1/4 of the image is below it
                   % figure;
                   % plot(bin,Hist.values); 
                    pos=1;
                    pr = prod(size(Image.OriginalImage))/ 4;
                    while sum(Hist.values(1:pos))<prod(size(Image.OriginalImage))/ 4  %at least, 1/4th of the image should be background
                        pos=pos+1; 
                    end
                    position = pos;
                Analysis.BackGroundThreshold=floor(bin(pos)+Image.maxOriginalImage*0.01);             %add 1%
                %Background computation from the threshold %with the new R2
                %version, the outside of the film is put to 0. However, this is not part of the background
                if immin == -32768
                    Analysis.BackGround=(Image.OriginalImage<Analysis.BackGroundThreshold)
                else    
                    Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);

                   % figure('Name', 'Mask0');
                  %  imagesc(Mask0); colormap(gray);

                    Image.OriginalImage=Image.OriginalImage.*Mask0;
                  %figure('Name', 'Image*Mask0');
                %imagesc(Image.OriginalImage); colormap(gray);
               %Analysis.BackGroundThreshold = 25000;
                    Analysis.BackGround=(Image.OriginalImage<Analysis.BackGroundThreshold).*Mask0;   

                end   
               % figure('Name', 'BackGround');
               % imagesc(Analysis.BackGround); colormap(gray);

                Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0);    %dilate background to erase little islands 
                %size_bkgr = size(Analysis.BackGround);
                % figure('Name', 'BackGround+Dilation');
                %imagesc(Analysis.BackGround); colormap(gray);
           end
        else
            Analysis.BackGround=zeros(size(Image.OriginalImage));
        end
       if DEBUG==1;figure;imagesc(Analysis.BackGround);title('ComputeBackGroundV2:"Background"');colormap(gray);end
        % figure;imagesc(Analysis.BackGround); colormap(gray);
       Analysis.BackGroundComputed=true; 
       
       % figure;imagesc(Analysis.BackGround);colormap(gray);
    end
end
  %figure;imagesc(Analysis.BackGround);colormap(gray);
