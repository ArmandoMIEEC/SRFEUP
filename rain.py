import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd
from scipy.integrate import quad_vec
import csv

rain = pd.read_excel('MATLAB/rain.xlsx')
t = np.linspace(0.0, 15, num=30)
x0 = 0
x1 = 15
rain_integrated, err = quad_vec(rain, x0, x1)
plt.plot(t, rain_integrated)
plt.show()

