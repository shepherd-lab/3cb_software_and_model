function fftImage = appFFT(image, mask)
%appFFT computes the Fourier transform of the input image

%size of FFT
Nf = 1024;

% %crop the original image to the masked region
% xmin = maskObj.minRect(1);
% ymin = maskObj.minRect(2);
% xmax = maskObj.minRect(3);
% ymax = maskObj.minRect(4);
% image = imageObj.image(ymin:ymax, xmin:xmax);
% mask = maskObj.image(ymin:ymax, xmin:xmax);

%clean image: remove negative pixels
minImage = min(image(:));
if (minImage < 0 && abs(minImage) < 10000)
    image = (image - minImage + 1).*mask;
end

%get image size
[ylen, xlen] = size(image);
x = 1:xlen;
y = 1:ylen;

%locate image center
x0 = round(xlen/2);
y0 = round(ylen/2);

%determine Hann Window radius
R = min([x0, y0]);
N = 2*R;

%create the Hann Window
[X, Y] = meshgrid(x, y);
r = sqrt((X - x0).^2 + (Y - y0).^2);
hannWin = 0.5*(cos(2*pi*r/N) + 1);
hannWin(r > R) = 0;

%compute FFT image
% image = (image - min_imageFT).*mask + 1;
fftCplx = fftshift(fft2(hannWin .* image, Nf, Nf));
fftImage = abs(fftCplx).^2;
