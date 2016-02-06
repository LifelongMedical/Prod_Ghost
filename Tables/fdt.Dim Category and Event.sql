CREATE TABLE [fdt].[Dim Category and Event]
(
[cat_event_key] [int] NOT NULL IDENTITY(1, 1),
[event_id] [uniqueidentifier] NULL,
[category_id] [uniqueidentifier] NOT NULL,
[Category Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prevent Appt] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Category and Event] ADD CONSTRAINT [cat_event_keypk1] PRIMARY KEY CLUSTERED  ([cat_event_key]) ON [PRIMARY]
GO
