function colorimage = gray2color(image)
cmap = summer(64);
res = grs2rgb(im,cmap);
% res is a size(im)-by-3 RGB image. IND2RGB. "Transfering Color to Grayscale
% Images" by Welsh
% [tmpng cmap] = rgb2ind(im); 
% [res] = ind2rgb(tmpng Newcmap);


