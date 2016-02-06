CREATE TABLE [fdt].[Dim Time of Day]
(
[Time of Slot] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[meridiem] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Time of Day] ADD CONSTRAINT [appt_time_pk2] PRIMARY KEY CLUSTERED  ([Time of Slot]) ON [PRIMARY]
GO
