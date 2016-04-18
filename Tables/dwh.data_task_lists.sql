CREATE TABLE [dwh].[data_task_lists]
(
[person_id] [uniqueidentifier] NULL,
[location_id] [uniqueidentifier] NULL,
[per_mon_id] [int] NOT NULL,
[enc_id] [uniqueidentifier] NULL,
[NG_task_id] [uniqueidentifier] NOT NULL,
[create_timestamp] [date] NULL,
[task_from_user_id] [int] NOT NULL,
[task_to_user_id] [int] NULL,
[HourstoCompeletion] [int] NULL,
[DaystoCompeletion] [int] NULL,
[seq_date] [date] NULL,
[Task_completed] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_Assigned] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_Read] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_rejected] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[task_desc] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_subj] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Request_Type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[active] [int] NOT NULL
) ON [PRIMARY]
GO
