IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'LMC\jabate')
CREATE LOGIN [LMC\jabate] FROM WINDOWS
GO
CREATE USER [lmc\jabate] FOR LOGIN [LMC\jabate]
GO
