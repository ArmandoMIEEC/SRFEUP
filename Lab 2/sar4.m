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

figure(1)
image(((1:1200)'+100)*2.5, (0:32000-1)'*0.05, abs(ch)'/100); 
ch_e = [ch; zeros(200, 14001)];
%% Range Migration
ch_ef = fftshift(fft(ch_e,[],2),2);
ch_cf = zeros(size(ch));
fx = 0:1/delta_x/size(ch, 2):1/delta_x*(1-1/size(ch,2));
fx = fx - ceil(length(fx)/2)*1/delta_x/size(ch,2);
for k = 1:14001; ch_cf(:,k) = interp1((1:1400)'+100, ch_ef(:,k), ((1:1200)'+100)/sqrt(1-(300/2340/2*fx(k))^2));end
figure(2);
ch_c = ifft(fftshift(ch_cf,2),[],2);
figure(3);
image(((1:1200)+100)*2.5, ((0:14000)'-7000)/14001/0.05, abs(fftshift(fft(ch_c'),1))/10000);

%% Azimuth Compression
F_ext = 64000;
angles = atan2(x*ones(1,1200), ones(64000,1)*r)*180/pi;
conv_func = (abs(angles) <= 20).*sinc(angles/15).*(abs(angles)> 0.8);
S = conv_func.*exp(-4j*pi*d/(3e8/2340e6));
CH = [zeros((F_ext-14000)/2, 1200); ch_c'; zeros((F_ext-14000)/2 -1, 1200)];
%CH = [zeros((64000-14000)/2, 1200); ch_c(:,end:-1:1).'; zeros((64000-14000)/2-1, 1200)];

figure(4)
%image(x,r,abs(S)*20);
image(((1:1200)+100)*2.5, ((0:14000)'-7000)/14001/0.05, abs(S)*20);
%%
figure(5)
image(x,r,abs(CH)/200);

ch_az = ifft(fft(CH).*conj(fft(fftshift(S,1))));
%ch_az = circshift(ifft(fft(conj(ch_ext)).*conj(fft(S))), -32000);
figure(6)
image(x,r,abs(ch_az)/20000);

%% Low-pass filter
figure(9)
%image(x,r,filter(fir1(128,0.05),1,abs(ch_az))/10000); axis equal;
image(((1:1200)+100)*2.5, (-32000+1:32000-1)'*0.05, filter(fir1(128,0.05),1,abs(ch_az))/10000);

%% Filtro de decimação

%%
ch_x = [zeros(100,14001); ch; zeros(200,14001)];
ch_xf = fftshift(fft(ch_x,[],2),2);

figure(7)
image(abs(ch_xf')/10000);

dn = round(1500*(1./sqrt(1-(300/fc/2*fx').^2)-1));
nn = 1500 - dn;
ch_vf = zeros(size(ch_xf));
for k=1:14001; dummy = fftshift(fft(ch_xf(:,k))); dummy = dummy(1:nn(k))+floor(dn(k)/2); ch_vf(1:nn(k),k)=ifft(fftshift(dummy)); end
figure(8)
image(abs(ch_vf')/10000);

ch_v = ifft(fftshift(ch_vf((1:1200)+100, :),2),[],2);
CH = [zeros((64000-14000)/2, 1200); ch_c(:,end:-1:1).'; zeros((64000-14000)/2-1, 1200)];
%%
res = circshift(ifft(fft(conj(CH)).*conj(fft(s))), -32000);

figure(10)
%image(x,r,filter(fir1(128,0.05),1,abs(res))/10000); 
image(((1:1200)+100)*2.5, (-32000+1:32000-1)'*0.05, filter(fir1(128,0.05),1,abs(res))/10000);