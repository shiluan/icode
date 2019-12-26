
/*
  Initialize ClaimAuditTrailConfig entries

*/


/*
[ClaimSetup]
	[ClaimBillingNo]
	[TreatyId]
	[ClaimStatus]
	[AssumedCompanyShare]
	[AssumedCompanyShareAmt]
	[StatementCurrencyExchangeRate]
	
	[PolicyNumber]
	[SmokerStatus]
	[CoverageSmokingStatus]
	[CoverageUnderwritingRating]
	[CoverageUnderwritingMethod]
	[CoverageUnderwritingType]
	[ProductType]
	
	[Litigated]
	[Contestable]
	[CounselRequired]
	
[ClaimLife]
	[FirstName]
	[LastName]
	[BirthDate]
	[DeathDate]
	[CauseOfDeath]
*/


INSERT ClaimAuditTrailConfig 
	(TableName, FieldName)
VALUES 
	('ClaimSetup', 'ClaimBillingNo'),
	('ClaimSetup', 'TreatyId'),
	('ClaimSetup', 'ClaimStatus'),
	('ClaimSetup', 'AssumedCompanyShare'),
	('ClaimSetup', 'AssumedCompanyShareAmt'),
	('ClaimSetup', 'StatementCurrencyExchangeRate'),

	('ClaimSetup', 'PolicyNumber'),
	('ClaimSetup', 'SmokerStatus'),
	('ClaimSetup', 'CoverageSmokingStatus'),
	('ClaimSetup', 'CoverageUnderwritingRating'),
	('ClaimSetup', 'CoverageUnderwritingMethod'),
	('ClaimSetup', 'CoverageUnderwritingType'),
	('ClaimSetup', 'ProductType'),

	('ClaimSetup', 'Litigated'),
	('ClaimSetup', 'Contestable'),
	('ClaimSetup', 'CounselRequired')

	

INSERT ClaimAuditTrailConfig 
	(TableName, FieldName)
VALUES 
	('ClaimLife', 'FirstName'),
	('LastName'),
	('BirthDate'),
	('DeathDate'),
	('CauseOfDeath')





	
	
	
