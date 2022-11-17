import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd

data = pd.read_csv("../MATLAB/Forecast.csv", delimiter= ';')
rain = []
rain = data[11]
