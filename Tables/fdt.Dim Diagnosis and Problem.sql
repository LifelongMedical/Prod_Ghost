CREATE TABLE [fdt].[Dim Diagnosis and Problem]
(
[dx_prob_key] [int] NOT NULL IDENTITY(1, 1),
[per_mon_id] [int] NULL,
[person_key] [int] NULL,
[enc_appt_key] [int] NULL,
[ICD Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dx Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dx Long] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chronic Dx] [int] NULL,
[Diagnosis Date] [datetime] NULL,
[Problem Effective Date] [datetime] NULL,
[Problem Resolution Date] [datetime] NULL,
[Snomed ID] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Snomed Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Chronic Dx Label] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dx NG Status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dx or Problem] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
