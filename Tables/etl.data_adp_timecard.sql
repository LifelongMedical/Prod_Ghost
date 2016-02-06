CREATE TABLE [etl].[data_adp_timecard]
(
[Company Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Grant] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[File Number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Worked Site] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Worked Grant] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[In time] [datetime] NULL,
[Out time] [datetime] NULL,
[Out Punch Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hours] [decimal] (38, 4) NULL,
[Earnings Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
