#Random Sample-based Testing

Preparing testing data is key to testing. Commonly we choose parameter’s boundary values, for example, the max, min, 0, etc. as critical testing values. But this type of testing may not measure the performance. As a complementary approach, we pick random samples from the execution history, after the function to be tested has run for some time, and apply mathematical method on random variable analysis to define the performance.

Suppose a function with n parameters, `X1, …, Xn`, each of which is a random variable. From the execution history we collect random samples of parameter combinations executed, then run tests on them.   
random samples  of parameters
`f(X1, X2,..., Xn)`

##Summarization of performance
A performance test will produce a summary report including following statistics for each function and for a process collectively. 

Statistics: 
* Mean
* Std
* Min
* Max




