CREATE TABLE [dwh].[data_fe_transaction]
(
[fe_trans_key] [int] NOT NULL IDENTITY(1, 1),
[GL7ACCOUNTSID] [int] NOT NULL,
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
[Post Date] [datetime] NOT NULL,
[Fund] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Indirect or Direct] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [numeric] (22, 5) NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
