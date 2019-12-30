
/*
track data changes in a table and record them in the auditing trail table

following variables are required to customize for use: 

	@auditingTable: the auditing table name
	@fields: tracking table column names to track changes 
	the tracking table name: used in creating the trigger

*/


--Drop trigger trig_auditing_trail

CREATE TRIGGER [dbo].[trig_auditing_trail] 
ON TestTrigger	-- {the tracking table name}
FOR INSERT, UPDATE, DELETE
AS 

BEGIN

	DECLARE @auditingTable VARCHAR(128)
	SET @auditingTable = 'ClaimAuditTrail'

	-- Determine the table name from the context
	DECLARE @tblname VARCHAR(128)
	SELECT @tblname = OBJECT_NAME(parent_object_id) 
	FROM sys.objects 
	WHERE sys.objects.name = OBJECT_NAME(@@PROCID)
	
	-- Configure the fields to be tracked
	DECLARE @fields TABLE (field_name VARCHAR(128))
	INSERT @fields SELECT FieldName FROM ClaimAuditTrailConfig WHERE TableName = @tblname
	
	-- Determine the action type
	DECLARE @type VARCHAR(10) --{insert, delete, update}
	
	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		SELECT @type = 'UPDATE'
	ELSE IF EXISTS (SELECT * FROM inserted)
		SELECT @type = 'INSERT'
	ELSE
		SELECT @type = 'DELETE'


	-- The inserted and deleted may not exist in dynamic sql
	SELECT * INTO #ins FROM inserted
	SELECT * INTO #del FROM deleted
	
	
	DECLARE @sql VARCHAR(4000)

	IF @type = 'INSERT'
	BEGIN
		SELECT @sql = 'INSERT ' + @auditingTable + '
		(
			TableName, 
			TableKey, 
			[Action] --,
			--ActionTakenBy
		) SELECT ' 
			+  '''' + @tblname + ''','  
			+ 'i.Id' + ','
			+ '''' + @type + '''' 
			+ ' FROM #ins i' 
		--print @sql
		EXEC (@sql)
	END


	IF @type = 'DELETE'
	BEGIN
		SELECT @sql = 'INSERT ' + @auditingTable + '
		(
			TableName, 
			TableKey, 
			[Action] --,
			--ActionTakenBy
		) SELECT ' 
			+  '''' + @tblname + ''','  
			+ 'd.Id' + ','
			+ '''' + @type + '''' 
			+ ' FROM #del d' 
		
		EXEC (@sql)
	END

					
	IF @type = 'UPDATE'
	BEGIN
		DECLARE @colId INT
		DECLARE @cols VARCHAR(8000),@fieldname VARCHAR(8000)
		SET @cols = SPACE(0)
		SET @fieldname = SPACE(0)
		SET @colId = 1
		
		WHILE @colId <= (
			SELECT COUNT(*) 
			FROM information_schema.columns
			WHERE table_name = @tblname)
		BEGIN
			IF (SUBSTRING(COLUMNS_UPDATED(),(@colId - 1) / 8 + 1, 1)) &
				POWER(2, (@colId - 1) % 8) = POWER(2, (@colId - 1) % 8)

			BEGIN
				SELECT @fieldname = name FROM sys.columns WHERE object_id = object_id(@tblname) AND column_id = @colId
				
				IF(@fieldname IN (SELECT field_name FROM @fields))
				
				BEGIN
					-- PRINT 'Updated columns are :'+ @tblname + '.' + CAST(@colId AS VARCHAR) +':'+ @fieldname

					-- the dynamic sql to insert audit trail records for UPDATE operations
					SELECT @sql = '
						INSERT ' + @auditingTable + '
						(
							TableName, 
							TableKey, 
							FieldName, 
							PreviousValue, 
							ChangedValue,
							[Action] --,
							--ActionTakenBy
						)
						SELECT ' 
							+  '''' + @tblname + ''','  
							+ 'i.Id' + ','
							+ '''' + @fieldname + ''','
							+ 'convert(VARCHAR(128),d.' + @fieldname + '),'
							+ 'convert(VARCHAR(128),i.' + @fieldname + '),'
							+ '''' + @type + '''' 

							+ ' FROM #ins i JOIN #del d ON i.Id = d.Id'
							+ ' WHERE coalesce(convert(varchar, i.' + @fieldname + ' ), '''')  <> coalesce(convert(varchar, d.' + @fieldname + ' ), '''')'


					--print @sql

					EXEC (@sql)
					
				END
			END

			SET @colId = @colId + 1
		END
	END
END

GO


