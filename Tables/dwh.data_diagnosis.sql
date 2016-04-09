CREATE TABLE [dwh].[data_diagnosis]
(
[Dx_key] [int] NOT NULL IDENTITY(1, 1),
[per_mon_id] [int] NULL,
[enc_appt_key] [int] NULL,
[enc_id] [uniqueidentifier] NULL,
[ICD9_Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diagnosis_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[chronic_ind] [int] NOT NULL,
[dx_status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[person_id] [uniqueidentifier] NOT NULL,
[location_id] [uniqueidentifier] NULL,
[provider_id] [uniqueidentifier] NULL,
[snomed_concept_id] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[snomed_fully_specified_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Diag_Full_Name] [varchar] (268) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[diabetes_flag] [int] NOT NULL,
[hypertension_flag] [int] NOT NULL,
[hiv_flag] [int] NOT NULL
) ON [PRIMARY]
GO
