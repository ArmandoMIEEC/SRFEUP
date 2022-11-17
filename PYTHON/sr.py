import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from datetime import datetime
import matplotlib.dates as mdates

with open('sat_data/sem12_sinal.txt') as f:
    signal_lines = f.readlines()

signal_datetime = []
signal_dates = []
signal = []

for line in signal_lines:
    line_split = line.split()
    signal_dates.append(line_split[0] + " " + line_split[1])
    signal.append(line_split[2])

with open('sat_data/sem23_sinal.txt') as f:
    signal_lines = f.readlines()

for line in signal_lines:
    line_split = line.split()
    signal_dates.append(line_split[0] + " " + line_split[1])
    signal.append(line_split[2])

for date in signal_dates:
    signal_datetime.append(datetime.strptime(date, '%d-%b-%Y %H:%M:%S'))


X = fft(signal)
N = len(X)
n = np.arange(N)
sr = 95479
T = N/sr
ts = 1.0/sr
t = np.arange(0,1,ts)
freq = n/T 

plt.stem(freq, np.abs(X), 'b', \
         markerfmt=" ", basefmt="-b")
plt.xlabel('Frequência (Hz)')
plt.ylabel('Amplitude da FFT')
plt.xlim(0, 10)
plt.show()

fig = plt.figure()
ax = fig.add_subplot(111)
plt.plot(signal_datetime, ifft(X), 'k')
ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
plt.xlabel('Data (dia/mês)')
plt.ylabel('Potência Recebida (dBm)')
fig.autofmt_xdate()
plt.savefig('sinal_comp_ant.png', dpi=1000)
plt.show()









