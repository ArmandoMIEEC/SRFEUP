import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft
from scipy.signal import find_peaks
from datetime import datetime
import pandas as pd
from scipy.integrate import quad_vec

rain = pd.read_excel('MATLAB/rain.xlsx')
