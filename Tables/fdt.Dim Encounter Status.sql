CREATE TABLE [fdt].[Dim Encounter Status]
(
[enc_comp_key] [bigint] NOT NULL,
[Encounter Status] [varchar] (37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Encounter Status] ADD CONSTRAINT [enc_comp_key_pk] PRIMARY KEY CLUSTERED  ([enc_comp_key]) ON [PRIMARY]
GO
