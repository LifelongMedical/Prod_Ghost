CREATE TABLE [fdt].[Dim Status Enc and Appt]
(
[enc_appt_comp_key] [bigint] NOT NULL,
[Status of Appointment] [varchar] (31) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Appt booked with PCP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Appt booked with a patient] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Appt had encounter] [varchar] (31) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enc had appt] [varchar] (31) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enc billable status] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status of Enc] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Appt was Kept] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Appt cancel reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enc had charges] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Dim Status Enc and Appt] ADD CONSTRAINT [enc_appt_comp_key_pk2] PRIMARY KEY CLUSTERED  ([enc_appt_comp_key]) ON [PRIMARY]
GO
