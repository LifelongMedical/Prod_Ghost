IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'LMC\hdoganay')
CREATE LOGIN [LMC\hdoganay] FROM WINDOWS
GO
CREATE USER [lmc\hdoganay] FOR LOGIN [LMC\hdoganay]
GO
