#SP Telemetry and Performance

##Summary
The process of telemetrying a stored procedure:
1. setup 
    1. exec telemetry_in.sql to install telemetrying environment
    2. create a shadow sp from the testing sp 
    3. alter the testing sp to add code redirecting to the shadow sp 
    4. alter the shadow_sp to add telemetry entries
5. execute the sp from app or direct sql call, many times
6. request telemetry summary
7. clean up
	1. delete the shadow_sp
    2. alter the testing sp to remove the redirecting code
    3. exec telemetry_un.sql to uninstall telemery environment 


##Create a shadow sp
To test a stored procedure, we create a shadow procedure with a name suffixed with '_mon'. 
Then, in the very beginning of that original sp we put code to redirect execution to
the shadow sp. We add telemetry entries in the shadow sp, we want minimize change to the original sp. 
When testing is done, we restore the original procedureby only remove the redirecting code. 

To create a shadow sp, in SSMS right-click on the testing sp, select [Script stored procedure as], [create to], 
[new query editor window], then change the name adding _mon and execute. 

##Alter the testing sp
this is to let the testing sp redirect execution to the shadow sp.

Execute the following code and we get two strings:
* @exec_str: the text to be put in the testing sp for redirecting execution; 
* @exec_str: the stringified parameters for telemetry records,  required in the shadow sp.

```
DECLARE @sp_name VARCHAR(255) = 'up_et_ContactUpdate' -- e.g
DECLARE @parms_str VARCHAR(MAX) = ''
DECLARE @exec_str VARCHAR(MAX) = ''
EXEC telemetry_alt_stmt @sp_name = @sp_name, @parms_str = @parms_str OUTPUT, @exec_str=@exec_str OUTPUT
PRINT @parms_str
PRINT ''
PRINT @exec_str
```



## Add Telemetry Entries
###Where to add 
First find the integrity points. Integrity points come inherently from business activities and integrity requirements. At a certain level, a business activity requires either to be completed or failed and rolled back to the original state. I.e. all-or-nothing.

###Telemetry Events 
telemetry events can be added upon a business activity, or inside of them. But to make code implementation more testable and manageable, functions should be carefully designed with appropriate granularity.

A well-structured implementation makes it easy to embed telemetry events. e.g., a function in AirData application called LoadTimelines that updates tables with new records added to the database, implemented through a stored procedure, add following two events:

```
'on-start': 
	// tracking the first event in a run
	try{
		runId = telemetry_insert();
	}
	catch{
		do nothing
	}
 
'on-end':
	// only track following events when a context is available 
	if(runId != null)
	{
		try{
			telemetry_insert(runId);
		}
		catch{
			do nothing
		}
	}
```
##The Telemetry Entry
A telemetry entry contain following variables:
* object: [str] the routine that is being tracked
* event: [str]the stages to track in a run of the routine
* runid: [str]all events in a run have the same runid
* params: [str]the parameters in string representation
* timestamp: [datetime]timestamp - the time that the event happens



A run starts with a runId, in the following code, the first log activity gets a runId that is used in following log activities 
so that logs reference the same runId are corresponding to the same run.

```
-- testing script
DECLARE @x bigint
DECLARE @r bigint

---- the first event in a run
exec @x = telemetry_insert @object = 'test', @event = 'on-start'
set @r = @x

---- minic a delay of 2 sec of workload 
WAITFOR DELAY '00:00:02';

---- the following events in a run
exec @x = telemetry_insert @object = 'test', @event = 'on-end',@runId = @r

select * from Telemetry
```
## The Summary
After runs with telemetry, we can retrieve the summary report. The following two scripts produces two type of reports: 
per-run report and report on runs.
```
EXEC summary_per_run @run_id=1

EXEC summary_runs

```


