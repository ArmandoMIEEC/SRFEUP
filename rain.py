from time import strftime

import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd
from scipy.integrate import quad_vec
import matplotlib.dates as mdates
import csv
import scipy.integrate as integrate

def s_to_datetime(date_string):
    from datetime import datetime

    datetime_object = datetime.strptime(date_string, '%d-%b-%Y %H:%M')
    return datetime_object


fhand = open("MATLAB/Forecast.csv", "r")

forecast_dates = [] #u
rain_amount = [] #r_a
aux = [] 
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
#print(rain_amount)

date_time = pd.to_datetime(forecast_dates)
rain_amount = integrate.cumulative_trapezoid(rain_amount)
rain_amount = np.append(rain_amount, rain_amount[-1])
#rain_amount = np.trapz(rain_amount)
print(rain_amount)


DF = pd.DataFrame()
DF['value'] = rain_amount
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%d-%m'))
plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=2))
DF = DF.set_index(date_time)
plt.plot(DF)
plt.xlabel('Data (dia/mês)')
plt.ylabel('Quantidade de chuva (mm)')
plt.gcf().autofmt_xdate()
plt.show()
