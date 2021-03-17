function ReturnResults=StructuralAnalysisComputationROI(CancerRegionData)
global ROI Outline Analysis Image StructuralAnalysis Error figuretodraw

dynamic=65536;
UnderSamplingFactor=1;
BreastFraction=1;

%% initialisation
StructuralAnalysis.FDTH=[];
StructuralAnalysis.RMS=0;
StructuralAnalysis.CDslope=0;
StructuralAnalysis.Caldwell=0;
StructuralAnalysis.Intercept=0;
Error.PC=false;

%%
%try
tic
    %Work on uncorrected images
  
    croi.xmin = min(CancerRegionData.Points(:,1));
    croi.xmax = max(CancerRegionData.Points(:,1));
    croi.ymin = min(CancerRegionData.Points(:,2));
    croi.ymax = max(CancerRegionData.Points(:,2));
    CancerROIMask = roipoly(Image.OriginalImage, CancerRegionData.Points(:,1), CancerRegionData.Points(:,2));
    figure(figuretodraw);hold on;
    funcBox(croi.xmin,croi.ymin,croi.xmax,croi.ymax,'b',1);
    temp_image = Image.OriginalImage.*CancerROIMask;
    CurrentImage=temp_image(croi.ymin:croi.ymax,croi.xmin:croi.xmax);
    CurrentImage=UnderSamplingN(CurrentImage,UnderSamplingFactor);
    clear temp_image;
   %figure;imagesc(CurrentImage); colormap(gray);
  %imagesc(CurrentImage_notexcuded); colormap(gray);
   %CurrentImage= CurrentImage_notexcuded;

   %CurrentImage=excludePCmuscle(CurrentImage_notexcuded);
    %clear CurrentImage_notexcuded;
    %Erase ouside of the skin edge
%     midpoint=ceil(length(Outline.x)/2);
%     for index=1:midpoint
%         CurrentImage(1:ceil(BreastFraction*(Outline.y(index)-Analysis.midpoint)+Analysis.midpoint),ceil(BreastFraction*Outline.x(index)))=0;
%         CurrentImage(ceil(BreastFraction*(Outline.y(length(Outline.y)-index)-Analysis.midpoint)+Analysis.midpoint):end,ceil(BreastFraction*Outline.x(index)))=0;        
%     end    
%     CurrentImage(:,ceil(BreastFraction*midpoint):end)=0;
    %CurrentImage = CurrentImage.*BreastMask;
%     index1 = find(CurrentImage<0);
%     im1 = CurrentImage(index1);
    %CurrentImageInit = double(CurrentImage);
    %CurrentImage=UnderSamplingN(CurrentImage,UnderSamplingFactor);
    BreastMaskUndersample = ~(CurrentImage==0);
    %figure;imagesc(BreastMaskUndersample);colormap(gray);
%     index2 = find(CurrentImage<0);
%     im2 = CurrentImage(index2);
    %CurrentImageUnderSample = CurrentImage;
    % figure('Name', 'CurrentImage'); imagesc(CurrentImage); colormap(gray);  
    %compute primitive of histogram of the breast
      bins=[0:1000]*(dynamic-Analysis.BackGroundThreshold)/1000;
    FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
    Histc = histc(FlatImage,bins);
    Histc(1)=0;   %erase background from calculation
    Histp=cumsum(Histc);
    Histp=Histp/Histp(end);
    %figure;
    %plot(Histp);
    %fractal analysis 
    FractalCurrentImage=CurrentImage;
   % figure;
   % imagesc(CurrentImage); colormap(gray);
   % figure;imagesc(FractalCurrentImage); colormap(gray);
    x=1:4;
    for k=x       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fractal dimension of thresholded image "FD_th"
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for indexFractalThreshold=1:17
            FractalThreshold=0.05*indexFractalThreshold;
            [maxi,thresholdindex]=max(Histp>FractalThreshold);
            threshold=bins(thresholdindex);
            
            %compute fractal dimension (feature 1: FD_th_x%)
            image = (FractalCurrentImage>threshold);
            [gradiant,gradimage]=myGradiant(image);
            FD_Th(k,indexFractalThreshold)=log10(gradiant);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fractal dimension of RMS %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %destroy the zeros 
        FlatImage=reshape(FractalCurrentImage,1,prod(size(FractalCurrentImage)));        
        Sorted=sort(FlatImage,2);
        [maxi,index]=max(Sorted>0);
        Sorted(1:index-1)=[];
        resultVar(k)=log10(var(Sorted))/2;

        %%%%%%%%%%%%%%%%%%%%%
        %%%%% CALDWELL %%%%%%
        %%%%%%%%%%%%%%%%%%%%%
        tempImage=abs(FractalCurrentImage(1:end-1,1:end-1)-FractalCurrentImage(2:end,1:end-1))+abs(FractalCurrentImage(1:end-1,1:end-1)-FractalCurrentImage(1:end-1,2:end));
        CalwellSurface(k)=log10(sum(sum(tempImage)));
        
        FractalCurrentImage=UnderSamplingN(FractalCurrentImage,2);
        %figure('Name', 'FractalCurrentImage');
        %imagesc(FractalCurrentImage); colormap(gray);  
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Continuous dimension %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CdYintX=[1:5]; 
    for k=CdYintX          
        S=4*k+1;
        %Prolongate Image to avoid border effect
        ImageYint2=[CurrentImage(:,1)*ones(1,2*k) CurrentImage CurrentImage(:,end)*ones(1,2*k)];
        ImageYint2=[ones(2*k,1)*ImageYint2(1,:); ImageYint2; ones(2*k,1)*ImageYint2(end,:)];        
        
        filter=ones(S)/S^2;
        ConvImage=conv2(ImageYint2,filter,'valid');        
        ImageYint3=CurrentImage-ConvImage;
 
        [gradiant,imageGrad]=MyGradiant(ImageYint3);
        GradYint(k)=log10(gradiant);
    end
    
    %fractal analysis FD_TH
    for indexFractalThreshold=1:17
        p = polyfit(x,FD_Th(:,indexFractalThreshold)',1);
        StructuralAnalysis.FDTH(indexFractalThreshold)=-p(1)/log10(2);
    end
    
    %fractal analysis RMS
    p = polyfit(x,resultVar,1);
    StructuralAnalysis.RMS=-p(1)/log10(2);

    %Caldwell
    p = polyfit(x,CalwellSurface,1);
    StructuralAnalysis.Caldwell=-p(1)/log10(2);
    
    %continuous dimension
    p = polyfit(log10(CdYintX),GradYint,1);
    StructuralAnalysis.CDslope=p(1);
    StructuralAnalysis.CDIntercept=p(2);

    %HZ_PROJ
    signal=sum(CurrentImage');
    %find the row where the number of pixel id less than 10 and destroy them
    pixels=sum(CurrentImage'>0);
    RowsToKeep=pixels>=10;    
    [Sorted,indexSort]=sort(RowsToKeep);
    [maxi,index]=max(Sorted);
    signal=signal./pixels;
    signal(indexSort(1:index-1))=[];
    StructuralAnalysis.HZPROJ=(var(signal))^0.5/1000;
        
    ReturnResults=[StructuralAnalysis.FDTH StructuralAnalysis.RMS StructuralAnalysis.CDIntercept StructuralAnalysis.CDslope StructuralAnalysis.HZPROJ StructuralAnalysis.Caldwell];
    StructuralAnalysis.Results=ReturnResults;
    str = StructuralAnalysis
   % SaveInDatabase('STRUCTURALANALYSIS');  %for temporary
    ;
      display('films');
    toc 
    %%%%%%%%%%%%%%%% FIRST ORDER GRAY-LEVEL HISTOGRAM %%%%%%%%%%%
    
    tic 
    %figure;imagesc(CurrentImage);colormap(gray);
    %CurrentImage = CurrentImageInit;
    %CurrentImage = CurrentImageUnderSample;
    %figure;imagesc(CurrentImage);colormap(gray);
     %CurrentImage = CurrentImage.*BreastMask;
     %figure('Name', 'CurrentImage'); imagesc(CurrentImage); colormap(gray);  
      min_CurrentImage = min(min(CurrentImage));
     if min_CurrentImage < 0 & abs(min_CurrentImage)< 10000
         CurrentImage = (CurrentImage - min_CurrentImage+1).*BreastMaskUndersample;
     end
     FlatImage=reshape(CurrentImage,1,prod(size(CurrentImage)));  
     Sorted_vect=sort(FlatImage,2);
     [maxi,index]=max(Sorted_vect>0);
     Sorted_vect(1:index-1)=[];
     
     
     Num = length(Sorted_vect);
     std_image = std(Sorted_vect);
     mean_image = mean(Sorted_vect);
     min_image = round(min(Sorted_vect));
     max_image = round(max(Sorted_vect));
     var_image = var(Sorted_vect);
     skew_roi = sum(((Sorted_vect - mean_image)/std_image).^3)/(Num-1);
     kurt_roi = sum(((Sorted_vect - mean_image)/std_image).^4)/(Num-1); 
         
%      skew_roi2 = sum(sum((((CurrentImage - mean_image)/std_image).^3).*BreastMaskUndersample))/(Num-1);
%      kurt_roi2 = sum(sum((((CurrentImage - mean_image)/std_image).^4).*BreastMaskUndersample))/(Num-1);
     %StructuralAnalysis.
      display('first order');
       toc 
     
       tic
       bin = min_image:0.5:max_image;
      histogram=double(histc(reshape(CurrentImage,1,prod(size(CurrentImage))),bin));

      sum100 = sum(histogram);
      sum30 = sum100*0.3;
      sum50 = sum100/2;
      sum70 = sum100*0.7;
      
      grmean = mean_image;
%       sum_hist(1) = 0;      
%       for i = 1:length(histogram)
%          sum_hist(i) = sum(histogram(1:i));
%       end
      
      sum_hist = cumsum(histogram);
      gr30_index = find(sum_hist>sum30);
      gr30 = sum_hist(gr30_index(1)-1);
      %figure; bar(histogram(1:gr25_index(1)-1));
      
      gr50_index = find(sum_hist>sum50);
      gr50 = sum_hist(gr50_index(1)-1);
      %figure; bar(histogram(gr25_index(1):gr50_index(1)-1));
      
      gr70_index = find(sum_hist>sum70);
      gr70 = sum_hist(gr70_index(1)-1);
      %figure; bar(histogram(gr50_index(1):gr75_index(1)-1));
      balance = (gr70 - grmean)/(grmean - gr30);
      StructuralAnalysis.std_image = std_image;
      StructuralAnalysis.skewness = skew_roi;
      StructuralAnalysis.kurtosis = kurt_roi;
      StructuralAnalysis.balance = balance;

      display('balance');
      toc
       
      %%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   
   
    %%%%%%%%%%%%%%%%%%%%%%%%%  GRAY-LEVEL CO_OCCURRENCE MATRIX (GLCM)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Create gray-level co-occurrence matrix from image
       tic
    Ng = 16;
    glcm_roi = graycomatrix(CurrentImage,'NumLevels',Ng,'GrayLimits',[min_image max_image]);
    stats = graycoprops(glcm_roi);
    N = sum(sum(glcm_roi));
    glcmroi_norm = glcm_roi/N;
    %glcm_norm = glcm_roi/N;
    glcm_0index = find(glcmroi_norm ~= 0);
    glcm_norm = glcmroi_norm(glcm_0index);
    glcmroi.entropy = -sum(glcm_norm.*log10(glcm_norm));
    energy = sum(sum(glcm_norm.^2)); %angular second moment
    gcontr = 0;
    sum_glcm = sum(sum(glcm_norm));
    glcmroi.energy = stats.Energy;
    glcmroi.contrast = stats.Contrast;
    glcmroi.homogeneity = stats.Homogeneity;
    glcmroi.correlation = stats.Correlation;
        
    StructuralAnalysis.glcmroi.energy = stats.Energy;
    StructuralAnalysis.glcmroi.contrast = stats.Contrast;
    StructuralAnalysis.glcmroi.homogeneity = stats.Homogeneity;
    StructuralAnalysis.glcmroi.correlation = stats.Correlation;

    %%%%%%%%%%% contrast calculation %%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:Ng
        for j = 1:Ng
            k_matr(i,j) = abs(i-j);
        end
    end
    
    for k = 0:Ng-1
        index = find(k_matr==k);
        gcontr = gcontr + k^2*sum(glcmroi_norm(index));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i_vect = 1:Ng;
    i_matr = repmat(i_vect,1,Ng);
    j_vect = 1:Ng;
    j_matr = repmat(j_vect,Ng,1);
    mx = 0; my = 0;
    for i = 1:Ng
        mx = mx + i*sum(glcmroi_norm(i,:));
    end
   
    for j = 1:Ng
        my = my + j*sum(glcmroi_norm(:,j));
    end
    
    
    sx = 0; sy = 0;
    for i = 1:Ng
        sx = sx + (i-mx)^2*sum(glcmroi_norm(i,:));
    end
    
    for j = 1:Ng
        sy = sy + (j-my)^2*sum(glcmroi_norm(:,j));
    end
    
    glcmroi.mean = sqrt(mx^2+my^2);
    glcmroi.std = sqrt(sx^2+sy^2);
    
    StructuralAnalysis.glcmroi.mean = glcmroi.mean;
    StructuralAnalysis.glcmroi.std = glcmroi.std;
   
    corr = 0;
    for i = 1:Ng
        for j = 1:Ng
            corr = corr + i*j*glcmroi_norm(i,j);
        end
    end
    correlation = (corr - mx*my)/(sx*sy);
    
    for i = 1:Ng
        px(i) = sum(glcmroi_norm(i,:));
    end
    
    for j = 1:Ng
        py(j) = sum(glcmroi_norm(:,j));
    end
    
    for i = 1:Ng
        for j = 1:Ng
            k_minus(i,j) = abs(i-j);
        end
    end
    
    for i = 1:Ng
        for j = 1:Ng
            k_plus(i,j) = i+j;
        end
    end
    
    p_xplusy = 0;
    for k = 2:2*Ng
        index = find(k_plus==k);
        p_xplusy = p_xplusy + sum(glcmroi_norm(index));
    end
    
    p_xminusy = 0;
    for k = 0:Ng
        index = find(k_minus==k);
        p_xminusy = p_xminusy + sum(glcmroi_norm(index));
    end

    
    a = 1;
   mi = 0; mj = 0;
     for i = 1:Ng
        for j = 1:Ng
            mi = mi + i*glcmroi_norm(i,j);
        end
     end
    
     for i = 1:Ng
        for j = 1:Ng
            mj = mj + j*glcmroi_norm(i,j);
        end
     end
    
     si2 = 0; sj2 = 0;
     
     for i = 1:Ng
        for j = 1:Ng
            si2 = si2 + glcmroi_norm(i,j)*(i-mi)^2;
        end
     end
     
      for i = 1:Ng
        for j = 1:Ng
            sj2 = sj2 + glcmroi_norm(i,j)*(j-mj)^2;
        end
      end
     
     g_c = 0;
     
     for i = 1:Ng
        for j = 1:Ng
            g_c  = g_c + glcmroi_norm(i,j)*(j-mj)*(i-mi)/sqrt(si2*sj2);
        end
     end
     
     dis = 0;
     
     for i = 1:Ng
        for j = 1:Ng
            dis  = dis + glcmroi_norm(i,j)*abs(i-j);
        end
     end
     
     inv_diffmom = 0;
     for i = 1:Ng
        for j = 1:Ng
            inv_diffmom  = inv_diffmom + glcmroi_norm(i,j)/(1+(i-j)^2); %homogeneity
        end
     end
     
     glcmroi.dissimilarity = dis;
     glcmroi.homogeneity = inv_diffmom;
     
     StructuralAnalysis.glcmroi.dissimilarity = glcmroi.dissimilarity;
     StructuralAnalysis.glcmroi.homogeneity = glcmroi.homogeneity;
%      imin = min(min(image_roi));
%      imax = max(max(image_roi));
     im_size = size(CurrentImage);
     %%%%%%%%%%%%%%%%%%%%%%% END GLCM  %%%%%%%%%%%%%%%%%%%%%%% 
      display('glcm'); 
      toc
      
      %%%%%%%%%%%%%%%% MEAN GRADIENT %%%%%%%%%%%%%%%%%%%%%%%%%
      tic
      d = 3;
      im_xplusd = zeros(size(CurrentImage));
      im_xminusd = zeros(size(CurrentImage));
      im_yplusd = zeros(size(CurrentImage));
      im_yminusd = zeros(size(CurrentImage));
      
      im_xplusd(1:im_size(1)-d,:) = CurrentImage(d+1:im_size(1),:);
      im_xminusd(d+1:im_size(1),:) = CurrentImage(1:im_size(1)-d,:); 
      im_yplusd(:,1:im_size(2)-d) = CurrentImage(:,d+1:im_size(2));
      im_yminusd(:,d+1:im_size(2)) = CurrentImage(:,1:im_size(2)-d); 
      
%       dims = size(im);
%       new_si = mod(-offset,dims(1:2));
      gd_image = abs(CurrentImage-im_xplusd) + abs(CurrentImage-im_xminusd) + abs(CurrentImage-im_yplusd) + abs(CurrentImage-im_yminusd);
      gd_image = gd_image(d+1:im_size(1)-d,d+1:im_size(2)-d);
      gd_size = size(gd_image);
      mean_gd = sum(sum(gd_image))/(gd_size(1)*gd_size(2));
      StructuralAnalysis.mean_gradient = mean_gd;
     display('mean gradient'); 
     toc
      %%%%%%%%%%%%%%%%%%%%%%%%  END   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
       %%%%%%%%%%%%%%%%%%%%%%%%%% FRACTAL MINKOWSKI DIMENSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     tic
     r = 1:10;
     for i = 1:10
         se3 = strel('rectangle', i*[3 3]);
         bw1 = imerode(CurrentImage, se3);
         bw2 = imdilate(CurrentImage,se3);
%          figure;imagesc(bw1);colormap(gray);
%          figure;imagesc(bw2);colormap(gray);
         V(i) = log10(sum(sum((bw2-bw1)))/i^3);
     end
         
    pm = polyfit(log10(1./r(2:end)),V(2:end),1);
    figure;plot(log10(1./r),V,'bo');hold on;
           plot(log10(1./r),pm(1)*log10(1./r)+pm(2),'r-');
    fr_mink=p(1);
    StructuralAnalysis.FD_Minkowki = fr_mink;
    display('minkowski'); 
    toc
   a = 1;
   %%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
   
   %%%%%%%%%%%%%%%%%%%% FOURIER ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          tic
   %CurrentImage = CurrentImageUnderSample;
   im_size = size(CurrentImage);
   ylen = im_size(1);
   xlen = im_size(2);
   x = (1:xlen);%-round(xlen/2);
   y = (1:ylen); %-);round(ylen/2)-
   [X,Y] = meshgrid(x,y);
   x0 = round(xlen/2);
   y0 = round(ylen/2);
   hann_wind = zeros(im_size(1),im_size(2)); 
   R = min([round(xlen/2) round(ylen/2)]);
   N = 2*R;
   zero_index = find(sqrt((X-x0).^2+(Y-y0).^2)>R);
   r = sqrt((X-x0).^2+(Y-y0).^2);
   rminus_index = find(r(Y>y0));
   r(rminus_index) = -r(rminus_index);
   hann_wind = 0.5*(cos(2*pi*r/N)+1);
   %hann_wind = 0.5*(1-cos(2*pi*r/N));
   hann_wind(zero_index) = 0;   
    % [THETA,RHO] = cart2pol(X,Y);
   
%    figure;imshow(hann_wind);
%    figure;surf(X,Y,hann_wind);
%    maxR = max(max(RHO));
%    minR = min(min(RHO));
   
    %im_min = round(min(min(CurrentImage)));
    %im_max = round(max(max(CurrentImage)));
    CurrentImage = (CurrentImage - min_image).*BreastMaskUndersample+1;
     % Y = fft2(CurrentImage-min_image+1,256,256);
      %Y = fft2(CurrentImage,256,256);
      Nf = 1024;
      xf = (1:Nf);%-round(xlen/2);
      yf = (1:Nf); %-);round(ylen/2)-
      [Xf,Yf] = meshgrid(xf,yf);
      z = hann_wind.*CurrentImage;
%       figure; imagesc(z);colormap(gray);
%       figure; imagesc(hann_wind);colormap(gray);
%       figure; imagesc(CurrentImage);colormap(gray);
      Yfft = fft2(z,Nf,Nf);
      Zfft = fftshift(Yfft);
      P_fft = abs(Zfft).^2;
      r = round(r);
      count = 0;
      %f = 0;
      f = zeros(1,Nf*Nf);
      P_vect = zeros(1,Nf*Nf);
      %figure; imagesc(P_fft);colormap(gray);
      r = sqrt((X-x0).^2+(Y-y0).^2);
      rminus_index = find(r(Y>y0));
      r(rminus_index) = -r(rminus_index);
      
      
      for u = 1:Nf
          for v = 1:Nf
              count = count + 1;
              f(count) = sqrt((u-0.5*Nf)^2 + (v-Nf*0.5)^2);
              %f(count) = sqrt((u-0.5*Nf)*(u-0.5*Nf) + (v-Nf*0.5)*(v-Nf*0.5));
              P_vect(count) = P_fft(u,v);
         
          end
      end
 
      f = round(f);
      minf = min(f);
      maxf = max(f);
      
      
      %Pfft_vect = zeros();
      for k=1:maxf
          r_index = find(f==k);
          if ~isempty(r_index)
            Pfft_vect(k) = mean(P_vect(r_index));
          end
      end
      xfm = 1:maxf;
      logf = log10([xfm]);
      logP = log10(Pfft_vect);
      k=1:128;          
      findex = find(logf>1.2 & logf<2.7);
      pf = polyfit(logf(findex)',logP(findex)',1);
      figure; plot(logf(findex),logP(findex),'bo');hold on; 
              plot(logf(findex), pf(1)*logf(findex)+pf(2),'r-');
      
     FT_FD = -pf(1);
     % figure;imagesc(P_fft/10^5);colormap(gray);
      %figure;surf(Xf,Yf,P_fft);
      
      u_v = zeros(Nf,Nf);
      u = 1:Nf;
      v = 1:Nf;
      
      for u = 1:Nf
          for v = 1:Nf
              u_v(u,v) = sqrt(u^2+v^2);
          end
      end
      
      %u_v = u.^2+v.^2
      FMP_fft = sum(sum(u_v.*abs(Zfft).^2))/(sum(sum(abs(Zfft).^2)));
      RMS_fft = sum(sum(abs(Zfft).^2));
      SMP_fft = sum(sum((u_v.^2).*abs(Zfft).^2))/(sum(sum(abs(Zfft).^2)));
      StructuralAnalysis.FMP_fft = FMP_fft;
      StructuralAnalysis.RMS_fft = RMS_fft;
      StructuralAnalysis.SMP_fft = SMP_fft;
      StructuralAnalysis.FT_FD = -pf(1);
      display('fourier transfer'); 
      toc
      
      
      %%%%%%%%%%%%%%%%%%%%%% NEIGHBOURHOOD OPERATIONS %%%%%%%%%%%%%%%%%%%%%% 
      tic
    d = 3;
    CurrentImage = round(CurrentImage);
    %I2 = nlfilter(image_roi,[3 3],'std2')
    fun = @(x) mean(x(:));
    B = nlfilter(CurrentImage,[2*d+1,2*d+1],fun);
    A = ((2*d+1)^2*B-CurrentImage)/((2*d+1)^2-1);
    xmin = d+1;
    xmax = im_size(1)-d;
    
    A = A(d+1:im_size(1)-d,d+1:im_size(2)-d);
    %A = A(2:4,2:4);
    j = 0;
    image_crop = round(CurrentImage(d+1:im_size(1)-d,d+1:im_size(2)-d));
%     im_size = size(image_roi);
%      min_image = round(min(min(CurrentImage)));
%      max_image = round(max(max(CurrentImage)));

     bin = min_image:1:max_image;
%     figure;hist(image_roi,bin);
    
%     histogram=histc(reshape(image_roi,1,im_size(1)*im_size(2)),bin); %,init:15000
%     %[C,I]=max(histogram(1:round(size(histogram,2)/2)));
%     array = reshape(image_roi,1,im_size(1)*im_size(2));
%     
%     index = find(histogram~=0);
%     figure; bar(histogram);
%     ma = histc(image_roi,bin);
   num = (im_size(1)-2*d)*(im_size(2)-2*d);
   
    for i=min_image:max_image
        index = find(image_crop==i);
        if ~isempty(index)
%             s(j) = 0;
%             N(j) = 0;
%             p(j) = 0;
%         else
            %i_array = repmat(i,1,size(index));
            j=j+1;
            grv(j) = i-min_image;
            s(j) = sum(abs(A(index)-i));
            N(j) = length(index);
            p(j) = (N(j)/num);
            %p(j) = (N(j)/((im_size(1))*(im_size(2))));
        end
    end
            
      %index2 = find(s~=0); 
      Ng = length(s);
      ns = sum(N);
      pm = sum(p);
      fcon = 0;
      fcon2 = 0;
      sum_s = sum(s)/num;
      dif = max_image - min_image;
      for i=1:Ng
%           for j =1:Ng
%               fcon = fcon + p(i)*p(j)*(grv(i)-grv(j))^2/((Ng*Ng-1)*sum_s);
              fcon2 = fcon2 + sum(p(i)*p.*(grv(i)-grv).^2/((Ng*Ng-1)*sum_s));
%           end
      end
      contrast = fcon;
      %contrast2 = p*p(j)*(grv(i)-grv(j))^2/((Ng*Ng-1)*sum_s)
      e = 10e-12;
      coarseness = 1/(e + sum(p.*s));
      fcomp = 0;
      for i=1:Ng
%           for j =1:Ng
%               %fcomp = fcomp + (p(i)*s(i) + p(j)*s(j))*abs(grv(i)-grv(j))/(num*(p(i)+p(j)));
              fcomp = fcomp + sum((p(i)*s(i) + p.*s).*abs(grv(i)-grv)/(num*(p(i)+p(j))));
%           end
      end
      complexity = fcomp;
      fstr = 0;
      for i=1:Ng
%           for j =1:Ng
%               fstr = fstr + (p(i)+p(j))*(grv(i)-grv(j))^2/(e+sum(s));
              fstr = fstr + sum((p(i)+p).*(grv(i)-grv).^2/(e+sum(s)));
%           end
      end
     strength = fstr;
     
     fbusy = 0;
     for i=1:Ng
%           for j =1:Ng
%               fbusy = fbusy + (grv(i)*p(i)-grv(j)*p(j))^2/(e+sum(s));
              fbusy = fbusy + sum((grv(i)*p(i)-grv.*p).^2/(e+sum(s)));
%           end
      end
     busyness = sum(p.*s)/fbusy;
     
     StructuralAnalysis.coarseness = coarseness;
     StructuralAnalysis.complexity = complexity;
     StructuralAnalysis.strength = strength;
     StructuralAnalysis.busyness = busyness;
     StructuralAnalysis.contrast = contrast;
         
     display('neighborhood'); 
     toc
    %%%%%%%%%%%%%%%%%%%%%%%%%%% END OF NEIGHBOURHOOD OPERATIONS     %%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
   
   a = 1;
   
    
% catch
%    lasterr
%    Error.PC=true; 
% end