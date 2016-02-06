CREATE TABLE [fdt].[Dim User Checkout]
(
[user_key] [int] NOT NULL IDENTITY(1, 1),
[User Checkout] [varchar] (52) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Resource Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Role Status] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Degree] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim User Checkout] ADD CONSTRAINT [user_key_pk14] PRIMARY KEY CLUSTERED  ([user_key]) ON [PRIMARY]
GO
