CREATE TABLE [dwh].[data_budget_encounter]
(
[budget_enc_key] [int] NOT NULL IDENTITY(1, 1),
[payor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[site code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location_key] [int] NULL,
[ActualLocalDateKey] [date] NULL,
[enc] [int] NULL
) ON [PRIMARY]
GO
