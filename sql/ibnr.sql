/*

select object_name(object_id), name 
from  sys.columns where lower(name) 
like '%premium%' order by name

*/


-- drop proc sp_QuarterEnd_QuarterEndSummary_IBNR
CREATE PROC [dbo].[sp_QuarterEnd_QuarterEndSummary_IBNR]
(
  @QuarterEndProcessId INT
)

/********************************************************
	Calculate IBNR rate and amount in QuarterEnd process

********************************************************/
AS

BEGIN
	/* Q.E. variables */
	DECLARE @AssumingCompanyId int;
	DECLARE @LineOfBusiness nvarchar(255);
	DECLARE @Current_StatementDate datetime;

	SELECT @AssumingCompanyId = AssumingCompanyId,
		   @Current_StatementDate = QuarterEndDate,
		   @LineOfBusiness = LineOfBusiness
    FROM   dbo.QuarterEndProcess
    WHERE  Id = @QuarterEndProcessId;


	DECLARE @trans TABLE
	(
		BillingId INT,
		QtrEndDate	DATETIME,
		IBNRFactor	DECIMAL,
		ExpiryDate	DATETIME, 
		EffectiveDate	DATETIME,
		IBNRMethod	VARCHAR(10),
		TmpMax111	INT, 
		TmpMax11	INT,
		TmpMin1		INT
		, LineOfBusiness VARCHAR(20)
		, RadLod VARCHAR(20)
		, UPRFactor DECIMAL

	)

	INSERT INTO @trans
	(
		BillingId
	)
	SELECT BillingId FROM QuarterEndSummary
	WHERE StatementDate = @Current_StatementDate



	UPDATE @trans 
	SET TmpMax111 = CASE 
		WHEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90 > 0 
		THEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90
		ELSE 0 END
	WHERE LineOfBusiness = 'Group Life' AND RadLod = 'RAD'


	UPDATE @trans 
	SET TmpMax111 = CASE 
		WHEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90 > 0 
		THEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90 
		ELSE 0 END
	WHERE LineOfBusiness = 'Group Life' AND RadLod = 'LOD'


	UPDATE @trans 
	SET TmpMax111 = CASE 
		WHEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90 > 0 
		THEN DATEDIFF(DAY, QtrEndDate, ExpiryDate) - 365 * 1 - 90
		ELSE 0 END
	WHERE LineOfBusiness = 'A&H'
	   

	UPDATE @trans 
	SET TmpMax11 = CASE 
		WHEN 90 - TmpMax111 > 0 
		THEN 90 - TmpMax111 
		ELSE 0 END

	UPDATE @trans 
	SET TmpMin1 
		= CASE WHEN TmpMax11 < DATEDIFF(DAY, QtrEndDate, EffectiveDate) 
				THEN TmpMax11 
				ELSE DATEDIFF(DAY, QtrEndDate, EffectiveDate) END

	/* INBRFactor  */
	UPDATE @trans 
	SET IBNRFactor 
		= TmpMin1 / DATEDIFF(day, ExpiryDate, EffectiveDate)


	
	/* UPR (Unearned Premium Reserve) Factor formula */
	UPDATE @trans 
	SET UPRFactor =	1 - (DATEDIFF(day, QtrEndDate, DATEADD(day, 1, EffectiveDate))/365) * ((DATEDIFF(month, QtrEndDate, EffectiveDate)+12)/12)
	WHERE RADLOD = 'RAD'
	
	UPDATE @trans 
	SET UPRFactor =	1 - (DATEDIFF(day, QtrEndDate, DATEADD(day, 1, EffectiveDate))/365) * (DATEDIFF(month, QtrEndDate, EffectiveDate)/12)
	WHERE RADLOD = 'LOD'



	/*INBRAmount*/
	UPDATE QuarterEndSummary
	SET IBNR = t.IBNRFactor 
		 --* ((FirstYearPremium + FYPremOS + RenPremPd + RenPremOS) 
		 --- (BkgPd + BkgOS)  
		 --- (FYAllowPd + FYAllowOS + RenAllowPd + RenAllowOS)
		 --- (FETaxPd + FETaxOF) 
		 --- (FYMgtFeePd + FYMgtFeeOS + RenMgtFeePd + RenMgtFeeOS) 
		 --- (CAPremPd + CAPremOS) 
		 --- (ERRPd + ERROS)) 
	
	FROM dbo.QuarterEndSummary AS s
		JOIN @trans AS t 
		ON s.BillingID = t.BillingId
		AND s.StatementDate = @Current_StatementDate 
		WHERE  IBNRMethod = 'Gross'


	/*INBRAmount*/
	UPDATE dbo.QuarterEndSummary
	SET IBNR = t.IBNRFactor 
		 --* (( TotalEarnedPrem 
		 --- TotalEarnedBrokerage 
		 --- TotalEarnedAllow 
		 --- TotalTaxes 
		 --- TotalEarnedMgtFees 
		 --- TotalCAPrem)
		 --- (ERRPd + ERROS)) 
	FROM dbo.QuarterEndSummary AS s
		JOIN @trans AS t 
		ON s.BillingID = t.BillingId
		AND s.StatementDate = @Current_StatementDate 
	WHERE  IBNRMethod = 'Earned'


	/*INBRAmount*/
	UPDATE QuarterEndSummary
	SET IBNR = IBNR - (ClaimAmountsPaid + ReserveforIncurredandReportedClaims) 
	FROM QuarterEndSummary AS s
		JOIN @trans AS t 
		ON s.BillingID = t.BillingId
		AND s.StatementDate = @Current_StatementDate 
	WHERE s.LineOfBusiness = 'A&H'

END
