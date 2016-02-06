CREATE TABLE [dwh].[data_diagnosis]
(
[first_mon_date] [date] NULL,
[create_timestamp] [datetime] NOT NULL,
[Dx_key] [int] NOT NULL IDENTITY(1, 1),
[diagnosis_code_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ICD9_Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[location_key] [int] NULL,
[provider_key] [int] NULL,
[Diag_Full_Name] [varchar] (268) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[snomed_concept_id] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[snomed_fully_specified_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_by] [int] NOT NULL,
[note] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
