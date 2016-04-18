CREATE TABLE [dwh].[data_vital_signs]
(
[encounterID] [uniqueidentifier] NULL,
[person_id] [uniqueidentifier] NOT NULL,
[create_timestamp] [datetime] NOT NULL,
[BP_date] [date] NULL,
[Recency] [bigint] NULL,
[per_mon_id] [int] NULL,
[first_mon_date] [date] NULL,
[enc_appt_key] [int] NULL,
[Type] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [numeric] (16, 2) NULL
) ON [PRIMARY]
GO
