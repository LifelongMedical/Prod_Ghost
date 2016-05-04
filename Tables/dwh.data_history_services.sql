CREATE TABLE [dwh].[data_history_services]
(
[per_mon_id] [int] NULL,
[first_mon_date] [date] NULL,
[Date of Service] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Staff FullName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Services/Referrals Provided] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resource Type] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service Type] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interpreter Service] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Referral Placed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Time Spent] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Internal Referral] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created Date] [datetime] NOT NULL,
[Recency] [bigint] NULL
) ON [PRIMARY]
GO
