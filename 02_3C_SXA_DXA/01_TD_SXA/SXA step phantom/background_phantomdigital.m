function Ibkg = background_phantomdigital(image)
      global Image Analysis Info
      
      H = fspecial('disk',5);
      image1 = imfilter(image,H,'replicate');
      %image_smooth = funcGradientGauss(image1,5);  %%% removed on 09/13/07
      % because of edges pbs.
      image_smooth =image1;
      sz = size(image_smooth);
      sz_orig = size(Image.OriginalImage);
      %FD 1/12/2012 Uses lowest 3rd percentile rather than lowest value to
      %improve reproducibility.
     % max_image = max(max(image)); %%%
      %min_image = min(min(phantom_image)); %%%
      sortedImage=sort(squeeze(reshape(image1, numel(image1), 1)));
     
      
%create a one dimensional sorted version of image
      min_image=single(sortedImage(round(numel(image1)*0.03)));
%Get the smallest value in the image.  This value is used directly in
%background computation.  So, this is not robust.
      sortedImage=sort(squeeze(reshape(Image.OriginalImage, numel(Image.OriginalImage), 1)));
%create a one dimensional sorted version of image
      min_image_orig=single(sortedImage(round(numel(Image.OriginalImage)*0.03)));
      

      
      init = 0;
% % %        if strcmpi(Info.machine_id,'27')| strcmpi(Info.machine_id,'28') % To prevent negative background for Machine_27 and 28
% % %        init1 = 3500;
% % %        else 
           init1 = 2000;
% % %        end;
      C = 1;
      count = 20;
      index_min_orig = [];
%       histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),min_image:15000);
%       figure;bar(histogram);
      % histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:15000);
       %[C,I]=max(histogram(1:round(size(histogram,2)/2)));
      % figure;
      %bar(histogram);
      %figure;imagesc(image_smooth);colormap(gray);
      a = isreal(image_smooth);
      X = reshape(image_smooth,1,sz(1)*sz(2));
      temp_image = Image.OriginalImage;
      temp_image(1:100,:) = 1000; 
      temp_image(end-100:end,:) = 1000; 
      while C < 200
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),min_image:65000);
         %figure;bar(histogram); 
         histogram_orig=histc(reshape(Image.OriginalImage,1,sz_orig(1)*sz_orig(2)),min_image_orig:15000);
         %figure;bar(histogram);
           if ~isempty(histogram_orig)
            [C,I]=max(histogram_orig(1:round(size(histogram_orig,2)/2)));
             if I == 1  &  min_image_orig <=0  & C > 100 
                 index_min_orig = find(temp_image == min_image_orig);         
             end
           end
          
        %figure;bar(histogram);
         if ~isempty(histogram)
            [C,I]=max(histogram(1:round(size(histogram,2)/2)));
             if I == 1  &  min_image_orig <=0  & C > 100 
                 histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),min_image+1:15000);
                     
             end
        else
            init = 1;
            break;
        end
         [C,I]=max(histogram(1:round(size(histogram,2)/2)));
         init = init + I + 50;
         count = count -1;  
          if count < 0
              break;
          end
          if init > 14000
              init = init1 - 1000;
              if init == 0
                  Ibkg = 1000;
                  init = 1000;
                  break;
              end
% % %               if strcmpi(Info.machine_id,'27')| strcmpi(Info.machine_id,'28')
% % %                   init1 = 2000;
% % %                   count = 20;
% % %               else 
              init1 = 1000;
              count = 20;
% % %               end
          end
      end
      %figure;
      %bar(histogram);
      Ibkg = double(init+min_image);
%       
 % % % % % %       if ~isempty(index_min_orig) %JW added or statement for UCSF images 
 %%%%%%%%%%%    for UCSF marker removal
%           [I,J] = ind2sub(sz_orig,index_min_orig);
%           xmin = round(min(I));
%           ymin = round(min(J));
%           xmax = round(max(I));
%           ymax = round(max(J));
%           %image_smooth(xmin-10:xmax+10,ymin-10:ymax+10) = Ibkg;
%           Image.image(xmin-10:xmax+10,ymin-10:ymax+10) = Ibkg; %does not work for GE images;
%           Image.OriginalImage(xmin-10:xmax+10,ymin-10:ymax+10) = Ibkg;
          
% % % % % %          end   
%       roi_mask = roipoly(image_smooth, [xmin-3 xmax+3 xmax+3 xmin-3], [ymin-3 ymin-3 ymax+3 ymax+3 ]);
%       figure; imagesc(roi_mask); colormap(gray);
%       figure; imagesc(image_smooth); colormap(gray);
%Analysis.Ibkg = Ibkg;
      a  =1;
     
      
      