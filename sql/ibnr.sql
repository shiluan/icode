CREATE PROC [dbo].[sp_QuarterEnd_QuarterEndSummary_IBNR]
(
  @QuarterEndProcessId INT
)

/********************************************************
	Calculate IBNR rate and amount in QuarterEnd process

********************************************************/
AS

BEGIN
	DECLARE @trans TABLE
	(
		QtrEndDate	DATETIME,
		INBRFactor	DECIMAL,
		ExpiryDate	DATETIME, 
		EffectiveDate	DATETIME,
		INBRMethod	VARCHAR(10),
		TmpMax111	INT, 
		TmpMax11	INT,
		TmpMin1		INT
		, LineOfBusiness VARCHAR(20)
		, RadLod VARCHAR(20)

	)

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
	SET INBRFactor 
		= TmpMin1 / DATEDIFF(day, ExpiryDate, EffectiveDate)

	/*INBRAmount*/
	--UPDATE @trans 
	--SET INBRAmount 
	--	= INBRFactor 
	--	 * ((FYPremPd + FYPremOS + RenPremPd + RenPremOS) 
	--	 - (BkgPd + BkgOS)  
	--	 - (FYAllowPd + FYAllowOS + RenAllowPd + RenAllowOS)
	--	 - (FETaxPd + FETaxOF) 
	--	 – (FYMgtFeePd + FYMgtFeeOS + RenMgtFeePd + RenMgtFeeOS) 
	--	 - (CAPremPd + CAPremOS) 
	--	 - (ERRPd + ERROS)) 
	--WHERE  IBNRMethod = 'Gross'

	/*INBRAmount*/
	--UPDATE @trans 
	--SET INBRAmount 
	--	= INBRFactor 
	--	 * (( TotalEarnedPrem 
	--	 - TotalEarnedBrokerage 
	--	 - TotalEarnedAllow 
	--	 - TotalTaxes 
	--	 - TotalEarnedMgtFees 
	--	 - TotalCAPrem)
	--	 - (ERRPd + ERROS)) 
	--WHERE  IBNRMethod = 'Earned'


	--/*INBRAmount*/
	--UPDATE @trans 
	--SET INBRAmount 
	--	= INBRAmount 
	--	– (ClaimAmountsPaid + ReserveforIncurredandReportedClaims) 

	--WHERE LineOfBusiness = 'A&H'


	/* UPR (Unearned Premium Reserve) Factor formula */

	UPDATE @trans 
	SET UPRFactor =	1 - (DATEDIFF(day, QtrEndDate, DATEADD(day, 1, EffectiveDate))/365) * ((DATEDIFF(month, QtrEndDate, EffectiveDate)+12)/12)
	WHERE RADLOD = 'RAD'
	
	UPDATE @trans 
	SET UPRFactor =	1 - (DATEDIFF(day, QtrEndDate, DATEADD(day, 1, EffectiveDate))/365) * (DATEDIFF(month, QtrEndDate, EffectiveDate)/12)
	WHERE RADLOD = 'LOD'

	


	/* Update QuarterEndSummary */
	
	UPDATE dbo.QuarterEndSummary
	SET INBRAmount = t.INBRAmount,
		UPRFactor = t.UPRFactor,
		UnearnedPremiumReserve = t.UPRFactor x s.ManagementFeesPaid
		
	FROM dbo.QuarterEndSummary AS s
		JOIN @trans AS t 
		ON t.BillingAcctId = s.BillingID
		AND s.StatementDate = @Current_StatementDate 



/* Update QuarterEndSummary */
	
	UPDATE dbo.QuarterEndSummary
	SET INBRAmount = t.INBRAmount
		
	FROM dbo.QuarterEndSummary AS s
		JOIN @trans AS t 
		ON t.BillingAcctId = s.BillingID
		AND s.StatementDate = @Current_StatementDate 




END
