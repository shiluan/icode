
## Pie Chart

import matplotlib.pyplot as plt 

labels = 'Positive', 'Negative', 'Neutral'
sizes = [100, 200, 300]
colors = ['green', 'red', 'grey']
yourtext = "Your Search Query from Step 2"


plt.pie(sizes, labels = labels, colors = colors, shadow = True, startangle = 90)
plt.title("Sentiment of 200 Tweets about "+yourtext)
plt.show()


## import dataset from Azure work space
from azureml import Workspace
ws = Workspace()

da = ws.datasets['sh601166.csv']
frame = da.to_dataframe()

## for time series use rolling window
r5 = frame['price'].rolling(window=5).mean()
r10 = frame['price'].rolling(window=10).mean()
r30 = frame['price'].rolling(window=30).mean()

#!set context to see plot in line
%matplotlib inline

r5.plot()
r10.plot()
r30.plot()
