CREATE TABLE [fdt].[Fact and Dim FE Budget]
(
[Amount Budget] [numeric] (33, 16) NULL,
[Fiscal Scenario Name] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PK_DATE] [datetime] NOT NULL,
[chart_account_key] [int] NOT NULL
) ON [PRIMARY]
GO
