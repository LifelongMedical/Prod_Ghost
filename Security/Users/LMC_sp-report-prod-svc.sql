IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'LMC\sp-report-prod-svc')
CREATE LOGIN [LMC\sp-report-prod-svc] FROM WINDOWS
GO
CREATE USER [LMC\sp-report-prod-svc] FOR LOGIN [LMC\sp-report-prod-svc]
GO
