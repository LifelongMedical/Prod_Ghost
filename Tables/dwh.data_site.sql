CREATE TABLE [dwh].[data_site]
(
[fe_site_key] [int] NOT NULL IDENTITY(1, 1),
[location_key] [int] NULL,
[Site] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site Description] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
