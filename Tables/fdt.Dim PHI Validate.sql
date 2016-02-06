CREATE TABLE [fdt].[Dim PHI Validate]
(
[enc_key] [int] NOT NULL,
[Encounter Number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Medical Record Number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full Name] [varchar] (147) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location Name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rendering Provider Name] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Encounter Bill Date] [date] NULL,
[Encounter Status] [varchar] (37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim PHI Validate] ADD CONSTRAINT [enc_key_pk10] PRIMARY KEY CLUSTERED  ([enc_key]) ON [PRIMARY]
GO
