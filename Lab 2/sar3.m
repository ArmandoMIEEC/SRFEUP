delta_x = 0.05;
fc = 2.340e9;
fs = 60e6;
wlen = 3e8/fc;
delta_R = (1/fs) * (3e8/2);
r = ((1:1200)+100)*2.5;
x = (-32000:32000-1)'*0.05;
d = sqrt(x.*x*ones(1,1200)+ones(64000,1)*r.*r);
A = (abs(atan2(x*ones(1,1200), ones(64000,1)*r))*180/pi <= 20) .* (abs(atan2(x*ones(1,1200), ones(64000,1)*r))*180/pi > 0.8);
s=A.*exp(-4j*pi*d/(3e8/fc));

ch_e = [ch; zeros(200, 14001)];
%% Range Migration
ch_ef = fftshift(fft(ch_e,[],2),2);
ch_cf = zeros(size(ch));
fx = 0:1/delta_x/size(ch, 2):1/delta_x*(1-1/size(ch,2));
fx = fx - ceil(length(fx)/2)*1/delta_x/size(ch,2);
for k = 1:14001; ch_cf(:,k) = interp1((1:1400)'+100, ch_ef(:,k), ((1:1200)'+100)/sqrt(1-(300/2340/2*fx(k))^2));end
figure(2);
image(((1:1200)+100)*2.5, ((0:14000)'-7000)/14001/0.05, abs(fftshift(fft(ch'),1))/10000); 
figure(3);
image(((1:1200)+100)*2.5, ((0:14000)'-7000)/14001/0.05, abs(fftshift(fft(ch_cf'),1))/10000); 
figure(4);
ch_c = ifft(fftshift(ch_cf,2),[],2);
figure(5);
image(((1:1200)+100)*2.5, ((0:14000)'-7000)/14001/0.05, abs(fftshift(fft(ch_c'),1))/10000);
