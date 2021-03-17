function Ibkg = background_phantomUK(phantom_image)
     % global Image
      
      H = fspecial('disk',5);
      image1 = imfilter(phantom_image,H,'replicate');
      image_smooth = funcGradientGauss(image1,5);
      sz = size(image_smooth)
      max_image = max(max(phantom_image))
      min_image = min(min(phantom_image))
      init =  min(min(image_smooth));%2000;
      init1 = min_image;%2000;
      C = 1;
      count = 20;
      while C < 20 | count < 0
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:20000);
         histogram = histogram(histogram ~= 0);
        [C,I]=max(histogram(1:round(size(histogram,2)/2)));
        
     %  figure;
     % bar(histogram);
      init = init + I + 50;
      count = count -1;  
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
     
      
      