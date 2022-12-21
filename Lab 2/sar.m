 % matlab script to focus ERS-2 signal data
%
% set some constants for e2_10001_2925
%
% range parameters
%
 rng_samp_rate = 1.896e+07;
 pulse_dur = 3.71e-05;
 chirp_slope = 4.1779e+11;
%
% azimuth parameters
%
 PRF=1679.902394;
 radar_wavelength=0.0566666;
 SC_vel=7125.;
%
% compute the range to the radar reflectors
%
 near_range=829924.366;
 dr=3.e08/(2.*rng_samp_rate);
 range=near_range+2700*dr;
%
% use the doppler centroid estimated from the dataand the
% doppler rate from the spacecraft velocity and
range
%
 fdc=284;
 fr=2*SC_vel*SC_vel/(range*radar_wavelength);
%
% get some sar data
%
 [cdata,nrow,ncol] = read_rawsar('rawsar.raw');
%
% make a colormap
%
 map=ones(21,3);
 for k=1:21;
 level=0.05*(k+8);
 level=min(level,1);
 map(k,:)=map(k,:).*level;
 end
 colormap(map);
%
% image the raw data
%
 figure(1)
 subplot(2,2,1),imagesc(abs(cdata'));
 xlabel('range')
 ylabel('azimuth')
 title('unfocussed raw data')
 axis([2600,2900,1000,1200])
%
% generate the range reference function
%
[cref,fcref]=rng_ref(ncol,rng_samp_rate,pulse_dur,chirp_slope);
%
% take the fft of the SAR data
%
 fcdata=fft(cdata);
%
% multiply by the range reference function
%
 cout=0.*fcdata;
 for k=1:nrow;
 ctmp=fcdata(:,k);
 ctmp=fcref.*ctmp;
 cout(:,k)=ctmp;
 end
 clear cdata
%
% now take the inverse fft
%
 odata=ifft(cout);
 clear cout
 
 %
% plot the image and the reflector locations
%
 x0=[2653.5,2621];
 x0=x0+90;
 y0=[20122,20226];
 y0=y0-19500+427;
 figure(1)
 hold
 subplot(2,2,2),imagesc(abs(odata'));
 plot(x0,y0,'o')
 xlabel('range')
 ylabel('azimuth')
 title('range compressed')
 axis([2600,2900,1000,1200])
%
% use this for figure 2 as well
%
 figure(2)
 colormap(map);
 subplot(2,2,1),imagesc(abs(odata'));
 hold on
 plot(x0,y0,'o')
 xlabel('range')
 ylabel('azimuth')
 title('range compressed')
 axis([2600,2900,1000,1200])
%
% generate the azimuth reference function
%
 [cazi,fcazi]=azi_ref(nrow,PRF,fdc,fr);
%
% take the column-wise fft of the range-compressed
data
%
 fcdata=fft(odata');
%
% multiply by the azimuth reference function
%
 cout=0.*fcdata;
 for k=1:ncol;
 ctmp=fcdata(:,k);
 ctmp=fcazi.*ctmp;
 cout(:,k)=ctmp;
 end
%
% now take the inverse fft and plot the data
%
 odata=ifft(cout);
 figure(2)
 subplot(2,2,2),imagesc(abs(odata));
 hold on
 plot(x0,y0,'o')
 xlabel('range')
 ylabel('azimuth')
 title('range and azimuth compressed')
 axis([2600,2900,1000,1200])