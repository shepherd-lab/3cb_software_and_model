function mammo_feature = feature_extraction()
    roifile_name = '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\SXAVersion6.5_11-05-08_mz-10\Mammo_features\roi_lean.png';
 % first order gray level statistics 
    image_roi = double(imread(roifile_name));
    %figure;imagesc(image_roi);colormap(gray);
    
%     test_image = image_roi(1:5,1:5);
    %image_roi = test_image;
    %test_image = image_roi;
    %image_roi(:,:) = [1 1 4 3 1;3 4 0 1 1; 5 4 2 2 2; 2 1 1 4 4; 0 2 2 5 1];
    %figure; imagesc(test_image);colormap(gray);
    
    im_size = size(image_roi);
     sz_roi = size(image_roi);
     
%     Num = sz_roi(1)*sz_roi(2);
%     min_roi = min(min(image_roi));
%     max_roi = max(max(image_roi));
%     std_roi = std2(image_roi);
%     mean_roi = mean2(image_roi);
%     %mean_roi = mean(mean(image_roi));
%     vect_roi =  reshape(image_roi,1,Num);
%     %mn = mean(vect_roi);
%     std_image = sqrt(sum(sum((image_roi- mean_roi).^2))/(Num-1))
%     %std_roi2 = std(std(image_roi)); %wrong
%      % std_roi = std(vect_roi);
%     var_roi = var(vect_roi);
%     
%     skew_roi = sum(sum(((image_roi - mean_roi)/std_roi).^3))/(Num-1);
%     kurt_roi = sum(sum(((image_roi - mean_roi)/std_roi).^4))/(Num-1); 
%     
% %     skew_roi2 = sum(((vect_roi - mean_roi)/std_roi).^3)/(Num-1);
% %     kurt_roi2 = sum(((vect_roi - mean_roi)/std_roi).^4)/(Num-1); 

    %%%%%%%%%%%%%%%%%%%%%%% NEIGHBOURHOOD OPERATIONS %%%%%%%%%%%%%%%%%%%%%% 
%     d = 3;
%     %I2 = nlfilter(image_roi,[3 3],'std2')
%     fun = @(x) mean(x(:));
%     B = nlfilter(image_roi,[2*d+1,2*d+1],fun);
%     A = ((2*d+1)^2*B-image_roi)/((2*d+1)^2-1);
%     xmin = d+1;
%     xmax = im_size(1)-d;
%     
%     A = A(d+1:im_size(1)-d,d+1:im_size(2)-d);
%     %A = A(2:4,2:4);
%     j = 0;
%     image_crop = image_roi(d+1:im_size(1)-d,d+1:im_size(2)-d);
%     im_size = size(image_roi);
%     imin = min(min(image_roi));
%     imax = max(max(image_roi));
%      bin = imin:1:imax;
% %     figure;hist(image_roi,bin);
%     
% %     histogram=histc(reshape(image_roi,1,im_size(1)*im_size(2)),bin); %,init:15000
% %     %[C,I]=max(histogram(1:round(size(histogram,2)/2)));
% %     array = reshape(image_roi,1,im_size(1)*im_size(2));
% %     
% %     index = find(histogram~=0);
% %     figure; bar(histogram);
% %     ma = histc(image_roi,bin);
%    num = (im_size(1)-2*d)*(im_size(2)-2*d);
%    
%     for i=imin:imax
%         index = find(image_crop==i);
%         if ~isempty(index)
% %             s(j) = 0;
% %             N(j) = 0;
% %             p(j) = 0;
% %         else
%             i_array = repmat(i,1,size(index));
%             j=j+1;
%             grv(j) = i-imin;
%             s(j) = sum(abs(A(index)-i));
%             N(j) = length(index);
%             p(j) = (N(j)/num);
%             %p(j) = (N(j)/((im_size(1))*(im_size(2))));
%         end
%     end
%             
%       %index2 = find(s~=0); 
%       Ng = length(s);
%       ns = sum(N);
%       pm = sum(p);
%       fcon = 0;
%       sum_s = sum(s)/num;
%       dif = imax - imin
%       for i=1:Ng
%           for j =1:Ng
%               fcon = fcon + p(i)*p(j)*(grv(i)-grv(j))^2/((Ng*Ng-1)*sum_s);
%           end
%       end
%       contrast = fcon;
%       %contrast2 = p*p(j)*(grv(i)-grv(j))^2/((Ng*Ng-1)*sum_s)
%       e = 10e-12;
%       coarseness = 1/(e + sum(p.*s));
%       fcomp = 0;
%       for i=1:Ng
%           for j =1:Ng
%               fcomp = fcomp + (p(i)*s(i) + p(j)*s(j))*abs(grv(i)-grv(j))/(num*(p(i)+p(j)));
%           end
%       end
%       complexity = fcomp;
%       fstr = 0;
%       for i=1:Ng
%           for j =1:Ng
%               fstr = fstr + (p(i)+p(j))*(grv(i)-grv(j))^2/(e+sum(s));
%           end
%       end
%      strength = fstr;
%      
%      fbusy = 0;
%      for i=1:Ng
%           for j =1:Ng
%               fbusy = fbusy + (grv(i)*p(i)-grv(j)*p(j))^2/(e+sum(s));
%           end
%       end
%      busyness = sum(p.*s)/fbusy;

    %%%%%%%%%%%%%%%%%%%%%%%%%%% NEIGHBOURHOOD OPERATIONS     %%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%% 
     
%    
%%%%%%%%%%%%%%%%%%%%%%%%% second order gray level statistics
%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   %Create gray-level co-occurrence matrix from image
%     %glcm_roi1 = graycomatrix(image_roi,'NumLevels',16,'GrayLimits',[])
%     Ng = 16;
%     glcm_roi = graycomatrix(image_roi,'NumLevels',Ng,'GrayLimits',[min_roi max_roi]);
%     stats = graycoprops(glcm_roi);
%     N = sum(sum(glcm_roi));
%     glcmroi_norm = glcm_roi/N;
%     %glcm_norm = glcm_roi/N;
%     glcm_0index = find(glcmroi_norm ~= 0);
%     glcm_norm = glcmroi_norm(glcm_0index);
%     entropy = -sum(glcm_norm.*log10(glcm_norm));
%     energy = sum(sum(glcm_norm.^2)); %angular second moment
%     gcontr = 0;
%     sum_glcm = sum(sum(glcm_norm));
%     glcmroi.energy = stats.Energy;
%     glcmroi.contrast = stats.Contrast;
%     glcmroi.homogeneity = stats.Homogeneity;
%     glcmroi.correlation = stats.Correlation;

    %%%%%%%%%%%% contrast calculation %%%%%%%%%%%%%%%%%%%%%%%%
%     for i = 1:Ng
%         for j = 1:Ng
%             k_matr(i,j) = abs(i-j);
%         end
%     end
%     
%     for k = 0:Ng-1
%         index = find(k_matr==k);
%         gcontr = gcontr + k^2*sum(glcmroi_norm(index));
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     i_vect = 1:Ng;
%     i_matr = repmat(i_vect,1,Ng);
%     j_vect = 1:Ng;
%     j_matr = repmat(j_vect,Ng,1);
%     mx = 0; my = 0;
%     for i = 1:Ng
%         mx = mx + i*sum(glcmroi_norm(i,:));
%     end
%    
%     for j = 1:Ng
%         my = my + j*sum(glcmroi_norm(:,j));
%     end
%     
%     sx = 0; sy = 0;
%     for i = 1:Ng
%         sx = sx + (i-mx)^2*sum(glcmroi_norm(i,:));
%     end
%     
%     for j = 1:Ng
%         sy = sy + (j-my)^2*sum(glcmroi_norm(:,j));
%     end
%     
%     corr = 0;
%     for i = 1:Ng
%         for j = 1:Ng
%             corr = corr + i*j*glcmroi_norm(i,j);
%         end
%     end
%     correlation = (corr - mx*my)/(sx*sy);
%     
%     for i = 1:Ng
%         px(i) = sum(glcmroi_norm(i,:));
%     end
%     
%     for j = 1:Ng
%         py(j) = sum(glcmroi_norm(:,j));
%     end
%     
%     for i = 1:Ng
%         for j = 1:Ng
%             k_minus(i,j) = abs(i-j);
%         end
%     end
%     
%     for i = 1:Ng
%         for j = 1:Ng
%             k_plus(i,j) = i+j;
%         end
%     end
%     
%     p_xplusy = 0;
%     for k = 2:2*Ng
%         index = find(k_plus==k);
%         p_xplusy = p_xplusy + sum(glcmroi_norm(index));
%     end
%     
%     p_xminusy = 0;
%     for k = 0:Ng
%         index = find(k_minus==k);
%         p_xminusy = p_xminusy + sum(glcmroi_norm(index));
%     end
% 
%     
%     a = 1;
%    mi = 0; mj = 0;
%      for i = 1:Ng
%         for j = 1:Ng
%             mi = mi + i*glcmroi_norm(i,j);
%         end
%      end
%     
%      for i = 1:Ng
%         for j = 1:Ng
%             mj = mj + j*glcmroi_norm(i,j);
%         end
%      end
%     
%      si2 = 0; sj2 = 0;
%      
%      for i = 1:Ng
%         for j = 1:Ng
%             si2 = si2 + glcmroi_norm(i,j)*(i-mi)^2;
%         end
%      end
%      
%       for i = 1:Ng
%         for j = 1:Ng
%             sj2 = sj2 + glcmroi_norm(i,j)*(j-mj)^2;
%         end
%       end
%      
%      g_c = 0;
%      
%      for i = 1:Ng
%         for j = 1:Ng
%             g_c  = g_c + glcmroi_norm(i,j)*(j-mj)*(i-mi)/sqrt(si2*sj2);
%         end
%      end
%      
%      dis = 0;
%      
%      for i = 1:Ng
%         for j = 1:Ng
%             dis  = dis + glcmroi_norm(i,j)*abs(i-j);
%         end
%      end
%      
%      inv_diffmom = 0;
%      for i = 1:Ng
%         for j = 1:Ng
%             inv_diffmom  = inv_diffmom + glcmroi_norm(i,j)/(1+(i-j)^2); %homogeneity
%         end
%      end
%      
%      imin = min(min(image_roi));
%      imax = max(max(image_roi));
%      im_size = size(image_roi);
%      
%       bin = imin:0.5:imax;
%       histogram=double(histc(reshape(image_roi,1,im_size(1)*im_size(2)),bin));
%       sum_hist(1) = 0;
%       sum100 = sum(histogram);
%       sum30 = sum100*0.3;
%       sum50 = sum100/2;
%       sum70 = sum100*0.7;
%       
%       grmean = mean_roi;
%       
%       for i = 1:length(histogram)
%          sum_hist(i) = sum(histogram(1:i));
%       end
%       
%       gr30_index = find(sum_hist>sum30);
%       gr30 = sum_hist(gr30_index(1)-1);
%       %figure; bar(histogram(1:gr25_index(1)-1));
%       
%       gr50_index = find(sum_hist>sum50);
%       gr50 = sum_hist(gr50_index(1)-1);
%       %figure; bar(histogram(gr25_index(1):gr50_index(1)-1));
%       
%       gr70_index = find(sum_hist>sum70);
%       gr70 = sum_hist(gr70_index(1)-1);
%       %figure; bar(histogram(gr50_index(1):gr75_index(1)-1));
%       balance = (gr70 - grmean)/(grmean - gr30);
%       
%       %%%%%%%%%%%%%%%% mean gradient %%%%%%%%%%%%%%%%%%%%%%%%%
%       d = 3;
%       im_xplusd = zeros(size(image_roi));
%       im_xminusd = zeros(size(image_roi));
%       im_yplusd = zeros(size(image_roi));
%       im_yminusd = zeros(size(image_roi));
%       
%       im_xplusd(1:im_size(1)-d,:) = image_roi(d+1:im_size(1),:);
%       im_xminusd(d+1:im_size(1),:) = image_roi(1:im_size(1)-d,:); 
%       im_yplusd(:,1:im_size(2)-d) = image_roi(:,d+1:im_size(2));
%       im_yminusd(:,d+1:im_size(2)) = image_roi(:,1:im_size(2)-d); 
%       
% %       dims = size(im);
% %       new_si = mod(-offset,dims(1:2));
%       gd_image = abs(image_roi-im_xplusd) + abs(image_roi-im_xminusd) + abs(image_roi-im_yplusd) + abs(image_roi-im_yminusd);
%       gd_image = gd_image(d+1:im_size(1)-d,d+1:im_size(2)-d);
%       gd_size = size(gd_image);
%       mean_gd = sum(sum(gd_image))/(gd_size(1)*gd_size(2));
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      %%%%%%%%%%%% Fourier analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
%       
%    ylen = im_size(1);
%    xlen = im_size(2);
%    x = (1:xlen);%-round(xlen/2);
%    y = (1:ylen); %-);round(ylen/2)-
%    [X,Y] = meshgrid(x,y);
%    x0 = round(xlen/2);
%    y0 = round(ylen/2);
%    hann_wind = zeros(im_size(1),im_size(2)); 
%    R = min([round(xlen/2) round(ylen/2)]);
%    N = 2*R;
%    zero_index = find(sqrt((X-x0).^2+(Y-y0).^2)>R);
%    r = sqrt((X-x0).^2+(Y-y0).^2);
%    rminus_index = find(r(Y>y0));
%    r(rminus_index) = -r(rminus_index);
%    hann_wind = 0.5*(cos(2*pi*r/N)+1);
%    %hann_wind = 0.5*(1-cos(2*pi*r/N));
%    hann_wind(zero_index) = 0;   
%     % [THETA,RHO] = cart2pol(X,Y);
%    
% %    figure;imshow(hann_wind);
% %    figure;surf(X,Y,hann_wind);
% %    maxR = max(max(RHO));
% %    minR = min(min(RHO));
%    
%     im_min = min(min(image_roi));
%     im_max = max(max(image_roi));
%     image_roi = image_roi - im_min+1;
%      % Y = fft2(image_roi-im_min+1,256,256);
%       %Y = fft2(image_roi,256,256);
%       Nf = 256;
%       xf = (1:Nf);%-round(xlen/2);
%       yf = (1:Nf); %-);round(ylen/2)-
%       [Xf,Yf] = meshgrid(xf,yf);
%       z = hann_wind.*image_roi;
%       Yfft = fft2(z,256,256);
%       Zfft = fftshift(Yfft);
%       P_fft = abs(Zfft).^2;
%       r = round(r);
%       count = 0;
%       f = 0;
%       
%       figure; imagesc(P_fft);colormap(gray);
%       r = sqrt((X-x0).^2+(Y-y0).^2);
%       rminus_index = find(r(Y>y0));
%       r(rminus_index) = -r(rminus_index);
%       
%       for u = 1:256
%           for v = 1:256
%               count = count + 1;
%               f(count) = sqrt((u-0.5*Nf)^2 + (v-Nf*0.5)^2);
%               P_vect(count) = P_fft(u,v);
%          
%           end
%       end
%  
%       f = round(f);
%       minf = min(f);
%       maxf = max(f);
%       
%       
%       %Pfft_vect = zeros();
%       for k=1:maxf
%           r_index = find(f==k);
%           if ~isempty(r_index)
%             Pfft_vect(k) = mean(P_vect(r_index));
%           end
%       end
%       xf = 1:maxf;
%       logf = log10([xf]);
%       logP = log10(Pfft_vect);
%       k=1:128;          
%       findex = find(logf>0.6 & logf<1.8);
%       p = polyfit(logf(findex)',logP(findex)',1)
%       figure; plot(logf(findex),logP(findex),'bo');
%       
%       for u = 1:256
%           for v = 1:256
%               f(u,v) = sqrt(u^2 + v^2);
%           end
%       end
%       
%       
%       figure;imagesc(P_fft/10^5);colormap(gray);
%       figure;surf(Xf,Yf,P_fft);
%       
%       
%       u = 1:Nf;
%       v = 1:Nf;
%       
%       for u = 1:Nf
%           for v = 1:Nf
%               u_v = sqrt(u^2+v^2);
%           end
%       end
%       
%       %u_v = u.^2+v.^2
%       fmp_fft = sum(sum(u_v.*abs(Zfft).^2))/(sum(sum(abs(Zfft).^2)));
   
   %%%%%%%%%%%%%%%%%%%%%%%%% fractal dimension %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % minkowski dimension
     r = 1:10;
     for i = 1:10
         se3 = strel('rectangle', i*[3 3]);
         bw1 = imerode(image_roi, se3);
         bw2 = imdilate(image_roi,se3);
%          figure;imagesc(bw1);colormap(gray);
%          figure;imagesc(bw2);colormap(gray);
         V(i) = log10(sum(sum((bw2-bw1)))/i^3);
     end
         
    p = polyfit(log10(1./r(2:end)),V(2:end),1);
    figure;plot(log10(1./r),V,'bo');
    fr_mink=p(1);
   a = 1;
      
      
     
     function out = hanning(length)
% A simple function to calculate a hanning window of
% length LENGTH. Values will be returned in OUT.
%
% Written for the GPR toolbox by U Theune, 2003

if ~rem(length,2)
    % length is even
    w = .5*(1-cos(2*pi*(1:length/2)'/(length+1))); 
    out=[w; w(end:-1:1)];
else
    w = .5*(1-cos(2*pi*(1:(length+1)/2)'/(length+1)));
    out=[w; w(end-1:-1:1)];
end
w = .5*(1 - cos(2*pi*(1:M)'/(M+1)));