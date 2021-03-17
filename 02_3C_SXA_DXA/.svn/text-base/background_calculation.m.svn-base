function Ibkg = background_calculation()
      global Image
      
      H = fspecial('disk',3);
      image1 = imfilter(Image.image,H,'replicate');
      image_smooth = funcGradientGauss(image1,3);
      sz = size(image_smooth)
      histogram=histc(reshape(image_smooth,1,sz(1)*sz(2)),11000:16000);
       figure;
       bar(histogram);
      [C,I]=max(histogram(1:round(size(histogram,2)/2)));
      Ibkg = I + 11000;
     