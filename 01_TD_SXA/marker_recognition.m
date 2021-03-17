function marker_recognition()
 global Image Analysis
   
    bw = im2bw(Image.image > 80000);
    rcc_hrz = imread('rcc_image.png');    %a = bw(32:45,88:98);
    %imwrite(uint8(rcc_hrz),rcc_hrz,'png');
    rcc_bw = im2bw(rcc_hrz);
    figure;imshow(bw);
    figure;imshow(rcc_hrz);
     immin = min(min(rcc_hrz));
     immax = max(max(rcc_hrz));
   % bw_rcchrz = rcc_hrz > ((immax-immin)*0.5);
    %C = real(ifft2(fft2(bw).*fft2(rot90(rcc_bw,2),256,256)));
    fft_im = fft2(bw);
    im1 = fft2(bw,256,256);
    im2 = fft2(rot90(rcc_bw,2),256,256);
    sz = size(bw);
    C = real(ifft2(fft2(bw).*fft2(rot90(rcc_bw,2),sz(1),sz(2))));
    figure;imshow(C,[]);
    max(C(:))
    thresh = 60; figure;imshow(C>thresh);
    p = 1;