IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'LMC\bmansalis')
CREATE LOGIN [LMC\bmansalis] FROM WINDOWS
GO
CREATE USER [LMC\bmansalis] FOR LOGIN [LMC\bmansalis] WITH DEFAULT_SCHEMA=[dwh]
GO
