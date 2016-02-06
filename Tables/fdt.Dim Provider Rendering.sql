CREATE TABLE [fdt].[Dim Provider Rendering]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[employee_key] [int] NULL,
[Provider Rendering] [varchar] (52) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Resource Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Role Status] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[Primary Location Provider 12m] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HR Employee Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HR Employee Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HR Location ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HR Location Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Provider Rendering] ADD CONSTRAINT [user_key_pk17] PRIMARY KEY CLUSTERED  ([user_key]) ON [PRIMARY]
GO
