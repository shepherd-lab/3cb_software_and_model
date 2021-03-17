function Ibkg = background_LEimage(image)
     % global Image
      
      H = fspecial('disk',5);
      image1 = imfilter(image,H,'replicate');
      %image_smooth = funcGradientGauss(image1,5);  %%% removed on 09/13/07
      % because of edges pbs.
      image_smooth =image1;
      sz = size(image_smooth);
     % max_image = max(max(image)); %%%
      %min_image = min(min(phantom_image)); %%%
      min_image = min(min(image1));
      init = 0;
      init1 = 2000;
      C = 1;
      count = 20;
      
      % histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:15000);
       %[C,I]=max(histogram(1:round(size(histogram,2)/2)));
      % figure;
      %bar(histogram);
      
      while C < 200
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),min_image:min_image+40000);
        [C,I]=max(histogram(1:round(size(histogram,2)/2)));
%         figure;bar(histogram);
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
      
     
      Ibkg = init+min_image;
      a  =1;
     
      
      