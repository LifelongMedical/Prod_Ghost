CREATE TABLE [fdt].[Fact and Dim Diagnosis]
(
[Dx_key] [int] NOT NULL IDENTITY(1, 1),
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[Diagnosis] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dx Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Chronic Dx] [int] NOT NULL,
[Dx Status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Snomed ID] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Snomed Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full Diagnosis] [varchar] (268) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Diabetes Dx Count] [int] NOT NULL,
[Hypertension Dx Count] [int] NOT NULL,
[HIV Dx Count] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [fdt].[Fact and Dim Diagnosis] ADD CONSTRAINT [PK__Fact and__5A3FD1459954C0F1] PRIMARY KEY CLUSTERED  ([Dx_key]) ON [PRIMARY]
GO
