from time import strftime

import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd
from scipy.integrate import quad_vec
import csv


def s_to_datetime(date_string):
    from datetime import datetime

    datetime_object = datetime.strptime(date_string, '%d-%b-%Y %H:%M')
    return datetime_object


fhand = open("MATLAB/Forecast.csv", "r")
forecast_dates = []
line = fhand.readline()
while line != "":
    forecast_dates.append(line[:17])
    line = fhand.readline()

print(forecast_dates)

for i in range(len(forecast_dates)):
    forecast_dates[i] = s_to_datetime(forecast_dates[i])

print(forecast_dates)

t = np.linspace(0.0, 15, num=30)
x0 = 0
x1 = 15
# rain_integrated, err = quad_vec(rain, x0, x1)
# plt.plot(dates, rain)
# plt.show()
