function text_recognition()
   
    bw = imread('text.png');
    a = bw(32:45,88:98);
    figure;imshow(bw);
    figure;imshow(a);
    C = real(ifft2(fft2(bw).*fft2(rot90(a,2),256,256)));
    figure;imshow(C,[]);
    max(C(:))
    thresh = 60;figure;imshow(C>thresh);
    p = 1;
    