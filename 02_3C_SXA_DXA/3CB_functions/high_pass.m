function high_pass(I)
%%
%http://www.bogotobogo.com/Matlab/Matlab_Tutorial_Digital_Image_Processing_6_Filter_Smoothing_Low_Pass_fspecial_filter2.php
fullfilename_read = '\\researchstg\aaStudies\Breast Studies\UCSF-GE Collaboration\GE_reconstruction\Projections\E11558554S1494I1.DCM';
info_dicom = dicominfo(fullfilename_read);
XX=double(dicomread(fullfilename_read));
%dicomwrite(XX,dicom_file,info_dicom,'CreateMode','copy');
%figure;imagesc(XX);colormap(gray);
mAs = info_dicom.ExposureInuAs/1000;
KVP = info_dicom.KVP;
%XX = log_convertSXA(XX, mAs, KVP) + 25000;
figure;imagesc(XX);colormap(gray);
%I = imread( 'peppers.png' );
 I_filtered = XX - imfilter( XX, fspecial('Gaussian', 5, 1 ) ); 
 figure;imagesc(I_filtered);colormap(gray);
 kernel = [-1 -1 -1;-1 8 -1;-1 -1 -1];
 filteredImage = imfilter(XX, kernel, 'same');
 figure;imagesc(filteredImage);colormap(gray);
 %%
 %image= imread('Question3_Data-Cats.jpg'); % read image
%H  = 1 - fspecial('gaussian' ,[5 5],2); % create unsharp mask
 H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2); % create unsharp mask
 sharpened1 = imfilter(XX,H);  % create a sharpened version of the image using that mask
 figure;imagesc(sharpened1);colormap(gray);
 h = fspecial('laplacian');
 sharpened2 = imfilter(XX,h); 
 figure;imagesc(sharpened2);colormap(gray);
 %%
 log = fspecial('log',[3 3],0.5);
figure; freqz2(log);
p = [1 0 -1;
     0 0 0;
    -1 0 1];
% laplacian = fspecial('laplacian',[3 3],0.5);
% figure; freqz2(laplacian);
% 
% figure; freqz2(p)
%%
% LowpassMask=(1/9)*ones(3,3); % Averaging mask of size 3*3 Filtered=conv2(image,LowpassMask);
% Filtered=conv2(XX,LowpassMask);
% figure;imagesc(XX-Filtered); colormap(gray);
Sobel=[-1 0 1]; 
Filtered=conv2(XX,Sobel);
figure;imagesc(Filtered); colormap(gray);
a = 1;
%%
%FFT
%% PSIB 2015, Trabalho final, o problema 2

% This application  performs the filtering of an image in the frequency 
% domain. It applies a low-pass filter for multiplying a transfer function 
% suitable for 2D Fourier transform of the image, then inverse Fourier 
% transform. An image and a cut-off frequency are choosen by user.
% Results are compared to images obtained using spatial filtering
% operators.

%% Input
% Image
% Image file selection dialog box
[filename,pathname] = uigetfile('*.jpg;*.tif;*.png;*.gif','Select the image file');
%Reading a file and converting to greyscale
I0 = imread(fullfile(pathname, filename)); %MxNx3
I0grey = im2double(rgb2gray(I0)); %grey, MxN

% Cut-off frequency for low pass filter
prompt = 'Enter a cut-off frequency for a low-pass filter:';
dlg_title = 'Cut-off frequency';
num_lines = 1;
def = {'0.20'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
K0 = str2double(answer);

% If loop that checks if K0 is correct (in range of frequencies)
ff = fft2(I0grey); % Take Fourier Transform 2D
while(1)
    if (K0 >= min(ff(:))) && (K0 <= max(ff(:)))
        break;
    else
        prompt = 'Entered cut-off frequency is incorrect, type another:';
        dlg_title = 'Cut-off frequency';
        num_lines = 1;
        def = {'0.20'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        K0 = str2double(answer);
    end
end
%% Processing
% Fourier transform
ff = fft2(I0grey); % Take Fourier Transform 2D
F = 20*log(abs(fftshift(ff))); % Shift center; get log magnitude

% Application of low pass filter in reconstruction
%Image dimensions 
[N,M] = size(I0grey); %[height, width]
%Sampling intervals 
dx = 1; 
dy = 1; 
%Characteristic wavelengths 
KX0 = (mod(1/2 + (0:(M-1))/M, 1) - 1/2); 
KX1 = KX0 * (2*pi/dx); 
KY0 = (mod(1/2 + (0:(N-1))/N, 1) - 1/2); 
KY1 = KY0 * (2*pi/dx); 
[KX,KY] = meshgrid(KX1,KY1); 
%Filter formulation 
lpf = (KX.*KX + KY.*KY < K0^2); 
%Filter Application 
rec = ifft2(lpf.*ff);

%
lp = fir1(32,K0);  % Generate the lowpass filter (order, cut-off frequency)
lp_2D = ftrans2(lp);  % Convert to 2-dimensions
I_double = im2double(I0grey);
I_lowpass_rep = imfilter(I_double,lp_2D,'replicate');
I_lowpass_gray = mat2gray(I_lowpass_rep);

% Spatial filtering operators
% Construction of 2D filters
%with default parameters to not influence ?
h1 = fspecial('gaussian'); %gaussian low-pass filter
h2 = fspecial('log');

% Image filtering
I_f1 = imfilter(I0grey,h1,'replicate');
I_f2= imfilter(I0grey,h2,'replicate');
%% Results
%Graphics
figure(1)
% Plot original
subplot(2,3,1)
imshow(I0grey); 
xlabel('X','FontSize',14); 
ylabel('Y','FontSize',14);

%show FFT, magnitude
subplot(2,3,2)
mesh(F); colormap(hot); % Plot Fourier Transform as function
xlabel('Horizontal Frequency','FontSize',12); 
ylabel('Vertical Frequency','FontSize',12);

% Reconstruction after filtering in frequency domain
subplot(2,3,3)
imshow(rec);
xlabel('X','FontSize',14); 
ylabel('Y','FontSize',14);
title('Hand-made low-pass filter');

% Filtered image 1, FIR
subplot(2,3,4)
imshow(I_lowpass_gray);
xlabel('X','FontSize',14); 
ylabel('Y','FontSize',14);
title('FIR low-pass');

% Filtered image 2, fspecial Gaussian
subplot(2,3,5)
imshow(I_f1);
xlabel('X','FontSize',14); 
ylabel('Y','FontSize',14);
title('Gaussian');

% Filtered image 3, fspecial Laplacian of Gaussian
subplot(2,3,6)
imshow(I_f2);
xlabel('X','FontSize',14); 
ylabel('Y','FontSize',14);
title('Laplacian of Gaussian');

%%
% fourier filter
% simple implementation of frequency domain filters
%clear all
%read input image
%dim=imread('lena.pgm');
dim = XX;
cim=double(dim);
[r,c]=size(cim);

r1=2*r;
c1=2*c;

pim=zeros((r1),(c1));
kim=zeros((r1),(c1));

%padding
for i=1:r
    for j=1:c
   pim(i,j)=cim(i,j);
    end
end

%center the transform
for i=1:r
    for j=1:c
   kim(i,j)=pim(i,j)*((-1)^(i+j));
    end
end


%2D fft
fim=fft2(kim);

n=1; %order for butterworth filter
thresh=10; % cutoff radius in frequency domain for filters

% % function call for low pass filters
% him=glp(fim,thresh); % gaussian low pass filter
% him=blpf(fim,thresh,n); % butterworth low pass filter

% function calls for high pass filters
him=ghp(fim,thresh); % gaussian low pass filter
him=bhp(fim,thresh,n);  %butterworth high pass filter

% % function call for high boost filtering
% him=hbg(fim,thresh);  % using gaussian high pass filter
%  him=hbb(fim,thresh,n);  % using butterworth high pass filter


%inverse 2D fft
 ifim=ifft2(him);
 
for i=1:r1
    for j=1:c1
   ifim(i,j)=ifim(i,j)*((-1)^(i+j));
    end
end


% removing the padding
for i=1:r
    for j=1:c
   rim(i,j)=ifim(i,j);
    end
end

% retaining the ral parts of the matrix
rim=real(rim);
%rim=uint8(rim);

figure, imshow(rim);

% figure;
% subplot(2,3,1);imshow(dim);title('Original image');
% subplot(2,3,2);imshow(uint8(kim));title('Padding');
% subplot(2,3,3);imshow(uint8(fim));title('Transform centering');
% subplot(2,3,4);imshow(uint8(him));title('Fourier Transform');
% subplot(2,3,5);imshow(uint8(ifim));title('Inverse fourier transform');
% subplot(2,3,6);imshow(uint8(rim));title('Cropped image');

end

