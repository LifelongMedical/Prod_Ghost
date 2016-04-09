CREATE TABLE [fdt].[Dim NG Provider_OLD]
(
[provider_key] [int] NOT NULL IDENTITY(1, 1),
[user_key] [int] NULL,
[employee_key] [int] NULL,
[Role Status] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NG Prov First Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG Prov Last Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NG Prov Full Name] [varchar] (52) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NG Prov Provider Name] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Degree] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active Provider] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Primary Location for Provider] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Site Active Provider 3m] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Primary Location for Provider 3m] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Site Active Provider 3m] [varchar] (54) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Secondary Location for Provider 6m] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Active Provider 6m] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Primary Location for Provider 6m] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active Provider 12m] [varchar] (37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Primary Location Provider 12m] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
