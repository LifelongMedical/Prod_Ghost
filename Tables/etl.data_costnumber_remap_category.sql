CREATE TABLE [etl].[data_costnumber_remap_category]
(
[Name Full] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Job Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OSHPD Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category Number] [float] NULL,
[Nbr of Employees] [float] NULL,
[FTE Hx] [float] NULL,
[Should Be] [float] NULL
) ON [PRIMARY]
GO
