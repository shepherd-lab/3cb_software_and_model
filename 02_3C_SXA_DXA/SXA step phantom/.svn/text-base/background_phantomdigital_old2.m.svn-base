function Ibkg = background_phantomdigital(phantom_image)
     % global Image
      
     % H = fspecial('disk',5);
      gaussianFilter = fspecial('gaussian', [7, 7], 5);
      
      tic;
      %image1 = imfilter(phantom_image,H,'replicate');
     image_smooth = imfilter(phantom_image, gaussianFilter, 'symmetric', 'conv');
       %figure; imagesc(image_smooth); colormap(gray);
      %image1 = medfilt2(phantom_image,[5 5]);
       tmed = toc
     % image_smooth = funcGradientGauss(image1,5);
      sz = size(image_smooth);
      %max_image = max(max(phantom_image));
      min_image = min(min(phantom_image));
      init = 2000;
      init1 = 2000;
      C = 1;
      count = 20;
      
      % histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:15000);
       %[C,I]=max(histogram(1:round(size(histogram,2)/2)));
       % figure;
      %bar(histogram);
      %figure; imagesc(image_smooth);colormap(gray);
      while C < 200
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:15000);
        [C,I]=max(histogram(1:round(size(histogram,2)/2)));
        %figure;  bar(histogram);
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
              init1 = 1000;
              count = 20;
          end
      end
      %figure;
      %bar(histogram);
      
     
      Ibkg = init;
      a  =1;
     
      
      