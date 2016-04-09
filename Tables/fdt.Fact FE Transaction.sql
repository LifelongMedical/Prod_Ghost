CREATE TABLE [fdt].[Fact FE Transaction]
(
[chart_account_key] [int] NULL,
[Post Date] [datetime] NOT NULL,
[Transaction Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [numeric] (22, 5) NULL
) ON [PRIMARY]
GO
