function fft_application()
%{
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
y = x + 2*randn(size(t));   
figure;% Sinusoids plus noise
plot(Fs*t(1:50),y(1:50))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')

% converting into frequency domain
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|');
%}


% n = 1:30;
% x = cos(2*pi*n/10);
% % Define 3 different values for N.
% % The abs function in MATLAB finds the magnitude of the transform,
% N1 = 64;
% N2 = 128;
% N3 = 256;
% X1 = abs(fft(x,N1));
% X2 = abs(fft(x,N2));
% X3 = abs(fft(x,N3));
% % to plot the magnitude of the transform we need to scale the freq.
% % The frequency scale begins at 0 and extends to N-1 for an N-point FFT.
% % We then normalize the scale so that it extends from 0 to [ 1-(1/N) ] .
% F1 = [0 : N1 - 1]/N1;
% F2 = [0 : N2 - 1]/N2;
% F3 = [0 : N3 - 1]/N3;
% figure;
% subplot(3,1,1)
% plot(F1,X1,'-x'),title('N = 64'),axis([0 1 0 20])
% subplot(3,1,2)
% plot(F2,X2,'-x'),title('N = 128'),axis([0 1 0 20])
% subplot(3,1,3)
% plot(F3,X3,'-x'),title('N = 256'),axis([0 1 0 20])
% 
% n = 1:30;
% x1 = cos(2*pi*n/10); % 3 periods
% x2 = [x1 x1]; % 6 periods
% x3 = [x1 x1 x1]; % 9 periods
% N = 2048; %no. of fft points
% % fft magnitude depends on fft points
% X1 = abs(fft(x1,N));
% X2 = abs(fft(x2,N));
% X3 = abs(fft(x3,N));
% F = [0:N-1]/N;
% subplot(3,1,1)
% plot(F,X1),title('3 periods'),axis([0 1 0 50])
% subplot(3,1,2)
% plot(F,X2),title('6 periods'),axis([0 1 0 50])
% subplot(3,1,3)
% plot(F,X3),title('9 periods'),axis([0 1 0 50]) 
% 
% n = 1:150; % 150 samples
% x1 = cos(2*pi*n/2.2); % 15 periods i.e.,each period of 10 samples
% N = 2048;
% X = abs(fft(x1,N));
% X = fftshift(X);
% F = [-N/2:N/2-1]/N; % so that freq range is between -0.5fs to 0.5fs
% plot(F,X),
% xlabel('frequency / f s') 
figure;
% f = zeros(30,30);
% f(5:24,13:17) = 1;
% imshow(f,'InitialMagnification','fit')
% F = fft2(f);
% F2 = log(abs(F));
% imshow(F2,[-1 5],'InitialMagnification','fit'); colormap(jet); colorbar
% F = fft2(f,256,256);
% imshow(log(abs(F)),[-1 5]); colormap(jet); colorbar
% F = fft2(f,256,256);F2 = fftshift(F);
% imshow(log(abs(F2)),[-1 5]); colormap(jet); colorbar

% bw = imread('text.png');
% imshow(bw);hold on;
% a = bw(32:45,88:98);
% b = imcrop;
% imshow(bw);
% figure, imshow(b);
% C = real(ifft2(fft2(bw) .* fft2(rot90(b,2),256,256)));
% figure, imshow(C,[]) % Scale image to appropriate display range.
% max(C(:))
% thresh = 60; % Use a threshold that's a little less than max.
% figure, imshow(C > thresh)% Display showing pixels over threshold.

% A key property of the Fourier transform is that the multiplication of two Fourier transforms corresponds 
% to the convolution of the associated spatial functions. This property, together with the fast Fourier transform, forms the basis for a fast convolution algorithm.
A = magic(3);
B = ones(3);
A(8,8) = 0;
B(8,8) = 0;
C = ifft2(fft2(A).*fft2(B));
C = C(1:5,1:5);
C = real(C)

