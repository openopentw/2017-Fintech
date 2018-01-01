import talib

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

pastData = pd.read_csv('SPY.csv')
pastData = pastData[-301:]
# pastData['Adj Open'] = pastData['Open'] + pastData[1:

# sma = talib.SMA(pastData['Adj Close'].values, timeperiod=30)

plt.plot(pastData['Date'], pastData['Adj Close'], 'C1', label='Adj Close')
plt.plot(pastData['Date'], talib.SMA(pastData['Adj Close'].values, 30), 'C2', label='SMA')
plt.legend()
plt.show()

# return 1
