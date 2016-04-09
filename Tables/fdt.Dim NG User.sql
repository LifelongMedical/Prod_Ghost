CREATE TABLE [fdt].[Dim NG User]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[employee_key] [int] NULL,
[NG User First Name] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG User Last Name] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG User Full Name] [varchar] (33) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
