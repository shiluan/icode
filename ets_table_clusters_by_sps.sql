
-- _tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 

-- _sps
SELECT NAME 
FROM dbo.sysobjects
WHERE (type = 'P')


--definition of a sp
DECLARE @def VARCHAR(MAX) 
SET @def = (SELECT OBJECT_DEFINITION (OBJECT_ID(N'upretSelectAssignor')))





-- _contains(table, sp)
IF(charindex(lower('pROCEDURE'), lower(@def))) >0 
	print 'found'
ELSE 
	PRINT 'NOT FOUDN'


--
-- put together
DECLARE @table_cluster_from_sps TABLE
(
  Table1Name varchar(255), 
  Table2Name varchar(255),
  Coocurrence int
)

-- create table combinations
INSERT INTO @table_cluster_from_sps
	SELECT t1.TABLE_NAME as Table1Name, t2.TABLE_NAME as Table2Name, 0 as Coocurrence
		FROM 
		((SELECT TABLE_NAME 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_TYPE = 'BASE TABLE') t1
		CROSS JOIN
		(SELECT TABLE_NAME 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_TYPE = 'BASE TABLE') t2
		
		)
		WHERE t1.TABLE_NAME <> t2.TABLE_NAME 

-- show table combinations
--select * from @table_cluster_from_sps		


DECLARE SP_CURSOR CURSOR 
  LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
	SELECT NAME 
	FROM dbo.sysobjects
	WHERE (type = 'P')

DECLARE @sp_def VARCHAR(MAX), @sp_name VARCHAR(255)

OPEN SP_CURSOR
FETCH NEXT FROM SP_CURSOR INTO @sp_name
WHILE @@FETCH_STATUS = 0
BEGIN 
    
	SET @sp_def = (SELECT OBJECT_DEFINITION (OBJECT_ID(@sp_name)))

	SET @sp_def = LOWER(@sp_def)

	UPDATE @table_cluster_from_sps
		SET Coocurrence = Coocurrence + 1
		WHERE charindex(lower(Table1Name), @sp_def) >0
			AND charindex(lower(Table2Name), @sp_def) >0
			

    --
    FETCH NEXT FROM SP_CURSOR INTO @sp_name
END
CLOSE SP_CURSOR
DEALLOCATE SP_CURSOR

select * from @table_cluster_from_sps	


