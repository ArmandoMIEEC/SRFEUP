import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd
from scipy.integrate import quad_vec
import csv

rain = pd.read_excel('MATLAB/rain.xlsx')
x0 = 0
x1 = 
rain_integrated, err = quad_vec(rain, xo, x1)
print(rain_integrated)
