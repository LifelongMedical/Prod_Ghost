CREATE TABLE [fdt].[Dim Medical Home Current]
(
[location_key] [int] NOT NULL IDENTITY(1, 1),
[Medical Home Current] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Medical Home Current] ADD CONSTRAINT [location_key_pk2] PRIMARY KEY CLUSTERED  ([location_key]) ON [PRIMARY]
GO
