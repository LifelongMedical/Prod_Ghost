CREATE TABLE [fdt].[Dim NG Resource]
(
[resource_key] [int] NOT NULL IDENTITY(1, 1),
[NG Schedule Resource Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[provider_key] [int] NULL
) ON [PRIMARY]
GO
