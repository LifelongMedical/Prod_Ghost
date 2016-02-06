CREATE TABLE [fdt].[Dim Appt Event]
(
[event_key] [int] NOT NULL IDENTITY(1, 1),
[Appt Event Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Appt Event] ADD CONSTRAINT [event_key_pk1] PRIMARY KEY CLUSTERED  ([event_key]) ON [PRIMARY]
GO
