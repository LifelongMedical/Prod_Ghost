CREATE TABLE [fdt].[Fact and Dim Task Lists]
(
[task_key] [int] NOT NULL IDENTITY(1, 1),
[person_id] [uniqueidentifier] NULL,
[location_id] [uniqueidentifier] NULL,
[per_mon_id] [int] NOT NULL,
[enc_id] [uniqueidentifier] NULL,
[NG_task_id] [uniqueidentifier] NOT NULL,
[create_timestamp] [date] NULL,
[task_from_user_id] [int] NOT NULL,
[task_to_user_id] [int] NULL,
[seq_date] [date] NULL,
[Task_completed] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_Assigned] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_Read] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task_rejected] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[task_desc] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[task_subj] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour Range] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour_Sort] [int] NULL,
[Day Range] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Day_Sort] [int] NULL,
[Request_Type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[active] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact and Dim Task Lists] ADD CONSTRAINT [PK__Fact and__2205E620F6161DCD] PRIMARY KEY CLUSTERED  ([task_key]) ON [PRIMARY]
GO
