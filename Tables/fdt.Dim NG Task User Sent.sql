CREATE TABLE [fdt].[Dim NG Task User Sent]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[employee_key] [int] NULL,
[NG User First Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG User Last Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG User Full Name] [varchar] (92) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
