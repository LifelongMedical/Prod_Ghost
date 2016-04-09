CREATE TABLE [fdt].[Dim Location for Enc or Appt_OLD]
(
[location_key] [int] NOT NULL IDENTITY(1, 1),
[site_id] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location for Enc or Appt] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Location for Enc or Appt_OLD] ADD CONSTRAINT [location_key_pk17] PRIMARY KEY CLUSTERED  ([location_key]) ON [PRIMARY]
GO
