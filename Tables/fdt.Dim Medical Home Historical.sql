CREATE TABLE [fdt].[Dim Medical Home Historical]
(
[location_key] [int] NOT NULL IDENTITY(1, 1),
[Medical Home Historical] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Medical Home Historical] ADD CONSTRAINT [location_key_pk3] PRIMARY KEY CLUSTERED  ([location_key]) ON [PRIMARY]
GO
