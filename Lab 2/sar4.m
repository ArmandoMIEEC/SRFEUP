delta_x = 0.05;
fc = 2.340e9;
fs = 60e6;
F_ext = 2^15;
r = ((1:1200)+100)*2.5;
x = (-F_ext/2:F_ext/2-1)'*0.05;
d = sqrt(x.*x*ones(1,1200)+ones(F_ext,1)*r.*r);

angles = atan2(x*ones(1,1200), ones(F_ext,1)*r)*180/pi;
conv_func = (abs(angles) <= 15).*sinc(angles/15).*(abs(angles)>0.8);
S = conv_func.*exp(-4j*pi*d/(3e8/2340e6));
ch_ext = [zeros((F_ext-14000)/2, 1200); ch'; zeros((F_ext-14000)/2 -1, 1200)];

figure(14)
image(x,r,abs(S)*20);
figure(15)
image(x,r,abs(ch_ext)/200);

ch_az = ifft(fft(ch_ext).*conj(fft(fftshift(S,1))));
figure(16)
image(x,r,abs(ch_az)/20000);
