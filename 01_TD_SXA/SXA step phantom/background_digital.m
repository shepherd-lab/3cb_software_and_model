function Ibkg = background_digital(phantom_image)
     % global Image
      
      H = fspecial('disk',5);
      image1 = imfilter(phantom_image,H,'replicate');
      image_smooth = funcGradientGauss(image1,3);
      sz = size(image_smooth);
      max_image = max(max(phantom_image));
      min_image = min(min(phantom_image));
      init = 2000;
      C = 1;
      while C < 200
         histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),init:15000);
        [C,I]=max(histogram(1:round(size(histogram,2)/2)));
       % figure;
       % bar(histogram);
        init = init + I + 50;
      end
      %figure;
      %bar(histogram);
      
     
      Ibkg = init;
      a  =1;
     
      
      