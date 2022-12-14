import matplotlib.pyplot as plt
import numpy as np
import scipy
from numpy.fft import fft, ifft
from datetime import datetime
import matplotlib.dates as mdates
import pandas as pd
import matplotlib.dates as mdates
import scipy.sparse
from scipy import integrate
from scipy.integrate import quad
from scipy.signal import butter, lfilter, freqz

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

for date in signal_dates23:
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

fig = plt.figure()
ax = fig.add_subplot(111)
plt.stem(freq, np.abs(X), 'k', \
       markerfmt=" ", basefmt="-k")
ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
plt.stem(freq, np.abs(X), 'b',
      markerfmt=" ", basefmt="-b")
plt.xlabel('Frequência (Hz)')
plt.ylabel('Amplitude da FFT')
plt.xlim(-0.1, 10)
plt.savefig('fft_sinal.png', dpi=1000)
plt.show()

# fig = plt.figure()
# ax = fig.add_subplot(111)
# plt.plot(signal_datetime, ifft(X), 'k')
# ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
# ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
# ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
# plt.xlabel('Data (dia/mês)')
# plt.ylabel('Potência Recebida (dBm)')
# fig.autofmt_xdate()
# plt.savefig('sinal_comp_ant.png', dpi=1000)
# plt.show()
noise_total = []
# Noise
with open('sat_data/sem23_ruido.txt') as f:
    noise_lines = f.readlines()

for line in noise_lines:
    line_split = line.split()
    noise_dates.append(line_split[0] + " " + line_split[1])
    noise.append(line_split[2])
    noise_total.append(line_split[0] + " " + line_split[1] + " " + line_split[2])

for date in noise_dates:
    noise_datetime.append(datetime.strptime(date, '%d-%b-%Y %H:%M:%S'))

noise_total = pd.read_csv('sat_data/sem23_ruido.csv')
noise_total.columns = ['All']
noise_total = noise_total['All'].str.split(";", n=2, expand=True)
noise_total.columns = ['Date', 'Hour', 'Value']
noise_total["Date"] = noise_total["Date"] + " " + noise_total["Hour"]
noise_total = noise_total.drop('Hour', axis=1)
noise_total['Date'] = pd.to_datetime(noise_total['Date'])
noise_total['Value'] = noise_total['Value'].astype(float)
noise_total.groupby(noise_total["Date"].dt.hour)["Value"].mean()
print(noise_total)

X23 = fft(signal23)
Y = fft(noise_total['Value'])
fig = plt.figure()
ax = fig.add_subplot(111)
plt.plot(noise_total['Date'], ifft(Y), 'k', label='ruído')
plt.plot()
ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
plt.xlabel('Data (dia/mês)')
plt.ylabel('Potência (dBm)')
plt.legend()
fig.autofmt_xdate()
plt.savefig('ruido_sem_filtro.png', dpi=1000)
plt.show()

for i in range(0, len(noise_total['Value'])):
    if abs(noise_total['Value'][i]) < 51:
        noise_total['Value'][i] = noise_total['Value'][i - 1]

for i in range(0, len(signal23)):
    if abs(float(signal23[i])) > 45:
        signal23[i] = signal23[i-1]

X23 = fft(signal23)
Y = fft(noise_total['Value'])
fig = plt.figure()
ax = fig.add_subplot(111)
plt.plot(noise_total['Date'], ifft(Y), 'k', label='ruído')
plt.plot(signal_datetime23, ifft(X23), color='red', label='sinal')
plt.plot()
ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
ax.set_xlabel('xlabel', fontdict=dict(weight='bold'))
ax.set_ylabel('ylabel', fontdict=dict(weight='bold'))
plt.xlabel('Data (dia/mês)')
plt.ylabel('Potência (dBm)')
plt.legend()
fig.autofmt_xdate()
plt.savefig('ruido_comp_ant.png', dpi=1000)
plt.show()

signal23 = [float(x) for x in signal23]
noise = [float(x) for x in noise]
mean_signal = sum(signal23) / len(signal23)
mean_noise = sum(noise) / len(noise)
print(mean_signal)
print(mean_noise)


def s_to_datetime(date_string):
    from datetime import datetime

    datetime_object = datetime.strptime(date_string, '%d-%b-%Y %H:%M')
    return datetime_object


fhand = open("../MATLAB/Forecast.csv", "r")

forecast_dates = []  # u
rain_amount = []  # r_a
aux = []
temperature = []
f_line = fhand.readlines()

for line in f_line:
    aux.append(line.strip().split(","))
    forecast_dates.append(line[:17])

del forecast_dates[0]
forecast_dates = list(map(lambda x: s_to_datetime(x), forecast_dates))

del aux[0]
for i in aux:
    rain_amount.append(float(i[-1]))

print(len(forecast_dates))
print(len(rain_amount))
# print(rain_amount)

date_time = pd.to_datetime(forecast_dates)


# rain_amount = integrate.cumulative_trapezoid(rain_amount)
# rain_amount = np.append(rain_amount, rain_amount[-1])
# noise_total['Value'] = np.append(noise_total['Value'], noise_total['Value'][-1])

def mean_filter(arr, k):
    p = len(arr)
    diag_offset = np.linspace(-(k // 2), k // 2, k, dtype=int)
    eL = scipy.sparse.diags(np.ones((k, p)), offsets=diag_offset, shape=(p, p))
    nrmlize = eL @ np.ones_like(arr)
    return (eL @ arr) / nrmlize


noise_total_filtered = mean_filter(noise_total['Value'], 50)

DF = pd.DataFrame()
DF['value'] = rain_amount
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%d/%m'))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=2))
DF = DF.set_index(date_time)
x0 = noise_total['Date'][0]
x1 = noise_total['Date'][len(noise_total['Date']) - 1]
fig, ax = plt.subplots()
ax.set_xlim([x0, x1])
ax.plot(DF, label="Chuva")
ax.set_xlabel('Data (dia/mês)')
ax.set_ylabel('Quantidade de chuva (mm/h)')
ax2 = ax.twinx()
ax2.set_ylim([-58, -52])
ax2.plot(noise_total['Date'], noise_total_filtered, 'k', label='Ruído')
ax2.set_ylabel('Potência de Ruído (dBm)')
plt.gcf().autofmt_xdate()
ax.legend()
#ax2.legend()
plt.savefig('ruido_com_chuva1.png', dpi=1000)
plt.show()



