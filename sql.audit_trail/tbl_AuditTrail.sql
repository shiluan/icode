
/*
	Create an audit trail table
	According to specific context, you can add custom fields, such as ClaimSetupId in following code, 
	as long as their value can be found in the Inserted, Deleted trigger context data, so they can 
	be inserted into the auditing records
*/


-- DROP TABLE ClaimAuditTrail

CREATE TABLE ClaimAuditTrail
(
	Id				int				IDENTITY(1,1) NOT NULL,
	ClaimSetupId	int,
	[Action]	varchar (20),		--{add, change, delete} 
	TableName	varchar(128), 
	TableKey	int, 
	FieldName	varchar(128), 
	PreviousValue	varchar(1000), 
	ChangedValue	varchar(1000), 	 
	ActionTakenBy	varchar(128)	DEFAULT (suser_sname()),
	ChangeDate	datetime			DEFAULT (getdate())
)
GO


ALTER TABLE [ClaimAuditTrail]
ADD CONSTRAINT PK_ClaimAuditTrail PRIMARY KEY (ID);
