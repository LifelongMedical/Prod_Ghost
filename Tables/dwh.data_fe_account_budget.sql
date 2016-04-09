CREATE TABLE [dwh].[data_fe_account_budget]
(
[amount_old] [numeric] (19, 4) NOT NULL,
[YEARID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GL7ACCOUNTSID] [int] NOT NULL,
[STARTDATE] [datetime] NOT NULL,
[PK_Date] [datetime] NOT NULL,
[amount] [numeric] (33, 16) NULL,
[Account Number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account Description] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account Group] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account Super Group] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project ID] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Project Name] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site Description] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category Number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category Description] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fund] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Indirect or Direct] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chart_account_key] [int] NOT NULL
) ON [PRIMARY]
GO
