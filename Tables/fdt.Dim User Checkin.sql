CREATE TABLE [fdt].[Dim User Checkin]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[User Checkin] [varchar] (52) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Resource Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Role Status] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Degree] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim User Checkin] ADD CONSTRAINT [user_key_pk13] PRIMARY KEY CLUSTERED  ([user_key]) ON [PRIMARY]
GO
