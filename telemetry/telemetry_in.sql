CREATE TABLE Telemetry (
	[ID] bigint IDENTITY(1,1) PRIMARY KEY,
	[Object] varchar(255) NOT NULL,
	[Event] varchar(255) NOT NULL,
	RunID bigint,
	Parms varchar(4096),
	[TimeStamp] datetime NOT NULL
	
)
GO

CREATE PROCEDURE telemetry_insert
	@object varchar(255),
	@event varchar(255),
	@runId bigint = NULL,
	@parms varchar(4096) = NULL
AS
	INSERT INTO Telemetry 
		([Object],[Event],RunID,	Parms, [TimeStamp])
	VALUES 
		(@object, @event, @runId, @parms, GETDATE())

	RETURN @@Identity;
GO

-- prc: telemetry_alt_stmt
-- build the command for altering a sproc for telemetry 
CREATE PROCEDURE telemetry_alt_stmt 
	@sp_name VARCHAR(255)   
	, @parms_str VARCHAR(MAX) OUTPUT
	, @exec_str VARCHAR(MAX) OUTPUT

AS  
	-- find parameters of a sp
	WITH parms_tbl(parmName, parmType) 
	AS 
	(
		SELECT 
			parm.name AS parmName,        
			typ.name AS parmType
		FROM sys.procedures sp
			JOIN sys.parameters parm ON sp.object_id = parm.object_id
			JOIN sys.types typ ON parm.system_type_id = typ.system_type_id
		WHERE sp.name = @sp_name
	)
	SELECT	@parms_str += ''''+parmName + '='',' + 'coalesce(' + parmName + ',''''' +')' + ',',
			@exec_str += parmName + '=' + parmName + ','
	FROM parms_tbl;

	SET @parms_str = substring(@parms_str, 1, len(@parms_str)-1)
	SET @parms_str = 'SET @parms = CONCAT('+@parms_str+')'
	SET @parms_str = 'DECLARE @parms VARCHAR(MAX)' + CHAR(13)+CHAR(10) + @parms_str

	SET @exec_str = 'EXEC '+ @sp_name + '_mon ' + substring(@exec_str, 1, len(@exec_str)-1)
	SET @exec_str = @exec_str + CHAR(13)+CHAR(10) + 'RETURN'
GO  

CREATE PROCEDURE summary_per_run
	@run_id int 
AS
-- query summary of a run
SELECT [Object], COALESCE([RunID], ID) RunID, [Event],  COALESCE(Parms, '') Parms, [TimeStamp]
	,COALESCE(datediff(SECOND
	,(select max([TimeStamp]) from 
	Telemetry t1 where (RunID = 6 or (ID=6 AND RunID is NULL)) and [TimeStamp]<t0.[TimeStamp]) 
	,[TimeStamp]), 0) as [interval] 
FROM Telemetry t0
WHERE RunID = @run_id or (ID=@run_id AND RunID is NULL)
GO


CREATE PROCEDURE summary_runs
AS
-- summary on runs
SELECT [Object], COALESCE(RunID,ID) RunId,  MIN([TimeStamp]) [Started], MAX([TimeStamp]) [Ended], DATEDIFF(SECOND,  Min([TimeStamp]), MAX([TimeStamp])) [Laps] 
FROM Telemetry
GROUP BY [Object], COALESCE(RunID,ID)
GO

