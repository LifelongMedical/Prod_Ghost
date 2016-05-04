CREATE TABLE [dwh].[data_action_plan]
(
[per_mon_id] [int] NULL,
[first_mon_date] [date] NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority Area] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Completed Date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service Date] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recency] [bigint] NULL,
[Create_Time] [datetime] NOT NULL
) ON [PRIMARY]
GO
