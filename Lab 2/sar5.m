clear all
Tr=2.5e-6;
Br=50e6;
Kr=Br/Tr;
Fr=1.2*Br;
f0=9.4e9;
c=3e8;
La=1;
Vr=250;
Fa=1.3*0.886*2*Vr/La;
theta=0;
R0=[30000 30000 30500];Rmin=29805;Rmax=30695;TWr=2*(Rmax-Rmin)/c;
X0=[450 550 550];Xmax=1000;TWa=Xmax/Vr;
Ta=0.886*R0*c/La/Vr/f0;
%===============²úÉú»Ø²¨Êý¾Ý======================
Na=floor(TWa*Fa+1);
t=(2*Rmin/c:1/Fr:2*Rmax/c)'*ones(1,Na);
ta=ones(TWr*Fr+1,1)*(0:1/Fa:TWa);
s0=zeros(TWr*Fr+1,Na);
for i=1:length(R0)
    R=sqrt(R0(i)^2+(X0(i)-Vr*ta).^2); 
    s0=s0+exp(-j*4*pi*f0*R/c+j*pi*Kr*(t-2*R/c).^2).*(abs(t-2*R/c)<Tr/2).*(abs(ta-X0(i)/Vr)<Ta(i)/2);
end
%====================RDA=========================
st=exp(-j*pi*Kr*(-Tr/2:1/Fr:Tr/2).^2);
N=length(st)+(TWr*Fr+1)-1;
Hr=fft(st,N).'*ones(1,Na);
src=ifft(fft(s0,N).*Hr);%¾àÀëÑ¹Ëõ,Äæ¸µÀïÒ¶±ä»¯ºóÊ±¼äÆðÊ¼µãÎªÁ½ÐòÁÐ¸÷×ÔÆðÊ¼µãÖ®ºÍ£¬Ê±¼ä¼ä¸ôÎª´ø¿íµ¹Êý£¬Ê±¼ä¿í¶ÈÎªÆµÂÊ¼ä¸ôµ¹Êý
fr=linspace(-Fr/2,Fr/2,N)'*ones(1,Na);
fa=linspace(-Fa/2,Fa/2,Na);
sf2=fftshift(fft2(src));
detaR=(c^2*30250*(ones(N,1)*fa).^2/f0^2/8/Vr^2);
srd=ifft(sf2.*exp(j*4*pi*fr.*detaR/c)).';%RCMC
Rc=(-Tr/2+2*Rmin/c:1/Fr:Tr/2+2*Rmax/c)*c/2;
Kac=2*Vr^2*f0/c./Rc;
sac=zeros(TWa*Fa+1,N);
for i=1:N
    Ha=exp(-j*pi/Kac(i)*fa.^2);
    sac(:,i)=srd(:,i).*Ha.';%·½Î»Ñ¹Ëõ
end
sac=ifft(sac);
%===================figure======================
figure(1);imagesc(abs(s0.'));xlabel('¾àÀëÏò');ylabel('·½Î»Ïò')
figure(2);imagesc(abs(src.'));xlabel('¾àÀëÏò');ylabel('·½Î»Ïò')
figure(3);imagesc(abs(srd));xlabel('¾àÀëÏò');ylabel('·½Î»Ïò')
figure(4);imagesc(abs(sac));xlabel('¾àÀëÏò');ylabel('·½Î»Ïò')
figure(5);plot(20*log10(abs(sac(:,354))/max(abs(sac(:,354)))))