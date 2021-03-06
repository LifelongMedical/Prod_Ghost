CREATE TABLE [dwh].[data_user_v2]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[self_provider_id] [uniqueidentifier] NULL,
[employee_key] [int] NULL,
[user_id] [int] NULL,
[first_name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [varchar] (92) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ng_data] [int] NOT NULL,
[user_id_ecw] [int] NULL
) ON [PRIMARY]
GO
