function I = log_convert(image)
  image = image.*(image>0)+1;
  mmax = max(max(image))
  mmin = min(min(image))
  I = -log((image+1)/(mmax+1) )* 10000;
  mmax2 = max(max(I))
  mmin2 = min(min(I))