CREATE TABLE [etl].[sp_provider_shift]
(
[FullName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetVisitsPerShift] [float] NULL,
[NumberOfPCPShifts] [float] NULL,
[FTE] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
