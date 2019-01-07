[https://www.datacamp.com/community/tutorials/time-series-analysis-tutorial]

## TimeSeries and trends plot


# Import packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# import seaborn as sns
%matplotlib inline
# sns.set()


df = pd.read_csv('data/time_trends.csv', skiprows=0)
df.head()


df.info()



df.columns = ['month', 'diet', 'gym', 'finance']
df.head()



df.month = pd.to_datetime(df.month)
df.set_index('month', inplace=True)
df.head()



df.plot(figsize=(20,10), linewidth=5, fontsize=20)
plt.xlabel('Year', fontsize=20);



