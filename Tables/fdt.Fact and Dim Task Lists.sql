CREATE TABLE [fdt].[Fact and Dim Task Lists]
(
[task_key] [int] NOT NULL IDENTITY(1, 1),
[task_to_user_key] [int] NULL,
[task_from_user_key] [int] NULL,
[Created Date] [date] NULL,
[Task Completed] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task Assigned] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task Read] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task Rejected] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Task Subject] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nbr of active Inbox] [int] NOT NULL,
[Request Type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Task Hours to Completion] [int] NULL,
[Task Days to Completion] [int] NULL,
[Hour Range] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour Sort] [int] NULL,
[Day Range] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Day Sort] [int] NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact and Dim Task Lists] ADD 
CONSTRAINT [PK__Fact and__2205E62057E687D2] PRIMARY KEY CLUSTERED  ([task_key]) ON [PRIMARY]
GO
