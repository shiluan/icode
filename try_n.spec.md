	// the spec
	try_n(f, n, tex, d);

where 
f: the aync function to try for n times, throw TransientException 
tex: TransientException, for catching
d: delay between tries; e.g. exponential delay strategy

	//constants
	MAX_RETRIES
	MAX_WAIT_INTERVAL


~~~
// an implementation in C#
async Task try_n()
{
	int retries = 0;

	for(;;)
	{
		try
		{
			await f();
			break;
		}
		catch(TransientException ex) 
		{
			retries++;
			if(retries>MAX_RETRIES)
			throw;
		}

		await Task.Delay(min(d(retries), MAX_WAIT_INTERVAL)
	}
}

int d(int k)
{
	return 2^k*100;
}

asyn Task f()
{
	...
}
~~~

