function FFT_demo()
%figure;
 x=pi/64*[0:127];
% x=0..<2pi in 128 points
y=sin(5*x)+2*cos(10*x);
plot(y)
%pause
Y=fft(y);
P=abs(Y).^2;
figure;
plot(P)

%figure;
y=sin(10*x)+sin(30.5*x);
Y=fft(y);
P=Y .* conj(Y);  % "(abs(Y)).^2"
semilogy(P(1:64)); % Plot only first half    Left figure below
%figure;
Y=fft(y,1024);      % increase the resolution with more (zero) data
P=Y .* conj(Y);
semilogy(P(1:512)); % Plot only first half   Right figure below
axis([1,512,0.1,10000])

%The side lobes may be reduced by using window-functions. First a rectagular window showing the origin of the side lobes, then a smoother Hanning-like window.
%figure;
w=ones(1,128);
W=abs(fft(w,1024)).^2;
subplot(121),  plot(w)
subplot(122),  semilogy(W(1:512)), axis([1,512,0.1,10000])

w=sin(0.5*x) .^2;   % Simple window, Hanning like
W=abs(fft(w,1024)).^2;
subplot(121);  plot(w)
subplot(122);  semilogy(W(1:512)), axis([1,512,0.1,10000])

z=w.*y;
Z=abs(fft(z,1024)).^2;
subplot(121);  plot(z)
subplot(122);  semilogy(Z(1:512)), axis([1,512,0.1,10000])
