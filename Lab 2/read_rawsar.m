function [csar,nrow,ncol]=read_rawsar(sar_file)
%
% routine to read and unpack ERS SAR data in
%DPAF format
%
 fid=fopen(sar_file,'r');
%
% read the bytes
%
 [sar,nsar]=fread(fid,'uchar');
 sar=reshape(sar,11644,nsar/11644);
 nrow=nsar/11644;
 ncol=5616;
 st=fclose(fid);
%
% extract the real and imaginary parts
% and remove the mean value
%
 csar=complex(sar(413:2:11643,:)-15.5,sar(414:2:11644,:)-15.5);
%