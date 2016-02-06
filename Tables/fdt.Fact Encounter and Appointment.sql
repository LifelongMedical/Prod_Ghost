CREATE TABLE [fdt].[Fact Encounter and Appointment]
(
[enc_appt_key] [int] NOT NULL IDENTITY(1, 1),
[user_resource_key] [int] NULL,
[enc_rendering_key] [int] NULL,
[location_key] [int] NULL,
[per_mon_id] [int] NULL,
[enc_appt_comp_key] [bigint] NULL,
[event_id] [uniqueidentifier] NULL,
[enc_app_date] [date] NULL,
[user_appt_created] [int] NULL,
[user_checkout] [int] NULL,
[user_readyforprovider] [int] NULL,
[user_enc_created] [int] NULL,
[user_charted] [int] NULL,
[enc_nbr] [numeric] (12, 0) NULL,
[Enc Number] [numeric] (12, 0) NULL,
[event_key] [int] NULL,
[enc_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_w_pcp_status_txt] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[enc_slot_type] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appt_duration] [int] NULL,
[Appt Duration] [int] NULL,
[appt_time] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appt Booked with PCP] [int] NOT NULL,
[Appt Booked Not with PCP] [int] NOT NULL,
[All Appt] [int] NOT NULL,
[Appt without a Pt] [int] NOT NULL,
[Appt Kept with Enc] [int] NOT NULL,
[Appt Kept with No Enc] [int] NOT NULL,
[Appt in Future] [int] NOT NULL,
[Appt No Show] [int] NOT NULL,
[Appt No Show with No Patient] [int] NOT NULL,
[Appt Future with No Patient] [int] NOT NULL,
[Appt Cancelled] [int] NOT NULL,
[Appt Deleted] [int] NOT NULL,
[Appt Rescheduled] [int] NOT NULL,
[Enc or Appt] [int] NOT NULL,
[Encounters] [int] NOT NULL,
[Billable Encounters] [int] NOT NULL,
[Non-billable Encounters] [int] NOT NULL,
[Billable Enc with Appt] [int] NOT NULL,
[Non-Billable Enc with Appt] [int] NOT NULL,
[Billable Appts with Enc Kept] [int] NOT NULL,
[Non-Billable Appts with Enc Kept] [int] NOT NULL,
[Days from Booked to Appt] [int] NULL,
[Min from Appt Time to Kept] [int] NULL,
[Min from Kept to Checkout] [int] NULL,
[Min Kept to Ready for Prov] [int] NULL,
[Min from Kept to Charted] [int] NULL,
[Mins from Kept to Charted] [int] NULL,
[Min from Ready for Prov to Checkout] [int] NULL,
[Date of Appointment Made] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [enc_appt_keypk] PRIMARY KEY CLUSTERED  ([enc_appt_key]) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_appt62] FOREIGN KEY ([appt_time]) REFERENCES [fdt].[Dim Time of Day] ([Time of Slot])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_enc_app_date] FOREIGN KEY ([enc_app_date]) REFERENCES [fdt].[Dim Time] ([Key Date])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_enc_appt_comp_key] FOREIGN KEY ([enc_appt_comp_key]) REFERENCES [fdt].[Dim Status Enc and Appt] ([enc_appt_comp_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_enc_rendering_key3] FOREIGN KEY ([enc_rendering_key]) REFERENCES [fdt].[Dim Provider Rendering] ([user_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_event_key1] FOREIGN KEY ([event_key]) REFERENCES [fdt].[Dim Category and Event] ([cat_event_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_location_key] FOREIGN KEY ([location_key]) REFERENCES [fdt].[Dim Location for Enc or Appt] ([location_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_per_mon_id] FOREIGN KEY ([per_mon_id]) REFERENCES [fdt].[Dim PHI Patient] ([per_mon_id])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_user_appt_created] FOREIGN KEY ([user_appt_created]) REFERENCES [fdt].[Dim User Appointment Creator] ([user_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_user_checkout] FOREIGN KEY ([user_checkout]) REFERENCES [fdt].[Dim User Checkout] ([user_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_user_enc_created3] FOREIGN KEY ([user_enc_created]) REFERENCES [fdt].[Dim User Encounter Creator] ([user_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_User_ReadyforProvider] FOREIGN KEY ([user_readyforprovider]) REFERENCES [fdt].[Dim User Ready for Provider] ([user_key])
GO
ALTER TABLE [fdt].[Fact Encounter and Appointment] ADD CONSTRAINT [FK_user_resource_key2] FOREIGN KEY ([user_resource_key]) REFERENCES [fdt].[Dim User Schedule Resource] ([user_key])
GO
