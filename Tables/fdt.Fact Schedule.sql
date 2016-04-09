CREATE TABLE [fdt].[Fact Schedule]
(
[slot_key] [int] NOT NULL IDENTITY(1, 1),
[resource_key] [int] NULL,
[schedule_resource_key] [int] NULL,
[slot_loc_key] [int] NULL,
[category_key] [int] NULL,
[appt_date] [date] NULL,
[slot_time] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duration Min] [int] NULL,
[NG Schedule Min] [int] NULL,
[Duration Hr] [decimal] (14, 6) NULL,
[NG Schedule Hr] [decimal] (14, 6) NULL,
[Nbr Slots for Appt] [int] NULL,
[Nbr Slots for Appt at 7am] [int] NULL,
[Nbr Slots for Appt Final] [int] NULL,
[Nbr Slots Avail 7am] [int] NULL,
[Nbr Slots Avail Final] [int] NULL,
[Nbr Slots Any Kind] [int] NULL,
[Nbr Slots as Overbooked] [int] NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact Schedule] ADD 
CONSTRAINT [slot_key_pk4] PRIMARY KEY CLUSTERED  ([slot_key]) ON [PRIMARY]
GO
