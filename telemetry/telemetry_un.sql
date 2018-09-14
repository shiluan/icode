-- telemetry_un.sql
-- clean up telemetry environment

DROP TABLE IF EXISTS Telemetry
GO

DROP PROCEDURE IF EXISTS telemetry_insert
GO

DROP PROCEDURE IF EXISTS telemetry_alt_stmt
GO

DROP PROCEDURE IF EXISTS summary_per_run
GO

DROP PROCEDURE IF EXISTS summary_runs
GO