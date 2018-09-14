
##Express the business processes
A business process is an composition of a set of supporting functions. Suppose function space `F = {f1, f2, ... , fn}`, then a process is a subset of F with connections of precedency, i.e. `P = {(fi, fj)}; i<>j`. It is a directed network.


For example, a collection F of functions that are components for constructing processes, and P1 and P2 are two such processes:
```
F= {f1, f2, f3, f4, f5, f6}
P1 = [(1,2), (2.3), (2,4), (4,5)] 
P2 = [(5,6),(6, 3), (3, 2)]
```


ps
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



-- query summary of a run
select [Object], COALESCE([RunID], ID) RunID, [Event],  COALESCE(Parms, '') Parms, [TimeStamp]
,COALESCE(datediff(SECOND
,(select max([TimeStamp]) from 
Telemetry t1 where (runId = 6 or (ID=6 AND RunID is NULL)) and [TimeStamp]<t0.[TimeStamp]) 
,[TimeStamp]), 0) as [interval] 
from Telemetry t0
where runId = 6 or (ID=6 AND RunID is NULL)




-- summary on runs
select [object], COALESCE(RunID,ID) RunId,  MIN([TimeStamp]) [Started], MAX([TimeStamp]) [Ended], DATEDIFF(SECOND,  Min([TimeStamp]), MAX([TimeStamp])) [Laps] from Telemetry
GROUP BY [object], COALESCE(RunID,ID)
--HAVING COALESCE(RunID,ID) in (6) AND [object] in ('test')





DECLARE @sp_name = 'up_et_ContactUpdate' -- e.g
DECLARE @parms_str VARCHAR(MAX) = ''
DECLARE @exec_str VARCHAR(MAX) = ''
EXEC telemetry_alt_stmt @sp_name = @sp_name, @parms_str = @parms_str OUTPUT, @exec_str=@exec_str OUTPUT
PRINT @parms_str
PRINT @exec_str


```


add function param_to_str()
-- pass list of parameters and generate a str
```
  select '@x:'+cast(1 as varchar(255))
  +'@y:'+cast(getdate() as varchar(255))
  +'@z:'+cast(coalesce(null,'') as varchar(255))
   +'@m:'+cast(coalesce('','') as varchar(255))
   +'@n:'+cast(coalesce(0,'') as varchar(255))

```
