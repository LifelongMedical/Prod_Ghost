CREATE TABLE [fdt].[Fact and Dim Problem List]
(
[prob_key] [int] NOT NULL IDENTITY(1, 1),
[Dx_key] [int] NULL,
[enc_id] [uniqueidentifier] NULL,
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[Dx Onset Date] [datetime] NULL,
[Dx Resolution Date] [datetime] NULL,
[Dx Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Diagnosis] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Diabetes Dx Count] [int] NOT NULL,
[Hypertension Dx Count] [int] NOT NULL,
[HIV Dx Count] [int] NOT NULL,
[Chronic Dx] [int] NULL,
[Dx Status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
ALTER TABLE [fdt].[Fact and Dim Problem List] ADD 
CONSTRAINT [PK__Fact and__D70A70B8397E10CE] PRIMARY KEY CLUSTERED  ([prob_key]) ON [PRIMARY]
GO
