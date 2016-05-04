CREATE TABLE [dwh].[data_diagnosis_problem]
(
[dx_prob_key] [int] NOT NULL IDENTITY(1, 1),
[per_mon_id] [int] NULL,
[person_key] [int] NULL,
[enc_appt_key] [int] NULL,
[enc_id] [uniqueidentifier] NULL,
[person_id] [uniqueidentifier] NULL,
[person_id_ecw] [int] NULL,
[icd_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diag_full_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chronic_ind] [int] NULL,
[dx_create_date] [datetime] NULL,
[eff_date] [datetime] NULL,
[thru_date] [datetime] NULL,
[snomed_id] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[snomed_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[chronic_dx_label] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dx_status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dx_prob_ind] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ng_data] [int] NULL
) ON [PRIMARY]
GO
