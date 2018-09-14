# simulation of normal distribution

%matplotlib inline

def dist_summary(dist, name='distribution'):
    import pandas as pd
    import matplotlib.pyplot as plt
    ser = pd.Series(dist)
    fig = plt.figure(1, figsize=(9,6))
    ax = fig.gca()
    ser.hist(ax=ax, bins=120)
    plt.show()
    
    return(ser.describe())
    

def sim_norm(nums, mean=600, sd=30):
    import numpy as np
    import numpy.random as rd
    
    for n in nums:
        dist = rd.normal(loc=mean, scale=sd, size=n)
        titl = 'normal distribution with' + str(n) + 'values'
        print(dist_summary(dist,titl))
    return ('done')


nums = [100, 1000, 10000]
sim_norm(nums)

