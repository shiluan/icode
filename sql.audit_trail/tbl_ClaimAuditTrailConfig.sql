/*
	Create an audit trail configuration table
	where to specify the tracked fields in every tracked table 
	
*/


-- DROP TABLE ClaimAuditTrailConfig

CREATE TABLE ClaimAuditTrailConfig
(
	TableName	VARCHAR(128) NOT NULL, 
	FieldName	VARCHAR(128) NOT NULL
)
GO


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_ClaimAuditTrailConfig_TableName')   
    DROP INDEX ix_ClaimAuditTrailConfig_TableName ON ClaimAuditTrailConfig;   
GO  
   
CREATE NONCLUSTERED INDEX ix_ClaimAuditTrailConfig_TableName
    ON ClaimAuditTrailConfig (TableName);   
GO  


IF EXISTS (SELECT name from sys.indexes  
           WHERE name = N'ix_ClaimAuditTrailConfig_TblFld')   
   DROP INDEX ix_ClaimAuditTrailConfig_TblFld ON ClaimAuditTrailConfig;   
GO  

CREATE UNIQUE INDEX ix_ClaimAuditTrailConfig_TblFld   
   ON ClaimAuditTrailConfig (TableName, FieldName);   
GO  
