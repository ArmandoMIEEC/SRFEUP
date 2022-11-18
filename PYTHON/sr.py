import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from datetime import datetime
import matplotlib.dates as mdates

# Signal
with open('sat_data/sem12_sinal.txt') as f:
    signal_lines = f.readlines()

signal_datetime = []
signal_datetime23 = []
signal_dates = []
signal_dates23 = []
signal = []
signal23 = []
noise = []
noise_dates = []
noise_datetime = []

for line in signal_lines:
    line_split = line.split()
    signal_dates.append(line_split[0] + " " + line_split[1])
    signal.append(line_split[2])

with open('sat_data/sem23_sinal.txt') as f:
    signal_lines = f.readlines()

for line in signal_lines:
    line_split = line.split()
    signal_dates.append(line_split[0] + " " + line_split[1])
    signal_dates23.append(line_split[0] + " " + line_split[1])
    signal.append(line_split[2])
    signal23.append(line_split[2])

for date in signal_dates:
    signal_datetime.append(datetime.strptime(date, '%d-%b-%Y %H:%M:%S'))
    signal_datetime23.append(datetime.strptime(date, '%d-%b-%Y %H:%M:%S'))

X = fft(signal)
X23 = fft(signal23)
N = len(X)
n = np.arange(N)
sr = 95479
T = N / sr
ts = 1.0 / sr
t = np.arange(0, 1, ts)
freq = n / T

#fig = plt.figure()
#ax = fig.add_subplot(111)
#plt.stem(freq, np.abs(X), 'k', \
 #        markerfmt=" ", basefmt="-k")
#ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
#ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
#plt.stem(freq, np.abs(X), 'b',
  #       markerfmt=" ", basefmt="-b")
#plt.xlabel('Frequência (Hz)')
#plt.ylabel('Amplitude da FFT')
#plt.xlim(-0.1, 10)
#plt.savefig('fft_sinal.png', dpi=1000)
#plt.show()

#fig = plt.figure()
#ax = fig.add_subplot(111)
#plt.plot(signal_datetime, ifft(X), 'k')
#ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
#ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
#ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
#plt.xlabel('Data (dia/mês)')
#plt.ylabel('Potência Recebida (dBm)')
#fig.autofmt_xdate()
#plt.savefig('sinal_comp_ant.png', dpi=1000)
#plt.show()

# Noise
with open('sat_data/sem23_ruido.txt') as f:
    noise_lines = f.readlines()

for line in noise_lines:
    line_split = line.split()
    noise_dates.append(line_split[0] + " " + line_split[1])
    noise.append(line_split[2])

for date in noise_dates:
    noise_datetime.append(datetime.strptime(date, '%d-%b-%Y %H:%M:%S'))

Y = fft(noise)
#fig = plt.figure()
#ax = fig.add_subplot(111)
#plt.plot(noise_datetime, ifft(Y), 'k', label='sinal')
#plt.plot(noise_datetime, ifft(X23), color='red', label='ruído')
#plt.plot()
#ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
#ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
#ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
#plt.xlabel('Data (dia/mês)')
#plt.ylabel('Potência (dBm)')
#plt.legend()
#fig.autofmt_xdate()
#plt.savefig('ruido_comp_ant.png', dpi=1000)
#plt.show()

signal23 = [float(x) for x in signal23]
noise = [float(x) for x in noise]
mean_signal = sum(signal23)/len(signal23)
mean_noise = sum(noise)/len(noise)
print(mean_signal)
print(mean_noise)


